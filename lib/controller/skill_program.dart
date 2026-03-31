import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../webservices/WebServicesHelper.dart';
import '../model/skill_program.dart';
import '../model/responsemodel/skill_program_response.dart';
import '../utills/Utils.dart';
import '../res/AppColor.dart';

import '../preferences/UserPreferences.dart';


import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';

class SkillProgramController extends GetxController {

  late GetStorage store;
  String userId = "";
  String accessToken = "";


  /// ================= LOADING =================
  RxBool isCategoryLoading = false.obs;
  RxBool isSubCategoryLoading = false.obs;
  RxBool isTypeLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isPosting = false.obs;
  RxBool isUploadingImage = false.obs;
  RxString feesType = "paid".obs; 
  
  /// ================= DATA =================
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> subCategoryList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> typeList = <Map<String, dynamic>>[].obs;

  RxList<SkillProgram> skillProgramList = <SkillProgram>[].obs;
  RxList<SkillProgram> filteredSkillProgramList = <SkillProgram>[].obs;
  
  /// ================= SELECTION =================
  RxInt selectedCategoryId = 0.obs;
  RxInt selectedSubCategoryId = 0.obs;
  RxInt selectedTypeId = 0.obs;

  /// ================= TEXT CONTROLLERS =================
  final titleController = TextEditingController();
  final durationController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchTitleController = TextEditingController(); // For search by title

  /// ================= LIVE PREVIEW RX =================
  RxString previewTitle = "".obs;
  RxString previewDuration = "".obs;
  RxString previewLocation = "".obs;
  RxString previewPrice = "".obs;
  RxString previewDescription = "".obs;

RxSet<int> appliedProgramIds = <int>{}.obs;
  /// ================= DROPDOWNS =================
  final List<String> programModeList = [
    "online",
    "offline",
    "hybrid",
  ];

  RxString selectedProgramMode = "".obs;

  final List<String> feesTypeList = [
    "paid",
    "free",
  ];

  /// ================= FILTER VARIABLES =================
  RxInt filterCategoryId = 0.obs;
  RxInt filterSubCategoryId = 0.obs;
  RxInt filterTypeId = 0.obs;
  RxString filterProgramMode = "".obs;
  RxInt filterMinPrice = 0.obs;
  RxInt filterMaxPrice = 0.obs;
  RxString filterDuration = "".obs;
  RxString filterFeesType = "".obs;
  RxString filterDisplayType = "".obs;
  RxString filterTitle = "".obs;

  RxInt selectedSuperCategoryId = 0.obs;

  /// ================= IMAGE =================
  RxList<Map<String, dynamic>> skillProgramImageList =
      <Map<String, dynamic>>[].obs;

      RxList<SkillsSuperCategoryModel> superCategoryList =
    <SkillsSuperCategoryModel>[].obs;

RxBool isSuperCategoryLoading = false.obs;

  /// ================= AUTHENTICATION =================


  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    _loadUserData();
     getSuperCategories();

    
    
    print("SkillControlelr UserId => $userId");
    print("SkillControlelr accessToken => $accessToken");

    titleController.addListener(() {
      previewTitle.value = titleController.text;
    });

    durationController.addListener(() {
      previewDuration.value = durationController.text;
    });

    locationController.addListener(() {
      previewLocation.value = locationController.text;
    });

    priceController.addListener(() {
      previewPrice.value = priceController.text;
    });

    descriptionController.addListener(() {
      previewDescription.value = descriptionController.text;
    });

    // Add listener for search title with debounce
    searchTitleController.addListener(() {
      filterTitle.value = searchTitleController.text;
    });
  }

  void _loadUserData() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    accessToken = store.read(UserPreferences.access_token) ?? "";
    
    print("SkillController UserId => $userId");
    print("SkillController accessToken => $accessToken");
  }

  void initData({
    required String token,
  }) {
    accessToken = token;
    getSkillProgramList();
    getCategory();
    getType();
   
  }

  /// ================= CATEGORY =================
  Future<void> getCategory({int? superCategoryId}) async {
  try {
    isCategoryLoading.value = true;

    // 🔥 SAVE SELECTED SUPER CATEGORY
    if (superCategoryId != null) {
      selectedSuperCategoryId.value = superCategoryId;
    }

    // 🔥 PARAM BUILD
    Map<String, dynamic> param = {};

    if (selectedSuperCategoryId.value != 0) {
      param["super_category_id"] =
          selectedSuperCategoryId.value;
    }

    final res =
        await WebServicesHelper().getSkillProgramCategory(param);

    print("=== CATEGORY RESPONSE ===");
    print(res);

    if (res != null && res['data'] != null) {
      categoryList.assignAll(
        List<Map<String, dynamic>>.from(res['data']),
      );
    } else {
      categoryList.clear();
    }
  } catch (e) {
    print("Error: $e");
    Utils.showCustomTosstError("Failed to load categories");
  } finally {
    isCategoryLoading.value = false;
  }
}


  Future<void> getSuperCategories() async {
  try {
    isSuperCategoryLoading.value = true;

    final res = await WebServicesHelper()
        .getSkillProgramSuperCategory({});

    print("=== SUPER CATEGORY RESPONSE ===");
    print(res);

    if (res != null && res['data'] != null) {
      List list = res['data'];

      superCategoryList.assignAll(
        list.map((e) => SkillsSuperCategoryModel.fromJson(e)).toList(),
      );

      print("Loaded: ${superCategoryList.length}");
    } else {
      superCategoryList.clear();
    }
  } catch (e) {
    print("Error: $e");
    Utils.showCustomTosstError("Failed to load super categories");
  } finally {
    isSuperCategoryLoading.value = false;
  }
}

  /// ================= SUB CATEGORY =================
  Future<void> getSubCategory(int categoryId) async {
    try {
      selectedCategoryId.value = categoryId;
      selectedSubCategoryId.value = 0;
      isSubCategoryLoading.value = true;

      final res = await WebServicesHelper()
          .getSkillProgramSubcategory({"category_id": categoryId});

      if (res != null && res['data'] != null) {
        subCategoryList.assignAll(
            List<Map<String, dynamic>>.from(res['data']));
      } else {
        subCategoryList.clear();
      }
    } catch (e) {
      Utils.showCustomTosstError("Failed to load subcategories");
    } finally {
      isSubCategoryLoading.value = false;
    }
  }

  /// ================= TYPE =================
  Future<void> getType() async {
    try {
      isTypeLoading.value = true;
      
      final res = await WebServicesHelper().getSkillProgramType({
        "access_token": accessToken,
      });

      print("=== TYPE API RESPONSE ===");
      print("Response code: ${res?['status']}");
      
      if (res != null && res['status'] == 200 && res['data'] != null) {
        typeList.clear();
        
        List<Map<String, dynamic>> types = [];
        for (var item in res['data']) {
          types.add({
            'id': item['id'],
            'name': item['name'],
            'description': item['description'] ?? '',
            'image': item['image'],
          });
        }
        
        typeList.assignAll(types);
        
        print("Types loaded: ${typeList.length}");
        for (var type in typeList) {
          print("Type ID: ${type['id']}, Name: ${type['name']}");
        }
        
      } else {
        typeList.clear();
        print("No types found or invalid response");
        print("Response: $res");
      }
    } catch (e) {
      print("Error loading types: $e");
      print("Stack trace: ${StackTrace.current}");
      Utils.showCustomTosstError("Failed to load types: ${e.toString()}");
    } finally {
      isTypeLoading.value = false;
    }
  }

  /// ================= SKILL PROGRAM LIST WITH BACKEND FILTERS =================
 Future<void> getSkillProgramList({
  int? categoryId,
  int? subcategoryId,
  int? typeId,
  String? programMode,
  String? title,
  int? minPrice,
  int? maxPrice,
  String? duration,
  String? feesType,
  String? displayType,
}) async {
  try {
    isLoading.value = true;
    
    // Build parameters with filters - all values must be strings
    final Map<String, String> param = {
      "access_token": accessToken,
    };
    
    // Add filter parameters if provided (prioritize passed parameters over filter variables)
    if (categoryId != null && categoryId != 0) {
      param["category_id"] = categoryId.toString();
      filterCategoryId.value = categoryId;
    } else if (filterCategoryId.value != 0) {
      param["category_id"] = filterCategoryId.value.toString();
    }
    
    if (subcategoryId != null && subcategoryId != 0) {
      param["subcategory_id"] = subcategoryId.toString();
      filterSubCategoryId.value = subcategoryId;
    } else if (filterSubCategoryId.value != 0) {
      param["subcategory_id"] = filterSubCategoryId.value.toString();
    }
    
    if (typeId != null && typeId != 0) {
      param["type_id"] = typeId.toString();
      filterTypeId.value = typeId;
    } else if (filterTypeId.value != 0) {
      param["type_id"] = filterTypeId.value.toString();
    }
    
    if (programMode != null && programMode.isNotEmpty) {
      param["program_mode"] = programMode;
      filterProgramMode.value = programMode;
    } else if (filterProgramMode.value.isNotEmpty) {
      param["program_mode"] = filterProgramMode.value;
    }
    
    if (title != null && title.isNotEmpty) {
      param["title"] = title;
      filterTitle.value = title;
    } else if (filterTitle.value.isNotEmpty) {
      param["title"] = filterTitle.value;
    }
    
    if (minPrice != null && minPrice > 0) {
      param["min_price"] = minPrice.toString();
      filterMinPrice.value = minPrice;
    } else if (filterMinPrice.value > 0) {
      param["min_price"] = filterMinPrice.value.toString();
    }
    
    if (maxPrice != null && maxPrice > 0) {
      param["max_price"] = maxPrice.toString();
      filterMaxPrice.value = maxPrice;
    } else if (filterMaxPrice.value > 0) {
      param["max_price"] = filterMaxPrice.value.toString();
    }
    
    if (duration != null && duration.isNotEmpty) {
      param["duration"] = duration;
      filterDuration.value = duration;
    } else if (filterDuration.value.isNotEmpty) {
      param["duration"] = filterDuration.value;
    }
    
    if (feesType != null && feesType.isNotEmpty) {
      param["fees_type"] = feesType;
      filterFeesType.value = feesType;
    } else if (filterFeesType.value.isNotEmpty) {
      param["fees_type"] = filterFeesType.value;
    }
    
    if (displayType != null && displayType.isNotEmpty) {
      param["display_type"] = displayType;
      filterDisplayType.value = displayType;
    } else if (filterDisplayType.value.isNotEmpty) {
      param["display_type"] = filterDisplayType.value;
    }

    print("=== GET SKILL PROGRAM PARAMS ===");
    print(param);

    final res = await WebServicesHelper().getSkillProgram(param);

    if (res != null) {
      final model = SkillProgramResponse.fromJson(res);
      skillProgramList.assignAll(model.data ?? []);
      filteredSkillProgramList.assignAll(skillProgramList);
      
      print("Loaded ${skillProgramList.length} skill programs");
    } else {
      skillProgramList.clear();
      filteredSkillProgramList.clear();
    }
  } catch (e) {
    print("Error loading skill programs: $e");
    Utils.showCustomTosstError("Failed to load skill programs");
  } finally {
    isLoading.value = false;
  }
}


/// ================= APPLY SKILL PROGRAM =================
 /// ================= APPLY SKILL PROGRAM =================
Future<bool> applySkillProgram({
  required int skillProgramId,
  required String userType,
}) async {
  try {
    // Check if already applied in local state
    if (appliedProgramIds.contains(skillProgramId)) {
      Utils.showCustomTosst("You have already applied for this program");
      return false;
    }
    
    isPosting.value = true;
    
    final Map<String, dynamic> param = {
      "accessToken": accessToken,
      "user_type": userType,
      "user_id": int.tryParse(userId) ?? 0,
      "skill_program_id": skillProgramId,
    };
    
    print("=== APPLY SKILL PROGRAM PARAMS ===");
    print(param);
    
    final response = await WebServicesHelper().postApplySkillProgram(param);
    
    if (response != null) {
      print("Response status: ${response['status']}");
      print("Response message: ${response['message']}");
      print("Response error: ${response['error']}");
      
      // Handle already applied case (status 500)
      if (response['status'] == 500 && 
          response['message'] != null && 
          response['message'].toString().toLowerCase().contains("already applied")) {
        // Add to applied set to update UI
        appliedProgramIds.add(skillProgramId);
        Utils.showCustomTosst("You have already applied for this program");
        return false;
      }
      
      // Handle success (status 200)
      if (response['status'] == 200) {
        // Check if there's an error in response
        if (response['error'] == true) {
          String errorMessage = response['message'] ?? "Failed to apply";
          
          // Check if message indicates already applied
          if (errorMessage.toLowerCase().contains("already applied") || 
              errorMessage.toLowerCase().contains("already exists")) {
            // Add to applied set
            appliedProgramIds.add(skillProgramId);
            Utils.showCustomTosst("You have already applied for this program");
          } else {
            Utils.showCustomTosstError(errorMessage);
          }
          return false;
        }
        
        // Success - Add to applied set
        appliedProgramIds.add(skillProgramId);
        Utils.showCustomTosst("Successfully applied for skill program");
        return true;
      } 
      // Handle other status codes
      else {
        String errorMessage = response['message'] ?? "Failed to apply for skill program";
        
        // If message contains "already applied", still add to set
        if (errorMessage.toLowerCase().contains("already applied")) {
          appliedProgramIds.add(skillProgramId);
          Utils.showCustomTosst("You have already applied for this program");
        } else {
          Utils.showCustomTosstError(errorMessage);
        }
        return false;
      }
    } else {
      Utils.showCustomTosstError("Failed to apply for skill program");
      return false;
    }
  } catch (e) {
    print("Error applying for skill program: $e");
    Utils.showCustomTosstError("Error: ${e.toString()}");
    return false;
  } finally {
    isPosting.value = false;
  }
}


  // Helper method to check if user has applied for a program
  bool hasApplied(int programId) {
    return appliedProgramIds.contains(programId);
  }
  
  // Load applied programs from API if needed
  Future<void> loadAppliedPrograms() async {
    try {
      // Call API to get user's applied programs
      // final response = await WebServicesHelper().getUserAppliedPrograms(accessToken);
      // if (response != null && response['data'] != null) {
      //   appliedProgramIds.clear();
      //   for (var program in response['data']) {
      //     appliedProgramIds.add(program['skill_program_id']);
      //   }
      // }
    } catch (e) {
      print("Error loading applied programs: $e");
    }
  }



// Add this method to handle apply with proper state management
Future<void> handleApplyProgram(SkillProgram program) async {
  // Check if already applied
  if (hasApplied(program.id ?? 0)) {
    // Show custom toast for already applied
    Get.snackbar(
      'Already Applied',
      'You have already applied for ${program.title}',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
    return;
  }
  
  // Close the bottom sheet
  Get.back();
  
  // Show confirmation dialog
  final bool? confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Apply for Program'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to apply for:',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            program.title ?? 'this program',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'The program coordinator will review your application and contact you soon.',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor().colorPrimary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Apply'),
        ),
      ],
    ),
  );
  
  if (confirmed == true) {
    // Show loading
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    
    // Call the apply function from controller
    final bool success = await applySkillProgram(
      skillProgramId: program.id ?? 0,
      userType: "user",
    );
    
    // Close loading dialog
    Get.back();
    
    if (success) {
      // Show success message
      Get.snackbar(
        'Success!',
        'Successfully applied for ${program.title}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      
      // Refresh the list to update UI
      await refreshList();
    }
  }
}

  /// ================= FILTER METHODS =================
  
  // Filter by Category
  void filterByCategory(int categoryId) {
    filterCategoryId.value = categoryId;
    filterSubCategoryId.value = 0; // Reset subcategory when category changes
    getSkillProgramList();
  }
  
  // Filter by Subcategory
  void filterBySubCategory(int subcategoryId) {
    filterSubCategoryId.value = subcategoryId;
    getSkillProgramList();
  }
  
  // Filter by Type
  void filterByType(int typeId) {
    filterTypeId.value = typeId;
    getSkillProgramList();
  }
  
  // Filter by Program Mode
  void filterByProgramMode(String mode) {
    filterProgramMode.value = mode;
    getSkillProgramList();
  }
  
  // Filter by Title (Search)
  void filterByTitle(String title) {
    filterTitle.value = title;
    getSkillProgramList();
  }
  
  // Filter by Price Range
  void filterByPriceRange(int minPrice, int maxPrice) {
    filterMinPrice.value = minPrice;
    filterMaxPrice.value = maxPrice;
    getSkillProgramList();
  }
  
  // Filter by Duration
  void filterByDuration(String duration) {
    filterDuration.value = duration;
    getSkillProgramList();
  }
  
  // Filter by Fees Type
  void filterByFeesType(String feesType) {
    filterFeesType.value = feesType;
    getSkillProgramList();
  }
  
  // Filter by Display Type (active/inactive/all)
  void filterByDisplayType(String displayType) {
    filterDisplayType.value = displayType;
    getSkillProgramList();
  }
  
  // Apply Advanced Filters (for floating button)
  void applyAdvancedFilters({
    int? categoryId,
    int? subcategoryId,
    int? typeId,
    String? programMode,
    String? title,
    int? minPrice,
    int? maxPrice,
    String? duration,
    String? feesType,
    String? displayType,
  }) {
    // Update filter variables
    if (categoryId != null) filterCategoryId.value = categoryId;
    if (subcategoryId != null) filterSubCategoryId.value = subcategoryId;
    if (typeId != null) filterTypeId.value = typeId;
    if (programMode != null) filterProgramMode.value = programMode;
    if (title != null) filterTitle.value = title;
    if (minPrice != null) filterMinPrice.value = minPrice;
    if (maxPrice != null) filterMaxPrice.value = maxPrice;
    if (duration != null) filterDuration.value = duration;
    if (feesType != null) filterFeesType.value = feesType;
    if (displayType != null) filterDisplayType.value = displayType;
    
    // Apply filters
    getSkillProgramList();
  }
  
  // Clear all filters
  void clearFilters() {
    // Reset all filter variables
    filterCategoryId.value = 0;
    filterSubCategoryId.value = 0;
    filterTypeId.value = 0;
    filterProgramMode.value = "";
    filterTitle.value = "";
    filterMinPrice.value = 0;
    filterMaxPrice.value = 0;
    filterDuration.value = "";
    filterFeesType.value = "";
    filterDisplayType.value = "";
    
    // Clear search controller
    searchTitleController.clear();
    
    // Reset selection variables (for form)
    selectedCategoryId.value = 0;
    selectedSubCategoryId.value = 0;
    selectedTypeId.value = 0;
    selectedProgramMode.value = "";
    feesType.value = "paid";
    
    // Reload all programs
    getSkillProgramList();
  }
  
  // Check if any filters are active
  bool get hasActiveFilters {
    return filterCategoryId.value != 0 ||
        filterSubCategoryId.value != 0 ||
        filterTypeId.value != 0 ||
        filterProgramMode.value.isNotEmpty ||
        filterTitle.value.isNotEmpty ||
        filterMinPrice.value > 0 ||
        filterMaxPrice.value > 0 ||
        filterDuration.value.isNotEmpty ||
        filterFeesType.value.isNotEmpty ||
        filterDisplayType.value.isNotEmpty;
  }
  
  // Get active filters count
  int get activeFiltersCount {
    int count = 0;
    if (filterCategoryId.value != 0) count++;
    if (filterSubCategoryId.value != 0) count++;
    if (filterTypeId.value != 0) count++;
    if (filterProgramMode.value.isNotEmpty) count++;
    if (filterTitle.value.isNotEmpty) count++;
    if (filterMinPrice.value > 0) count++;
    if (filterMaxPrice.value > 0) count++;
    if (filterDuration.value.isNotEmpty) count++;
    if (filterFeesType.value.isNotEmpty) count++;
    if (filterDisplayType.value.isNotEmpty) count++;
    return count;
  }

  /// ================= IMAGE UPLOAD =================
  Future<void> uploadSkillProgramImage(File imageFile) async {
    try {
      isUploadingImage.value = true;

      final uploadRes =
          await WebServicesHelper().fileUpload("image", imageFile);

      if (uploadRes == null || uploadRes['status'] != 200) {
        Utils.showCustomTosstError("Image upload failed");
        return;
      }

      final imageForApi = {
        "name": uploadRes['data']['name'],
        "path": uploadRes['data']['path'],
        "size": uploadRes['data']['size'] ?? await imageFile.length(),
        "url": uploadRes['data']['path'],
        "type": "banner",
      };

      skillProgramImageList.clear();
      skillProgramImageList.add(imageForApi);
    } catch (e) {
      Utils.showCustomTosstError("Image upload failed: ${e.toString()}");
    } finally {
      isUploadingImage.value = false;
    }
  }

  void removeImage() {
    skillProgramImageList.clear();
  }
  
  /// ================= LOCATION =================
  Future<void> getCurrentLocation() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.back(); // Close loading
        Get.snackbar(
          'Location Error',
          'Please enable location services',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.back(); // Close loading
          Get.snackbar(
            'Permission Denied',
            'Location permission is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.back(); // Close loading
        Get.snackbar(
          'Permission Denied',
          'Location permissions are permanently denied. Please enable from settings.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Get.back(); // Close loading

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // Format the address
        String location = [
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((element) => element != null && element.isNotEmpty).join(', ');
        
        // Update the controller
        locationController.text = location;
        
        // Show success message
        Get.snackbar(
          'Success',
          'Location detected: $location',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not detect location',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.back(); // Close loading if open
      Get.snackbar(
        'Error',
        'Failed to get location: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ================= CLEAR =================
  void clearSkillProgramForm() {
    titleController.clear();
    durationController.clear();
    priceController.clear();
    locationController.clear();
    descriptionController.clear();

    previewTitle.value = "";
    previewDuration.value = "";
    previewLocation.value = "";
    previewPrice.value = "";
    previewDescription.value = "";

    selectedCategoryId.value = 0;
    selectedSubCategoryId.value = 0;
    selectedTypeId.value = 0;
    selectedProgramMode.value = "";
    feesType.value = "paid";

    skillProgramImageList.clear();
  }

  /// ================= REFRESH =================
  Future<void> refreshList() async {
    /// Clear filters and reload
    clearFilters();
    clearSkillProgramForm();
    
    /// Call API
    await getSkillProgramList();
  }

  /// ================= DISPOSE =================
  @override
  void onClose() {
    titleController.dispose();
    durationController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    searchTitleController.dispose();
    super.onClose();
  }
}