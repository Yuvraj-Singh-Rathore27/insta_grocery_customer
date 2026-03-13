import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/file_model.dart';
import '../model/job_listing_model.dart';
import '../model/job_type_model.dart';
import '../model/responsemodel/BaseResponse.dart';
import '../model/responsemodel/FileUploadResponseModel.dart';
import '../model/responsemodel/StateResponseModel.dart';
import '../model/responsemodel/job_listing_response_model.dart';
import '../model/responsemodel/job_type_response_model.dart';
import '../model/state_model.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/ApiUrl.dart';
import '../webservices/WebServicesHelper.dart';
import '../model/candidate_resume_model.dart';

class JobProviderController extends GetxController {
  // ==================== STORAGE & AUTH ====================
  late GetStorage store;
  String userId = "";
  String accessToken = "";

  // ==================== JOB POSTING FORM VARIABLES ====================
  var selectedType = "1".obs;
  final List<File> images = <File>[].obs;
  PickedFile? pickedFile;
RxList<FileModel> uploadResumeList = <FileModel>[].obs;
  RxList certificateList = <FileModel>[].obs;
  
  // Form Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController resumeHeadingController = TextEditingController();
  TextEditingController experiencesController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController jobSpecialityController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController expectedSalaryController = TextEditingController();
  TextEditingController preferredCountryController = TextEditingController();
  TextEditingController preferredStateController = TextEditingController();
  TextEditingController preferredCityController = TextEditingController();
  TextEditingController jobCategoryController = TextEditingController();

  // Add Language here
  TextEditingController languageController=TextEditingController();

  // Selection Variables
  var experiencesType = "Fresher".obs;
  var selectedAccommodation = "".obs;
  var selectedExpectedSalary = "".obs;
  var selectedJobCategory = "".obs;
  var selectedJobSubCategory = "".obs;
  var selectedJobType = "".obs;
  var selectedCategoryID = "".obs;
  var selecteCategoryName = "".obs;
  var selecteSubdCategoryId = "".obs;
  var selecteSubdCategoryName = "".obs;
  var selectedDate = "".obs;
  var selectedGender = "".obs;
  var selectedCity = "".obs;
  var selectedMinimumExperience = "".obs;
  var selectedMaxExperience = "".obs;
  
  // Boolean Variables
  var needUpdate = false.obs;
  var accommodationRequired = false.obs;
  var anyCity = false.obs;

  // ==================== JOB DATA LISTS ====================
  RxList<JobTypeModel> jobTypeList = <JobTypeModel>[].obs;
  RxList<JobTypeModel> jobSubTypeList = <JobTypeModel>[].obs;
  RxList<JobListingModel> jobListing = <JobListingModel>[].obs;
  RxList<JobListingModel> filteredJobList = <JobListingModel>[].obs;
  RxList<JobListingModel> appliedJobList = <JobListingModel>[].obs;
  RxList<int> appliedJobIds = <int>[].obs;

  // ==================== MY POSTED JOBS VARIABLES ====================
  RxList<dynamic> myPostedJobs = <dynamic>[].obs;
  RxList<dynamic> jobApplicants = <dynamic>[].obs;
  RxInt selectedJobId = 0.obs;
  RxBool isLoadingMyJobs = false.obs;
  RxBool isLoadingApplicants = false.obs;

  // ==================== DROPDOWN LISTS ====================
  RxList<String> genderList = <String>[].obs;
  RxList<String> expectedSalaryList = <String>[].obs;
  RxList<String> minimumExperienceList = <String>[].obs;
  RxList<String> maxExperienceList = <String>[].obs;
  RxList<String> jobCategoryListValue = <String>[].obs;
  RxList<String> jobSubcategoryListValue = <String>[].obs;
  RxList<String> accommodationList = <String>[].obs;
  RxList<String> jobTypeListValue = <String>[].obs;
  RxList<StateModel> cityList = <StateModel>[].obs;
  RxList<String> citySelectableList = <String>[].obs;

  // ==================== FILTER VARIABLES ====================
  RxList<String> selectedJobTypeFilters = <String>[].obs;
  RxString selectedCategoryFilter = ''.obs;
  RxString selectedSubCategoryFilter = ''.obs;
  RxString selectedJobTypeFilter = ''.obs;
  RxBool isFilterApplied = false.obs;
  
  // ==================== NEW FILTER VARIABLES ====================
  RxString selectedExperienceFilter = ''.obs;
  RxList<String> selectedLanguages = <String>[].obs;
  RxString selectedAccommodationFilter = ''.obs;
  RxString selectedSalaryExpectationFilter = ''.obs;
  RxString selectedLocationTypeFilter = ''.obs; // Within Country/Abroad
  RxString selectedPreferredCityFilter = ''.obs;

  // ==================== FILTER OPTIONS ====================
  RxList<String> experienceOptions = <String>[].obs;
  RxList<String> languageOptions = <String>[].obs;
  RxList<String> accommodationOptions = <String>[].obs;
  RxList<String> salaryExpectationOptions = <String>[].obs;
  RxList<String> locationTypeOptions = <String>[].obs;

  // ==================== SEARCH VARIABLES ====================
  RxString searchQuery = ''.obs;
  RxList<JobListingModel> searchedJobList = <JobListingModel>[].obs;

  // ==================== PROFILE VARIABLES ====================
  RxList<String> languagesList = <String>[].obs;
  RxList<String> jobSubSpecialityList = <String>[].obs;
  RxList<String> skillsList = <String>[].obs;
  RxList<Map<String, dynamic>> allResumes = <Map<String, dynamic>>[].obs;
  final categoryId = RxInt(0);
  final subcategoryId = RxInt(0);
  final resumeFiles = RxList<Map<String, dynamic>>();
  final photoData = Rx<Map<String, dynamic>>({});
  final shortVideoData = Rx<Map<String, dynamic>>({});
  RxList<dynamic> photoList = <dynamic>[].obs;
  RxList<dynamic> shortVideoList = <dynamic>[].obs;

  // ==================== TAGS VARIABLES ====================
  RxList<String> availableTags = <String>[].obs;
  RxList<String> selectedTags = <String>[].obs;
  RxBool isLoadingTags = false.obs;
  RxString selectedMainCategoryType = "CAREER".obs;

  // ==================== SALARY VARIABLES ====================

TextEditingController salaryFromController = TextEditingController();
TextEditingController salaryToController = TextEditingController();

RxString selectedSalaryType = "Monthly".obs;

RxList<String> salaryTypeList = <String>[
  "Monthly",
  "Yearly",
  "Hourly",
  "Weekly"
].obs;


// ==================== MAP LOCATION VARIABLES ====================

TextEditingController cityNameController = TextEditingController();
TextEditingController stateNameController = TextEditingController();
TextEditingController countryController = TextEditingController();

RxDouble latitude = 0.0.obs;
RxDouble longitude = 0.0.obs;

// ==================== CANDIDATE RESUME VARIABLES ====================

// ==================== CANDIDATE RESUME VARIABLES ====================

RxList<CandidateData> candidateResumeList = <CandidateData>[].obs;

RxBool isLoadingCandidateResume = false.obs;

// filter 


RxString filterName = "".obs;
RxString filterCity = "".obs;
RxString filterExperience = "".obs;
RxString filterExpectedSalary = "".obs;
RxBool filterAccommodation = true.obs;

RxString selectedResumeJobType = "".obs;
  

  // ==================== INITIALIZATION ====================
  @override
  void onInit() {
    store = GetStorage();
    userId = store.read(UserPreferences.user_id);
    accessToken = store.read(UserPreferences.access_token);
    
    print("JobProviderController Userid => $userId");
    print("JobProviderController accessToken => $accessToken");
    
    // Initialize data
    initializeDropdowns();
    initializeFilterOptions(); 
    getJobTypeList("CAREER");
    getJobListing();
    getMyPostedJobs();
    getCandidateResumeList();
    getCityList();
    // fetchAvailableTags();

    super.onInit();
  }

  // ==================== INITIALIZE FILTER OPTIONS ====================
  void initializeFilterOptions() {
    // Experience options
    experienceOptions.addAll([
      'Fresher',
      '0-1 years',
      '1-3 years', 
      '3-5 years',
      '5-8 years',
      '8-10 years',
      '10+ years'
    ]);
    
    // Language options
    languageOptions.addAll([
      'English',
      'Hindi',
      'Spanish',
      'French',
      'German',
      'Chinese',
      'Arabic',
      'Regional Language'
    ]);
    
    // Accommodation options
    accommodationOptions.addAll(['Yes', 'No', 'Not Required']);
    
    // Salary expectation options
    salaryExpectationOptions.addAll([
      '0-3 LPA',
      '3-6 LPA', 
      '6-10 LPA',
      '10-15 LPA',
      '15-20 LPA',
      '20-30 LPA',
      '30-50 LPA',
      '50+ LPA'
    ]);
    
    // Location type options
    locationTypeOptions.addAll(['Within Country', 'Abroad']);
    
    experienceOptions.refresh();
    languageOptions.refresh();
    accommodationOptions.refresh();
    salaryExpectationOptions.refresh();
    locationTypeOptions.refresh();
  }

  // ==================== RESUME VIEWING FOR APPLICANTS ====================
  void viewApplicantResume(Map<String, dynamic> jobSeeker) {
    if (jobSeeker.isEmpty) {
      Get.snackbar(
        'Error',
        'No resume data available for this applicant',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    print("🎯 Opening resume for: ${jobSeeker['full_name']}");
  }

  // ==================== SEARCH METHODS ====================
  void searchJobs(String query) {
    searchQuery.value = query.trim().toLowerCase();
    
    if (searchQuery.isEmpty) {
      searchedJobList.assignAll(
        selectedJobTypeFilters.isNotEmpty || isFilterApplied.value ? filteredJobList : jobListing
      );
    } else {
      List<JobListingModel> tempSearchedList = [];
      final List<JobListingModel> sourceList = 
          selectedJobTypeFilters.isNotEmpty || isFilterApplied.value ? filteredJobList : jobListing;
      
      for (var job in sourceList) {
        bool matchesSearch = false;
        final jobHeading = job.jobHeading?.toLowerCase() ?? '';
        final jobLocation = job.jobLocation?.toLowerCase() ?? '';
        final jobType = job.jobType?.toLowerCase() ?? '';
        final workType = job.workType?.toLowerCase() ?? '';
        final jobCategory = job.jobCategory?.toLowerCase() ?? '';
        final city = job.city?.toLowerCase() ?? '';
        final state = job.state?.toLowerCase() ?? '';
        
        if (jobHeading.contains(searchQuery.value) ||
            jobLocation.contains(searchQuery.value) ||
            jobType.contains(searchQuery.value) ||
            workType.contains(searchQuery.value) ||
            jobCategory.contains(searchQuery.value) ||
            city.contains(searchQuery.value) ||
            state.contains(searchQuery.value)) {
          matchesSearch = true;
        }
        if (matchesSearch) {
          tempSearchedList.add(job);
        }
      }
      searchedJobList.assignAll(tempSearchedList);
    }
    searchedJobList.refresh();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchedJobList.clear();
    initializeFilteredList();
  }

  // ==================== FILTER METHODS ====================
  void applyFilters() {
    List<JobListingModel> tempFilteredList = [];
     print("🔥 APPLY FILTERS CALLED 🔥");
    
    // Start with all jobs
    tempFilteredList.addAll(jobListing);
    
   // Apply category filter (DIRECT ID MATCH)
if (selectedCategoryID.isNotEmpty &&
    selectedCategoryID.value != '') {

  tempFilteredList = tempFilteredList.where((job) {
    return job.categoryId?.toString() ==
        selectedCategoryID.value;
  }).toList();
}
    // Apply subcategory filter
    if (selectedSubCategoryFilter.isNotEmpty && selectedSubCategoryFilter.value != '') {
      tempFilteredList = tempFilteredList.where((job) {
        String? selectedSubCategoryId = _getSubCategoryIdFromName(selectedSubCategoryFilter.value);
        if (selectedSubCategoryId != null && job.subcategoryId != null) {
          return job.subcategoryId.toString() == selectedSubCategoryId;
        }
        return false;
      }).toList();
    }
    
    // Apply job type filter
    if (selectedJobTypeFilter.isNotEmpty && selectedJobTypeFilter.value != '') {
      tempFilteredList = tempFilteredList.where((job) {
        final jobType = job.jobType?.toLowerCase() ?? '';
        final workType = job.workType?.toLowerCase() ?? '';
        final filterType = selectedJobTypeFilter.value.toLowerCase();
        
        return jobType.contains(filterType) || workType.contains(filterType);
      }).toList();
    }
    
    // Apply experience filter
    if (selectedExperienceFilter.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        final minExp = job.minExperience?.toString().toLowerCase() ?? '';
        final maxExp = job.maxExperience?.toString().toLowerCase() ?? '';
        
        return _matchesExperienceFilter(minExp, maxExp, selectedExperienceFilter.value);
      }).toList();
    }

    print("Selected Category Name: ${selectedCategoryFilter.value}");
print("Selected Category ID: ${_getCategoryIdFromName(selectedCategoryFilter.value)}");

for (var job in jobListing) {
  print("Job -> ${job.jobHeading} | categoryId: ${job.categoryId}");
}
    
    // Apply languages filter
    if (selectedLanguages.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        // Check if job has any of the selected languages
        // You might need to add a languages field to your JobListingModel
        for (var language in selectedLanguages) {
          if (_jobHasLanguage(job, language)) {
            return true;
          }
        }
        return false;
      }).toList();
    }
    
    // Apply accommodation filter
    if (selectedAccommodationFilter.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        final jobAccommodation = job.accommodation?.toLowerCase() ?? '';
        final filterAccommodation = selectedAccommodationFilter.value.toLowerCase();
        
        if (filterAccommodation == 'yes') {
          return jobAccommodation.contains('yes') || 
                 jobAccommodation.contains('provided') ||
                 jobAccommodation.contains('true');
        } else if (filterAccommodation == 'no') {
          return jobAccommodation.contains('no') || 
                 jobAccommodation.contains('false') ||
                 jobAccommodation.isEmpty;
        } else if (filterAccommodation == 'not required') {
          return true;
        }
        return false;
      }).toList();
    }
    
    // Apply salary expectation filter
    if (selectedSalaryExpectationFilter.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        final salaryFrom = job.salaryFrom ?? 0;
        final salaryTo = job.salaryTo ?? 0;
        final salaryRange = job.salaryRange?.toString().toLowerCase() ?? '';
        
        return _matchesSalaryFilter(salaryFrom, salaryTo, salaryRange, selectedSalaryExpectationFilter.value);
      }).toList();
    }
    
    // Apply location type filter (Within Country/Abroad)
    if (selectedLocationTypeFilter.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        final jobCountry = job.country?.toLowerCase() ?? '';
        
        if (selectedLocationTypeFilter.value == 'Within Country') {
          return jobCountry.contains('india') || 
                 !jobCountry.contains('foreign') ||
                 jobCountry.isEmpty;
        } else if (selectedLocationTypeFilter.value == 'Abroad') {
          return jobCountry.contains('foreign') || 
                 !jobCountry.contains('india') ||
                 jobCountry.toLowerCase().contains('international');
        }
        return false;
      }).toList();
    }
    
    // Apply preferred city filter
    if (selectedPreferredCityFilter.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        final jobCity = job.city?.toLowerCase() ?? '';
        final jobLocation = job.jobLocation?.toLowerCase() ?? '';
        final preferredCity = selectedPreferredCityFilter.value.toLowerCase();
        
        return jobCity.contains(preferredCity) || 
               jobLocation.contains(preferredCity);
      }).toList();
    }
    
    // Apply tags filter
    if (selectedTags.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        for (var tag in selectedTags) {
          if (_jobMatchesTag(job, tag)) {
            return true;
          }
        }
        return false;
      }).toList();
    }
    
    // Apply chip filters
    if (selectedJobTypeFilters.isNotEmpty) {
      tempFilteredList = tempFilteredList.where((job) {
        for (var filter in selectedJobTypeFilters) {
          if (_jobMatchesTypeFilter(job, filter)) {
            return true;
          }
        }
        return false;
      }).toList();
    }
    
    filteredJobList.assignAll(tempFilteredList);
    
    // Update search list if there's an active search
    if (searchQuery.isNotEmpty) {
      searchJobs(searchQuery.value);
    } else {
      searchedJobList.assignAll(filteredJobList);
    }
    
    // Update filter applied state
   isFilterApplied.value =
    selectedCategoryID.value.isNotEmpty ||
    selectedSubCategoryFilter.value.isNotEmpty ||
    selectedJobTypeFilter.value.isNotEmpty ||
    selectedExperienceFilter.value.isNotEmpty ||
    selectedLanguages.isNotEmpty ||
    selectedAccommodationFilter.value.isNotEmpty ||
    selectedSalaryExpectationFilter.value.isNotEmpty ||
    selectedLocationTypeFilter.value.isNotEmpty ||
    selectedPreferredCityFilter.value.isNotEmpty ||
    selectedTags.isNotEmpty ||
    selectedJobTypeFilters.isNotEmpty;
    filteredJobList.refresh();
    searchedJobList.refresh();
    
    print("🔄 All Filters Applied:");
    print("📊 Category: ${selectedCategoryFilter.value}");
    print("📊 Subcategory: ${selectedSubCategoryFilter.value}");
    print("📊 Job Type: ${selectedJobTypeFilter.value}");
    print("⏳ Experience: ${selectedExperienceFilter.value}");
    print("🗣️ Languages: ${selectedLanguages.length}");
    print("🏠 Accommodation: ${selectedAccommodationFilter.value}");
    print("💰 Salary: ${selectedSalaryExpectationFilter.value}");
    print("🌍 Location: ${selectedLocationTypeFilter.value}");
    print("🏙️ Preferred City: ${selectedPreferredCityFilter.value}");
    print("🏷️ Selected Tags: ${selectedTags.length}");
    print("📊 Total Jobs After Filter: ${filteredJobList.length}");
  }

  // ==================== HELPER METHODS FOR FILTERS ====================
  bool _matchesExperienceFilter(String minExp, String maxExp, String filter) {
    final minExpNum = int.tryParse(minExp) ?? 0;
    final maxExpNum = int.tryParse(maxExp) ?? 0;
    
    switch (filter.toLowerCase()) {
      case 'fresher':
        return minExpNum == 0 || maxExpNum == 0;
      case '0-1 years':
        return (minExpNum >= 0 && minExpNum <= 1) || (maxExpNum >= 0 && maxExpNum <= 1);
      case '1-3 years':
        return (minExpNum >= 1 && minExpNum <= 3) || (maxExpNum >= 1 && maxExpNum <= 3);
      case '3-5 years':
        return (minExpNum >= 3 && minExpNum <= 5) || (maxExpNum >= 3 && maxExpNum <= 5);
      case '5-8 years':
        return (minExpNum >= 5 && minExpNum <= 8) || (maxExpNum >= 5 && maxExpNum <= 8);
      case '8-10 years':
        return (minExpNum >= 8 && minExpNum <= 10) || (maxExpNum >= 8 && maxExpNum <= 10);
      case '10+ years':
        return minExpNum >= 10 || maxExpNum >= 10;
      default:
        return false;
    }
  }

  bool _matchesSalaryFilter(int salaryFrom, int salaryTo, String salaryRange, String filter) {
    // Use salaryFrom and salaryTo if available, otherwise parse salaryRange
    int minSalary = salaryFrom;
    int maxSalary = salaryTo;
    
    if (minSalary == 0 && maxSalary == 0 && salaryRange.isNotEmpty) {
      // Parse salary range string (e.g., "30000-50000")
      if (salaryRange.contains('-')) {
        List<String> parts = salaryRange.split('-');
        if (parts.length == 2) {
          minSalary = int.tryParse(parts[0]) ?? 0;
          maxSalary = int.tryParse(parts[1]) ?? 0;
        }
      }
    }
    
    // Convert to LPA (assuming salary is in monthly, multiply by 12)
    final minSalaryLPA = (minSalary * 12) / 100000;
    final maxSalaryLPA = (maxSalary * 12) / 100000;
    final avgSalaryLPA = (minSalaryLPA + maxSalaryLPA) / 2;
    
    switch (filter.toLowerCase()) {
      case '0-3 lpa':
        return avgSalaryLPA <= 3;
      case '3-6 lpa':
        return avgSalaryLPA >= 3 && avgSalaryLPA <= 6;
      case '6-10 lpa':
        return avgSalaryLPA >= 6 && avgSalaryLPA <= 10;
      case '10-15 lpa':
        return avgSalaryLPA >= 10 && avgSalaryLPA <= 15;
      case '15-20 lpa':
        return avgSalaryLPA >= 15 && avgSalaryLPA <= 20;
      case '20-30 lpa':
        return avgSalaryLPA >= 20 && avgSalaryLPA <= 30;
      case '30-50 lpa':
        return avgSalaryLPA >= 30 && avgSalaryLPA <= 50;
      case '50+ lpa':
        return avgSalaryLPA >= 50;
      default:
        return false;
    }
  }

  bool _jobHasLanguage(JobListingModel job, String language) {
    // Check if job has the specified language
    // You might need to add a languages field to your JobListingModel
    final jobDescription = '${job.jobHeading} ${job.jobCategory} ${job.jobType}'.toLowerCase();
    return jobDescription.contains(language.toLowerCase());
  }

  bool _jobMatchesTag(JobListingModel job, String tag) {
    final jobText = '${job.jobHeading} ${job.jobCategory} ${job.jobType} ${job.workType} ${job.jobLocation}'.toLowerCase();
    return jobText.contains(tag.toLowerCase());
  }

  bool _jobMatchesTypeFilter(JobListingModel job, String filter) {
    final jobType = job.jobType?.toLowerCase() ?? '';
    final workType = job.workType?.toLowerCase() ?? '';
    final filterLower = filter.toLowerCase();
    
    return jobType.contains(filterLower) || workType.contains(filterLower);
  }

  // ==================== CATEGORY & SUBCATEGORY METHODS ====================
  List<String> getAvailableCategories() {
    List<String> categories = [];
    for (var jobType in jobTypeList) {
      if (jobType.name != null && jobType.name!.isNotEmpty) {
        categories.add(jobType.name!);
      }
    }
    print("📊 Available Categories from API: $categories");
    return categories;
  }

  List<String> getAvailableSubCategories() {
  if (jobSubTypeList.isEmpty) return [];
  return jobSubTypeList.map((e) => e.name!.trim()
   ?? '').toList();
}


List<String> getAvailableJobTypes() {
  // Always return all 6 predefined job types
  final predefinedJobTypes = [
    "FRESHER", 
    "CAREER", 
    "BUSINESS", 
    "DOMESTIC"
  ];
  
  print("📊 Available Job Types: $predefinedJobTypes");
  return predefinedJobTypes;
}
  String? _getCategoryIdFromName(String categoryName) {
    for (var category in jobTypeList) {
      if (category.name == categoryName) {
        return category.id.toString();
      }
    }
    return null;
  }

  String? _getSubCategoryIdFromName(String subCategoryName) {
    for (var subCategory in jobSubTypeList) {
      if (subCategory.name == subCategoryName) {
        return subCategory.id.toString();
      }
    }
    return null;
  }

  void _fetchSubcategoriesForCategory(String categoryId) {
    selectedCategoryID.value = categoryId;
    getJobSubcategoryList();
  }

  // ==================== CLEAR FILTERS METHODS ====================
  void clearAllFilters() {
    selectedJobTypeFilters.clear();
    selectedCategoryFilter.value = '';
    selectedSubCategoryFilter.value = '';
    selectedJobTypeFilter.value = '';
    selectedExperienceFilter.value = '';
    selectedLanguages.clear();
    selectedAccommodationFilter.value = '';
    selectedSalaryExpectationFilter.value = '';
    selectedLocationTypeFilter.value = '';
    selectedPreferredCityFilter.value = '';
    selectedTags.clear();
    searchQuery.value = '';
    isFilterApplied.value = false;
    
    filteredJobList.assignAll(jobListing);
    searchedJobList.assignAll(jobListing);
    filteredJobList.refresh();
    searchedJobList.refresh();
  }

  void clearAdvancedFilters() {
    selectedCategoryFilter.value = '';
    selectedSubCategoryFilter.value = '';
    selectedJobTypeFilter.value = '';
    selectedExperienceFilter.value = '';
    selectedLanguages.clear();
    selectedAccommodationFilter.value = '';
    selectedSalaryExpectationFilter.value = '';
    selectedLocationTypeFilter.value = '';
    selectedPreferredCityFilter.value = '';
    selectedTags.clear();
    applyFilters();
  }

  // ==================== LANGUAGE METHODS ====================
  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
    applyFilters();
  }

  void clearSelectedLanguages() {
    selectedLanguages.clear();
    applyFilters();
  }

  // ==================== CATEGORY CHANGE HANDLER ====================
  void onCategoryFilterChanged(String? category) {
    selectedCategoryFilter.value = category ?? '';
    selectedSubCategoryFilter.value = '';
    
    if (selectedCategoryFilter.isNotEmpty && selectedCategoryFilter.value != '') {
      String? categoryId;
      for (var cat in jobTypeList) {
        if (cat.name == selectedCategoryFilter.value) {
          categoryId = cat.id.toString();
          selectedCategoryID.value = categoryId;
          break;
        }
      }
      
      if (categoryId != null) {
        getJobSubcategoryList().then((_) {
          applyFilters();
        });
      }
    } else {
      applyFilters();
    }
  }

  // ==================== DEBUG METHODS ====================
  void debugJobData() {
    print("🔍 DEBUG - Job Data Structure:");
    print("📊 Total Jobs: ${jobListing.length}");
    print("📊 Available Categories: ${getAvailableCategories()}");
    print("📊 Selected Category: ${selectedCategoryFilter.value}");
    print("📊 Available Subcategories: ${getAvailableSubCategories()}");
    
    for (int i = 0; i < jobListing.length; i++) {
      var job = jobListing[i];
      print("--- Job ${i + 1} ---");
      print("Job Heading: ${job.jobHeading}");
      print("Category ID: ${job.categoryId}");
      print("Subcategory ID: ${job.subcategoryId}");
      print("Job Type: ${job.jobType}");
      print("Work Type: ${job.workType}");
      print("Min Experience: ${job.minExperience}");
      print("Max Experience: ${job.maxExperience}");
      print("Salary From: ${job.salaryFrom}");
      print("Salary To: ${job.salaryTo}");
      print("Country: ${job.country}");
      print("City: ${job.city}");
      print("Accommodation: ${job.accommodation}");
    }
  }

  // ==================== FILTER INITIALIZATION ====================
  void filterJobsByType(List<String> selectedTypes) {
    selectedJobTypeFilters.assignAll(selectedTypes);
    applyFilters();
  }

  void initializeFilteredList() {
    filteredJobList.assignAll(jobListing);
    filteredJobList.refresh();
  }

  // ==================== MY POSTED JOBS METHODS ====================
  Future<void> getMyPostedJobs() async {
    try {
      isLoadingMyJobs.value = true;
      Utils().customPrint('🔄 Fetching jobs posted by user ID: $userId');
      
      final param = {
        "user_id": userId,
        "accessToken": accessToken,
      };
      
      Map<String, dynamic>? response = await WebServicesHelper().getJobListApi(param);
      
      if (response != null) {
        myPostedJobs.clear();
        
        if (response['data'] != null && response['data'] is List) {
          List<dynamic> allJobs = response['data'] as List;
          Utils().customPrint('📊 Total jobs available: ${allJobs.length}');
          
          for (var job in allJobs) {
            if (job['created_by'] != null && job['created_by'].toString() == userId) {
              myPostedJobs.add(job);
            }
          }
          
          Utils().customPrint('🎯 Total jobs posted by me: ${myPostedJobs.length}');
          await fetchApplicantCountsForAllJobs();
        }
      }
    } catch (e) {
      Utils.showCustomTosst("Error loading your posted jobs");
      Utils().customPrint('❌ Exception in getMyPostedJobs: $e');
    } finally {
      isLoadingMyJobs.value = false;
    }
  }

  Future<void> fetchApplicantCountsForAllJobs() async {
    try {
      Utils().customPrint('🔄 Fetching applicant counts for ${myPostedJobs.length} jobs');
      
      for (var job in myPostedJobs) {
        final jobId = job['id'];
        if (jobId != null) {
          final count = await getApplicantCountForJob(jobId);
          job['applicant_count'] = count;
          Utils().customPrint('📝 Job ${job['job_heading']} has $count applicants');
        }
      }
      
      myPostedJobs.refresh();
      Utils().customPrint('✅ Updated applicant counts for all jobs');
    } catch (e) {
      Utils().customPrint('❌ Error fetching applicant counts: $e');
    }
  }

  Future<int> getApplicantCountForJob(int jobId) async {
    try {
      final param = {
        "job_id": jobId.toString(),
        "page": "1",
        "size": "1",
        "accessToken": accessToken,
      };
      
      Map<String, dynamic>? response = await WebServicesHelper().getListAppliedJobByJobId(param);
      
      if (response != null && response['error'] == false) {
        return response['total'] ?? 0;
      }
    } catch (e) {
      Utils().customPrint('❌ Error getting applicant count for job $jobId: $e');
    }
    return 0;
  }

  Future<void> getApplicantsForJob(int jobId) async {
    try {
      isLoadingApplicants.value = true;
      selectedJobId.value = jobId;
      
      final param = {
        "job_id": jobId.toString(),
        "page": "1",
        "size": "50",
        "accessToken": accessToken,
      };

      Utils().customPrint('🔄 Fetching applicants for job ID: $jobId');
      
      Map<String, dynamic>? response = await WebServicesHelper().getListAppliedJobByJobId(param);
      
      if (response != null && response['error'] == false && response['status'] == 200) {
        jobApplicants.clear();
        if (response['data'] != null && response['data'] is List) {
          jobApplicants.addAll(response['data'] as List);
        }
        Utils().customPrint('✅ Loaded ${jobApplicants.length} applicants for job $jobId');
      } else {
        String errorMessage = response?['message'] ?? 'Failed to load applicants';
        Utils.showCustomTosst(errorMessage);
      }
    } catch (e) {
      Utils.showCustomTosst("Error loading applicants");
      Utils().customPrint('❌ Exception in getApplicantsForJob: $e');
    } finally {
      isLoadingApplicants.value = false;
    }
  }

  Future<void> refreshMyJobs() async {
    Utils().customPrint('🔄 Refreshing my jobs data');
    await getMyPostedJobs();
  }

  void debugJobStructure() {
    if (myPostedJobs.isNotEmpty) {
      Utils().customPrint('🔍 DEBUG - First job structure:');
      Utils().customPrint(myPostedJobs.first.toString());
    } else {
      Utils().customPrint('❌ No jobs available for debugging');
    }
  }

  // ==================== JOB APPLICATION METHODS ====================
  Future<void> applyJobApi(int jobId, JobListingModel job) async {
    final params = {
      "user_type": "user",
      "user_id": userId,
      "job_id": jobId,
    };

    print("📤 Applying for job => $params");

    final response = await WebServicesHelper().PostapplyJobApi(params);

    print("📥 Response: $response");

    if (response != null && response['status'] == 200) {
      String message = response['message'] ?? 'Something went wrong';
      bool isError = response['error'] ?? false;

      if (isError) {
        Get.snackbar("Notice", message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
      } else {
        appliedJobIds.add(jobId);
        appliedJobList.add(job);
        Get.snackbar("Success", "Job applied successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar("Error", "Something went wrong. Please try again later.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  // ==================== SELECTION HANDLERS ====================
  void onCitySelect(var data, String type) {
    switch (type) {
      case 'Accommodation':
        selectedAccommodation.value = data;
        break;
      case 'Expected_Salary':
        selectedExpectedSalary.value = data;
        break;
      case 'job_type':
        selectedJobType.value = data;
        break;
      case 'job_category':
        selectedJobCategory.value = data;
        for (int i = 0; i < jobTypeList.length; i++) {
          if (selectedJobCategory.value == jobTypeList.value[i].name) {
            selectedCategoryID.value = jobTypeList.value[i].id.toString();
            break;
          }
        }
        getJobSubcategoryList();
        break;
      case 'job_subcategory':
        selectedJobSubCategory.value = data;
        for (int i = 0; i < jobSubTypeList.length; i++) {
          if (selectedJobSubCategory.value == jobSubTypeList.value[i].name) {
            selecteSubdCategoryId.value = jobSubTypeList.value[i].id.toString();
            break;
          }
        }
        break;
      case 'gender':
        selectedGender.value = data;
        break;
      case 'city_type':
        selectedCity.value = data;
        break;
      case 'minimum_experience':
        selectedMinimumExperience.value = data;
        break;
      case 'max_experience':
        selectedMaxExperience.value = data;
        break;
    }
  }

  // ==================== API METHODS - DATA FETCHING ====================
  Future<void> getCityList() async {
    Map<String, dynamic>? response = await WebServicesHelper().getCityList();
    if (response != null) {
      StateResponseModel responseModel = StateResponseModel.fromJson(response);
      try {
        if (responseModel.status == 200) {
          cityList.value.addAll(responseModel.data as Iterable<StateModel>);
          for (int i = 0; i < cityList.length; i++) {
            citySelectableList.add(cityList[i].name ?? '');
          }
          citySelectableList.refresh();
        } else {
          Utils.showCustomTosst("Failed to load cities");
        }
      } catch (E) {
        print("Error loading cities: $E");
      }
    } else {
      Utils.showCustomTosst("Failed to load cities");
    }
  }

  Future<void> getJobTypeList(String categoryType) async {
    jobSubTypeList.clear();
jobSubcategoryListValue.clear();
selectedJobSubCategory.value = "";
selecteSubdCategoryId.value = "";
  final param = {
    "accessToken": accessToken,
    "category_type": categoryType,
  };

  Map<String, dynamic>? response =
      await WebServicesHelper().getJobcategoryList(param);

  if (response != null) {
    JobTypeResponseModel responseModel =
        JobTypeResponseModel.fromJson(response);

    try {
      if (responseModel.status == 200 &&
          responseModel.data != null) {

        jobTypeList.clear();
        jobCategoryListValue.clear();

        jobTypeList
            .addAll(responseModel.data as Iterable<JobTypeModel>);

        for (var item in jobTypeList) {
          jobCategoryListValue.add(item.name ?? '');
        }

        jobTypeList.refresh();
        jobCategoryListValue.refresh();
      } else {
        Utils.showCustomTosst("Failed to load job categories");
      }
    } catch (E) {
      print("error $E");
    }
  }
}
  Future<void> getJobSubcategoryList() async {
    final param = {
      "user_id": userId,
      "accessToken": accessToken,
      "category_id": selectedCategoryID.value.toString()
    };

    Map<String, dynamic>? response = await WebServicesHelper().getJobSubcategoryList(param);
    if (response != null) {
      JobTypeResponseModel responseModel = JobTypeResponseModel.fromJson(response);
      try {
        if (responseModel.status == 200 && responseModel.data != null) {
          jobSubTypeList.clear();
          jobSubcategoryListValue.clear();
          jobSubTypeList.addAll(responseModel.data as Iterable<JobTypeModel>);
          jobSubTypeList.refresh();
          for (int i = 0; i < jobSubTypeList.length; i++) {
            jobSubcategoryListValue.add(jobSubTypeList[i].name ?? '');
          }
          jobSubcategoryListValue.refresh();
        } else {
          Utils.showCustomTosst("Failed to load job subcategories");
        }
      } catch (E) {
        print("error" + E.toString());
      }
    }
  }

  Future<void> getJobListing() async {
    final param = {
      "user_id": userId,
      "accessToken": accessToken,
    };
    Map<String, dynamic>? response = await WebServicesHelper().getJobListApi(param);
    if (response != null) {
      JobListingResponseModel responseModel = JobListingResponseModel.fromJson(response);
      try {
        if (responseModel.data != null && responseModel.data!.isNotEmpty) {
          if (jobListing.isNotEmpty) jobListing.clear();
          jobListing.addAll(responseModel.data as Iterable<JobListingModel>);
          jobListing.refresh();
          initializeFilteredList();
        }
      } catch (E) {
        print("jobTypeList E==>" + E.toString());
      }
    }
  }

  // ==================== JOB POSTING METHODS ====================
Future<void> postJobByProviderApi() async {
  BuildContext? context = Get.context;
  print("Selected Category ID => ${selectedCategoryID.value}");
print("Selected SubCategory ID => ${selecteSubdCategoryId.value}");

  // ---------------- VALIDATION ----------------

  if (nameController.text.isEmpty) {
    Utils.showCustomTosstError("Please enter name.");
    return;
  }

  
  if (cityNameController.text.isEmpty) {
    Utils.showCustomTosstError("Please select location.");
    return;
  }

  if (selectedJobType.value.isEmpty) {
    Utils.showCustomTosstError("Please select Job Type.");
    return;
  }

  if (salaryFromController.text.isEmpty ||
      salaryToController.text.isEmpty) {
    Utils.showCustomTosstError("Please enter salary range.");
    return;
  }

  if (mobileNumberController.text.isEmpty) {
    Utils.showCustomTosstError("Please enter mobile number.");
    return;
  }

  if (emailId.text.isEmpty) {
    Utils.showCustomTosstError("Please enter email id.");
    return;
  }

  if (uploadResumeList.isEmpty) {
    Utils.showCustomTosstError("Please upload photo.");
    return;
  }

  // ---------------- CITY ID FIND ----------------

  String selectedCityId = "";

  for (var city in cityList) {
    if (selectedCity.value == city.name) {
      selectedCityId = city.id.toString();
      break;
    }
  }

  // ---------------- API PARAM ----------------

  final param = {
    "user_id": userId,
    "accessToken": accessToken,

    "created_by": userId,
    "created_by_id": userId,
    "updated_by": userId,
    "updated_by_id": userId,

    "user_type": "user",

    "country": countryController.text,

    "job_posted_by": nameController.text,
    "job_heading": resumeHeadingController.text,

    "category_id": selectedCategoryID.value,
    "subcategory_id": selecteSubdCategoryId.value.isEmpty
    ? null
    : int.parse(selecteSubdCategoryId.value),

    "job_type": selectedJobType.value,
    "work_type": selectedJobType.value,

    "min_experience": selectedMinimumExperience.value,
    "max_experience": selectedMaxExperience.value,

    // Salary
    "salary_from": salaryFromController.text,
    "salary_to": salaryToController.text,
    "salary_type": selectedSalaryType.value,

    "language": languageController.text,

    "contact_number": mobileNumberController.text,
    "email": emailId.text,

    "city": cityNameController.text,
    "state": stateNameController.text,

    "latitude": latitude.value,
    "longitude": longitude.value,

    "job_location": cityNameController.text,

    "accommodation": selectedAccommodation.value == "Yes",

   "upload_photos": uploadResumeList.map((e) {
  return {
    "path": e.path,
    "name": e.name
  };
}).toList(),

    "city_ids": [selectedCityId],
  };

  // ---------------- API CALL ----------------

  if (context != null) {
    showLoaderDialog(context);
  }
  

  Map<String, dynamic>? response =
      await WebServicesHelper().postJobByProviderApi(param);

  if (response != null) {
    BaseResponse responseModel = BaseResponse.fromJson(response);

    try {
      if (responseModel.status == 200) {
        if (context != null) hideProgress(context);

        Utils.showCustomTosst(responseModel.message ?? "Job posted");

        await getMyPostedJobs();
      } else {
        if (context != null) hideProgress(context);
      }
    } catch (e) {
      if (context != null) hideProgress(context);

      print("Post Job Error => $e");
    }
  }
}
  // ==================== FILE HANDLING METHODS ====================
  Future<void> getFromGallery(bool isCamera, String type) async {
    pickedFile = await ImagePicker().getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile?.path ?? '');
      fileUpload(imageFile, type);
      images.add(imageFile);
    }
  }

  Future<void> fileUpload(File images, String type) async {
    BuildContext? context = Get.context;
    String filePath = ApiUrl.fileUploadResume;
    
    showLoaderDialog(context!);
    Map<String, dynamic>? response = await WebServicesHelper().fileUpload(filePath, images);

    if (response != null) {
      FileUploadResponseModel baseResponse = FileUploadResponseModel.fromJson(response);
      try {
        if (baseResponse.status == 200) {
          if (type == 'Upload Certificates') {
            certificateList.add(baseResponse.data);
          } else {
            uploadResumeList.add(baseResponse.data!);
          }
          hideProgress(context);
        } else {
          Utils.showCustomTosst("Error image uploaded");
          hideProgress(context);
        }
      } catch (E) {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  // ==================== TAGS METHODS ====================
  List<String> getAvailableTags() {
  if (selectedSubCategoryFilter.isEmpty || selectedSubCategoryFilter.value == '') {
    return []; // No tags if no subcategory selected
  }
  
  List<String> tags = [];
  
  // Find the selected subcategory ID
  String? selectedSubCategoryId;
  for (var subCategory in jobSubTypeList) {
    if (subCategory.name!.trim() == selectedSubCategoryFilter.value.trim()) {
      selectedSubCategoryId = subCategory.id.toString();
      break;
    }
  }
  
  if (selectedSubCategoryId != null) {
    // Filter tags based on subcategory
    // You can modify this logic based on how your tags are related to subcategories
    for (var tag in availableTags) {
      // Simple matching - you can make this more sophisticated
      if (_tagMatchesSubcategory(tag, selectedSubCategoryFilter.value)) {
        tags.add(tag);
      }
    }
  }
  
  print("🏷️ Available Tags for '${selectedSubCategoryFilter.value}': $tags");
  return tags;
}

/// 🔧 Helper to check if tag matches subcategory
bool _tagMatchesSubcategory(String tag, String subcategory) {
  // Customize this logic based on your tag-subcategory relationships
  final tagLower = tag.toLowerCase();
  final subcategoryLower = subcategory.toLowerCase();
  
  // Example matching logic - modify as per your requirements
  if (subcategoryLower.contains('developer') && 
      (tagLower.contains('programming') || tagLower.contains('coding'))) {
    return true;
  }
  if (subcategoryLower.contains('design') && tagLower.contains('design')) {
    return true;
  }
  if (subcategoryLower.contains('marketing') && tagLower.contains('marketing')) {
    return true;
  }
  
  // Default: return all tags if no specific matching logic
  return true;
}


// ==================== GET CANDIDATE RESUME LIST ====================

Future<void> getCandidateResumeList() async {

  isLoadingCandidateResume.value = true;

  Map<String, dynamic> param = {
    "accessToken": accessToken,
  };

  if (filterName.value.trim().isNotEmpty) {
    param["name"] = filterName.value.trim();
  }

  if (filterCity.value.trim().isNotEmpty) {
    param["preferred_city"] = filterCity.value.trim();
  }

  if (filterExpectedSalary.value.trim().isNotEmpty) {
    param["expected_salary"] = filterExpectedSalary.value.trim();
  }

  if (selectedCategoryID.value.isNotEmpty) {
    param["category_id"] = selectedCategoryID.value;
  }

  if (selecteSubdCategoryId.value.isNotEmpty) {
    param["subcategory_id"] = selecteSubdCategoryId.value;
  }

  if (selectedResumeJobType.value.isNotEmpty) {
    param["job_type"] = selectedResumeJobType.value;
  }

  param["accommodation"] = filterAccommodation.value;

  final response =
      await WebServicesHelper().getListOfCandiateResume(param);

  isLoadingCandidateResume.value = false;

  if (response != null && response['status'] == 200) {

    List list = response['data'] ?? [];

    List<CandidateData> temp =
        list.map((e) => CandidateData.fromJson(e)).toList();

    /// ⭐ LOCAL EXPERIENCE FILTER
    if (filterExperience.value.isNotEmpty) {

      int selectedExp =
          filterExperience.value == "10+"
              ? 10
              : int.tryParse(filterExperience.value) ?? 0;

      temp = temp.where((e) {

        int candidateExp =
            int.tryParse(e.experience?.toString() ?? "0") ?? 0;

        return candidateExp >= selectedExp;

      }).toList();
    }

    candidateResumeList.value = temp;
  }
}

/// 🏷️ Fetch all available tags from API (keep this as is)
Future<void> fetchAvailableTags() async {
  try {
    isLoadingTags.value = true;
    
    final param = {
      "access_token": accessToken,
      "category_id": selectedCategoryID.value.trim(),
      "subcategory_id": selecteSubdCategoryId.value.trim(),

    };

    print("🔥 Sending to Tag API => $param");

    Map<String, dynamic>? response = await WebServicesHelper().getTagList(param);
    
    if (response != null && response['status'] == 200) {
      availableTags.clear();
      
      if (response['data'] != null && response['data'] is List) {
        List<dynamic> tagsData = response['data'] as List;
        
        for (var tag in tagsData) {
          if (tag['name'] != null && tag['name'].toString().isNotEmpty) {
            availableTags.add(tag['name'].toString());
          }
        }
        
        print("🏷️ Loaded ${availableTags.length} tags from API");
      }
    } else {
      print("❌ Failed to load tags: ${response?['message']}");
      _setFallbackTags();
    }
  } catch (e) {
    print("❌ Error loading tags: $e");
    _setFallbackTags();
  } finally {
    isLoadingTags.value = false;
  }
}

// ==================== JOB COUNT BY CATEGORY ====================

int getJobCountByCategory(String categoryId) {

  if (jobListing.isEmpty) return 0;

  int count = 0;

  for (var job in jobListing) {

    if (job.categoryId != null &&
        job.categoryId.toString() == categoryId) {
      count++;
    }

  }

  return count;
}

/// 🔄 Update tags when subcategory changes
void onSubCategoryFilterChanged(String? subcategory) {
  selectedSubCategoryFilter.value = subcategory ?? '';

  // find subcategory id
  for (var sub in jobSubTypeList) {
    if (sub.name!.trim().toLowerCase() == subcategory!.trim().toLowerCase()) {
      selecteSubdCategoryId.value = sub.id.toString();
      break;
    }
  }

  print("🎯 category_id SENT: ${selectedCategoryID.value}");
  print("🎯 subcategory_id SENT: ${selecteSubdCategoryId.value}");

  // Now call tags API
  fetchAvailableTags();

  applyFilters();
}



  void _setFallbackTags() {
    availableTags.addAll([
      "Urgent Hiring", "Work From Home", "Immediate Joining", "Fresher", "Experienced",
      "Remote Work", "On-site", "Contract", "Temporary", "Permanent"
    ]);
    print("🔄 Using fallback tags: ${availableTags.length} tags");
  }

  List<String> getAvailableTagsForFilter() {
    if (selectedSubCategoryFilter.isNotEmpty) {
    return getAvailableTags();
  }
    return availableTags;
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    applyFilters();
  }

  void clearSelectedTags() {
    selectedTags.clear();
    applyFilters();
  }

  void onResumeJobTypeChanged(String type) {

  selectedResumeJobType.value = type;

  /// Reset category + subcategory
  selectedCategoryFilter.value = "";
  selectedSubCategoryFilter.value = "";
  selectedCategoryID.value = "";
  selecteSubdCategoryId.value = "";

  jobCategoryListValue.clear();
  jobSubcategoryListValue.clear();
  jobSubTypeList.clear();

  /// ⭐ Load categories according to job type
  getJobTypeList(type);
}

  // ==================== UTILITY METHODS ====================
  void clearForm() {
    List<TextEditingController> controllers = [
      nameController, mobileNumberController, resumeHeadingController,
      experiencesController, emailId, birthDateController, contactNumberController,
      jobSpecialityController, qualificationController, expectedSalaryController,
      preferredCountryController, preferredStateController, preferredCityController,
      jobCategoryController,languageController
    ];
    
    for (var controller in controllers) {
      controller.clear();
    }

    selectedGender.value = "Male";
    selectedJobType.value = "";
    selectedCategoryID.value = "";
    selecteSubdCategoryId.value = "";
    accommodationRequired.value = false;
    anyCity.value = false;

    languagesList.clear();
    jobSubSpecialityList.clear();
    skillsList.clear();
    uploadResumeList.clear();
    certificateList.clear();
    photoList.clear();
    shortVideoList.clear();
    salaryFromController.clear();
salaryToController.clear();
cityNameController.clear();
stateNameController.clear();
countryController.clear();

latitude.value = 0.0;
longitude.value = 0.0;

selectedSalaryType.value = "Monthly";

    needUpdate.value = false;
    clearAllFilters();
  }

  void initializeDropdowns() {
    genderList.addAll(["Male", "Female", "Any Gender"]);
    expectedSalaryList.addAll([
      "0-3 Lac", "3-8 Lac", "8-20 Lac", "20-50 Lac", "50 Lac Above"
    ]);
    
    for (int i = 1; i < 21; i++) minimumExperienceList.add(i.toString());
    for (int i = 1; i < 40; i++) maxExperienceList.add(i.toString());
    
    accommodationList.addAll(["Yes", "No"]);
    jobTypeListValue.addAll([
    "Full Time", 
    "Part Time", 
    "Night Jobs", 
    "Remote Jobs", 
    "Freelancers", 
    "Internships"
  ]);
    genderList.refresh();
    expectedSalaryList.refresh();
    minimumExperienceList.refresh();
    maxExperienceList.refresh();
    accommodationList.refresh();
    jobTypeListValue.refresh();
  }

  void clearResumeFilters() {

  filterName.value = "";
  filterCity.value = "";
  filterExperience.value = "";
  filterExpectedSalary.value = "";
  filterAccommodation.value = true;

  selectedResumeJobType.value = "";

  selectedCategoryFilter.value = "";
  selectedSubCategoryFilter.value = "";
  selectedCategoryID.value = "";
  selecteSubdCategoryId.value = "";

  jobCategoryListValue.clear();
  jobSubcategoryListValue.clear();
  jobSubTypeList.clear();

  /// reload default category type
  getJobTypeList("CAREER");

  getCandidateResumeList();
}
}