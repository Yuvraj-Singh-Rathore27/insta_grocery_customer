import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/file_model.dart';
import '../model/job_type_model.dart';
import '../model/responsemodel/BaseResponse.dart';
import '../model/responsemodel/FileUploadResponseModel.dart';
import '../model/responsemodel/job_type_response_model.dart';
import '../model/responsemodel/resume_details_response.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/ApiUrl.dart';
import '../webservices/WebServicesHelper.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ResumeController extends GetxController {
  late GetStorage store;
  String userId = "";
  String accessToken = "";
  var selectedType = "1".obs;

  // File handling
  PickedFile? pickedFile;
  RxList<FileModel> uploadResumeList = <FileModel>[].obs;
  RxList<FileModel> certificateList = <FileModel>[].obs;
  RxList<File> images = <File>[].obs;

  // Form controllers
  TextEditingController resumenameController = TextEditingController();
  TextEditingController resumemobileNumberController = TextEditingController();
  TextEditingController resumeresumeHeadingController = TextEditingController();
  TextEditingController resumeexperiencesController = TextEditingController();
  TextEditingController resumeemailId = TextEditingController();
  TextEditingController resumebirthDateController = TextEditingController();
  TextEditingController resumecontactNumberController = TextEditingController();
  TextEditingController resumejobSpecialityController = TextEditingController();
  TextEditingController resumequalificationController = TextEditingController();
  TextEditingController resumeexpectedSalaryController =
      TextEditingController();
  TextEditingController resumepreferredCountryController =
      TextEditingController();
  TextEditingController resumepreferredStateController =
      TextEditingController();
  TextEditingController resumepreferredCityController = TextEditingController();

  // Category controllers and lists
  final resumejobCategoryController = TextEditingController();
  RxList<String> resumejobCategoryListValue = <String>[].obs;
  RxList<String> resumejobSubcategoryListValue = <String>[].obs;
  var resumeselectedJobSubCategory = "".obs;

  // Observable variables
  var resumeexperiencesType = "Fresher".obs;
  var resumeselectedJobCategory = "".obs;
  var confirmationChecked = false.obs;
  var resumeselectedGender = "".obs;
  var resumeneedUpdate = false.obs;
  var resumeId = "".obs;
  RxBool resumeaccommodationRequired = false.obs;
  RxBool resumeanyCity = false.obs;
  RxList<String> resumegenderList = <String>[].obs;

  // Job type lists
  RxList<JobTypeModel> resumejobTypeList = <JobTypeModel>[].obs;
  RxList<JobTypeModel> resumejobSubTypeList = <JobTypeModel>[].obs;
  RxList<String> resumejobTypeListValue = <String>[].obs;
  var resumeselectedJobType = "".obs;
  var resumeselectedCategoryID = "".obs;
  var resumeselecteSubdCategoryId = "".obs;
  final resumecategoryId = RxInt(0);
  final resumesubcategoryId = RxInt(0);

  // Loading states
  var isLoadingCategories = false.obs;
  var isLoadingSubcategories = false.obs;

  // Lists for tags and data
  RxList<String> resumelanguagesList = <String>[].obs;
  RxList<String> resumejobSubSpecialityList = <String>[].obs;
  RxList<String> resumeskillsList = <String>[].obs;
  RxList<Map<String, dynamic>> resumeallResumes = <Map<String, dynamic>>[].obs;

  // File data
  final resumeresumeFiles = RxList<Map<String, dynamic>>();
  final resumephotoData = Rx<Map<String, dynamic>>({});
  final resumeshortVideoData = Rx<Map<String, dynamic>>({});
  RxList<FileModel> resumephotoList = <FileModel>[].obs;
  RxList<FileModel> resumeshortVideoList = <FileModel>[].obs;


  // Category Type
RxList<String> categoryTypeList = <String>[
  "CAREER",
  "BUSINESS",
  "DOMESTIC",
  "FRESHER"
].obs;

var selectedCategoryType = "".obs;
RxString resumeselectedSalaryType = ''.obs;
// Add this list for salary types (optional)
List<String> salaryTypeList = ['Monthly', 'Yearly'];

RxString currentCity = ''.obs;
RxString currentState = ''.obs;
RxString currentCountry = ''.obs;


  @override
  void onInit() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id);
    accessToken = store.read(UserPreferences.access_token);
    print("ResumeController Userid => $userId");
    print("ResumeController accessToken => $accessToken");

    getJobTypeList();
    getResumeDetailsApi();
  autoFillLocation();

    // Initialize gender list
    resumegenderList.addAll(["Male", "Female", "Any Gender"]);
    resumegenderList.refresh();

    // Initialize job type list
    resumejobTypeListValue
        .addAll(["Full Time", "Part Time", "Night Shifts", "Freelance"]);

    super.onInit();
  }

  // Method to manually load resume data when needed
  Future<void> loadResumeData() async {
    await getResumeDetailsApi();
    Utils.showCustomTosst('Resume data loaded successfully');
  }

  // void save as draft
  void saveAsDraft() {
    print('Saving as draft...');
    Utils.showCustomTosst('Resume saved as draft successfully');
  }

  // Enhanced category selection method
  void onCategorySelect(String data, String type) {
    if (type == 'job_type') {
      resumeselectedJobType.value = data;
      update();
    }
    if (type == 'job_category') {
      resumeselectedJobCategory.value = data;
      resumejobCategoryController.text = data;

      // Clear previous subcategories immediately
      clearSubcategories();

      // Force UI update immediately
      update();

      // Find and set category ID
      for (int i = 0; i < resumejobTypeList.length; i++) {
        if (resumeselectedJobCategory.value ==
            resumejobTypeList.value[i].name) {
          resumeselectedCategoryID.value =
              resumejobTypeList.value[i].id.toString();
          resumecategoryId.value = resumejobTypeList.value[i].id ?? 0;
          break;
        }
      }

      // Load subcategories
      if (resumeselectedCategoryID.value.isNotEmpty) {
        getJobSubcategoryList();
      }
    }
    if (type == 'job_subcategory') {
      resumeselectedJobSubCategory.value = data;

      // Find and set subcategory ID
      for (int i = 0; i < resumejobSubTypeList.length; i++) {
        if (resumeselectedJobSubCategory.value ==
            resumejobSubTypeList.value[i].name) {
          resumeselecteSubdCategoryId.value =
              resumejobSubTypeList.value[i].id.toString();
          resumesubcategoryId.value = resumejobSubTypeList.value[i].id ?? 0;
          break;
        }
      }
      update();
    }
    if (type == 'gender') {
      resumeselectedGender.value = data;
      update();
    }
    if (type == 'category_type') {
  onCategoryTypeSelect(data);
}
  }

// In ResumeController.dart - Update this method
// Update this method in ResumeController
Future<void> onCategoryTypeSelect(String type) async {
  // Use the new handler instead of directly setting
  handleCategoryTypeChange(type);
}
  void clearSubcategories() {
    resumeselectedJobSubCategory.value = "";
    resumeselecteSubdCategoryId.value = "";
    resumesubcategoryId.value = 0;
    resumejobSubcategoryListValue.clear();
    resumejobSubTypeList.clear();
    update();
  }

  // Enhanced getJobTypeList with loading state
  Future<void> getJobTypeList() async {
    isLoadingCategories.value = true;

    final param = {
  "user_id": userId,
  "accessToken": accessToken,
  "category_type": selectedCategoryType.value
};

    try {
      Map<String, dynamic>? response =
          await WebServicesHelper().getJobcategoryList(param);
      Utils().customPrint('response on view ${response?.toString()}');

      if (response != null) {
        JobTypeResponseModel responseModel =
            JobTypeResponseModel.fromJson(response);
        if (responseModel.status == 200) {
          if (responseModel.data != null) {
            resumejobTypeList.clear();
            resumejobCategoryListValue.clear();

            resumejobTypeList
                .addAll(responseModel.data as Iterable<JobTypeModel>);

            for (int i = 0; i < resumejobTypeList.length; i++) {
              resumejobCategoryListValue.add(resumejobTypeList[i].name ?? '');
            }

            print("Jobcategory==>${resumejobCategoryListValue.length}");
          }
        } else {
          Utils.showCustomTosst("Failed to load job categories");
        }
      }
    } catch (E) {
      print("error" + E.toString());
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Enhanced getJobSubcategoryList with loading state and UI update
  Future<void> getJobSubcategoryList() async {
    if (resumeselectedCategoryID.value.isEmpty) {
      print("No category selected for subcategories");
      return;
    }

    isLoadingSubcategories.value = true;

    // Clear previous subcategories immediately
    resumejobSubcategoryListValue.clear();
    resumejobSubTypeList.clear();

    // Force UI update to show loading state
    update();

    final param = {
      "user_id": userId,
      "accessToken": accessToken,
      "category_id": resumeselectedCategoryID.value.toString()
    };

    try {
      Map<String, dynamic>? response =
          await WebServicesHelper().getJobSubcategoryList(param);
      Utils().customPrint('response on view ${response?.toString()}');

      if (response != null) {
        JobTypeResponseModel responseModel =
            JobTypeResponseModel.fromJson(response);
        if (responseModel.status == 200) {
          if (responseModel.data != null) {
            resumejobSubTypeList.clear();
            resumejobSubcategoryListValue.clear();

            resumejobSubTypeList
                .addAll(responseModel.data as Iterable<JobTypeModel>);

            for (int i = 0; i < resumejobSubTypeList.length; i++) {
              resumejobSubcategoryListValue
                  .add(resumejobSubTypeList[i].name ?? '');
            }

            print("JobSubcategory==>${resumejobSubcategoryListValue.length}");
            update();
          }
        } else {
          Utils.showCustomTosst("Failed to load job subcategories");
        }
      }
    } catch (E) {
      print("error" + E.toString());
    } finally {
      isLoadingSubcategories.value = false;
      update();
    }
  }

  // Updated resume details API to properly handle categories
  // Updated resume details API to properly handle categories and category type detection
Future<void> getResumeDetailsApi() async {
  final param = {
    "user_id": userId,
    "accessToken": accessToken,
  };

  try {
    Map<String, dynamic>? response =
        await WebServicesHelper().getResumeDetailsApi(param);

    if (response != null &&
        response["data"] != null &&
        response["data"].isNotEmpty) {
      print("📦 API Response: ${response.toString()}");

      final List<Map<String, dynamic>> resumeList =
          List<Map<String, dynamic>>.from(response["data"]);
      resumeallResumes.value = resumeList;

      // Find current user’s resume or fallback to first
      final userResume = resumeList.firstWhere(
        (res) => res["user_id"]?.toString() == userId.toString(),
        orElse: () => resumeList.first,
      );

      print("👤 User Resume: ${userResume.toString()}");

      // 🧹 Clear form before loading new data
      clearForm();

      // =======================
      // DETECT CATEGORY TYPE FROM LOADED DATA
      // =======================
      String detectedCategoryType = _detectCategoryType(userResume);
      selectedCategoryType.value = detectedCategoryType;
      print("🎯 Detected Category Type: $detectedCategoryType");

      // =======================
      // Basic Information (only load if visible for category)
      // =======================
      resumenameController.text = userResume["full_name"]?.toString() ?? '';
      
      // Handle email based on category
      if (_isFieldVisibleForCategory('email', detectedCategoryType)) {
        resumeemailId.text = userResume["email"]?.toString() ?? '';
      }
      
      // Handle mobile/contact number based on category
      if (detectedCategoryType == "BUSINESS" || detectedCategoryType == "DOMESTIC") {
        if (_isFieldVisibleForCategory('contactNumber', detectedCategoryType)) {
          resumecontactNumberController.text =
              userResume["contact_number"]?.toString() ?? 
              userResume["mobile_number"]?.toString() ?? '';
        }
      } else {
        if (_isFieldVisibleForCategory('mobileNumber', detectedCategoryType)) {
          resumemobileNumberController.text =
              userResume["mobile_number"]?.toString() ?? 
              userResume["contact_number"]?.toString() ?? '';
        }
      }
      
      resumeresumeHeadingController.text =
          userResume["resume_headline"]?.toString() ?? '';

      final gender = userResume["gender"]?.toString()?.toLowerCase() ?? '';
      if (gender == 'm' || gender == 'male') {
        resumeselectedGender.value = 'Male';
      } else if (gender == 'f' || gender == 'female') {
        resumeselectedGender.value = 'Female';
      }

      // Only set birth date if visible in this category
      if (_isFieldVisibleForCategory('birthDate', detectedCategoryType)) {
        resumebirthDateController.text =
            userResume["birth_date"]?.toString() ?? '';
      }

      // Only set qualification if visible
      if (_isFieldVisibleForCategory('qualification', detectedCategoryType)) {
        resumequalificationController.text =
            userResume["qualification"]?.toString() ?? '';
      }

      // =======================
      // Category & Subcategory
      // =======================
      final categoryId =
          userResume["category"]?["id"] ?? userResume["category_id"] ?? 0;
      final subcategoryId = userResume["subcategory"]?["id"] ??
          userResume["subcategory_id"] ??
          0;
      final categoryName = userResume["job_category"]?.toString() ??
          userResume["category"]?["name"]?.toString() ??
          '';
      final subcategoryName =
          userResume["subcategory"]?["name"]?.toString() ?? '';

      resumecategoryId.value = int.tryParse(categoryId.toString()) ?? 0;
      resumesubcategoryId.value = int.tryParse(subcategoryId.toString()) ?? 0;

      if (categoryName.isNotEmpty) {
        resumeselectedJobCategory.value = categoryName;
        resumejobCategoryController.text = categoryName;
      }

      if (resumecategoryId.value > 0) {
        resumeselectedCategoryID.value = resumecategoryId.value.toString();
        
        // Load subcategories after a short delay to ensure UI is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getJobSubcategoryList().then((_) {
            if (subcategoryName.isNotEmpty) {
              // Find and set the correct subcategory
              for (int i = 0; i < resumejobSubTypeList.length; i++) {
                if (resumejobSubTypeList[i].name == subcategoryName) {
                  resumeselectedJobSubCategory.value = subcategoryName;
                  resumeselecteSubdCategoryId.value = 
                      resumejobSubTypeList[i].id.toString();
                  resumesubcategoryId.value = resumejobSubTypeList[i].id ?? 0;
                  break;
                }
              }
            }
            update();
          });
        });
      }

      // =======================
      // Work Details (only if visible)
      // =======================
      if (_isFieldVisibleForCategory('expectedSalary', detectedCategoryType)) {
        resumeexpectedSalaryController.text =
            userResume["expected_salary"]?.toString() ?? '';
      }

      // Handle experience based on category
      double experienceValue = 0.0;
      if (userResume["experience"] != null) {
        experienceValue = double.tryParse(userResume["experience"].toString()) ?? 0.0;
      }

      if (detectedCategoryType == "FRESHER" || experienceValue == 0) {
        resumeexperiencesType.value = "Fresher";
      } else {
        resumeexperiencesType.value = "Experienced";
        if (_isFieldVisibleForCategory('yearsOfExperience', detectedCategoryType)) {
          resumeexperiencesController.text = experienceValue.toString();
        }
      }

      if (_isFieldVisibleForCategory('jobSpeciality', detectedCategoryType)) {
        resumejobSpecialityController.text =
            userResume["job_speciality"]?.toString() ?? '';
      }

      // Job Sub-Speciality
      if (userResume["job_sub_speciality"] != null && 
          _isFieldVisibleForCategory('jobSubSpeciality', detectedCategoryType)) {
        resumejobSubSpecialityList.value =
            List<String>.from(userResume["job_sub_speciality"]);
      }

      // =======================
      // Location Preferences
      // =======================
      if (_isFieldVisibleForCategory('preferredCountry', detectedCategoryType)) {
        resumepreferredCountryController.text =
            userResume["preferred_country"]?.toString() ?? '';
      }
      
      if (_isFieldVisibleForCategory('preferredState', detectedCategoryType)) {
        resumepreferredStateController.text =
            userResume["preferred_state"]?.toString() ?? '';
      }
      
      if (_isFieldVisibleForCategory('preferredCity', detectedCategoryType)) {
        resumepreferredCityController.text =
            userResume["preferred_city"]?.toString() ?? '';
      }
      
      resumeanyCity.value = userResume["any_city"] == true;

      // =======================
      // Skills & Languages (only if visible)
      // =======================
      if (userResume["languages"] != null && 
          _isFieldVisibleForCategory('languages', detectedCategoryType)) {
        resumelanguagesList.value =
            List<String>.from(userResume["languages"]);
      }
      
      if (userResume["skills"] != null && 
          _isFieldVisibleForCategory('skills', detectedCategoryType)) {
        resumeskillsList.value = List<String>.from(userResume["skills"]);
      }

      // =======================
      // Certificates
      // =======================
      if (userResume["certificate"] != null && 
          _isFieldVisibleForCategory('certificates', detectedCategoryType)) {
        final certList =
            List<Map<String, dynamic>>.from(userResume["certificate"]);
        certificateList.value =
            certList.map((cert) => FileModel.fromJson(cert)).toList();
      }

      // =======================
      // Resume Files
      // =======================
      if (userResume["resume"] != null && 
          _isFieldVisibleForCategory('documents', detectedCategoryType)) {
        final resumeFileList =
            List<Map<String, dynamic>>.from(userResume["resume"]);
        uploadResumeList.value =
            resumeFileList.map((r) => FileModel.fromJson(r)).toList();
      }

      // =======================
      // Photo
      // =======================
      if (userResume["photo"] != null && userResume["photo"] is Map &&
          _isFieldVisibleForCategory('profilePhoto', detectedCategoryType)) {
        final photoData = Map<String, dynamic>.from(userResume["photo"]);
        if (photoData.isNotEmpty) {
          resumephotoList.value = [FileModel.fromJson(photoData)];
        }
      }

      // =======================
      // Short Video
      // =======================
      if (userResume["short_video"] != null &&
          userResume["short_video"] is Map &&
          _isFieldVisibleForCategory('shortVideo', detectedCategoryType)) {
        final videoData =
            Map<String, dynamic>.from(userResume["short_video"]);
        if (videoData.isNotEmpty) {
          resumeshortVideoList.value = [FileModel.fromJson(videoData)];
        }
      }

      // =======================
      // Salary Type
      // =======================
      if (_isFieldVisibleForCategory('salaryType', detectedCategoryType)) {
        // You might need to get this from your data or set a default
        resumeselectedSalaryType.value = 'Yearly'; // Default or from data
      }

      // =======================
      // Accommodation
      // =======================
      if (_isFieldVisibleForCategory('accommodation', detectedCategoryType)) {
        resumeaccommodationRequired.value = 
            userResume["accommodation"] == true;
      }

      // =======================
      // Resume ID for Update API
      // =======================
      resumeId.value = userResume["id"]?.toString() ?? "";
      print("✅ Resume ID Loaded => ${resumeId.value}");

      // =======================
      // Final Flags
      // =======================
      resumeneedUpdate.value = true;
      
      // Force UI update
      update();
      
      print("✅ Resume data updated successfully for category: $detectedCategoryType");
    } else {
      print('❌ Response or data is Null');
      resumeneedUpdate.value = false;
    }
  } catch (e, st) {
    print("⚠️ getResumeDetailsApi Exception => $e");
    print("🧠 Stack Trace => $st");
    resumeneedUpdate.value = false;
  }
}

// Helper method to detect category type from resume data
String _detectCategoryType(Map<String, dynamic> userResume) {
  // Check if it's FRESHER (no experience)
  double experience = double.tryParse(userResume["experience"]?.toString() ?? '0') ?? 0;
  if (experience == 0) {
    return "FRESHER";
  }
  
  // Check if it's BUSINESS (has contact_number but no email/mobile)
  bool hasContactNumber = userResume["contact_number"] != null && 
                         userResume["contact_number"].toString().isNotEmpty;
  bool hasEmail = userResume["email"] != null && 
                 userResume["email"].toString().isNotEmpty;
  bool hasMobile = userResume["mobile_number"] != null && 
                  userResume["mobile_number"].toString().isNotEmpty;
  
  if (hasContactNumber && !hasEmail && !hasMobile) {
    return "BUSINESS";
  }
  
  // Check if it's DOMESTIC (minimal fields)
  bool hasQualification = userResume["qualification"] != null && 
                         userResume["qualification"].toString().isNotEmpty;
  bool hasSkills = userResume["skills"] != null && 
                  (userResume["skills"] as List).isNotEmpty;
  bool hasLanguages = userResume["languages"] != null && 
                     (userResume["languages"] as List).isNotEmpty;
  
  if (!hasQualification && !hasSkills && !hasLanguages) {
    return "DOMESTIC";
  }
  
  // Default to CAREER
  return "CAREER";
}

// Helper method to check if field should be visible for category
bool _isFieldVisibleForCategory(String fieldName, String categoryType) {
  // This should match your UI visibility map
  Map<String, Map<String, bool>> fieldVisibility = {
    'CAREER': {
      'birthDate': true,
      'email': true,
      'mobileNumber': true,
      'contactNumber': false,
      'qualification': true,
      'yearsOfExperience': true,
      'expectedSalary': true,
      'salaryType': true,
      'accommodation': true,
      'skills': true,
      'languages': true,
      'profilePhoto': true,
      'documents': true,
      'certificates': true,
      'shortVideo': true,
      'jobSubSpeciality': true,
      'jobSpeciality': true,
      'preferredCountry': true,
      'preferredState': true,
      'preferredCity': true,
    },
    'FRESHER': {
      'birthDate': true,
      'email': true,
      'mobileNumber': true,
      'contactNumber': false,
      'qualification': true,
      'yearsOfExperience': false,
      'expectedSalary': true,
      'salaryType': true,
      'accommodation': true,
      'skills': true,
      'languages': true,
      'profilePhoto': true,
      'documents': true,
      'certificates': true,
      'shortVideo': true,
      'jobSubSpeciality': true,
      'jobSpeciality': true,
      'preferredCountry': true,
      'preferredState': true,
      'preferredCity': true,
    },
    'BUSINESS': {
      'birthDate': false,
      'email': true,
      'mobileNumber': false,
      'contactNumber': true,
      'qualification': true,
      'yearsOfExperience': true,
      'expectedSalary': true,
      'salaryType': false,
      'accommodation': false,
      'skills': true,
      'languages': true,
      'profilePhoto': true,
      'documents': true,
      'certificates': true,
      'shortVideo': true,
      'jobSubSpeciality': true,
      'jobSpeciality': true,
      'preferredCountry': true,
      'preferredState': true,
      'preferredCity': true,
    },
    'DOMESTIC': {
      'birthDate': false,
      'email': true,
      'mobileNumber': false,
      'contactNumber': true,
      'qualification': false,
      'yearsOfExperience': false,
      'expectedSalary': true,
      'salaryType': false,
      'accommodation': false,
      'skills': false,
      'languages': false,
      'profilePhoto': true,
      'documents': true,
      'certificates': true,
      'shortVideo': true,
      'jobSubSpeciality': true,
      'jobSpeciality': true,
      'preferredCountry': true,
      'preferredState': true,
      'preferredCity': true,
    },
  };

  return fieldVisibility[categoryType]?[fieldName] ?? true;
}
  // Updated postResumeApi to include proper category data
  Future<void> postResumeApi() async {
    BuildContext? context = Get.context;
    if (!confirmationChecked.value) {
      Utils.showCustomTosst("Please confirm the details before submitting");
      return;
    }

    final param = {
      "accessToken": accessToken,
      "created_by": userId,
      "created_by_id": userId,
      "updated_by": userId,
      "updated_by_id": userId,
      "user_type": "user",
      "user_id": userId,
      "full_name": resumenameController.text,
      "resume_headline": resumeresumeHeadingController.text,
      "gender": resumeselectedGender.value == "Male" ? 'm' : 'f',
      "birth_date": resumebirthDateController.text.isEmpty
          ? "2025-11-01"
          : resumebirthDateController.text,
      "experience": resumeexperiencesType.value == 'Experienced'
          ? double.tryParse(resumeexperiencesController.text) ?? 0.0
          : 0.0,
      "job_type": resumeselectedJobType.value,
      "job_category": resumeselectedJobCategory.value,
      "category_id": resumecategoryId.value,
      "subcategory_id": resumesubcategoryId.value,
      "subcategory_name": resumeselectedJobSubCategory.value,
      "expected_salary":
          double.tryParse(resumeexpectedSalaryController.text) ?? 0.0,
      "accommodation": resumeaccommodationRequired.value,
      "contact_number": resumecontactNumberController.text.isEmpty
          ? resumemobileNumberController.text
          : resumecontactNumberController.text,
      "languages": resumelanguagesList.toList(),
      "skills": resumeskillsList.toList(),
      "job_sub_speciality": resumejobSubSpecialityList.toList(),
      "certificate": certificateList.map((f) => f.toJson()).toList(),
      "resume": uploadResumeList.map((f) => f.toJson()).toList(),
      "photo": resumephotoList.isNotEmpty ? resumephotoList.first.toJson() : {},
      "short_video": resumeshortVideoList.isNotEmpty
          ? resumeshortVideoList.first.toJson()
          : {},
      "email": resumeemailId.text,
      "job_speciality": resumejobSpecialityController.text.isEmpty
          ? "General"
          : resumejobSpecialityController.text,
      "qualification": resumequalificationController.text.isEmpty
          ? "Not Specified"
          : resumequalificationController.text,
      "preferred_country": resumepreferredCountryController.text.isEmpty
          ? "India"
          : resumepreferredCountryController.text,
      "preferred_state": resumepreferredStateController.text.isEmpty
          ? "Not Specified"
          : resumepreferredStateController.text,
      "preferred_city": resumepreferredCityController.text.isEmpty
          ? "Not Specified"
          : resumepreferredCityController.text,
      "any_city": resumeanyCity.value,
    };

    _printDebugParameters(param);
    showLoaderDialog(context!);

    try {
      Map<String, dynamic>? response;
      if (resumeneedUpdate.value) {
        response =
            await WebServicesHelper().updateResumeApi(param, resumeId.value);
      } else {
        response = await WebServicesHelper().postResumeApi(param);
      }
      _handleApiResponse(response);
    } catch (e) {
      Utils.showCustomTosstError('❌ An error occurred');
      Utils().customPrint('Error in postResumeApi: $e');
    } finally {
      hideProgress(context);
    }
  }

  void _ensureMinimumArrayValues() {
    if (resumelanguagesList.isEmpty) resumelanguagesList.add('English');
    if (resumeskillsList.isEmpty) resumeskillsList.add('Communication');
    if (resumejobSubSpecialityList.isEmpty)
      resumejobSubSpecialityList.add('General');
  }

  void _handleApiResponse(Map<String, dynamic>? response) {
    Utils().customPrint('🧭 API Response => ${response.toString()}');
    if (response != null) {
      final BaseResponse model = BaseResponse.fromJson(response);
      if (model.status == 200) {
        Utils.showCustomTosst(model.message ??
            'Resume ${resumeneedUpdate.value ? 'updated' : 'uploaded'} successfully');
        getResumeDetailsApi();
      } else {
        Utils.showCustomTosstError(model.message ?? 'Something went wrong');
      }
    } else {
      Utils.showCustomTosstError('Failed to connect to server');
    }
  }

  void _printDebugParameters(Map<String, dynamic> param) {
    print('🎯 ====== RESUME API PARAMS ======');
    print('Category: ${param["job_category"]}');
    print('Category ID: ${param["category_id"]}');
    print('Subcategory ID: ${param["subcategory_id"]}');
    print('Subcategory Name: ${param["subcategory_name"]}');
    print('=================================\n');
  }

  // File Upload Methods
  getFromGallery(isCamera, type) async {
    pickedFile = await ImagePicker().getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      print('path is => ${pickedFile?.path ?? ''}');
      File imageFile = File(pickedFile?.path ?? '');

      // Map the UI type to upload type
      String uploadType = 'Upload Resume';
      if (type.contains('Certificate')) uploadType = 'Upload Certificates';
      if (type.contains('Photo')) uploadType = 'Upload Photo';
      if (type.contains('Video')) uploadType = 'Upload Video';

      fileUpload(imageFile, uploadType);
    }
  }

  Future<void> fileUpload(File images, String type) async {
    BuildContext? context = Get.context;
    String filePath = ApiUrl.fileUploadResume;
    showLoaderDialog(context!);

    Map<String, dynamic>? response =
        await WebServicesHelper().fileUpload(filePath, images);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      FileUploadResponseModel baseResponse =
          FileUploadResponseModel.fromJson(response);
      try {
        if (baseResponse.status == 200) {
          // Create FileModel from response
          FileModel uploadedFile = FileModel(
            name: baseResponse.data?.name,
            path: baseResponse.data?.path,
          );

          print("File uploaded successfully for type: $type");

          // Add to correct list based on type
          if (type == 'Upload Certificates') {
            certificateList.add(uploadedFile);
          } else if (type == 'Upload Photo') {
            resumephotoList.clear();
            resumephotoList.add(uploadedFile);
          } else if (type == 'Upload Video') {
            resumeshortVideoList.clear();
            resumeshortVideoList.add(uploadedFile);
          } else {
            uploadResumeList.add(uploadedFile);
          }

          hideProgress(context);
          Utils.showCustomTosst("File uploaded successfully");
        } else {
          Utils.showCustomTosst("Error uploading file");
          hideProgress(context);
        }
      } catch (E) {
        hideProgress(context);
        Utils.showCustomTosstError("Upload failed: $E");
      }
    } else {
      hideProgress(context);
      Utils.showCustomTosstError("Failed to upload file");
    }
  }

  Future<void> autoFillLocation() async {
  try {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks.first;

    currentCity.value = place.locality ?? "";
    currentState.value = place.administrativeArea ?? "";
    currentCountry.value = place.country ?? "";

    resumepreferredCityController.text = currentCity.value;
    resumepreferredStateController.text = currentState.value;
    resumepreferredCountryController.text = currentCountry.value;

  } catch (e) {
    print(e);
  }
}


// Add this method to ResumeController
void handleCategoryTypeChange(String newType) {
  // Store previous category type
  String previousType = selectedCategoryType.value;
  
  if (previousType.toUpperCase() != newType.toUpperCase()) {
    // Update the selected category type
    selectedCategoryType.value = newType;
    
    // Clear fields that should NOT be visible in the new category type
    clearInvisibleFieldsForCategory(newType);
    
    // Reload job categories for the new type
    getJobTypeList();
    
    // Force UI update
    update();
    
    // Show message to user
    Utils.showCustomTosst("Category changed to $newType. Please update relevant fields.");
  }
}

// Add this helper method to clear fields based on category type
void clearInvisibleFieldsForCategory(String categoryType) {
  // Define which fields should be invisible for each category type
  // This should match your _fieldVisibility map in the UI
  Map<String, List<String>> invisibleFieldsByCategory = {
    'CAREER': ['contactNumber'], // Fields not visible in CAREER
    'FRESHER': ['yearsOfExperience', 'experience'], // Fresher doesn't need experience
    'BUSINESS': ['birthDate', 'email', 'mobileNumber', 'salaryType', 'accommodation'],
    'DOMESTIC': ['birthDate', 'email', 'mobileNumber', 'qualification', 
                 'experience', 'yearsOfExperience', 'salaryType', 'accommodation', 
                 'skills', 'languages'],
  };

  // Get fields to clear for this category type
  List<String> fieldsToClear = invisibleFieldsByCategory[categoryType.toUpperCase()] ?? [];
  
  // Clear the fields
  for (String field in fieldsToClear) {
    clearSpecificField(field);
  }
}

// Add this method to clear specific fields
void clearSpecificField(String fieldName) {
  switch (fieldName) {
    case 'fullName':
      resumenameController.clear();
      break;
    case 'gender':
      resumeselectedGender.value = '';
      break;
    case 'birthDate':
      resumebirthDateController.clear();
      break;
    case 'email':
      resumeemailId.clear();
      break;
    case 'mobileNumber':
      resumemobileNumberController.clear();
      break;
    case 'contactNumber':
      resumecontactNumberController.clear();
      break;
    case 'qualification':
      resumequalificationController.clear();
      break;
    case 'jobType':
      resumeselectedJobType.value = '';
      break;
    case 'experience':
      resumeexperiencesType.value = 'Fresher';
      resumeexperiencesController.clear();
      break;
    case 'yearsOfExperience':
      resumeexperiencesController.clear();
      break;
    case 'expectedSalary':
      resumeexpectedSalaryController.clear();
      break;
    case 'salaryType':
      resumeselectedSalaryType.value = '';
      break;
    case 'accommodation':
      resumeaccommodationRequired.value = false;
      break;
    case 'skills':
      resumeskillsList.clear();
      break;
    case 'languages':
      resumelanguagesList.clear();
      break;
    case 'preferredCountry':
      resumepreferredCountryController.clear();
      break;
    case 'preferredState':
      resumepreferredStateController.clear();
      break;
    case 'preferredCity':
      resumepreferredCityController.clear();
      break;
    case 'anyCity':
      resumeanyCity.value = false;
      break;
    case 'documents':
      uploadResumeList.clear();
      break;
    case 'certificates':
      certificateList.clear();
      break;
    case 'shortVideo':
      resumeshortVideoList.clear();
      break;
    case 'profilePhoto':
      resumephotoList.clear();
      break;
    case 'resumeHeadline':
      resumeresumeHeadingController.clear();
      break;
    case 'jobSpeciality':
      resumejobSpecialityController.clear();
      break;
    case 'jobSubSpeciality':
      resumejobSubSpecialityList.clear();
      break;
    case 'jobCategory':
      resumeselectedJobCategory.value = '';
      resumejobCategoryController.clear();
      resumecategoryId.value = 0;
      resumeselectedCategoryID.value = '';
      break;
    case 'jobSubcategory':
      resumeselectedJobSubCategory.value = '';
      resumesubcategoryId.value = 0;
      resumeselecteSubdCategoryId.value = '';
      resumejobSubcategoryListValue.clear();
      resumejobSubTypeList.clear();
      break;
  }
}

  // Utility Methods
  void onGenderSelect(String gender) {
    resumeselectedGender.value = gender;
  }

  void onJobTypeSelect(String jobType) {
    resumeselectedJobType.value = jobType;
    update();
  }

  void clearForm() {
    resumenameController.clear();
    resumemobileNumberController.clear();
    resumeresumeHeadingController.clear();
    resumeexperiencesController.clear();
    resumeemailId.clear();
    resumebirthDateController.clear();
    resumecontactNumberController.clear();
    resumejobSpecialityController.clear();
    resumequalificationController.clear();
    resumeexpectedSalaryController.clear();
    resumepreferredCountryController.clear();
    resumepreferredStateController.clear();
    resumepreferredCityController.clear();
    resumejobCategoryController.clear();

    resumeselectedGender.value = "";
    resumeselectedJobType.value = "";
    resumeselectedJobCategory.value = "";
    resumeselectedJobSubCategory.value = "";
    resumeselectedCategoryID.value = "";
    resumeselecteSubdCategoryId.value = "";
    resumecategoryId.value = 0;
    resumesubcategoryId.value = 0;
    resumeaccommodationRequired.value = false;
    resumeanyCity.value = false;
    resumeexperiencesType.value = "Fresher";

    resumelanguagesList.clear();
    resumejobSubSpecialityList.clear();
    resumeskillsList.clear();
    uploadResumeList.clear();
    certificateList.clear();
    resumephotoList.clear();
    resumeshortVideoList.clear();

    resumeneedUpdate.value = false;
    resumeId.value = "";
    confirmationChecked.value = false;
  }
}
