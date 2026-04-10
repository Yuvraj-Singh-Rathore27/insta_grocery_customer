import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../webservices/WebServicesHelper.dart';
import '../model/gigs_works_model.dart';
import '../utills/Utils.dart';
import '../preferences/UserPreferences.dart';


class GigsController extends GetxController {

  /// ================= STORAGE =================
  late GetStorage store;
  String userId = "";
  String accessToken = "";

  /// ================= LOADING =================
  RxBool isSuperCategoryLoading = false.obs;
  RxBool isCategoryLoading = false.obs;
  RxBool isSubCategoryLoading = false.obs;
  RxBool isPosting = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isUploadingImage = false.obs;
  RxBool isGettingLocation = false.obs;
  RxBool isLoadingProfile = false.obs;

  /// ================= DATA LIST =================
  RxList<GigsSuperCategoryModel> superCategoryList =
      <GigsSuperCategoryModel>[].obs;

  RxList<GigsCategoryModel> categoryList =
      <GigsCategoryModel>[].obs;

  RxList<GigsSubCategoryModel> subCategoryList =
      <GigsSubCategoryModel>[].obs;

  /// ================= SELECTION =================
  RxInt selectedSuperCategoryId = 0.obs;
  RxInt selectedCategoryId = 0.obs;
  RxInt selectedSubCategoryId = 0.obs;
  
  /// ================= TEXT FIELDS STRING VALUES (for UI binding) =================
  RxString selectedSuperCategoryName = "".obs;
  RxString selectedCategoryName = "".obs;
  RxString selectedSubCategoryName = "".obs;

  /// ================= TEXT CONTROLLERS =================
  final fullNameController = TextEditingController();
  final titleController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final cityController = TextEditingController();
  final serviceRadiusController = TextEditingController();
  final priceController = TextEditingController();
  final bioController = TextEditingController();

  /// ================= LOCATION =================
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  /// ================= DROPDOWN =================
  RxString workPreference = "".obs;
  RxString experienceLevel = "".obs;

  /// ================= SKILLS =================
  RxList<String> selectedSkillsList = <String>[].obs;
  
  /// ================= SKILL INPUT CONTROLLER =================
  final skillInputController = TextEditingController();
  
  /// ================= IMAGE =================
  RxList<Map<String, dynamic>> profileImageList = <Map<String, dynamic>>[].obs;
  RxString profileImagePath = "".obs;
  
  /// ================= EDIT MODE =================
  RxBool isEditMode = false.obs;
  RxInt editingGigId = 0.obs;
  RxBool hasExistingProfile = false.obs;
  
  /// ================= STORED EDIT DATA =================
  Map<String, dynamic>? editData;

  RxList<Map<String, dynamic>> gigsList = <Map<String, dynamic>>[].obs;

  /// ================= HIRED GIGS =================
RxList<Map<String, dynamic>> hiredGigsList = <Map<String, dynamic>>[].obs;
RxSet<int> hiredGigIds = <int>{}.obs;
RxBool isLoadingHiredGigs = false.obs;
RxBool isProfileActive = true.obs;
  
  /// ================= ADD SKILL METHOD =================
  
  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    getSuperCategories();
    checkAndLoadProfile();
    print("GigsController UserId => $userId");
  }

  void addSkill() {
    String skill = skillInputController.text.trim();
    if (skill.isNotEmpty && !selectedSkillsList.contains(skill)) {
      selectedSkillsList.add(skill);
      skillInputController.clear();
    } else if (skill.isEmpty) {
      Utils.showCustomTosstError("Please enter a skill");
    } else if (selectedSkillsList.contains(skill)) {
      Utils.showCustomTosstError("Skill already added");
    }
  }
  
  /// ================= REMOVE SKILL METHOD =================
  void removeSkill(String skill) {
    selectedSkillsList.remove(skill);
  }

  /// ================= IMAGE PICKER & UPLOAD =================
  Future<void> pickAndUploadImage() async {
    try {
      final ImageSource? source = await Get.dialog<ImageSource>(
        AlertDialog(
          title: const Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image == null) return;

      File imageFile = File(image.path);
      await uploadProfileImage(imageFile);
      
    } catch (e) {
      Utils.showCustomTosstError("Failed to pick image: ${e.toString()}");
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      isUploadingImage.value = true;

      final uploadRes = await WebServicesHelper().fileUpload("image", imageFile);

      if (uploadRes == null || uploadRes['status'] != 200) {
        Utils.showCustomTosstError("Image upload failed");
        return;
      }

      final imageForApi = {
        "name": uploadRes['data']['name'],
        "path": uploadRes['data']['path'],
        "size": uploadRes['data']['size'] ?? await imageFile.length(),
        "url": uploadRes['data']['path'],
        "type": "profile",
      };

      profileImageList.clear();
      profileImageList.add(imageForApi);
      profileImagePath.value = uploadRes['data']['path'];
      
      Utils.showCustomTosst("Image uploaded successfully");
      
    } catch (e) {
      Utils.showCustomTosstError("Image upload failed: ${e.toString()}");
    } finally {
      isUploadingImage.value = false;
    }
  }

  void removeImage() {
    profileImageList.clear();
    profileImagePath.value = "";
  }

  /// ================= GET CURRENT LOCATION =================
  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Utils.showCustomTosstError('Please enable location services');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Utils.showCustomTosstError('Location permission is required');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.showCustomTosstError('Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        List<String> addressParts = [];
        
        if (place.name != null && place.name!.isNotEmpty) addressParts.add(place.name!);
        if (place.street != null && place.street!.isNotEmpty) addressParts.add(place.street!);
        if (place.locality != null && place.locality!.isNotEmpty) addressParts.add(place.locality!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressParts.add(place.administrativeArea!);
        if (place.country != null && place.country!.isNotEmpty) addressParts.add(place.country!);
        
        String address = addressParts.isNotEmpty ? addressParts.join(", ") : "";
        
        if (address.isNotEmpty) {
          locationController.text = address;
        }
        
        if (cityController.text.isEmpty && place.locality != null && place.locality!.isNotEmpty) {
          cityController.text = place.locality!;
        }
        
        Utils.showCustomTosst("Location detected successfully");
      } else {
        Utils.showCustomTosstError("Could not get address from location");
      }
    } catch (e) {
      Utils.showCustomTosstError("Failed to get location: ${e.toString()}");
    } finally {
      isGettingLocation.value = false;
    }
  }

  /// ================= CHECK EXISTING PROFILE =================
  Future<void> checkAndLoadProfile() async {
  try {
    isLoadingProfile.value = true;

    final res = await WebServicesHelper().getUserGigProfile({
      "user_id": userId,
      "access_token": accessToken,
    });

    print("=== CHECK PROFILE RESPONSE ===");
    print(res);
    print("DATA TYPE => ${res?['data'].runtimeType}");

    if (res != null && res['status'] == 200 && res['data'] != null) {

      Map<String, dynamic> profileData = {};

      /// 🔥 HANDLE BOTH CASES
      if (res['data'] is List) {
        if (res['data'].isNotEmpty) {
          profileData = res['data'][0];
        }
      } else if (res['data'] is Map) {
        profileData = res['data'];
      }

      if (profileData.isNotEmpty) {
        hasExistingProfile.value = true;
        isEditMode.value = true;

        editingGigId.value = profileData['id'] ?? 0;

        editData = profileData;

        setEditData(profileData);
      } else {
        hasExistingProfile.value = false;
        isEditMode.value = false;
        editData = null;
      }

    } else {
      hasExistingProfile.value = false;
      isEditMode.value = false;
      editData = null;
    }

  } catch (e) {
    print("❌ Error checking profile: $e");

    hasExistingProfile.value = false;
    isEditMode.value = false;
    editData = null;

  } finally {
    isLoadingProfile.value = false;
  }
}

  void _loadUserData() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";;
     print("=================GigsController UserId => $userId");
    accessToken = store.read("access_token") ?? "";
  }

  /// =========================================================
  /// 🔥 1. GET SUPER CATEGORY
  /// =========================================================
  Future<void> getSuperCategories() async {
    try {
      isSuperCategoryLoading.value = true;

      final res = await WebServicesHelper()
          .getGigsSuperCategory({});

      if (res != null && res['data'] != null) {
        superCategoryList.assignAll(
          (res['data'] as List)
              .map((e) => GigsSuperCategoryModel.fromJson(e))
              .toList(),
        );
      } else {
        superCategoryList.clear();
      }

    } catch (e) {
      Utils.showCustomTosstError("Failed to load super categories");
    } finally {
      isSuperCategoryLoading.value = false;
    }
  }

  /// =========================================================
  /// 🔥 2. GET CATEGORY
  /// =========================================================
  Future<void> getCategory({required int superCategoryId, String? superCategoryName}) async {
    try {
      isCategoryLoading.value = true;

      selectedSuperCategoryId.value = superCategoryId;
      if (superCategoryName != null) {
        selectedSuperCategoryName.value = superCategoryName;
      }

      categoryList.clear();
      subCategoryList.clear();
      selectedCategoryId.value = 0;
      selectedSubCategoryId.value = 0;
      selectedCategoryName.value = "";
      selectedSubCategoryName.value = "";

      final res = await WebServicesHelper()
          .getGigsCategory({
        "super_category_id": superCategoryId
      });

      if (res != null && res['data'] != null && (res['data'] as List).isNotEmpty) {
        categoryList.assignAll(
          (res['data'] as List)
              .map((e) => GigsCategoryModel.fromJson(e))
              .toList(),
        );
      } else {
        categoryList.clear();
      }

    } catch (e) {
      Utils.showCustomTosstError("Failed to load categories");
      categoryList.clear();
    } finally {
      isCategoryLoading.value = false;
    }
  }

  /// =========================================================
  /// 🔥 3. GET SUB CATEGORY
  /// =========================================================
  Future<void> getSubCategory(int categoryId, {String? categoryName}) async {
    try {
      isSubCategoryLoading.value = true;

      selectedCategoryId.value = categoryId;
      if (categoryName != null) {
        selectedCategoryName.value = categoryName;
      }

      subCategoryList.clear();
      selectedSubCategoryId.value = 0;
      selectedSubCategoryName.value = "";

      final res = await WebServicesHelper()
          .getGigsSubCategory({
        "category_id": categoryId
      });

      if (res != null && res['data'] != null && (res['data'] as List).isNotEmpty) {
        subCategoryList.assignAll(
          (res['data'] as List)
              .map((e) => GigsSubCategoryModel.fromJson(e))
              .toList(),
        );
      } else {
        subCategoryList.clear();
      }

    } catch (e) {
      Utils.showCustomTosstError("Failed to load subcategories");
      subCategoryList.clear();
    } finally {
      isSubCategoryLoading.value = false;
    }
  }
  
  /// =========================================================
  /// 🔥 SET SUB CATEGORY
  /// =========================================================
  void setSubCategory(int subCategoryId, String subCategoryName) {
    selectedSubCategoryId.value = subCategoryId;
    selectedSubCategoryName.value = subCategoryName;
  }
  
  /// =========================================================
  /// 🔥 SET WORK PREFERENCE
  /// =========================================================
  void setWorkPreference(String value) {
    workPreference.value = value;
  }
  
  /// =========================================================
  /// 🔥 SET EXPERIENCE LEVEL
  /// =========================================================
  void setExperienceLevel(String value) {
    experienceLevel.value = value;
  }
  
  /// =========================================================
  /// 🔥 SET SERVICE RADIUS
  /// =========================================================
  void setServiceRadius(String radius) {
    serviceRadiusController.text = radius;
  }

  /// =========================================================
  /// 🔥 4. CREATE GIG PROFILE (POST)
  /// =========================================================
  Future<bool> postGigProfile() async {
    try {
      isPosting.value = true;

      if (fullNameController.text.isEmpty ||
          titleController.text.isEmpty ||
          phoneController.text.isEmpty ||
          selectedCategoryId.value == 0 ||
          selectedSubCategoryId.value == 0) {

        Utils.showCustomTosstError("Please fill all required fields");
        return false;
      }

      final Map<String, dynamic> param = {
        "full_name": fullNameController.text.trim(),
        "title": titleController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "location": locationController.text.trim(),
        "city": cityController.text.trim(),
        "service_radius": int.tryParse(serviceRadiusController.text) ?? 0,
        "latitude": latitude.value,
        "longitude": longitude.value,
        "work_preference": workPreference.value,
        "category_id": selectedCategoryId.value,
        "subcategory_id": selectedSubCategoryId.value,
        "skills": selectedSkillsList,
        "experience_level": experienceLevel.value,
        "price": double.tryParse(priceController.text) ?? 0,
        "bio": bioController.text.trim(),
        "user_id": int.tryParse(userId) ?? 0,
        "created_by": int.tryParse(userId) ?? 0,
        "created_by_id": int.tryParse(userId) ?? 0,
        "accessToken": accessToken,
      };
      
      if (profileImageList.isNotEmpty) {
        param["image"] = profileImageList;
      }

      print("=== CREATE GIG PARAM ===");
      print(param);

      final res = await WebServicesHelper()
          .postGigsWorksProfile(param);

      if (res != null && res['status'] == 200) {
        Utils.showCustomTosst("Gig Created Successfully");
        hasExistingProfile.value = true;
        isEditMode.value = true;
        editingGigId.value = res['data']['id'] ?? 0;
        return true;
      } else {
        Utils.showCustomTosstError(
            res?['message'] ?? "Something went wrong");
        return false;
      }

    } catch (e) {
      Utils.showCustomTosstError("Error: ${e.toString()}");
      return false;
    } finally {
      isPosting.value = false;
    }
  }

  /// =========================================================
  /// 🔥 5. UPDATE GIG PROFILE (PUT)
  /// =========================================================
  Future<bool> updateGigProfile(int gigId) async {
    try {
      isUpdating.value = true;

      if (fullNameController.text.isEmpty ||
          titleController.text.isEmpty ||
          phoneController.text.isEmpty ||
          selectedCategoryId.value == 0 ||
          selectedSubCategoryId.value == 0) {

        Utils.showCustomTosstError("Please fill all required fields");
        return false;
      }

      final Map<String, dynamic> param = {
        "full_name": fullNameController.text.trim(),
        "title": titleController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "location": locationController.text.trim(),
        "city": cityController.text.trim(),
        "service_radius": int.tryParse(serviceRadiusController.text) ?? 0,
        "latitude": latitude.value,
        "longitude": longitude.value,
        "work_preference": workPreference.value,
        "category_id": selectedCategoryId.value,
        "subcategory_id": selectedSubCategoryId.value,
        "skills": selectedSkillsList,
        "experience_level": experienceLevel.value,
        "price": double.tryParse(priceController.text) ?? 0,
        "bio": bioController.text.trim(),
        "updated_by": int.tryParse(userId) ?? 0,
        "updated_by_id": int.tryParse(userId) ?? 0,
        "accessToken": accessToken,
      };
      
      if (profileImageList.isNotEmpty) {
        param["image"] = profileImageList;
      }

      print("=== UPDATE GIG PARAM ===");
      print(param);

      final res = await WebServicesHelper()
          .updateGigsWorksProfile(param, gigId);

      if (res != null && res['status'] == 200) {
        Utils.showCustomTosst("Gig Updated Successfully");
        return true;
      } else {
        Utils.showCustomTosstError(
            res?['message'] ?? "Something went wrong");
        return false;
      }

    } catch (e) {
      Utils.showCustomTosstError("Error: ${e.toString()}");
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> hireGig(Map<String, dynamic> gig) async {
  try {
    isLoadingProfile.value = true;

    /// 🔥 PARAM BUILD (IMPORTANT)
    final Map<String, dynamic> param = {
      "profile_id": gig['id'],                  // 👈 REQUIRED
      "user_id": userId,                    // 👈 logged in user
      "accessToken": accessToken,           // 👈 token
    };

    print("=== HIRE PARAM ===");
    print(param);

    /// 🔥 API CALL
    final res = await WebServicesHelper().hireGigsWorksProfile(param);

    print("=== HIRE RESPONSE ===");
    print(res);

    /// ✅ SUCCESS
    if (res != null && res['status'] == 200) {
      Get.snackbar(
        "Success ✅",
        "Gig hired successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } 
    /// ❌ ERROR FROM API
    else {
      Get.snackbar(
        "Error ❌",
        res?['message'] ?? "Failed to hire gig",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

  } catch (e) {
    print("❌ ERROR => $e");

    Get.snackbar(
      "Error ❌",
      "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoadingProfile.value = false;
  }
}

  /// =========================================================
  /// 🔥 SET EDIT DATA (Load existing gig data for editing)
  /// =========================================================
  void setEditData(Map<String, dynamic> gigData) {
    print("=== SETTING EDIT DATA ===");
    print(gigData);
    
    isEditMode.value = true;
    editingGigId.value = gigData['id'] ?? 0;
    
    // Basic Info
    fullNameController.text = gigData['full_name'] ?? "";
    titleController.text = gigData['title'] ?? "";
    phoneController.text = gigData['phone_number'] ?? "";
    emailController.text = gigData['email'] ?? "";
    locationController.text = gigData['location'] ?? "";
    cityController.text = gigData['city'] ?? "";
    serviceRadiusController.text = (gigData['service_radius'] ?? 0).toString();
    priceController.text = (gigData['price'] ?? 0).toString();
    bioController.text = gigData['bio'] ?? "";
    isProfileActive.value = gigData['is_active'] ?? true;
    
    // Dropdown values
    workPreference.value = gigData['work_preference'] ?? "";
    experienceLevel.value = gigData['experience_level'] ?? "";
    
    // Location
    latitude.value = (gigData['latitude'] ?? 0).toDouble();
    longitude.value = (gigData['longitude'] ?? 0).toDouble();
    
    // Skills
    if (gigData['skills'] != null && gigData['skills'] is List) {
      selectedSkillsList.assignAll(List<String>.from(gigData['skills']));
    }
    
    // Image
    if (gigData['image'] != null && gigData['image'] is List && (gigData['image'] as List).isNotEmpty) {
      var imageData = gigData['image'][0];
      profileImagePath.value = imageData['path'] ?? "";
      profileImageList.add({
        "name": imageData['name'] ?? "",
        "path": imageData['path'] ?? "",
        "url": imageData['path'] ?? "",
        "type": "profile",
      });
    }
    
    // Set Super Category and load categories
    if (gigData['super_category_id'] != null && gigData['super_category_id'] != 0) {
      selectedSuperCategoryId.value = gigData['super_category_id'];
      selectedSuperCategoryName.value = gigData['super_category_name'] ?? "";
      
      // Load categories after super category is set
      _loadCategoriesForEdit(
        gigData['super_category_id'], 
        gigData['category_id'] ?? 0, 
        gigData['category_name'] ?? "",
        gigData['subcategory_id'] ?? 0,
        gigData['subcategory_name'] ?? ""
      );
    }
  }

  /// Helper method to load categories for edit
  void _loadCategoriesForEdit(int superCategoryId, int savedCategoryId, String savedCategoryName, int savedSubCategoryId, String savedSubCategoryName) async {
    try {
      final res = await WebServicesHelper().getGigsCategory({
        "super_category_id": superCategoryId
      });
      
      if (res != null && res['data'] != null && (res['data'] as List).isNotEmpty) {
        categoryList.assignAll(
          (res['data'] as List)
              .map((e) => GigsCategoryModel.fromJson(e))
              .toList(),
        );
        
        // Set selected category if exists
        if (savedCategoryId != 0) {
          selectedCategoryId.value = savedCategoryId;
          selectedCategoryName.value = savedCategoryName;
          
          // Load subcategories
          _loadSubCategoriesForEdit(savedCategoryId, savedSubCategoryId, savedSubCategoryName);
        }
      }
    } catch (e) {
      print("Error loading categories for edit: $e");
    }
  }

  /// Helper method to load subcategories for edit
  void _loadSubCategoriesForEdit(int categoryId, int savedSubCategoryId, String savedSubCategoryName) async {
    try {
      final res = await WebServicesHelper().getGigsSubCategory({
        "category_id": categoryId
      });
      
      if (res != null && res['data'] != null && (res['data'] as List).isNotEmpty) {
        subCategoryList.assignAll(
          (res['data'] as List)
              .map((e) => GigsSubCategoryModel.fromJson(e))
              .toList(),
        );
        
        // Set selected subcategory if exists
        if (savedSubCategoryId != 0) {
          selectedSubCategoryId.value = savedSubCategoryId;
          selectedSubCategoryName.value = savedSubCategoryName;
        }
      }
    } catch (e) {
      print("Error loading subcategories for edit: $e");
    }
  }

  /// =========================================================
  /// 🔥 SUBMIT (CREATE OR UPDATE based on mode)
  /// =========================================================
  Future<bool> submitGigProfile() async {
    if (hasExistingProfile.value && editingGigId.value != 0) {
      return await updateGigProfile(editingGigId.value);
    } else {
      return await postGigProfile();
    }
  }

  Future<void> loadMyProfile() async {
  try {
    isLoadingProfile.value = true;

    final res = await WebServicesHelper().getUserGigProfile({
      "access_token": accessToken,
    });

    _handleProfileResponse(res);

  } catch (e) {
    print("Error: $e");
  } finally {
    isLoadingProfile.value = false;
  }
}


// Add these methods anywhere in your GigsController class (before onClose)

/// =========================================================
/// 🔥 GET HIRED GIGS (Workers hired by current user)
/// =========================================================
Future<void> getMyHiredGigs() async {
  try {
    isLoadingHiredGigs.value = true;

    final Map<String, dynamic> param = {
      "access_token": accessToken,
      "user_id": userId,
    };

    print("=== GET MY HIRED GIGS PARAM ===");
    print(param);

    final res = await WebServicesHelper().getHireGigs(param);

    print("=== GET MY HIRED GIGS RESPONSE ===");
    print(res);

    if (res != null && res['status'] == 200 && res['data'] != null) {
      
      List<Map<String, dynamic>> allData = [];

      /// 🔥 HANDLE LIST / MAP
      if (res['data'] is List) {
        allData = List<Map<String, dynamic>>.from(res['data']);
      } else if (res['data'] is Map<String, dynamic>) {
        allData = [res['data']];
      }

      /// 🔥 FILTER ONLY CURRENT USER
      int currentUserId = int.tryParse(userId) ?? 0;

      hiredGigsList.value = allData.where((hire) {
        /// handle multiple structures
        int hireUserId =
            hire['user_id'] ??
            hire['user']?['id'] ??
            0;

        return hireUserId == currentUserId;
      }).toList();

      /// 🔥 FIX LOOP (ONLY ONE LOOP)
      hiredGigIds.clear();

      for (var hire in hiredGigsList) {
        int profileId = hire['profile_id'] ?? 0;
        int hireId = hire['id'] ?? 0;

        if (profileId != 0) {
          hiredGigIds.add(profileId);
          hire['hire_id'] = hireId;
        }
      }

      print("✅ FILTERED GIGS COUNT => ${hiredGigsList.length}");
      print("✅ Hired Profile IDs => ${hiredGigIds.toList()}");

    } else {
      hiredGigsList.clear();
      hiredGigIds.clear();
      print("⚠️ No hired gigs found");
    }

  } catch (e) {
    print("❌ Error fetching hired gigs: $e");
    hiredGigsList.clear();
    hiredGigIds.clear();
  } finally {
    isLoadingHiredGigs.value = false;
  }
}
/// =========================================================
/// 🔥 CHECK IF A WORKER IS HIRED BY CURRENT USER
/// =========================================================
bool isWorkerHiredByMe(int profileId) {
  return hiredGigIds.contains(profileId);
}

/// =========================================================
/// 🔥 UPDATE HIRE GIG METHOD (Add to local list on success)
/// =========================================================
/// =========================================================
/// 🔥 HIRE GIG WITH DESCRIPTION/MESSAGE
/// =========================================================
Future<bool> hireGigWithTracking(Map<String, dynamic> gig, {String? description}) async {
  try {
    isLoadingProfile.value = true;

    final Map<String, dynamic> param = {
      "profile_id": gig['id'],
      "user_id": int.tryParse(userId) ?? 0,
      "accessToken": accessToken,
      "description": description ?? "Hired for gig work", // Default message if not provided
    };

    print("=== HIRE PARAM ===");
    print(param);

    final res = await WebServicesHelper().hireGigsWorksProfile(param);

    print("=== HIRE RESPONSE ===");
    print(res);

    if (res != null && res['status'] == 200) {
      // Add to hired list locally
      hiredGigIds.add(gig['id']);
      
      // Also add to hiredGigsList with the description
      Map<String, dynamic> hiredRecord = {
         "hire_id": res['data']['id'] ?? DateTime.now().millisecondsSinceEpoch,
        "profile_id": gig['id'],
        "profile": gig,
        "user": {
          "first_name": "You", // Current user
          "last_name": "",
        },
        "description": description ?? "Hired for gig work",
        "is_active": true,
        "created_at": DateTime.now().toIso8601String(),
      };
      hiredGigsList.insert(0, hiredRecord);
      
      // Show success message
      Get.snackbar(
        "Success! 🎉",
        "${gig['full_name']} has been hired successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      return true;
    } else {
      Get.snackbar(
        "Error ❌",
        res?['message'] ?? "Failed to hire. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

  } catch (e) {
    print("❌ ERROR => $e");
    Get.snackbar(
      "Error ❌",
      "Something went wrong. Please try again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return false;
  } finally {
    isLoadingProfile.value = false;
  }
}

Future<bool> updateHireMessage(
  int hireId,
  String description,
) async {
  try {
    isUpdating.value = true;

    final param = {
      "description": description,
      "updated_by": int.tryParse(userId) ?? 0,
      "updated_by_id": int.tryParse(userId) ?? 0,
     
    };

    print("=== UPDATE MESSAGE PARAM ===");
    print(param);

    final res = await WebServicesHelper()
        .updateGigsWorks(param, hireId); // 👈 YOUR API

    print("=== UPDATE RESPONSE ===");
    print(res);

    if (res != null && res['status'] == 200) {
      Utils.showCustomTosst("Message Updated Successfully");
      return true;
    } else {
      Utils.showCustomTosstError(res?['message'] ?? "Update failed");
      return false;
    }

  } catch (e) {
    print("❌ UPDATE ERROR => $e");
    Utils.showCustomTosstError("Something went wrong");
    return false;
  } finally {
    isUpdating.value = false;
  }
}



// activate deavtivate controller

Future<void> toggleProfileStatus(bool activate) async {
  try {
    isLoadingProfile.value = true;

    final param = {
      "hire_id": editingGigId.value,  // or profile_id
      "accessToken": accessToken,
    };

    final res = await WebServicesHelper()
        .toggleGigActivation(param, activate);

    if (res != null && res['status'] == 200) {

      /// ✅ UPDATE UI STATE HERE
      isProfileActive.value = activate;

      Utils.showCustomTosst(
        activate ? "Profile Activated ✅" : "Profile Deactivated ❌",
      );

    } else {
      Utils.showCustomTosstError(
        res?['message'] ?? "Failed to update status",
      );
    }

  } catch (e) {
    print("❌ ERROR => $e");
  } finally {
    isLoadingProfile.value = false;
  }
}
void _handleProfileResponse(Map<String, dynamic>? res) {
  if (res != null && res['status'] == 200 && res['data'] != null) {

    /// 🔥 IF LIST (MULTIPLE GIGS)
    if (res['data'] is List) {
      gigsList.assignAll(List<Map<String, dynamic>>.from(res['data']));
    } 
    /// 🔥 IF SINGLE OBJECT
    else {
      gigsList.assignAll([res['data']]);
    }

    hasExistingProfile.value = true;

  } else {
    gigsList.clear();
    hasExistingProfile.value = false;
  }
}



  /// =========================================================
  /// 🔥 DISPOSE
  /// =========================================================
  @override
  void onClose() {
    fullNameController.dispose();
    titleController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    cityController.dispose();
    serviceRadiusController.dispose();
    priceController.dispose();
    bioController.dispose();
    skillInputController.dispose();
    super.onClose();
  }
}