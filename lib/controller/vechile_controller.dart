import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../webservices/WebServicesHelper.dart';
import '../preferences/UserPreferences.dart';
import '../model/vechile_model.dart';
import '../model/vehicle_sos_model.dart';
import '../model/vehicle_booking_model.dart';
import '../model/file_model.dart';

import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleController extends GetxController {
  // 1 = Cab, 2 = Ambulance (ids from GET /admin/vehicle-type/). Drives which
  // categories and nearby vehicles are fetched.
  final RxInt vehicleTypeId;

  VehicleController({int vehicleTypeId = 1})
      : vehicleTypeId = vehicleTypeId.obs;

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
  // Null while location hasn't failed / is still being resolved. Set to a
  // reason ('service_disabled' | 'permission_denied' | 'permission_denied_forever' | 'unknown')
  // when getCurrentLocation() cannot get a fix, so the UI can show a real
  // error state instead of spinning on the loading screen forever.
  RxnString locationError = RxnString();

  // ==================== LOCATION ====================
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  // ==================== VEHICLE TYPES (from GET /admin/vehicle-type/) ====
  // Full list from the API and the type matched against [vehicleTypeId]
  // (1 = Cab, 2 = Ambulance). Categories are loaded for the matched type.
  var vehicleTypeList = <Map<String, dynamic>>[].obs;
  var selectedVehicleType = Rxn<Map<String, dynamic>>();
  var isLoadingVehicleTypes = false.obs;

  // ==================== FACILITIES (GET /admin/vehicle-facility/) =========
  // Facility id → name (Patient Transport, ICU Ambulance, Oxygen Support...)
  // used to display a vehicle's facility_ids on the detail screen.
  RxMap<int, String> facilityNames = <int, String>{}.obs;

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

  // ==================== SOS / EMERGENCY ====================
  RxBool isSendingSos = false.obs;

  // ==================== BOOKING (/bookings/) ====================
  // The booking the customer is currently riding on / waiting for. Restored
  // from GET /bookings/ on startup so the live status survives an app restart,
  // and polled while it is in a non-terminal state.
  Rxn<VehicleBookingModel> activeBooking = Rxn<VehicleBookingModel>();
  RxList<VehicleBookingModel> myBookings = <VehicleBookingModel>[].obs;
  RxBool isCreatingBooking = false.obs;
  RxBool isCancellingBooking = false.obs;
  RxBool isLoadingBookings = false.obs;
  Timer? bookingPollTimer;
  static const Duration bookingPollInterval = Duration(seconds: 10);
  
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
  void onInit() {
    super.onInit();
    loadUserData();
    // Facility names for the detail screen (no need to block on it)
    loadFacilities();
    // Restore a ride that is still running from a previous session so the
    // card shows its live status instead of an empty "Book" button.
    loadMyBookings();
    _bootstrap();
  }

  // Startup sequence for the map screen.
  //
  // The type/category APIs do NOT depend on the device location, so they run
  // alongside the GPS fix instead of behind it. Previously everything was
  // awaited in one chain starting with getCurrentLocation(): when that call
  // never returned (no fix indoors, emulator with no location set) onInit
  // parked on the await forever — no categories, no vehicles, and the map sat
  // on "Finding nearby vehicles..." with nothing to retry.
  Future<void> _bootstrap() async {
    // Both of these swallow their own errors, so the chain can't throw here.
    final Future<void> catalog =
        resolveVehicleType().then((_) => getCategories());

    await getCurrentLocation();

    // ONLY ONE INITIAL FETCH
    await fetchNearbyVehicles(force: true);

    startLocationListener();
    _startPeriodicRefresh();

    await catalog;
  }

  @override
  void onClose() {
    customerLocationStream?.cancel();
    apiDebounceTimer?.cancel();
    refreshTimer?.cancel();
    bookingPollTimer?.cancel();

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

  // How long we wait for a GPS fix before giving up. Without a bound
  // getCurrentPosition() can wait for a fix that never comes (indoors, weak
  // signal, emulator with no location set) and everything behind it stalls.
  static const Duration locationTimeout = Duration(seconds: 12);

  Future<void> getCurrentLocation() async {
    try {
      isLocationReady.value = false;
      locationError.value = null;

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint("❌ Location error => service disabled");
        locationError.value = 'service_disabled';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint("❌ Location error => permission denied forever");
        locationError.value = 'permission_denied_forever';
        return;
      }

      if (permission == LocationPermission.denied) {
        debugPrint("❌ Location error => permission denied");
        locationError.value = 'permission_denied';
        return;
      }

      // Cached fix first: it comes back immediately and is accurate enough to
      // draw the map and run the first nearby-vehicle fetch while the GPS
      // warms up. Anything is better than an empty screen here.
      Position? cached;
      try {
        cached = await Geolocator.getLastKnownPosition()
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint("⚠️ Last known position unavailable => $e");
      }

      if (cached != null) {
        _applyPosition(cached, source: "last known");
      }

      // Fresh fix, bounded twice: geolocator's own timeLimit, plus a Future
      // timeout because on some Android devices timeLimit doesn't fire.
      try {
        final Position fresh = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: locationTimeout,
        ).timeout(locationTimeout + const Duration(seconds: 3));
        _applyPosition(fresh, source: "gps");
      } on TimeoutException {
        debugPrint("⏱️ Location timed out after ${locationTimeout.inSeconds}s");
        // The cached fix is already applied and good enough — only report a
        // failure when we have nothing at all to show.
        if (cached == null) {
          isLocationReady.value = false;
          locationError.value = 'timeout';
        }
      } catch (e) {
        debugPrint("❌ Location error => $e");
        if (cached == null) {
          isLocationReady.value = false;
          locationError.value = 'unknown';
        }
      }
    } catch (e) {
      isLocationReady.value = false;
      locationError.value = 'unknown';
      debugPrint("❌ Location error => $e");
    }
  }

  void _applyPosition(Position position, {required String source}) {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    isLocationReady.value = true;
    locationError.value = null;
    debugPrint(
        "📍 [$source] LAT => ${latitude.value}, LNG => ${longitude.value}");
  }

  // Retry path for the "couldn't get your location" screen. Redoes the fix and,
  // if the catalog calls failed/never ran the first time, reloads them too so
  // the category chips aren't missing after a recovery.
  Future<void> retryInitialLoad() async {
    await getCurrentLocation();

    if (categoryList.isEmpty) {
      await resolveVehicleType();
      await getCategories();
    }

    if (latitude.value != 0.0 || longitude.value != 0.0) {
      await forceRefresh();
    }
  }

  // ============================
  // ✅ FACILITY NAMES (GET /admin/vehicle-facility/)
  // ============================
  Future<void> loadFacilities() async {
    try {
      final response = await WebServicesHelper().getVechileFacilities();

      final List<dynamic> rawList =
          (response != null && response['data'] is List)
              ? response['data']
              : [];

      final Map<int, String> names = {};
      for (final item in rawList) {
        if (item is Map && item['id'] is int && item['name'] != null) {
          names[item['id']] = item['name'].toString();
        }
      }

      if (names.isNotEmpty) {
        facilityNames.value = names;
      }
      debugPrint("✅ [FACILITY] Loaded ${names.length} facilities");
    } catch (e) {
      debugPrint("❌ [FACILITY] Error: $e");
    }
  }

  // ============================
  // ✅ STEP 1: VEHICLE TYPE API (GET /admin/vehicle-type/)
  // ============================
  // Called before loading categories. Fetches all vehicle types and finds
  // the one matching [vehicleTypeId] (Book Cab → 1, Book Ambulance → 2).
  Future<void> resolveVehicleType() async {
    try {
      isLoadingVehicleTypes.value = true;

      final response = await WebServicesHelper().getVechileTypes();

      List<dynamic> rawList = [];
      if (response != null) {
        if (response['data'] is List) {
          rawList = response['data'];
        } else if (response['items'] is List) {
          rawList = response['items'];
        }
      }

      vehicleTypeList.value =
          rawList.whereType<Map<String, dynamic>>().toList();

      debugPrint("✅ [TYPE] Vehicle types from API: "
          "${vehicleTypeList.map((t) => '${t['id']}:${t['name']}').join(', ')}");

      // Find the type whose id matches the opened module
      Map<String, dynamic>? match;
      for (final type in vehicleTypeList) {
        if (type['id']?.toString() == vehicleTypeId.value.toString()) {
          match = type;
          break;
        }
      }

      if (match != null) {
        selectedVehicleType.value = match;
        debugPrint(
            "✅ [TYPE] Matched type id=${match['id']} name=${match['name']}"
            " → loading its categories");
      } else {
        selectedVehicleType.value = null;
        debugPrint("⚠️ [TYPE] No type with id=${vehicleTypeId.value} in API "
            "response, categories will still be filtered by this id");
      }
    } catch (e) {
      debugPrint("❌ [TYPE] Vehicle type error: $e");
    } finally {
      isLoadingVehicleTypes.value = false;
    }
  }

  Future<void> getCategories() async {
    try {
      isLoadingCategories.value = true;
      // NOTE: backend expects "vechile_type_id" (backend's spelling), not
      // "vehicle_type_id" — with the wrong name it ignores the filter and
      // returns ALL categories.
      final response = await WebServicesHelper().vechileCategory({
        "page": 1,
        "size": 50,
        "vechile_type_id":
            selectedVehicleType.value?['id'] ?? vehicleTypeId.value,
        "display_type": "active",
        "order_by": "id",
        "descending": false,
      });
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

  // Picks a subcategory chip. Passing null (the "All" chip), or tapping the
  // already-selected subcategory again, clears the filter so every vehicle in
  // the selected category shows. fetchNearbyVehicles only sends subcategory_id
  // when one is selected, so clearing it is enough to widen the results.
  void onSubCategorySelected(SubCategory? subCategory) {
    final bool clearing =
        subCategory == null || selectedSubCategory.value?.id == subCategory.id;
    selectedSubCategory.value = clearing ? null : subCategory;
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
        // Cab (1) vs Ambulance (2) — only vehicles of the opened module show.
        // Both spellings sent because the category API uses the backend's
        // "vechile_type_id" spelling; remove whichever this endpoint ignores.
        "vehicle_type_id": vehicleTypeId.value,
       
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

    } catch (e) {
      debugPrint("❌ [API] Error: $e");
    } finally {
      isFetchingInProgress = false;
      // The request is over however it ended — success, null response, thrown
      // exception, HTTP timeout. Marking it done here (instead of only on the
      // happy paths) is what stops "Finding nearby vehicles..." from spinning
      // forever after a failed call: the UI falls through to the empty state
      // with a Try Again button. The three early returns above happen before
      // this try block, so a skipped fetch never trips the flag.
      hasInitialFetchDone.value = true;
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
      // Include type + category in hash to differentiate responses
      buffer.write("type_${vehicleTypeId.value}:");
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

  // ============================
  // ✅ SWITCH VEHICLE TYPE (Cab <-> Ambulance)
  // ============================
  // Called when the map screen is opened for a different module. Reloads the
  // type's categories and vehicles from scratch.
  Future<void> setVehicleType(int typeId) async {
    if (vehicleTypeId.value == typeId) return;

    debugPrint("🔄 [TYPE] Switching vehicle type to: $typeId");
    vehicleTypeId.value = typeId;

    // Reset all type-specific state
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    subCategoryList.clear();
    lastSelectedCategoryId = null;
    nearbyVehicles.clear();
    vehiclePositions.clear();
    movingVehicles.clear();
    vehicleDataMap.clear();
    categoryVehiclePositions.clear();
    categoryVehicleData.clear();

    // Show the loading state on the map while the new type loads
    hasInitialFetchDone.value = false;

    // Step 1: vehicle type API → Step 2: categories of that type
    await resolveVehicleType();
    await getCategories();
    await forceRefresh();

    // Ensure the map leaves the loading state even if the fetch was skipped
    hasInitialFetchDone.value = true;
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

    // A manually picked location is a perfectly valid fix, so it has to clear
    // the location error and flip isLocationReady. Without this, picking a
    // location after a failed/timed-out GPS read left the screen stuck on the
    // loading/error state even though we knew exactly where to search.
    if (lat != 0.0 || lng != 0.0) {
      isLocationReady.value = true;
      locationError.value = null;
    }
  }
  
  bool isVehicleMoving(int vehicleId) {
    return movingVehicles[vehicleId] ?? false;
  }
  
  LatLng? getVehiclePosition(int vehicleId) {
    return vehiclePositions[vehicleId];
  }

  // ============================
  // ✅ SOS / EMERGENCY ALERT
  // ============================
  static const String defaultSosMessage =
      "Emergency assistance required. Vehicle breakdown on highway.";

  Future<bool> sendSosAlert({
    required int vehicleId,
    required int driverId,
    required double latitude,
    required double longitude,
    String message = defaultSosMessage,
  }) async {
    try {
      isSendingSos.value = true;

      final sosModel = VehicleSosModel(
        vehicleId: vehicleId,
        driverId: driverId,
        userId: int.tryParse(userId) ?? 0,
        latitude: latitude,
        longitude: longitude,
        message: message,
      );

      final response = await WebServicesHelper()
          .createVehicleSosAlert(sosModel.toJson(), accessToken);

      if (response != null) {
        debugPrint("✅ [SOS] Alert sent: $response");
        return true;
      } else {
        debugPrint("❌ [SOS] Failed to send alert");
        return false;
      }
    } catch (e) {
      debugPrint("❌ [SOS] Error: $e");
      return false;
    } finally {
      isSendingSos.value = false;
    }
  }

  // ============================
  // ✅ BOOKING (/bookings/)
  // ============================

  /// The logged-in user id, which the booking API calls `customer_id`.
  /// 0 when nobody is logged in — every booking call guards on this.
  int get customerId => int.tryParse(userId) ?? 0;

  /// The live booking for [vehicleId], if the customer has one. Used by the
  /// vehicle card to swap the Book button for the ride status.
  VehicleBookingModel? bookingForVehicle(dynamic vehicleId) {
    final int? id = vehicleId is int
        ? vehicleId
        : int.tryParse(vehicleId?.toString() ?? '');
    if (id == null) return null;

    final VehicleBookingModel? booking = activeBooking.value;
    if (booking != null && booking.vehicleId == id && booking.isLive) {
      return booking;
    }
    return null;
  }

  /// POST /bookings/ — books [vehicleId] with [driverId] from the customer's
  /// current pickup point. Drop coordinates are optional (the API only
  /// requires pickup). Returns the created booking, or null with a snackbar
  /// carrying the backend's message on failure.
  Future<VehicleBookingModel?> createBooking({
    required int driverId,
    required int vehicleId,
    double? pickupLat,
    double? pickupLng,
    double? dropLat,
    double? dropLng,
  }) async {
    if (isCreatingBooking.value) return null;

    final request = VehicleBookingCreateModel(
      customerId: customerId,
      driverId: driverId,
      vehicleId: vehicleId,
      // Default pickup = wherever the customer is looking on the map (their
      // GPS fix, or the location they picked manually).
      pickupLatitude: pickupLat ?? latitude.value,
      pickupLongitude: pickupLng ?? longitude.value,
      dropLatitude: dropLat,
      dropLongitude: dropLng,
    );

    if (!request.isValid) {
      debugPrint("❌ [BOOKING] Invalid request: ${request.toJson()}");
      _bookingError(customerId <= 0
          ? "Please log in to book this vehicle"
          : "Could not read your pickup location. Try again.");
      return null;
    }

    try {
      isCreatingBooking.value = true;

      final response = await WebServicesHelper()
          .createVehicleBooking(request.toJson(), accessToken);

      if (response == null) {
        _bookingError("Network error. Please try again.");
        return null;
      }

      final int status = _statusCodeOf(response);
      if (status < 200 || status > 299 || response['error'] == true) {
        _bookingError(_messageOf(response, "Could not create the booking"));
        return null;
      }

      final Map<String, dynamic>? data = _dataMapOf(response);
      if (data == null) {
        _bookingError(_messageOf(response, "Could not create the booking"));
        return null;
      }

      final booking = VehicleBookingModel.fromJson(data);

      // The create response doesn't always echo every field back. Backfill
      // from the request so the card can match this booking to its vehicle
      // and show a status straight away (the next poll replaces it anyway).
      booking.customerId ??= request.customerId;
      booking.driverId ??= request.driverId;
      booking.vehicleId ??= request.vehicleId;
      booking.pickupLatitude ??= request.pickupLatitude;
      booking.pickupLongitude ??= request.pickupLongitude;
      booking.dropLatitude ??= request.dropLatitude;
      booking.dropLongitude ??= request.dropLongitude;
      booking.status ??= VehicleBookingStatus.pending;

      activeBooking.value = booking;
      myBookings.insert(0, booking);
      _startBookingPolling();

      debugPrint("✅ [BOOKING] Created #${booking.id} → ${booking.status}");
      return booking;
    } catch (e) {
      debugPrint("❌ [BOOKING] Create error: $e");
      _bookingError("Something went wrong. Please try again.");
      return null;
    } finally {
      isCreatingBooking.value = false;
    }
  }

  /// GET /bookings/?customer_id=&page=&size= — the customer's bookings.
  /// Also picks the newest still-running one as [activeBooking] and starts
  /// polling it.
  Future<void> loadMyBookings({int page = 1, int size = 10}) async {
    if (customerId <= 0) {
      debugPrint("⏭️ [BOOKING] No user id, skipping booking list");
      return;
    }

    try {
      isLoadingBookings.value = true;

      final response = await WebServicesHelper().getCustomerBookings(
        customerId: customerId,
        page: page,
        size: size,
        accessToken: accessToken,
      );

      if (response == null) {
        debugPrint("❌ [BOOKING] Null booking list response");
        return;
      }

      final parsed = VehicleBookingListResponse.fromJson(response);
      myBookings.value = parsed.data;

      VehicleBookingModel? live;
      for (final booking in parsed.data) {
        if (booking.isLive) {
          live = booking;
          break;
        }
      }

      activeBooking.value = live;
      if (live != null) {
        _startBookingPolling();
      } else {
        _stopBookingPolling();
      }

      debugPrint("✅ [BOOKING] ${parsed.data.length} bookings"
          "${live != null ? ', active #${live.id} (${live.status})' : ''}");
    } catch (e) {
      debugPrint("❌ [BOOKING] List error: $e");
    } finally {
      isLoadingBookings.value = false;
    }
  }

  /// GET /bookings/{id} — refreshes one booking. Returns the fresh record and
  /// keeps [activeBooking] / [myBookings] in sync with it.
  Future<VehicleBookingModel?> refreshBooking(int bookingId) async {
    try {
      final response = await WebServicesHelper()
          .getVehicleBookingById(bookingId, accessToken);

      if (response == null) return null;

      final Map<String, dynamic>? data = _dataMapOf(response);
      if (data == null || data.isEmpty) return null;

      final booking = VehicleBookingModel.fromJson(data);
      _applyBookingUpdate(booking);
      return booking;
    } catch (e) {
      debugPrint("❌ [BOOKING] Refresh error: $e");
      return null;
    }
  }

  /// POST /bookings/{id}/cancel — the backend refuses this once the trip is
  /// COMPLETED, so its message is surfaced as-is when it does.
  Future<bool> cancelBooking(int bookingId) async {
    if (isCancellingBooking.value) return false;

    if (customerId <= 0) {
      _bookingError("Please log in to manage your bookings");
      return false;
    }

    try {
      isCancellingBooking.value = true;

      final response = await WebServicesHelper()
          .cancelVehicleBooking(bookingId, customerId, accessToken);

      if (response == null) {
        _bookingError("Network error. Please try again.");
        return false;
      }

      final int status = _statusCodeOf(response);
      if (status < 200 || status > 299 || response['error'] == true) {
        _bookingError(_messageOf(response, "Could not cancel the booking"));
        return false;
      }

      final Map<String, dynamic>? data = _dataMapOf(response);
      // The cancel response may or may not echo the booking back — fall back
      // to marking the one we know about as cancelled.
      final VehicleBookingModel booking = (data != null && data.isNotEmpty)
          ? VehicleBookingModel.fromJson(data)
          : (VehicleBookingModel.fromJson({
              ...?activeBooking.value?.toJson(),
              'id': bookingId,
              'status': VehicleBookingStatus.cancelled,
            }));

      _applyBookingUpdate(booking);

      debugPrint("✅ [BOOKING] Cancelled #$bookingId");
      return true;
    } catch (e) {
      debugPrint("❌ [BOOKING] Cancel error: $e");
      _bookingError("Something went wrong. Please try again.");
      return false;
    } finally {
      isCancellingBooking.value = false;
    }
  }

  // Writes a fresh booking record into the list + active slot, and stops the
  // polling once the ride reaches a terminal state.
  void _applyBookingUpdate(VehicleBookingModel booking) {
    final int index = myBookings.indexWhere((b) => b.id == booking.id);
    if (index >= 0) {
      myBookings[index] = booking;
    } else {
      myBookings.insert(0, booking);
    }

    if (activeBooking.value?.id == booking.id || booking.isLive) {
      activeBooking.value = booking.isLive ? booking : null;
    }

    if (!booking.isLive) {
      _stopBookingPolling();
    }
  }

  // Polls the active booking so the customer sees ACCEPTED → ARRIVING →
  // IN_PROGRESS → COMPLETED without pulling to refresh. Stops itself as soon
  // as there is nothing live left to watch.
  void _startBookingPolling() {
    if (bookingPollTimer?.isActive ?? false) return;

    bookingPollTimer = Timer.periodic(bookingPollInterval, (_) async {
      final VehicleBookingModel? booking = activeBooking.value;
      final int? id = booking?.id;

      if (id == null || booking == null || !booking.isLive) {
        _stopBookingPolling();
        return;
      }

      await refreshBooking(id);
    });
  }

  void _stopBookingPolling() {
    bookingPollTimer?.cancel();
    bookingPollTimer = null;
  }

  // ---- response helpers (the backend wraps everything in an envelope) ----

  int _statusCodeOf(Map<String, dynamic> response) {
    final dynamic status = response['status'];
    if (status is int) return status;
    return int.tryParse(status?.toString() ?? '') ?? 200;
  }

  String _messageOf(Map<String, dynamic> response, String fallback) {
    // FastAPI validation errors come back as {detail: [...]} instead of the
    // usual envelope, so they'd otherwise show as a blank message.
    final dynamic detail = response['detail'];
    if (detail is String && detail.isNotEmpty) return detail;
    if (detail is List && detail.isNotEmpty) {
      final dynamic first = detail.first;
      if (first is Map && first['msg'] != null) return first['msg'].toString();
    }

    final dynamic message = response['message'];
    if (message is String && message.isNotEmpty) return message;

    return fallback;
  }

  Map<String, dynamic>? _dataMapOf(Map<String, dynamic> response) {
    final dynamic data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is List && data.isNotEmpty && data.first is Map) {
      return Map<String, dynamic>.from(data.first as Map);
    }
    return null;
  }

  void _bookingError(String message) {
    Get.snackbar(
      "Booking",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}