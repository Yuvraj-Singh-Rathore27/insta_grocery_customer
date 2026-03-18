import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../webservices/WebServicesHelper.dart';
import '../model/internship_program.dart';
import '../model/responsemodel/internship_program_response.dart';
import '../preferences/UserPreferences.dart';
import '../utills/Utils.dart';

class InternshipController extends GetxController {
  /// ================= STORAGE & AUTH ====================
  late GetStorage store;
  String userId = "";
  String accessToken = "";

  /// ================= LOADING =================
  RxBool isCategoryLoading = false.obs;
  RxBool isSubCategoryLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isApplying = false.obs; // Added for apply functionality

  /// ================= DATA =================
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> subCategoryList = <Map<String, dynamic>>[].obs;

  RxList<InternshipProgram> internshipList = <InternshipProgram>[].obs;
  RxList<InternshipProgram> filteredInternshipList = <InternshipProgram>[].obs;

  /// ================= APPLIED INTERNSHIPS =================
  RxList<int> appliedInternshipIds = <int>[].obs; // Track applied internship IDs

  /// ================= SELECTION =================
  RxInt selectedCategoryId = 0.obs;
  RxInt selectedSubCategoryId = 0.obs;

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    
    // Initialize storage and get user data
    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    accessToken = store.read(UserPreferences.access_token) ?? "";
    
    print("InternshipController UserId => $userId");
    print("InternshipController accessToken => $accessToken");
    
    // Load initial data
    getCategory();
    getInternshipList();
  }

  /// ================= CATEGORY =================
  Future<void> getCategory() async {
    try {
      isCategoryLoading.value = true;

      final res = await WebServicesHelper().getInternshipProgramCategory({});

      if (res != null && res['data'] != null) {
        categoryList.assignAll(
            List<Map<String, dynamic>>.from(res['data']));
      } else {
        categoryList.clear();
      }
    } finally {
      isCategoryLoading.value = false;
    }
  }

  /// ================= SUB CATEGORY =================
  Future<void> getSubCategory(int categoryId) async {
    try {
      selectedCategoryId.value = categoryId;
      selectedSubCategoryId.value = 0;
      isSubCategoryLoading.value = true;

      final res = await WebServicesHelper()
          .getInternshipProgramSubcategory({"category_id": categoryId});

      if (res != null && res['data'] != null) {
        subCategoryList.assignAll(
            List<Map<String, dynamic>>.from(res['data']));
      } else {
        subCategoryList.clear();
      }
    } finally {
      isSubCategoryLoading.value = false;
    }
  }

  /// ================= INTERNSHIP LIST =================
  Future<void> getInternshipList() async {
    try {
      isLoading.value = true;

      final res = await WebServicesHelper().getInternshipProgram({});

      if (res != null) {
        final model = InternshipProgramResponse.fromJson(res);
        internshipList.assignAll(model.data ?? []);
        filteredInternshipList.assignAll(internshipList);
      } else {
        internshipList.clear();
        filteredInternshipList.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= APPLY FOR INTERNSHIP =================
  Future<void> applyForInternship(int internshipId, InternshipProgram internship) async {
    try {
      isApplying.value = true;

      // Prepare params as per your API requirement
      final params = {
        "user_type": "user",
        "user_id": int.tryParse(userId) ?? 0,
        "internship_id": internshipId,
      };

      Utils().customPrint("📤 Applying for internship => $params");
      Utils().customPrint("📤 Access Token => $accessToken");

      // Make API call
      final response = await WebServicesHelper().postApplyInternshipProgram({
        ...params,
        "accessToken": accessToken,
      });

      Utils().customPrint("📥 Response: $response");

      // Handle response
      if (response != null) {
        // Check different possible success scenarios
        bool isSuccess = false;
        String message = "Application submitted";
        
        if (response['status'] == 200 || response['status'] == 201) {
          isSuccess = true;
          message = response['message'] ?? "Applied successfully!";
        } else if (response['error'] == false) {
          isSuccess = true;
          message = response['message'] ?? "Applied successfully!";
        } else if (response['success'] == true) {
          isSuccess = true;
          message = response['message'] ?? "Applied successfully!";
        }

        if (isSuccess) {
          // Add to applied list
          appliedInternshipIds.add(internshipId);
          
          // Show success message
          Get.snackbar(
            "Success",
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Show error message from API
          String errorMsg = response['message'] ?? "Failed to apply";
          Get.snackbar(
            "Error",
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // No response from server
        Get.snackbar(
          "Error",
          "No response from server",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Utils().customPrint("❌ Error applying for internship: $e");
      Get.snackbar(
        "Error",
        "Failed to apply. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isApplying.value = false;
    }
  }

  /// ================= CHECK IF APPLIED =================
  bool isApplied(int internshipId) {
    return appliedInternshipIds.contains(internshipId);
  }

  /// ================= GET APPLIED COUNT =================
  int getAppliedCount() {
    return appliedInternshipIds.length;
  }

  /// ================= FILTER =================
  void filterInternshipsBySubCategory(int subId) {
    if (subId == 0) {
      filteredInternshipList.value = internshipList;
      return;
    }

    filteredInternshipList.value = internshipList
        .where((e) => e.subcategoryId == subId)
        .toList();
  }

  /// ================= REFRESH =================
  Future<void> refreshList() async {
    selectedCategoryId.value = 0;
    selectedSubCategoryId.value = 0;
    subCategoryList.clear();
    await getInternshipList();
  }

  /// ================= DISPOSE =================
  @override
  void onClose() {
    super.onClose();
  }
}