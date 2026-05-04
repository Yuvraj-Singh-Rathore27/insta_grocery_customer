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
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleController extends GetxController {
  late GetStorage store;
  String userId = "";
  String accessToken = "";
  RxBool isVehicleActive = true.obs;

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
  var selectedSeat = 2.obs; // Default seat capacity

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

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  final String _apiKey = "b1c1fddec9aa995a6c68";
  final String _cluster = "mt1";

  late PusherChannel channel;
  String channelName = "";
  bool isPusherConnected = false;
  Set<String> subscribedChannels = {};
  bool isSubscribing = false;
  bool isFetchingFromEvent = false;
  bool hasPendingFetch = false;
  Map<int, LatLng> vehiclePositions = {};

  @override
  // void onInit() {
  //   super.onInit();
  //   // store = GetStorage();
  //   // userId = store.read(UserPreferences.user_id) ?? "";
  //   // accessToken = store.read(UserPreferences.access_token) ?? "";
  //   loadUserData();
  //   getCategories();
  //    Future.delayed(const Duration(milliseconds: 300), () {
  //   loadExistingData(); // 🔥 IMPORTANT
  //   fetchNearbyVehicles();
  // });
  // }

  @override
  void onInit() async {
    super.onInit();

    loadUserData();

    await getCategories(); // 🔥 WAIT

    await loadExistingData(); // 🔥 AFTER categories

    fetchNearbyVehicles();
  }

  @override
  void onClose() {
    // Clean up controllers
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
    pusher.disconnect();
    super.onClose();
  }

  void loadUserData() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    accessToken = store.read(UserPreferences.access_token) ?? "";

    print("🚗 VehicleController UserId => $userId");
  }

  // ============================
  // ✅ GET CATEGORIES
  // ============================
  Future<void> getCategories() async {
    try {
      isLoadingCategories.value = true;

      final response = await WebServicesHelper().vechileCategory({});

      if (response != null && response['data'] != null) {
        categoryList.value = (response['data'] as List)
            .map((e) => Category.fromJson(e))
            .toList();

        debugPrint("✅ Categories: ${categoryList.length}");
      } else {
        categoryList.clear();
        Utils.showCustomTosstError("No category data");
      }
    } catch (e) {
      debugPrint("❌ Category Error: $e");
      categoryList.clear();
    } finally {
      isLoadingCategories.value = false; // 🔥 MUST
    }
  }

  // ============================
  // ✅ GET SUB CATEGORY
  // ============================
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
  // ✅ ON CATEGORY SELECT
  // ============================
  Future<void> onCategorySelected(Category? category) async {
    if (category == null) return;

    selectedCategory.value = category;
    selectedSubCategory.value = null;

    await getSubCategories(category.id); // 🔥 WAIT
  }

  // ============================
  // ✅ ON SUBCATEGORY SELECT
  // ============================
  void onSubCategorySelected(SubCategory? subCategory) {
    if (subCategory == null) return;

    selectedSubCategory.value = subCategory;

    // 🔥 debounce or delay
    Future.delayed(Duration(milliseconds: 300), () {
      fetchNearbyVehicles();
    });
  }

  // ============================
  // ✅ CREATE DRIVER
  // ============================
  Future<bool> createDriver() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter driver name");
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter contact number");
      return false;
    }
    if (licenseController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter license number");
      return false;
    }
    if (expiryController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter license expiry date");
      return false;
    }

    final body = {
      "name": nameController.text.trim(),
      "contact_number": phoneController.text.trim(),
      "license_number": licenseController.text.trim(),
      "license_expiry_date": expiryController.text.trim(),
      "user_id": int.tryParse(userId) ?? 0,
      "image": driverPhotoList.isNotEmpty ? driverPhotoList.first.toJson() : {},
      "created_by": int.tryParse(userId) ?? 0,
      "created_by_id": int.tryParse(userId) ?? 0,
      "updated_by": int.tryParse(userId) ?? 0,
      "updated_by_id": int.tryParse(userId) ?? 0
    };

    debugPrint("📤 Creating Driver: $body");

    final res = await WebServicesHelper().postDrivers(body, accessToken);

    if (res != null && res['data'] != null) {
      driverId.value = res['data']['id'];
      isDriverCreated.value = true;
      Utils.showCustomTosst("Driver Created Successfully");
      return true;
    }

    Utils.showCustomTosstError("Failed to create driver");
    return false;
  }

  // ============================
  // ✅ CREATE VEHICLE
  // ============================
  Future<bool> createVehicle() async {
    // Validation
    if (selectedCategory.value == null) {
      Utils.showCustomTosstError("Please select vehicle category");
      return false;
    }
    if (selectedSubCategory.value == null) {
      Utils.showCustomTosstError("Please select vehicle subcategory");
      return false;
    }
    if (vehicleNumberController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter vehicle number");
      return false;
    }
    if (modelController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter make & model");
      return false;
    }
    if (yearController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter year");
      return false;
    }
    if (baseController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter base charges");
      return false;
    }
    if (rateController.text.trim().isEmpty) {
      Utils.showCustomTosstError("Please enter rate per KM");
      return false;
    }
    if (rcDocumentList.isEmpty) {
      Utils.showCustomTosstError("Please upload RC document");
      return false;
    }
    if (insuranceDocumentList.isEmpty) {
      Utils.showCustomTosstError("Please upload insurance document");
      return false;
    }

    final body = {
      "driver_id": driverId.value,
      "category_id": selectedCategory.value!.id,
      "subcategory_id": selectedSubCategory.value!.id,
      "user_id": int.tryParse(userId) ?? 0,
      "vehicle_number": vehicleNumberController.text.trim().toUpperCase(),
      "make_model": modelController.text.trim(),
      "year": int.tryParse(yearController.text.trim()) ?? DateTime.now().year,
      "latitude": latitude.value,
      "longitude": longitude.value,
      "color": colorController.text.trim(),
      "seating_capacity": selectedSeat.value,
      "base_charges": double.tryParse(baseController.text.trim()) ?? 0.0,
      "rate_per_km": double.tryParse(rateController.text.trim()) ?? 0.0,
      "rc_document": rcDocumentList.first.toJson(),
      "insurance_document": insuranceDocumentList.first.toJson(),
      "created_by": int.tryParse(userId) ?? 0,
      "created_by_id": int.tryParse(userId) ?? 0,
      "updated_by": int.tryParse(userId) ?? 0,
      "updated_by_id": int.tryParse(userId) ?? 0
    };

    debugPrint("📤 Creating Vehicle: $body");

    final res = await WebServicesHelper().postVechile(body, accessToken);

    if (res != null && res['data'] != null) {
      Utils.showCustomTosst("Vehicle Created Successfully");
      return true;
    }

    Utils.showCustomTosstError("Failed to create vehicle");
    return false;
  }

  // ============================
  // 🚀 FINAL SUBMIT FLOW
  // ============================
  Future<void> submitAll() async {
    if (isSubmitting.value) return;

    isSubmitting.value = true;

    try {
      // 🔥 STEP 1: LOCATION FETCH
      await getCurrentLocation();

      // 🔥 DRIVER
      if (driverId.value == 0) {
        bool ok = await createDriver();
        if (!ok) return;
      } else {
        bool ok = await updateDriver();
        if (!ok) return;
      }

      // 🔥 VEHICLE
      if (vehicleId.value == 0) {
        bool ok = await createVehicle();
        if (!ok) return;
      } else {
        bool ok = await updateVehicleData();
        if (!ok) return;
      }
      Get.back();

      Utils.showCustomTosst("✅ Done");
    } catch (e) {
      print("❌ ERROR => $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  // ============================
  // 📸 FILE UPLOAD METHODS
  // ============================
  Future<void> pickImageFromGallery(String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 80,
    );

    if (image != null) {
      await uploadFile(File(image.path), type);
    }
  }

  Future<void> pickImageFromCamera(String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 80,
    );

    if (image != null) {
      await uploadFile(File(image.path), type);
    }
  }

  Future<void> uploadFile(File file, String type) async {
    BuildContext? context = Get.context;
    Utils.showLoaderDialog(context!);

    try {
      final response =
          await WebServicesHelper().fileUpload(ApiUrl.fileUploadResume, file);

      if (response != null) {
        FileUploadResponseModel baseResponse =
            FileUploadResponseModel.fromJson(response);

        if (baseResponse.status == 200 && baseResponse.data != null) {
          FileModel uploadedFile = FileModel(
            name: baseResponse.data?.name,
            path: baseResponse.data?.path,
          );

          // Add to appropriate list based on type
          switch (type) {
            case 'driver_photo':
              driverPhotoList.clear();
              driverPhotoList.add(uploadedFile);
              break;
            case 'rc_document':
              rcDocumentList.clear();
              rcDocumentList.add(uploadedFile);
              break;
            case 'insurance_document':
              insuranceDocumentList.clear();
              insuranceDocumentList.add(uploadedFile);
              break;
          }

          Utils.hideProgress(context!);
          Utils.showCustomTosst("File uploaded successfully");
        } else {
          Utils.hideProgress(context!);
          Utils.showCustomTosstError(baseResponse.message ?? "Upload failed");
        }
      } else {
        Utils.hideProgress(context!);
        Utils.showCustomTosstError("Failed to upload file");
      }
    } catch (e) {
      Utils.hideProgress(context!);
      debugPrint("❌ Upload error: $e");
      Utils.showCustomTosstError("Error uploading file");
    }
  }

  Future<void> loadExistingData() async {
    if (userId.isEmpty) return;

    clearForm(); // 🔥 MUST (old data remove)

    // ================= DRIVER =================
    final driverRes =
        await WebServicesHelper().getDriverByUserId(userId, accessToken);

    if (driverRes != null &&
        driverRes['data'] != null &&
        driverRes['data'].isNotEmpty) {
      final driver = (driverRes['data'] as List).firstWhereOrNull(
        (d) => d['user_id'].toString() == userId,
      );

      if (driver == null) {
        print("❌ NO DRIVER FOR THIS USER");
        return;
      }

      driverId.value = driver['id'];

      nameController.text = driver['name'] ?? "";
      phoneController.text = driver['contact_number'] ?? "";
      licenseController.text = driver['license_number'] ?? "";
      expiryController.text = driver['license_expiry_date'] ?? "";

      // ================= VEHICLE =================
      final vehicleRes =
          await WebServicesHelper().getVehicleByUserId(userId, accessToken);

      if (vehicleRes != null &&
          vehicleRes['data'] != null &&
          vehicleRes['data'].isNotEmpty) {
        print("🔥 VEHICLE LIST => ${vehicleRes['data']}");

        final vehicle = (vehicleRes['data'] as List).firstWhereOrNull(
          (v) => v['user_id'].toString() == userId,
        );

        if (vehicle == null) {
          print("❌ NO VEHICLE FOR THIS USER");
          return;
        }

        vehicleId.value = vehicle['id'];

        vehicleNumberController.text = vehicle['vehicle_number'] ?? "";
        modelController.text = vehicle['make_model'] ?? "";
        yearController.text = (vehicle['year'] ?? "").toString();
        colorController.text = vehicle['color'] ?? "";
        baseController.text = (vehicle['base_charges'] ?? "").toString();
        rateController.text = (vehicle['rate_per_km'] ?? "").toString();

        selectedSeat.value = vehicle['seating_capacity'] ?? 2;
      }
    }
  }

  Future<bool> updateDriver() async {
    final body = {
      "name": nameController.text.trim(),
      "contact_number": phoneController.text.trim(),
      "license_number": licenseController.text.trim(),
      "license_expiry_date": expiryController.text.trim(),
      "user_id": int.parse(userId),
    };

    final res = await WebServicesHelper().updateDriverProfile(
      driverId.value,
      body,
      accessToken,
    );

    return res != null && res['status'] == 200;
  }

  Future<bool> updateVehicleData() async {
    final body = {
      "driver_id": driverId.value,
      "category_id": selectedCategory.value!.id,
      "subcategory_id": selectedSubCategory.value!.id,
      "vehicle_number": vehicleNumberController.text.trim(),
      "make_model": modelController.text.trim(),
      "year": int.tryParse(yearController.text.trim()) ?? 0,
      "color": colorController.text.trim(),

      // 🔥 LOCATION (IMPORTANT)
      "latitude": latitude.value,
      "longitude": longitude.value,

      "seating_capacity": selectedSeat.value,
      "base_charges": double.tryParse(baseController.text.trim()) ?? 0,
      "rate_per_km": double.tryParse(rateController.text.trim()) ?? 0,

      // 🔥 DOCUMENTS
      "rc_document":
          rcDocumentList.isNotEmpty ? rcDocumentList.first.toJson() : {},
      "insurance_document": insuranceDocumentList.isNotEmpty
          ? insuranceDocumentList.first.toJson()
          : {},

      // 🔥 USER LINK
      "updated_by": int.parse(userId),
      "updated_by_id": int.parse(userId),
    };

    final res = await WebServicesHelper().updateVehicle(
      vehicleId.value,
      body,
      accessToken,
    );

    return res != null && res['status'] == 200;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      print("📍 LAT => ${latitude.value}");
      print("📍 LNG => ${longitude.value}");
    } catch (e) {
      print("❌ Location error => $e");
      Utils.showCustomTosstError("Location fetch failed");
    }
  }

// pathch vechile
  Future<void> toggleStatus() async {
    final param = {
      "vechile_id": vehicleId.value,
      "accessToken": accessToken,
    };

    bool newStatus = !isVehicleActive.value;

    final res =
        await WebServicesHelper().toggleVehicleActivation(param, newStatus);

    if (res != null && res['status'] == 200) {
      isVehicleActive.value = newStatus;
      Utils.showCustomTosst(
        newStatus ? "Vehicle Activated" : "Vehicle Deactivated",
      );
    } else {
      Utils.showCustomTosstError(res?['message'] ?? "Failed");
    }
  }

  Future<void> fetchNearbyVehicles() async {
    if (isSubscribing) {
      hasPendingFetch = true;
      return;
    }

    isSubscribing = true;

    try {
      // 🔥 STEP 1: Ensure location
      if (latitude.value == 0.0 || longitude.value == 0.0) {
        await getCurrentLocation();
      }

      final param = {
        "latitude": latitude.value,
        "longitude": longitude.value,
        "radius_km": 50,
      };

      if (selectedCategory.value != null) {
        param["category_id"] = selectedCategory.value!.id;
      }

      if (selectedSubCategory.value != null) {
        param["subcategory_id"] = selectedSubCategory.value!.id;
      }

      // 🔥 STEP 2: API call
      final res = await WebServicesHelper().getVechile(param);

      if (res != null && res['data'] != null) {
        List newData = res['data'];

        // 🔥 STEP 3: Compare IDs (safe)
        List oldIds = nearbyVehicles.map((e) => e['id']).toList();
        List newIds = newData.map((e) => e['id']).toList();
        Set oldSet = oldIds.toSet();
        Set newSet = newIds.toSet();

        bool isDifferent =
            oldSet.length != newSet.length || !oldSet.containsAll(newSet);

        // 🔥 STEP 4: Animate markers (IMPORTANT)
        for (var v in newData) {
          int id = v['id'];
          double lat = v['latitude'];
          double lng = v['longitude'];

          animateMarker(id, LatLng(lat, lng));
        }

        if (isDifferent) {
          print("🔄 Vehicle list changed → resubscribe");

          // 🔥 unsubscribe old channels
          await unsubscribeAll();

          // 🔥 update list
          nearbyVehicles.value = newData;

          // 🔥 ensure connection
          if (!isPusherConnected) {
            await initPusher();
          }

          // 🔥 subscribe new
          await subscribeVehicles();
        } else {
          // 🔥 only update list (NO reconnect)
          nearbyVehicles.value = newData;
        }

        print("🚗 Nearby Vehicles => ${nearbyVehicles.length}");
      }

      // 🔥 fallback connection
      if (!isPusherConnected) {
        await initPusher();
      }
    } catch (e) {
      print("❌ fetch error => $e");
    } finally {
      isSubscribing = false;

      // 🔥 handle pending fetch
      if (hasPendingFetch) {
        hasPendingFetch = false;
        fetchNearbyVehicles();
      }
    }
  }

  Future<void> initPusher() async {
    if (isPusherConnected) return; // 🔥 prevent multiple init

    try {
      await pusher.init(
        apiKey: _apiKey,
        cluster: _cluster,
        onEvent: onEvent,
      );

      await pusher.connect();

      isPusherConnected = true; // ✅ mark connected

      print("✅ Pusher Connected");
    } catch (e) {
      print("❌ Pusher Error => $e");
    }
  }

  Future<void> subscribeVehicles() async {
    for (var v in nearbyVehicles) {
      String channelName = "track-${v['id']}";

      // 🔥 already subscribed skip
      if (subscribedChannels.contains(channelName)) {
        print("⚠️ Skip duplicate => $channelName");
        continue;
      }

      try {
        await pusher.subscribe(channelName: channelName);

        subscribedChannels.add(channelName);

        print("✅ Subscribed => $channelName");
      } catch (e) {
        print("❌ Subscribe error => $e");
      }
    }
  }

  void onEvent(PusherEvent event) async {
    print("📡 EVENT (signal)");

    // 🔥 prevent multiple API spam
    if (isFetchingFromEvent) return;

    isFetchingFromEvent = true;

    try {
      // ❌ data ignore करो
      // ✅ सिर्फ API call करो
      await fetchNearbyVehicles();
    } catch (e) {
      print("❌ Event error => $e");
    }

    // 🔥 cooldown
    Future.delayed(Duration(seconds: 2), () {
      isFetchingFromEvent = false;
    });
  }

  Future<void> unsubscribeAll() async {
    for (var channel in subscribedChannels) {
      try {
        await pusher.unsubscribe(channelName: channel);
        print("❌ Unsubscribed => $channel");
      } catch (e) {
        print("Error unsubscribing $channel => $e");
      }
    }

    subscribedChannels.clear();
  }

// These for specially animation when marker not move and jump directly so we are use these
// make sure resolve these then we are use these animation and do these think

  Future<void> animateMarker(int id, LatLng newPosition) async {
    LatLng? oldPosition = vehiclePositions[id];

    if (oldPosition == null) {
      vehiclePositions[id] = newPosition;
      update(); // 🔥 ADD THIS
      return;
    }

    const int steps = 20;
    const duration = Duration(milliseconds: 1000);

    double latStep = (newPosition.latitude - oldPosition.latitude) / steps;
    double lngStep = (newPosition.longitude - oldPosition.longitude) / steps;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(duration ~/ steps);

      double lat = oldPosition.latitude + latStep * i;
      double lng = oldPosition.longitude + lngStep * i;

      vehiclePositions[id] = LatLng(lat, lng);

      // 🔥 trigger UI update
      update();
    }
  }

  // ============================
  // 🧹 CLEAR FORM
  // ============================
  void clearForm() {
    nameController.clear();
    phoneController.clear();
    licenseController.clear();
    expiryController.clear();
    vehicleNumberController.clear();
    modelController.clear();
    yearController.clear();
    colorController.clear();
    baseController.clear();
    rateController.clear();

    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedSeat.value = 2;

    driverPhotoList.clear();
    rcDocumentList.clear();
    insuranceDocumentList.clear();

    driverId.value = 0;
    isDriverCreated.value = false;
  }

  // ============================
  // 🗺️ LOCATION UPDATE
  // ============================
  void updateLocation(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;
  }
}
