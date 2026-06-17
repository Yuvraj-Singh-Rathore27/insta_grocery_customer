import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../webservices/WebServicesHelper.dart';
import '../utills/Utils.dart';
import '../preferences/UserPreferences.dart';
import '../model/vechile_model.dart';
import '../model/file_model.dart';
import '../model/responsemodel/FileUploadResponseModel.dart';
import '../webservices/ApiUrl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleController extends GetxController {
  late GetStorage store;
  String userId = "";
  String accessToken = "";
  RxBool isVehicleActive = true.obs;
  RxBool isDriverActive = true.obs;

  // ==================== FORM CONTROLLERS ====================
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController licenseController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController baseController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  RxBool isLoadingVehicles = true.obs;
  RxBool isLocationReady = false.obs;
  RxBool hasInitialFetchDone = false.obs;

  // ==================== LOCATION ====================
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // ==================== CATEGORY & SUBCATEGORY ====================
  var categoryList = <Category>[].obs;
  var subCategoryList = <SubCategory>[].obs;
  var selectedCategory = Rxn<Category>();
  var selectedSubCategory = Rxn<SubCategory>();
  var isLoadingCategories = false.obs;
  var isLoadingSubCategories = false.obs;
  var selectedSeat = 2.obs;

  // ==================== DRIVER ====================
  RxInt driverId = 0.obs;
  RxBool isDriverCreated = false.obs;

  // ==================== FILE UPLOADS ====================
  RxList<FileModel> rcDocumentList = <FileModel>[].obs;
  RxList<FileModel> insuranceDocumentList = <FileModel>[].obs;
  RxList<FileModel> driverPhotoList = <FileModel>[].obs;

  // ==================== LOADING ====================
  RxBool isSubmitting = false.obs;
  RxInt vehicleId = 0.obs;
  RxList<dynamic> nearbyVehicles = [].obs;
  
  // Add loading indicator for category change
  RxBool isLoadingVehiclesByCategory = false.obs;

  // ==================== VEHICLE MOVEMENT TRACKING ====================
  Map<int, LatLng> vehiclePositions = {};
  Map<int, bool> movingVehicles = {};
  Map<int, dynamic> vehicleDataMap = {};
  
  // Store positions per category to avoid losing data
  Map<int?, Map<int, LatLng>> categoryVehiclePositions = {};
  Map<int?, List<dynamic>> categoryVehicleData = {};
  
  // ==================== CRITICAL: API CONTROL VARIABLES ====================
  bool isFetchingInProgress = false;
  DateTime? lastApiCallTime;
  Timer? apiDebounceTimer;
  String? lastApiResponseHash;
  
  // Track last selected category to prevent duplicate calls
  int? lastSelectedCategoryId;
  
  // ==================== LOCATION STREAM ====================
  StreamSubscription<Position>? customerLocationStream;
  double? lastCustomerLat;
  double? lastCustomerLng;
  DateTime? lastCustomerMoveTime;
  
  // ==================== OTHER ====================
  Timer? refreshTimer;

  @override
  void onInit() async {
    super.onInit();
    loadUserData();
    await getCurrentLocation();
    await getCategories();
    
    // ONLY ONE INITIAL FETCH
    await fetchNearbyVehicles();
    
    startLocationListener();
    _startPeriodicRefresh();
  }

  @override
  void onClose() {
    customerLocationStream?.cancel();
    apiDebounceTimer?.cancel();
    refreshTimer?.cancel();
    
    nameController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    expiryController.dispose();
    vehicleNumberController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    baseController.dispose();
    rateController.dispose();
    
    super.onClose();
  }

  void loadUserData() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    accessToken = store.read(UserPreferences.access_token) ?? "";
    debugPrint("🚗 VehicleController UserId => $userId");
  }

  Future<void> getCurrentLocation() async {
    try {
      isLocationReady.value = false;
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      isLocationReady.value = true;
      debugPrint("📍 LAT => ${latitude.value}, LNG => ${longitude.value}");
    } catch (e) {
      isLocationReady.value = false;
      debugPrint("❌ Location error => $e");
    }
  }

  Future<void> getCategories() async {
    try {
      isLoadingCategories.value = true;
      final response = await WebServicesHelper().vechileCategory({});
      if (response != null && response['data'] != null) {
        categoryList.value = (response['data'] as List)
            .map((e) => Category.fromJson(e))
            .toList();
        debugPrint("✅ Categories: ${categoryList.length}");
      }
    } catch (e) {
      debugPrint("❌ Category Error: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }
                     
  Future<void> getSubCategories(int categoryId) async {
    isLoadingSubCategories.value = true;
    subCategoryList.clear();
    final response = await WebServicesHelper()
        .getVechileSubCategory({"category_id": categoryId});
    if (response != null && response['data'] != null) {
      subCategoryList.value = (response['data'] as List)
          .map((e) => SubCategory.fromJson(e))
          .toList();
      debugPrint("✅ Subcategories loaded: ${subCategoryList.length}");
    }
    isLoadingSubCategories.value = false;
  }

  // ============================
  // ✅ FIXED: ON CATEGORY SELECT - WITH PROPER HANDLING
  // ============================
  Future<void> onCategorySelected(Category? category) async {
    if (category == null) return;
    
    // 🔥 PREVENT duplicate category selection
    if (selectedCategory.value?.id == category.id) {
      debugPrint("⏳ [CATEGORY] Same category selected, ignoring");
      return;
    }
    
    debugPrint("🔄 [CATEGORY] Switching to category: ${category.name} (ID: ${category.id})");
    
    // Show loading indicator
    isLoadingVehiclesByCategory.value = true;
    
    // Update selected category
    selectedCategory.value = category;
    selectedSubCategory.value = null;
    
    // Load subcategories
    await getSubCategories(category.id);
    
    // 🔥 CRITICAL: Clear old vehicle data immediately for better UX
    // But save current positions for this category first
    if (selectedCategory.value != null) {
      categoryVehiclePositions[lastSelectedCategoryId] = Map.from(vehiclePositions);
      categoryVehicleData[lastSelectedCategoryId] = List.from(nearbyVehicles);
    }
    
    // Clear current vehicles while loading
    nearbyVehicles.clear();
    vehiclePositions.clear();
    movingVehicles.clear();
    
    // Force refresh with new category
    await forceRefresh();
    
    isLoadingVehiclesByCategory.value = false;
    lastSelectedCategoryId = category.id;
  }

  void onSubCategorySelected(SubCategory? subCategory) {
    if (subCategory == null) return;
    selectedSubCategory.value = subCategory;
    forceRefresh();
  }

  // ============================
  // ✅ FIXED: MAIN FETCH METHOD - PROPER CATEGORY HANDLING
  // ============================
  Future<void> fetchNearbyVehicles({bool force = false}) async {
    // 🚫 CHECK 1: Valid location?
    if (latitude.value == 0.0 || longitude.value == 0.0) {
      debugPrint("❌ [SKIP] No location");
      return;
    }

    // 🚫 CHECK 2: Already fetching?
    if (isFetchingInProgress) {
      debugPrint("⏳ [SKIP] Already fetching");
      return;
    }

    // 🚫 CHECK 3: Rate limiting - EXCEPT for force refresh (category change)
    if (!force && lastApiCallTime != null) {
      final timeSinceLastCall = DateTime.now().difference(lastApiCallTime!);
      if (timeSinceLastCall.inSeconds < 3) { // Reduced to 3 seconds for better UX
        debugPrint("⏳ [SKIP] Only ${timeSinceLastCall.inSeconds}s since last API call");
        return;
      }
    }

    try {
      isFetchingInProgress = true;
      
      // Build request parameters
      final param = {
        "latitude": latitude.value,
        "longitude": longitude.value,
        "radius_km": 50,
        "is_active": true,
      };

      // 🔥 CRITICAL: Add category filter ONLY if a category is selected
      if (selectedCategory.value != null) {
        param["category_id"] = selectedCategory.value!.id;
        debugPrint("🔍 [API] Filtering by category_id: ${selectedCategory.value!.id}");
      } else {
        debugPrint("🔍 [API] No category filter (showing all)");
      }
      
      if (selectedSubCategory.value != null) {
        param["subcategory_id"] = selectedSubCategory.value!.id;
        debugPrint("🔍 [API] Filtering by subcategory_id: ${selectedSubCategory.value!.id}");
      }

      debugPrint("🚗 [API] Calling API with params: $param");
      
      final res = await WebServicesHelper().getVechile(param);

      if (res == null) {
        debugPrint("❌ [API] Null response");
        return;
      }
      
      final List<dynamic> newVehicles = res['data'] != null 
          ? List.from(res['data']) 
          : [];
      
      debugPrint("📊 [API] Received ${newVehicles.length} vehicles");

      // 🔥 FORCE REFRESH: Always update for category changes
      if (force) {
        debugPrint("🔄 [API] Force refresh - updating UI");
        _updateVehicleData(newVehicles);
        lastApiResponseHash = _generateResponseHash(newVehicles);
        lastApiCallTime = DateTime.now();
        hasInitialFetchDone.value = true;
        return;
      }
      
      // Check if response is identical (only for non-force fetches)
      final String newResponseHash = _generateResponseHash(newVehicles);
      
      if (!force && lastApiResponseHash == newResponseHash && nearbyVehicles.isNotEmpty) {
        debugPrint("✅ [SKIP] Response identical to last fetch");
        lastApiCallTime = DateTime.now();
        return;
      }
      
      // Check vehicle movement
      final bool hasMovement = _hasVehiclesMoved(newVehicles);
      
      if (!force && !hasMovement && nearbyVehicles.isNotEmpty && newVehicles.length == nearbyVehicles.length) {
        debugPrint("✅ [SKIP] No vehicles moved 20+ meters");
        lastApiCallTime = DateTime.now();
        lastApiResponseHash = newResponseHash;
        return;
      }

      debugPrint("🔄 [API] Updating vehicles (Movement: $hasMovement, Force: $force)");
      _updateVehicleData(newVehicles);
      
      lastApiResponseHash = newResponseHash;
      lastApiCallTime = DateTime.now();
      hasInitialFetchDone.value = true;

    } catch (e) {
      debugPrint("❌ [API] Error: $e");
    } finally {
      isFetchingInProgress = false;
    }
  }
  
  // ============================
  // ✅ UPDATE VEHICLE DATA HELPER
  // ============================
  void _updateVehicleData(List<dynamic> newVehicles) {
    // Save old positions before clearing to detect movement
    final Map<int, LatLng> oldPositions = Map.from(vehiclePositions);

    if (selectedCategory.value != null && vehiclePositions.isNotEmpty) {
      categoryVehiclePositions[selectedCategory.value!.id] = Map.from(vehiclePositions);
    }

    vehiclePositions.clear();
    movingVehicles.clear();

    for (var vehicle in newVehicles) {
      final int vehicleId = vehicle['id'];
      final double lat = (vehicle['latitude'] ?? 0.0).toDouble();
      final double lng = (vehicle['longitude'] ?? 0.0).toDouble();

      if (lat != 0.0 && lng != 0.0) {
        final newPos = LatLng(lat, lng);
        vehiclePositions[vehicleId] = newPos;

        final LatLng? oldPos = oldPositions[vehicleId];
        if (oldPos != null) {
          final double distance = Geolocator.distanceBetween(
            oldPos.latitude, oldPos.longitude, lat, lng,
          );
          movingVehicles[vehicleId] = distance >= 5;
          debugPrint("🚗 Vehicle $vehicleId moved ${distance.toStringAsFixed(1)}m — ${movingVehicles[vehicleId]! ? 'MOVING' : 'STANDING'}");
        } else {
          movingVehicles[vehicleId] = false;
        }

        vehicleDataMap[vehicleId] = vehicle;
      }
    }

    nearbyVehicles.value = newVehicles;
    debugPrint("✅ [UI] Updated ${newVehicles.length} vehicles on map");
  }

  // ============================
  // ✅ GENERATE HASH WITH CATEGORY CONTEXT
  // ============================
  String _generateResponseHash(List<dynamic> vehicles) {
    try {
      StringBuffer buffer = StringBuffer();
      // Include category in hash to differentiate between different category responses
      buffer.write("cat_${selectedCategory.value?.id ?? 'all'}:");
      buffer.write("subcat_${selectedSubCategory.value?.id ?? 'none'}:");
      
      for (var vehicle in vehicles) {
        buffer.write("${vehicle['id']}:");
        buffer.write("${vehicle['latitude']}:");
        buffer.write("${vehicle['longitude']}");
        buffer.write("|");
      }
      return buffer.toString();
    } catch (e) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  // ============================
  // ✅ CHECK VEHICLE MOVEMENT
  // ============================
  bool _hasVehiclesMoved(List<dynamic> newVehicles) {
    for (var newVehicle in newVehicles) {
      final int vehicleId = newVehicle['id'];
      final double newLat = (newVehicle['latitude'] ?? 0.0).toDouble();
      final double newLng = (newVehicle['longitude'] ?? 0.0).toDouble();
      
      if (newLat == 0.0 || newLng == 0.0) continue;
      
      final LatLng? oldPosition = vehiclePositions[vehicleId];
      
      if (oldPosition != null) {
        final double distance = Geolocator.distanceBetween(
          oldPosition.latitude, oldPosition.longitude, newLat, newLng
        );
        
        if (distance >= 20) {
          debugPrint("🚗 Vehicle $vehicleId moved ${distance.toStringAsFixed(1)}m");
          return true;
        }
      }
    }
    return false;
  }

  // ============================
  // ✅ LOCATION LISTENER
  // ============================
  void startLocationListener() {
    customerLocationStream?.cancel();
    
    double? lastTriggeredLat;
    double? lastTriggeredLng;
    
    customerLocationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 100,
      ),
    ).listen(
      (Position position) async {
        try {
          final double newLat = position.latitude;
          final double newLng = position.longitude;
          
          if (lastTriggeredLat == null || lastTriggeredLng == null) {
            lastTriggeredLat = newLat;
            lastTriggeredLng = newLng;
            lastCustomerLat = newLat;
            lastCustomerLng = newLng;
            debugPrint("📍 [LOCATION] Initial location saved");
            return;
          }
          
          double distance = Geolocator.distanceBetween(
            lastTriggeredLat!, lastTriggeredLng!, newLat, newLng
          );
          
          debugPrint("📏 [LOCATION] Customer moved: ${distance.toStringAsFixed(1)}m");
          
          if (distance < 100) {
            debugPrint("🛑 [LOCATION] Ignoring movement <100m");
            return;
          }
          
          if (lastCustomerMoveTime != null) {
            final timeSinceLastMove = DateTime.now().difference(lastCustomerMoveTime!);
            if (timeSinceLastMove.inSeconds < 15) {
              debugPrint("⏳ [LOCATION] Last fetch ${timeSinceLastMove.inSeconds}s ago, need 15s");
              return;
            }
          }
          
          if (isFetchingInProgress) {
            debugPrint("⏳ [LOCATION] Fetch in progress, skipping");
            return;
          }
          
          debugPrint("🚀 [LOCATION] Customer moved ${distance.toStringAsFixed(1)}m - triggering fetch");
          
          lastTriggeredLat = newLat;
          lastTriggeredLng = newLng;
          lastCustomerMoveTime = DateTime.now();
          
          latitude.value = newLat;
          longitude.value = newLng;
          
          await _debouncedFetch();
          
        } catch (e) {
          debugPrint("❌ [LOCATION] Error: $e");
        }
      },
    );
  }

  // ============================
  // ✅ PERIODIC REFRESH (every 15s)
  // ============================
  void _startPeriodicRefresh() {
    refreshTimer?.cancel();
    refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      debugPrint("⏱️ [TIMER] 5s refresh triggered");
      await fetchNearbyVehicles(force: true);
    });
  }

  // ============================
  // ✅ DEBOUNCED FETCH
  // ============================
  Future<void> _debouncedFetch() async {
    if (apiDebounceTimer?.isActive ?? false) {
      apiDebounceTimer?.cancel();
    }
    
    apiDebounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      await fetchNearbyVehicles();
    });
  }

// Add this method to VehicleController
Future<void> clearCategoryFilter() async {
  debugPrint("🔄 [FILTER] Clearing category filter");
  
  selectedCategory.value = null;
  selectedSubCategory.value = null;
  
  // Clear the hash to force new API call
  lastApiResponseHash = null;
  lastApiCallTime = null;
  
  await fetchNearbyVehicles(force: true);
}
  // ============================
  // ✅ FORCE REFRESH
  // ============================
  Future<void> forceRefresh() async {
    debugPrint("🔄 [FORCE] Manual force refresh");
    
    apiDebounceTimer?.cancel();
    
    // Clear the hash to force a new API call
    lastApiResponseHash = null;
    lastApiCallTime = null;
    
    await fetchNearbyVehicles(force: true);
  }

  void updateLocation(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;
  }
  
  bool isVehicleMoving(int vehicleId) {
    return movingVehicles[vehicleId] ?? false;
  }
  
  LatLng? getVehiclePosition(int vehicleId) {
    return vehiclePositions[vehicleId];
  }
}