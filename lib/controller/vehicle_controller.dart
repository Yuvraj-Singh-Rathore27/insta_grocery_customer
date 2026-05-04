// // Replace your existing VehicleController with this fixed version

// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';

// import '../model/vechile_model.dart';
// import '../webservices/WebServicesHelper.dart';
// import '../utills/Utils.dart';
// import 'package:get_storage/get_storage.dart';
// import '../preferences/UserPreferences.dart';
// import 'package:geolocator/geolocator.dart';

// class VehicleController extends GetxController {
//   /// ==========================================================
//   /// USER DATA (loaded once from storage)
//   /// ==========================================================
//   late GetStorage store;
//   String userId = "";
//   String accessToken = "";

//   /// ==========================================================
//   /// CATEGORY STATE (API data)
//   /// ==========================================================
//   final categories = <VehicleCategory>[].obs;
//   final subCategories = <VehicleSubCategory>[].obs;

//   final isLoadingCategory = false.obs;
//   final isLoadingSubCategory = false.obs;

//   /// Cache to avoid repeated API calls
//   bool _categoryLoaded = false;
//   final Map<int, List<VehicleSubCategory>> _subCategoryCache = {};

//   /// Selected values
//   VehicleCategory? selectedCategory;
//   VehicleSubCategory? selectedSubCategory;

//   /// ==========================================================
//   /// DRIVER FORM
//   /// ==========================================================
//   String name = "";
//   String contactNumber = "";
//   String licenseNumber = "";
//   String licenseExpiryDate = "";

//   /// Driver Controllers
//   final nameCtrl = TextEditingController();
//   final contactNumberCtrl = TextEditingController();
//   final licenseNumberCtrl = TextEditingController();
//   final licenseExpiryDateCtrl = TextEditingController();

//   /// ==========================================================
//   /// VEHICLE FORM
//   /// ==========================================================
//   String vehicleNumber = "";
//   String makeModel = "";
//   String year = "";
//   String color = "";
//   String baseCharge = "";
//   String rateKm = "";
//   String seatingCapacity = "";

//   /// Vehicle Controllers
//   final vehicleNumberCtrl = TextEditingController();
//   final makeModelCtrl = TextEditingController();
//   final yearCtrl = TextEditingController();
//   final colorCtrl = TextEditingController();
//   final baseChargeCtrl = TextEditingController();
//   final rateKmCtrl = TextEditingController();
//   final seatingCapacityCtrl = TextEditingController();

//   /// ==========================================================
//   /// STATE MANAGEMENT
//   /// ==========================================================
//   int? driverId;
//   var isDriverCreated = false.obs;
//   var isVehicleCreated = false.obs;
//   var isEditingMode = false.obs;
//   var isSubmitting = false.obs;
//   var selectedSeat = "".obs;

//   final formKey = GlobalKey<FormState>();

//   /// ==========================================================
//   /// IMAGE STATE
//   /// ==========================================================
//   final driverImageList = <Map<String, dynamic>>[].obs;
//   final isUploadingImage = false.obs;

//   final isVehicleOnline = false.obs;
//   final vehicleStatus = "".obs;
//   var vehicleId = 0.obs;
//   final currentVehicle = Rxn<Map<String, dynamic>>();

//   final rcDocument = Rxn<Map<String, dynamic>>();
//   final insuranceDocument = Rxn<Map<String, dynamic>>();

//   final vehicles = <Vehicle>[].obs;

//   /// loading state
//   final isLoadingVehicles = false.obs;
//   final hasVehicles = false.obs;

//   // Add this new observable map
//   final subCategoryVehicleCount = <int, bool>{}.obs;
//   final isLoadingSubCategoryAvailability = false.obs;

//   /// ==========================================================
//   /// INIT
//   /// ==========================================================
//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserData();
//     checkDriverExistsFromAPI();

//     // Don't call fetchCategories directly here - let the UI trigger it
//     // Or call it with a slight delay to ensure everything is ready
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchCategories();
//     });

//     ever(isDriverCreated, (_) {
//       if (isDriverCreated.value) {
//         fetchVehicleData();
//       }
//     });
//   }

//   @override
//   void onClose() {
//     nameCtrl.dispose();
//     contactNumberCtrl.dispose();
//     licenseNumberCtrl.dispose();
//     licenseExpiryDateCtrl.dispose();
//     vehicleNumberCtrl.dispose();
//     makeModelCtrl.dispose();
//     yearCtrl.dispose();
//     colorCtrl.dispose();
//     baseChargeCtrl.dispose();
//     rateKmCtrl.dispose();
//     seatingCapacityCtrl.dispose();
//     super.onClose();
//   }

//   /// ==========================================================
//   /// LOAD USER DATA
//   /// ==========================================================
//   void _loadUserData() {
//     store = GetStorage();
//     userId = store.read(UserPreferences.user_id) ?? "";
//     accessToken = store.read("access_token") ?? "";
//     print(
//         "📱 User loaded: userId=$userId, token=${accessToken.substring(0, 10)}...");
//   }

//   /// ==========================================================
//   /// CHECK IF DRIVER EXISTS
//   /// ==========================================================
//   Future<void> checkDriverExistsFromAPI() async {
//     final res =
//         await WebServicesHelper().getDriverByUserId(userId, accessToken);

//     if (res != null && res['data'] != null) {
//       final list = res['data'] as List;
//       if (list.isNotEmpty) {
//         driverId = list.first['id'];
//         isDriverCreated.value = true;
//         store.write("driver_id", driverId);
//         await getDriverProfile();
//       }
//     }
//   }

//   /// ==========================================================
//   /// GET DRIVER PROFILE
//   /// ==========================================================
//   Future<void> getDriverProfile() async {
//     final res =
//         await WebServicesHelper().getDriverByUserId(userId, accessToken);

//     if (res != null && res['data'] != null) {
//       final list = res['data'] as List;
//       if (list.isNotEmpty) {
//         final data = list.first;
//         driverId = data['id'];
//         name = data['name'] ?? "";
//         contactNumber = data['contact_number'] ?? "";
//         licenseNumber = data['license_number'] ?? "";
//         licenseExpiryDate = data['license_expiry_date'] ?? "";

//         nameCtrl.text = name;
//         contactNumberCtrl.text = contactNumber;
//         licenseNumberCtrl.text = licenseNumber;
//         licenseExpiryDateCtrl.text = licenseExpiryDate;

//         if (data['image'] != null) {
//           driverImageList.value = [data['image']];
//         }

//         await checkVehicleExists();
//         update();
//       }
//     }
//   }

//   /// ==========================================================
//   /// CHECK IF VEHICLE EXISTS
//   /// ==========================================================
//   Future<void> checkVehicleExists() async {
//     if (driverId == null) return;

//     try {
//       final res = await WebServicesHelper()
//           .getVehicleByDriverId(driverId!, accessToken);

//       if (res != null && res['data'] != null && res['data'] is List) {
//         final List list = res['data'];

//         if (list.isNotEmpty) {
//           final vehicle = list.first;

//           // ✅ IMPORTANT: store vehicleId
//           vehicleId.value = vehicle['id'] ?? 0;

//           isVehicleCreated.value = true;

//           // ✅ SAFE PARSING
//           vehicleNumber = vehicle['vehicle_number']?.toString() ?? "";
//           makeModel = vehicle['make_model']?.toString() ?? "";
//           year = vehicle['year']?.toString() ?? "";
//           color = vehicle['color']?.toString() ?? "";
//           seatingCapacity = vehicle['seating_capacity']?.toString() ?? "";
//           baseCharge = vehicle['base_charges']?.toString() ?? "";
//           rateKm = vehicle['rate_per_km']?.toString() ?? "";

//           // ✅ SET CONTROLLERS
//           vehicleNumberCtrl.text = vehicleNumber;
//           makeModelCtrl.text = makeModel;
//           yearCtrl.text = year;
//           colorCtrl.text = color;
//           seatingCapacityCtrl.text = seatingCapacity;
//           baseChargeCtrl.text = baseCharge;
//           rateKmCtrl.text = rateKm;

//           // ✅ CATEGORY + SUBCATEGORY
//           if (vehicle['category_id'] != null) {
//             await fetchAndSelectCategory(vehicle['category_id']);
//           }

//           if (vehicle['subcategory_id'] != null) {
//             await fetchAndSelectSubCategory(vehicle['subcategory_id']);
//           }

//           print("✅ Vehicle loaded successfully (ID: ${vehicleId.value})");
//         } else {
//           // ✅ NO VEHICLE CASE
//           isVehicleCreated.value = false;
//           vehicleId.value = 0;

//           print("⚠️ No vehicle found for driver");
//         }
//       } else {
//         print("❌ Invalid vehicle response format");
//       }
//     } catch (e) {
//       print("❌ Error in checkVehicleExists: $e");
//       Utils.showCustomTosstError("Failed to load vehicle data");
//     }
//   }

//   /// ==========================================================
//   /// FETCH CATEGORIES - FIXED
//   /// ==========================================================
//   Future<void> fetchCategories() async {
//     if (_categoryLoaded) {
//       print("📦 Categories already loaded, skipping fetch");
//       return;
//     }

//     isLoadingCategory.value = true;
//     print("🌐 Fetching categories...");

//     try {
//       final res = await WebServicesHelper().vechileCategory({});

//       if (res != null && res['data'] != null) {
//         if (res['data'] is List) {
//           final List dataList = res['data'];
//           print("✅ Found ${dataList.length} categories");

//           categories.value =
//               dataList.map((e) => VehicleCategory.fromJson(e)).toList();

//           _categoryLoaded = true;
//           print("✅ Categories loaded: ${categories.length}");
//         } else {
//           print("❌ Data is not a List: ${res['data'].runtimeType}");
//         }
//       } else {
//         print("❌ No data in response");
//       }
//     } catch (e) {
//       print("❌ Error fetching categories: $e");
//     } finally {
//       isLoadingCategory.value = false;
//     }
//   }

//   /// ==========================================================
//   /// FETCH SUBCATEGORIES - FIXED (MOST IMPORTANT)
//   /// ==========================================================
//   Future<void> fetchSubCategories(int categoryId,
//       {bool forceRefresh = false}) async {
//     // Check cache first
//     if (!forceRefresh && _subCategoryCache.containsKey(categoryId)) {
//       print("📦 Using CACHED subcategories for categoryId: $categoryId");
//       final cachedData = _subCategoryCache[categoryId]!;
//       print("📦 Cache size: ${cachedData.length}");
//       subCategories.value = cachedData;
//       return;
//     }

//     isLoadingSubCategory.value = true;
//     print("🌐 FETCHING subcategories for categoryId: $categoryId");

//     try {
//       final res = await WebServicesHelper()
//           .getVechileSubCategory({"category_id": categoryId});

//       if (res != null && res['data'] != null) {
//         if (res['data'] is List) {
//           final List dataList = res['data'];
//           print("✅ Found ${dataList.length} subcategories");

//           final parsedData =
//               dataList.map((e) => VehicleSubCategory.fromJson(e)).toList();

//           // Update cache and observable
//           _subCategoryCache[categoryId] = parsedData;
//           subCategories.value = parsedData;

//           print("✅ Cached and displayed ${parsedData.length} subcategories");
//         } else {
//           print("❌ Data is not a List: ${res['data'].runtimeType}");
//           subCategories.clear();
//         }
//       } else {
//         print("❌ No data in response");
//         subCategories.clear();
//       }
//     } catch (e) {
//       print("❌ Error fetching subcategories: $e");
//       subCategories.clear();
//     } finally {
//       isLoadingSubCategory.value = false;
//     }
//   }

//   /// ==========================================================
//   /// SELECT CATEGORY - FIXED
//   /// ==========================================================
//   Future<void> selectCategory(VehicleCategory category) async {
//     selectedCategory = category;
//     selectedSubCategory = null;
//     subCategoryVehicleCount.clear(); // ← reset availability
//     update();

//     await fetchSubCategories(category.id);

//     // ← Replace fetchNearbyVehicles with this
//     await fetchSubCategoryVehicleCounts(category.id);
//   }

//   /// ==========================================================
//   /// SELECT SUBCATEGORY
//   /// ==========================================================
//   void selectSubCategory(VehicleSubCategory subCategory) {
//     print("🎯 SubCategory selected: ${subCategory.name}");

//     selectedSubCategory = subCategory;

//     /// 🔥 CALL VEHICLE API HERE
//     fetchNearbyVehicles(
//       categoryId: selectedCategory?.id,
//       subCategoryId: subCategory.id,
//     );

//     update(); // for UI
//   }

//   /// ==========================================================
//   /// FETCH AND SELECT EXISTING CATEGORY/SUBCATEGORY
//   /// ==========================================================
//   Future<void> fetchAndSelectCategory(int categoryId) async {
//     await fetchCategories();
//     final categoryList =
//         categories.where((cat) => cat.id == categoryId).toList();
//     if (categoryList.isNotEmpty) {
//       await selectCategory(categoryList.first);
//     }
//   }

//   Future<void> fetchAndSelectSubCategory(int subCategoryId) async {
//     if (selectedCategory != null) {
//       await fetchSubCategories(selectedCategory!.id);
//       final subList =
//           subCategories.where((sub) => sub.id == subCategoryId).toList();
//       if (subList.isNotEmpty) {
//         selectSubCategory(subList.first);
//       }
//     }
//   }

//   /// ==========================================================
//   /// REFRESH METHODS - ADD THESE
//   /// ==========================================================
//   void refreshCategories() {
//     print("🔄 Manual refresh triggered - clearing all caches");
//     _categoryLoaded = false;
//     _subCategoryCache.clear();
//     categories.clear();
//     subCategories.clear();
//     fetchCategories();
//   }

//   void clearSubCategoryCache(int categoryId) {
//     if (_subCategoryCache.containsKey(categoryId)) {
//       _subCategoryCache.remove(categoryId);
//       print("🗑️ Cleared cache for category $categoryId");
//     }
//   }

//   /// ==========================================================
//   /// TOGGLE EDIT MODE
//   /// ==========================================================
//   void toggleEditMode(bool value) {
//     isEditingMode.value = value;
//     if (value) {
//       // Populate controllers with existing data
//       nameCtrl.text = name;
//       contactNumberCtrl.text = contactNumber;
//       licenseNumberCtrl.text = licenseNumber;
//       licenseExpiryDateCtrl.text = licenseExpiryDate;

//       vehicleNumberCtrl.text = vehicleNumber;
//       makeModelCtrl.text = makeModel;
//       yearCtrl.text = year;
//       colorCtrl.text = color;
//       seatingCapacityCtrl.text = seatingCapacity;
//       baseChargeCtrl.text = baseCharge;
//       rateKmCtrl.text = rateKm;
//     }
//     update();
//   }

//   /// ==========================================================
//   /// SYNC FORM TO STATE
//   /// ==========================================================
//   void syncDriverFormToState() {
//     name = nameCtrl.text.trim();
//     contactNumber = contactNumberCtrl.text.trim();
//     licenseNumber = licenseNumberCtrl.text.trim();
//     licenseExpiryDate = licenseExpiryDateCtrl.text.trim();
//   }

//   void syncVehicleFormToState() {
//     vehicleNumber = vehicleNumberCtrl.text.trim();
//     makeModel = makeModelCtrl.text.trim();
//     year = yearCtrl.text.trim();
//     color = colorCtrl.text.trim();
//     seatingCapacity = seatingCapacityCtrl.text.trim();
//     baseCharge = baseChargeCtrl.text.trim();
//     rateKm = rateKmCtrl.text.trim();
//   }

//   /// ==========================================================
//   /// IMAGE PICK & UPLOAD
//   /// ==========================================================
//   Future<void> pickAndUploadDriverImage() async {
//     final source = await Get.dialog<ImageSource>(
//       AlertDialog(
//         title: const Text("Select Image"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text("Camera"),
//               onTap: () => Get.back(result: ImageSource.camera),
//             ),
//             ListTile(
//               title: const Text("Gallery"),
//               onTap: () => Get.back(result: ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );

//     if (source == null) return;

//     final image = await ImagePicker().pickImage(source: source);
//     if (image == null) return;

//     await uploadDriverImage(File(image.path));
//   }

//   Future<void> uploadDriverImage(File file) async {
//     isUploadingImage.value = true;

//     final res = await WebServicesHelper().fileUpload("image", file);

//     if (res != null && res['status'] == 200) {
//       driverImageList.value = [
//         {
//           "name": res['data']['name'],
//           "path": res['data']['path'],
//         }
//       ];
//     }

//     isUploadingImage.value = false;
//   }

//   /// ==========================================================
//   /// CREATE DRIVER
//   /// ==========================================================
//   Future<int?> createDriver() async {
//     final int userIdInt = int.tryParse(userId) ?? 0;

//     final request = DriverRequest(
//       name: name,
//       contactNumber: contactNumber,
//       licenseNumber: licenseNumber,
//       licenseExpiryDate: licenseExpiryDate,
//       userId: userIdInt,
//       image: driverImageList.isNotEmpty ? driverImageList.first : null,
//       createdBy: userIdInt,
//       createdById: userIdInt,
//       updatedBy: userIdInt,
//       updatedById: userIdInt,
//     );

//     final res =
//         await WebServicesHelper().postDrivers(request.toJson(), accessToken);

//     if (res != null &&
//         (res['status'] == 200 || res['status'] == 201) &&
//         res['data'] != null &&
//         res['data']['id'] != null) {
//       final id = res['data']['id'];
//       store.write("driver_id", id);
//       driverId = id;
//       isDriverCreated.value = true;
//       return id;
//     }

//     if (res != null &&
//         res['message'] == "Driver profile already exists for this user") {
//       await getDriverProfile();
//       isDriverCreated.value = true;
//       return driverId;
//     }

//     Utils.showCustomTosstError("Driver creation failed");
//     return null;
//   }

//   /// ==========================================================
//   /// UPDATE DRIVER
//   /// ==========================================================
//   Future<bool> updateDriver(int driverId) async {
//     final int userIdInt = int.tryParse(userId) ?? 0;

//     if (name.isEmpty || contactNumber.isEmpty || licenseNumber.isEmpty) {
//       Utils.showCustomTosstError("Fill all required fields");
//       return false;
//     }

//     final body = {
//       "name": name,
//       "contact_number": contactNumber,
//       "license_number": licenseNumber,
//       "license_expiry_date": licenseExpiryDate,
//       "image": driverImageList.isNotEmpty ? driverImageList.first : {},
//       "updated_by": userIdInt,
//       "updated_by_id": userIdInt,
//     };

//     final res = await WebServicesHelper().updateDriverProfile(
//       driverId,
//       body,
//       accessToken,
//     );

//     if (res != null && (res['status'] == 200 || res['status'] == 201)) {
//       Utils.showCustomTosst("Driver updated successfully");
//       return true;
//     }

//     Utils.showCustomTosstError("Driver update failed");
//     return false;
//   }

//   /// ==========================================================
//   /// CREATE VEHICLE
//   /// ==========================================================
//   Future<bool> createVehicle(int driverId) async {
//     final int userIdInt = int.tryParse(userId) ?? 0;

//     if (vehicleNumber.isEmpty ||
//         makeModel.isEmpty ||
//         year.isEmpty ||
//         seatingCapacity.isEmpty) {
//       Utils.showCustomTosstError("Fill all vehicle fields");
//       return false;
//     }

//     if (selectedCategory == null || selectedSubCategory == null) {
//       Utils.showCustomTosstError("Select category & subcategory");
//       return false;
//     }
//     final location = await getCurrentLocation();

//     final request = VehicleRequest(
//       driverId: driverId,
//       categoryId: selectedCategory?.id ?? 0,
//       subcategoryId: selectedSubCategory?.id ?? 0,
//       userId: userIdInt,
//       vehicleNumber: vehicleNumber,
//       makeModel: makeModel,
//       year: int.tryParse(year) ?? 0,
//       color: color,
//       seatingCapacity: int.tryParse(seatingCapacity) ?? 0,
//       baseCharges: double.tryParse(baseCharge) ?? 0,
//       ratePerKm: double.tryParse(rateKm) ?? 0,
//       rcDocument: rcDocument.value,
//       insuranceDocument: insuranceDocument.value,
//       createdBy: userIdInt,
//       createdById: userIdInt,
//       updatedBy: userIdInt,
//       updatedById: userIdInt,
//       latitude: location["lat"], // ✅ AUTO
//       longitude: location["lng"],
//     );

//     final res =
//         await WebServicesHelper().postVechile(request.toJson(), accessToken);

//     if (res != null && (res['status'] == 200 || res['status'] == 201)) {
//   isVehicleCreated.value = true;

//   // 🔥 REFRESH VEHICLE DATA AFTER CREATE
//   await checkVehicleExists();

//   return true;
// }
//     return false;
//   }

//   /// ==========================================================
//   /// UPDATE VEHICLE
//   /// ==========================================================
//   Future<bool> updateVehicle(int driverId) async {
//     final int userIdInt = int.tryParse(userId) ?? 0;
//     print("🚗 updateVehicle CALLED");
//     if (vehicleNumber.isEmpty || makeModel.isEmpty || year.isEmpty) {
//       Utils.showCustomTosstError("Fill all vehicle fields");
//       return false;
//     }

//     if (vehicleId.value == 0) {
//       Utils.showCustomTosstError("Vehicle not found");
//       return false;
//     }

//     final location = await getCurrentLocation();

//     final body = {
//       "driver_id": driverId,
//       "category_id": selectedCategory?.id ?? 0,
//       "subcategory_id": selectedSubCategory?.id ?? 0,
//       "user_id": userIdInt,
//       "vehicle_number": vehicleNumber,
//       "make_model": makeModel,
//       "year": int.tryParse(year) ?? 0,
//       "color": color,
//       "seating_capacity": int.tryParse(seatingCapacity) ?? 0,
//       "base_charges": double.tryParse(baseCharge) ?? 0,
//       "rate_per_km": double.tryParse(rateKm) ?? 0,
//       "updated_by": userIdInt,
//       "updated_by_id": userIdInt,
//       "rc_document": rcDocument.value ?? {},
//       "insurance_document": insuranceDocument.value ?? {},
//       "latitude": location["lat"],
//       "longitude": location["lng"],
//     };

//     print("📦 BODY => $body");
//     final res = await WebServicesHelper()
//         .updateVehicle(vehicleId.value, body, accessToken);
//     print("🚗 UPDATE RESPONSE => $res");

//     return res != null && res['status'] == 200;
//   }

//   /// ==========================================================
//   /// COMBINED SUBMISSION
//   /// ==========================================================
  
//   Future<void> submitCombinedRegistration() async {
//   if (!formKey.currentState!.validate()) return;

//   if (isSubmitting.value) return;
//   isSubmitting.value = true;

//   try {
//     // 🔹 STEP 1: CREATE / UPDATE DRIVER
//     int? currentDriverId = driverId;

//     if (!isDriverCreated.value) {
//       syncDriverFormToState();

//       currentDriverId = await createDriver();

//       if (currentDriverId == null) {
//         Utils.showCustomTosstError("Driver registration failed");
//         isSubmitting.value = false;
//         return;
//       }
//     } else if (isEditingMode.value) {
//       syncDriverFormToState();

//       final success = await updateDriver(driverId!);

//       if (!success) {
//         Utils.showCustomTosstError("Driver update failed");
//         isSubmitting.value = false;
//         return;
//       }
//     }

//     // 🔹 STEP 2: CREATE / UPDATE VEHICLE
//     syncVehicleFormToState();

//     if (selectedCategory == null || selectedSubCategory == null) {
//       Utils.showCustomTosstError("Please select vehicle category");
//       isSubmitting.value = false;
//       return;
//     }

//     bool vehicleSuccess;
//     if (vehicleId.value != 0) {
//       print("🔄 UPDATE VEHICLE");
//       vehicleSuccess = await updateVehicle(currentDriverId!);
//     } else {
//       print("🚗 CREATE VEHICLE");
//       vehicleSuccess = await createVehicle(currentDriverId!);
//     }

//     if (!vehicleSuccess) {
//       Utils.showCustomTosstError("Vehicle operation failed");
//       isSubmitting.value = false;
//       return;
//     }

//     // 🔥 IMPORTANT: sync latest data (fix duplicate / wrong state issue)
//     await checkVehicleExists();

//     // 🔹 SUCCESS FLOW
//     isEditingMode.value = false;

//     // ✅ stop loader BEFORE navigation
//     isSubmitting.value = false;

//     Utils.showCustomTosst("Registration completed successfully!");

//     // ✅ wait UI stable
//     await Future.delayed(const Duration(milliseconds: 400));

//     // ✅ close dialogs if any
//     while (Get.isOverlaysOpen) {
//       Get.back();
//     }

//     // ✅ go back
//     if (Navigator.of(Get.context!).canPop()) {
//   Get.back(result: true);
// }

//   } catch (e) {
//     print("❌ ERROR => $e");
//     Utils.showCustomTosstError("Something went wrong");
//     isSubmitting.value = false;
//   }
// }

//   /// ==========================================================
//   /// UPDATE BOTH PROFILES
//   /// ==========================================================
//  Future<void> updateBothProfiles() async {
//   if (isSubmitting.value) return;

//   isSubmitting.value = true;

//   try {
//     if (driverId == null) {
//       Utils.showCustomTosstError("Driver not found");
//       isSubmitting.value = false;
//       return;
//     }

//     print("🔄 Updating DRIVER...");
//     bool driverSuccess = await updateDriver(driverId!);

//     if (!driverSuccess) {
//       Utils.showCustomTosstError("Driver update failed");
//       isSubmitting.value = false;
//       return;
//     }

//     print("🔄 Updating VEHICLE...");
//     print("vehicleId => ${vehicleId.value}");

//     if (vehicleId.value == 0) {
//       Utils.showCustomTosstError("Vehicle not found");
//       isSubmitting.value = false;
//       return;
//     }

//     bool vehicleSuccess = await updateVehicle(driverId!);

//     if (!vehicleSuccess) {
//       Utils.showCustomTosstError("Vehicle update failed");
//       isSubmitting.value = false;
//       return;
//     }

//     // 🔥 IMPORTANT: sync latest data
//     await checkVehicleExists();

//     // ✅ SUCCESS FLOW
//     Utils.showCustomTosst("Profile updated successfully");

//     // ✅ stop loader FIRST
//     isSubmitting.value = false;

//     // ✅ wait UI stable
//     await Future.delayed(const Duration(milliseconds: 400));

//     // ✅ close dialogs if any
//     while (Get.isOverlaysOpen) {
//       Get.back();
//     }

//     // ✅ go back
//     Get.back(result: true);

//   } catch (e) {
//     print("❌ Error in updateBothProfiles: $e");
//     Utils.showCustomTosstError("Something went wrong");

//     isSubmitting.value = false;
//   }
// }


//   /// ==========================================================
//   /// TOGGLE VEHICLE ACTIVATION
//   /// ==========================================================
//   Future<void> toggleVehicleActivation(bool activate) async {
//     if (vehicleId.value == 0) return;

//     isSubmitting.value = true;

//     try {
//       final param = {
//         'vechile_id': vehicleId.value,
//         'accessToken': accessToken,
//       };

//       final response =
//           await WebServicesHelper().toggleVehicleActivation(param, activate);

//       if (response != null && response['status'] == 200) {
//         /// ✅ UPDATE LOCAL STATE
//         isVehicleOnline.value = activate;
//         vehicleStatus.value = activate ? "active" : "inactive";

//         /// 🔥 IMPORTANT: UPDATE currentVehicle ALSO
//         if (currentVehicle.value != null) {
//           currentVehicle.value!['status'] = activate ? "active" : "inactive";
//           currentVehicle.refresh();
//         }

//         /// 🔥 FORCE REFETCH FROM API
//         await fetchVehicleData();

//         Utils.showCustomTosst(
//           activate
//               ? "Vehicle activated successfully"
//               : "Vehicle deactivated successfully",
//         );
//       }
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   /// ==========================================================
//   /// FETCH VEHICLE DATA (call this after driver is loaded)
//   /// ==========================================================
//   Future<void> fetchVehicleData() async {
//     if (driverId == null) return;

//     final res =
//         await WebServicesHelper().getVehicleByDriverId(driverId!, accessToken);

//     if (res != null && res['data'] != null) {
//       final list = res['data'] as List;

//       if (list.isNotEmpty) {
//         final vehicle = list.first;

//         currentVehicle.value = vehicle;
//         vehicleId.value = vehicle['id'] ?? 0;

//         /// 🔥 FIX START HERE
//         final isActive = vehicle['is_active'] ?? false;

//         vehicleStatus.value = isActive ? "active" : "inactive";
//         isVehicleOnline.value = isActive;

//         /// 🔥 FIX END

//         print("🚗 API is_active => $isActive");

//         update();
//       }
//     }
//   }

//   /// ==========================================================
//   /// FETCH VEHICLES BY SUBCATEGORY ID
//   /// ==========================================================
//   Future<void> fetchNearbyVehicles({
//     int? categoryId,
//     int? subCategoryId,
//   }) async {
//     print("📍 Fetching nearby vehicles...");

//     isLoadingVehicles.value = true;

//     try {
//       /// 🔥 GET CURRENT LOCATION
//       final location = await getCurrentLocation();

//       final params = {
//         "latitude": location["lat"],
//         "longitude": location["lng"],
//         "radius_km": 50,
//       };

//       /// ✅ OPTIONAL FILTERS
//       if (categoryId != null) {
//         params["category_id"] = categoryId;
//       }

//       if (subCategoryId != null) {
//         params["subcategory_id"] = subCategoryId;
//       }

//       print("📦 PARAMS => $params");

//       final res = await WebServicesHelper().getVechile(params);

//       if (res != null && res['data'] != null) {
//         if (res['data'] is List) {
//           final List dataList = res['data'];

//           vehicles.value = dataList.map((e) => Vehicle.fromJson(e)).toList();

//           // 🔥 ADD THIS
//           hasVehicles.value = vehicles.isNotEmpty;

//           print("✅ Nearby vehicles: ${vehicles.length}");
//         } else {
//           vehicles.clear();
//         }
//       } else {
//         vehicles.clear();
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//       vehicles.clear();
//       hasVehicles.value = false;
//     } finally {
//       isLoadingVehicles.value = false;
//     }
//   }

// // upoload rc and upload insureence
//   Future<void> uploadRcDocument(File file) async {
//     final res = await WebServicesHelper().fileUpload("document", file);

//     if (res != null && res['status'] == 200) {
//       rcDocument.value = {
//         "name": res['data']['path'].toString().split('/').last,
//         "path": res['data']['path'],
//       };
//     }
//   }

//   Future<void> uploadInsuranceDocument(File file) async {
//     final res = await WebServicesHelper().fileUpload("document", file);

//     if (res != null && res['status'] == 200) {
//       insuranceDocument.value = {
//         "name": res['data']['path'].toString().split('/').last,
//         "path": res['data']['path'],
//       };
//     }
//   }

//   Future<Map<String, double>> getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }

//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         print("⚠️ Location permission denied");
//         return {"lat": 0.0, "lng": 0.0}; // fallback
//       }

//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       return {
//         "lat": position.latitude,
//         "lng": position.longitude,
//       };
//     } catch (e) {
//       print("❌ Location error: $e");
//       return {"lat": 0.0, "lng": 0.0}; // fallback
//     }
//   }

//   Future<void> showImageSourceDialog({
//     required Function(File file) onImageSelected,
//   }) async {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Select Image",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),

//               const SizedBox(height: 20),

//               /// 📸 CAMERA
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.blue),
//                 title: const Text("Capture Image"),
//                 onTap: () async {
//                   Get.back();
//                   final image =
//                       await ImagePicker().pickImage(source: ImageSource.camera);

//                   if (image != null) {
//                     onImageSelected(File(image.path));
//                   }
//                 },
//               ),

//               /// 🖼️ GALLERY
//               ListTile(
//                 leading: const Icon(Icons.photo, color: Colors.green),
//                 title: const Text("Select from Gallery"),
//                 onTap: () async {
//                   Get.back();
//                   final image = await ImagePicker()
//                       .pickImage(source: ImageSource.gallery);

//                   if (image != null) {
//                     onImageSelected(File(image.path));
//                   }
//                 },
//               ),

//               const SizedBox(height: 10),

//               TextButton(
//                 onPressed: () => Get.back(),
//                 child:
//                     const Text("Cancel", style: TextStyle(color: Colors.red)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> fetchSubCategoryVehicleCounts(int categoryId) async {
//     isLoadingSubCategoryAvailability.value = true;
//     subCategoryVehicleCount.clear();

//     final location = await getCurrentLocation();

//     for (final sub in subCategories) {
//       try {
//         final params = {
//           "latitude": location["lat"],
//           "longitude": location["lng"],
//           "radius_km": 50,
//           "category_id": categoryId,
//           "subcategory_id": sub.id,
//         };

//         final res = await WebServicesHelper().getVechile(params);

//         if (res != null && res['data'] is List) {
//           subCategoryVehicleCount[sub.id] = (res['data'] as List).isNotEmpty;
//         } else {
//           subCategoryVehicleCount[sub.id] = false;
//         }
//       } catch (e) {
//         subCategoryVehicleCount[sub.id] = false;
//       }
//     }

//     subCategoryVehicleCount.refresh();
//     isLoadingSubCategoryAvailability.value = false;
//   }


// void updateVehiclePosition(int vehicleId, double lat, double lng) {
//   int index = vehicles.indexWhere((v) => v.id == vehicleId);

//   if (index != -1) {
//     final old = vehicles[index];

//     final updatedVehicle = Vehicle(
//       id: old.id,
//       categoryId: old.categoryId,
//       subcategoryId: old.subcategoryId,
//       vehicleNumber: old.vehicleNumber,
//       makeModel: old.makeModel,
//       color: old.color,
//       seatingCapacity: old.seatingCapacity,
//       baseCharges: old.baseCharges,
//       ratePerKm: old.ratePerKm,
//       driverId: old.driverId,
//       status: old.status,
//       latitude: lat,
//       longitude: lng,
//       driver: old.driver,
//     );

//     vehicles[index] = updatedVehicle;
//     vehicles.refresh();
//   }
// }
//   /// ==========================================================
//   /// RESET FORM
//   /// ==========================================================
//   void reset() {
//     selectedCategory = null;
//     selectedSubCategory = null;
//     subCategories.clear();

//     name = "";
//     contactNumber = "";
//     licenseNumber = "";
//     licenseExpiryDate = "";
//     vehicleNumber = "";
//     makeModel = "";
//     year = "";
//     color = "";
//     baseCharge = "";
//     rateKm = "";
//     seatingCapacity = "";

//     nameCtrl.clear();
//     contactNumberCtrl.clear();
//     licenseNumberCtrl.clear();
//     licenseExpiryDateCtrl.clear();
//     vehicleNumberCtrl.clear();
//     makeModelCtrl.clear();
//     yearCtrl.clear();
//     colorCtrl.clear();
//     baseChargeCtrl.clear();
//     rateKmCtrl.clear();
//     seatingCapacityCtrl.clear();

//     driverImageList.clear();
//     isEditingMode.value = false;

//     update();
//   }
// }
