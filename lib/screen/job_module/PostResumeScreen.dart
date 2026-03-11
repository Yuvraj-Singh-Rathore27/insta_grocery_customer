import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/utills/Utils.dart';
import '../../controller/resume_controller.dart';
import '../../res/AppColor.dart';
import '../../res/AppDimens.dart';
import '../../res/ImageRes.dart';
import '../../model/file_model.dart';
import 'resume_detail_view.dart';

class PostResumeScreen extends StatefulWidget {
  const PostResumeScreen({super.key});

  @override
  State<PostResumeScreen> createState() => _PostResumeScreenState();
}

class _PostResumeScreenState extends State<PostResumeScreen> {
  late ResumeController controller;
  late double height, width;

  // Field visibility maps for different category types
  final Map<String, Map<String, bool>> _fieldVisibility = {
    'CAREER': {
      'resumeHeadline': true,
      'jobSpeciality': true,
      'jobSubSpeciality': false,
      'jobCategory': true,
      'jobSubcategory': true,
      'profilePhoto': true,
      'fullName': true,
      'gender': true,
      'birthDate': true,
      'email': true,
      'mobileNumber': true,
      'contactNumber': false,
      'qualification': true,
      'jobType': true,
      'experience': true,
      'yearsOfExperience': true,
      'expectedSalary': true,
      'salaryType': true,
      'accommodation': true,
      'skills': true,
      'languages': true,
      'preferredCountry': true,
      'preferredCity': true,
      'preferredState': true,
      'anyCity': false,
      'documents': false,
      'certificates': false,
      'shortVideo': false,
    },
    'FRESHER': {
      'resumeHeadline': true,
      'jobSpeciality': true,
      'jobSubSpeciality': false,
      'jobCategory': true,
      'jobSubcategory': true,
      'profilePhoto': true,
      'fullName': true,
      'gender': true,
      'birthDate': true,
      'email': true,
      'mobileNumber': true,
      'contactNumber': false,
      'qualification': true,
      'jobType': true,
      'experience': true,
      'yearsOfExperience': true,
      'expectedSalary': true,
      'salaryType': true,
      'accommodation': true,
      'skills': true,
      'languages': true,
      'preferredCountry': true,
      'preferredCity': true,
      'preferredState': true,
      'anyCity': false,
      'documents': false,
      'certificates': false,
      'shortVideo': false,
    },
    'BUSINESS': {
      'resumeHeadline': true,
      'jobSpeciality': true,
      'jobSubSpeciality': false,
      'jobCategory': true,
      'jobSubcategory': true,
      'profilePhoto': true,
      'fullName': true,
      'gender': true,
      'birthDate': false,
      'email': true,
      'mobileNumber': false,
      'contactNumber': true,
      'qualification': true,
      'jobType': true,
      'experience': true,
      'yearsOfExperience': true,
      'expectedSalary': true,
      'salaryType': false,
      'accommodation': false,
      'skills': true,
      'languages': true,
      'preferredCountry': true,
      'preferredCity': true,
      'preferredState': true,
      'anyCity': false,
      'documents': false,
      'certificates': false,
      'shortVideo': false,
    },
    'DOMESTIC': {
      'resumeHeadline': true,
      'jobSpeciality': true,
      'jobSubSpeciality': false,
      'jobCategory': true,
      'jobSubcategory': true,
      'profilePhoto': true,
      'fullName': true,
      'gender': true,
      'birthDate': false,
      'email': true,
      'mobileNumber': false,
      'contactNumber': true,
      'qualification': false,
      'jobType': true,
      'experience': false,
      'yearsOfExperience': false,
      'expectedSalary': true,
      'salaryType': false,
      'accommodation': false,
      'skills': false,
      'languages': false,
      'preferredCountry': true,
      'preferredCity': true,
      'preferredState': true,
      'anyCity': false,
      'documents': false,
      'certificates': false,
      'shortVideo': false,
    },
   
    'default': {
      'resumeHeadline': true,
      'jobSpeciality': true,
      'jobSubSpeciality': true,
      'jobCategory': true,
      'jobSubcategory': true,
      'profilePhoto': true,
      'fullName': true,
      'gender': true,
      'birthDate': true,
      'email': true,
      'mobileNumber': true,
      'contactNumber': true,
      'qualification': true,
      'jobType': true,
      'experience': true,
      'yearsOfExperience': true,
      'expectedSalary': true,
      'salaryType': true,
      'accommodation': true,
      'skills': true,
      'languages': true,
      'preferredCountry': true,
      'preferredCity': true,
      'preferredState': true,
      'anyCity': true,
      'documents': true,
      'certificates': true,
      'shortVideo': true,
    },
  };

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResumeController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set default salary type
      controller.resumeselectedSalaryType.value = 'Yearly';
      
      // Load job categories for default selected category type if any
      if (controller.selectedCategoryType.value.isNotEmpty) {
        controller.getJobTypeList();
      }
    });
  }

  // Helper method to check if field should be visible
  bool _isFieldVisible(String fieldName) {
    final categoryType = controller.selectedCategoryType.value.toUpperCase();
    final visibilityMap = _fieldVisibility[categoryType] ?? _fieldVisibility['CAREER']!;
    return visibilityMap[fieldName] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Resume',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor().whiteColor,
        foregroundColor: AppColor().blackColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (controller.resumeallResumes.isNotEmpty) {
                final myResume = controller.resumeallResumes.firstWhere(
                  (resume) =>
                      resume["user_id"]?.toString() == controller.userId,
                  orElse: () => controller.resumeallResumes.first,
                );

                Get.to(() => ResumeDetailView(resume: myResume));
              } else {
                Utils.showCustomTosst("No resume data available");
                controller.loadResumeData();
              }
            },
            icon: const Icon(Icons.remove_red_eye),
            tooltip: 'Load my resume',
          ),
          IconButton(
            onPressed: () {
              _showClearConfirmationDialog(context, controller);
            },
            icon: const Icon(Icons.clear_all),
            tooltip: 'clear all',
          )
        ],
      ),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Category Type Selection
            _buildCategoryTypeSection(),

            const SizedBox(height: 10),

            // Dynamic sections based on category type
            if (_isFieldVisible('resumeHeadline') || 
                _isFieldVisible('jobSpeciality') || 
                _isFieldVisible('jobSubSpeciality') ||
                _isFieldVisible('jobCategory') ||
                _isFieldVisible('jobSubcategory'))
              _buildResumeInfoSection(),

            if (_isFieldVisible('fullName') || 
                _isFieldVisible('gender') || 
                _isFieldVisible('birthDate') ||
                _isFieldVisible('email') ||
                _isFieldVisible('mobileNumber') ||
                _isFieldVisible('contactNumber') ||
                _isFieldVisible('profilePhoto'))
              _buildPersonalInfoSection(),

            if (_isFieldVisible('jobType') || 
                _isFieldVisible('experience') || 
                _isFieldVisible('yearsOfExperience') ||
                _isFieldVisible('expectedSalary') ||
                _isFieldVisible('salaryType') ||
                _isFieldVisible('accommodation'))
              _buildEmploymentPreferencesSection(),

            if (_isFieldVisible('qualification') || 
                _isFieldVisible('skills') || 
                _isFieldVisible('languages'))
              _buildSkillsQualificationsSection(),

              const SizedBox(height: 10),

/// CURRENT LOCATION CARD
GestureDetector(
  onTap: () async {
    await controller.autoFillLocation();
  },
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.red.shade200),
      color: Colors.red.shade50,
    ),
    child: Column(
      children: [

        /// Current Location Field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
            color: Colors.white,
          ),
          child: Row(
            children: [

              Expanded(
  child: Obx(() => Center(
    child: Text(
      controller.currentCity.value.isEmpty
          ? "Tap to detect your current location"
          : "${controller.currentCity.value}, ${controller.currentState.value}, ${controller.currentCountry.value}",
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    ),
  )),
),

         const     Icon(Icons.my_location, color: Colors.red)
            ],
          ),
        ),

        const SizedBox(height: 10),

        /// Map Placeholder (UI like screenshot)
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.location_on, size: 35, color: Colors.red),
              SizedBox(height: 5),
              Text(
                "Tap to detect location",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 16),

            if (_isFieldVisible('preferredCountry') || 
                _isFieldVisible('preferredState') || 
                _isFieldVisible('preferredCity') ||
                _isFieldVisible('anyCity'))
              _buildLocationPreferencesSection(),

            if (_isFieldVisible('documents') || 
                _isFieldVisible('certificates') || 
                _isFieldVisible('shortVideo'))
              _buildDocumentsSection(),

            const SizedBox(height: 20),
          ],
        ),
      )),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildCategoryTypeSection() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppColor().whiteColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              size: 16,
              color: AppColor().colorPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                color: AppColor().blackColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.categoryTypeList.isEmpty) {
            return const SizedBox();
          }
          
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.categoryTypeList.map((type) {
                bool isSelected = controller.selectedCategoryType.value.toUpperCase() == type.toUpperCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _buildMinimalCategoryChip(type, isSelected),
                );
              }).toList(),
            ),
          );
        }),
      ],
    ),
  );
}

Widget _buildMinimalCategoryChip(String type, bool isSelected) {
  return GestureDetector(
     onTap: () async {
      if (isSelected) return;
      
      // Show confirmation dialog when updating existing resume
      if (controller.resumeneedUpdate.value) {
        _showCategoryChangeConfirmation(context, type);
      } else {
        await controller.onCategoryTypeSelect(type);
        if (type.toUpperCase() == 'FRESHER') {
          controller.resumeexperiencesType.value = 'Fresher';
        }
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColor().colorPrimary : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected 
              ? Colors.transparent
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Inter",
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? Colors.white : AppColor().blackColor.withOpacity(0.7),
        ),
      ),
    ),
  );
}

  Widget _buildPersonalInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor,
                ),
              ),
              if (_isFieldVisible('profilePhoto'))
                const Spacer(),
              if (_isFieldVisible('profilePhoto'))
                _buildProfilePhotoWidget(),
            ],
          ),
          const SizedBox(height: 16),

          if (_isFieldVisible('fullName'))
            _buildTextFieldWithLabel(
              'Full Name*',
              controller.resumenameController,
              'Enter your full name',
              TextInputType.text,
            ),
          if (_isFieldVisible('fullName'))
            const SizedBox(height: 16),

          if (_isFieldVisible('gender'))
            _buildDropdownWithLabel(
              'Gender*',
              controller.resumeselectedGender.value,
              controller.resumegenderList,
              'gender',
              'Select Gender',
            ),
          if (_isFieldVisible('gender'))
            const SizedBox(height: 16),

          if (_isFieldVisible('birthDate'))
            _buildDatePickerField(
              'Birth Date',
              controller.resumebirthDateController,
              'Select Birth Date',
            ),
          if (_isFieldVisible('birthDate'))
            const SizedBox(height: 16),

          if (_isFieldVisible('email'))
            _buildTextFieldWithLabel(
              'Email ID*',
              controller.resumeemailId,
              'Enter your email',
              TextInputType.emailAddress,
            ),
          if (_isFieldVisible('email'))
            const SizedBox(height: 16),

          if (_isFieldVisible('mobileNumber'))
            _buildTextFieldWithLabel(
              'Mobile Number*',
              controller.resumemobileNumberController,
              'Enter mobile number',
              TextInputType.phone,
            ),
          if (_isFieldVisible('mobileNumber'))
            const SizedBox(height: 16),

          if (_isFieldVisible('contactNumber'))
            _buildTextFieldWithLabel(
              'Contact Number*',
              controller.resumecontactNumberController,
              'Enter contact number',
              TextInputType.phone,
            ),
        ],
      ),
    );
  }


  void _showCategoryChangeConfirmation(BuildContext context, String newType) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Change Category'),
        content: Text(
          'Changing category to $newType will clear some fields that are not applicable. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColor().blackColor),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await controller.onCategoryTypeSelect(newType);
              if (newType.toUpperCase() == 'FRESHER') {
                controller.resumeexperiencesType.value = 'Fresher';
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor().colorPrimary,
            ),
            child:  Text('Continue',style: TextStyle(color: AppColor().whiteColor),),
          ),
        ],
      );
    },
  );
}

  Widget _buildProfilePhotoWidget() {
    return Obx(() {
      if (controller.resumephotoList.isNotEmpty) {
        final photo = controller.resumephotoList.first;
        return GestureDetector(
          onTap: () => showCustomDialog(context, controller, 'Profile Photo'),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor().colorPrimary, width: 2),
              image: photo is FileModel && photo.path != null
                  ? DecorationImage(
                      image: FileImage(File(photo.path!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photo is FileModel && photo.path == null
                ? Icon(Icons.person, color: AppColor().colorPrimary, size: 30)
                : null,
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => showCustomDialog(context, controller, 'Profile Photo'),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor().colorPrimary, width: 2),
              color: AppColor().colorExp.withOpacity(0.2),
            ),
            child: Icon(Icons.camera_alt, color: AppColor().colorPrimary, size: 30),
          ),
        );
      }
    });
  }

  Widget _buildResumeInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resume Detail',
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
          const SizedBox(height: 16),

          if (_isFieldVisible('resumeHeadline'))
            _buildTextFieldWithLabel(
              'Resume Headline*',
              controller.resumeresumeHeadingController,
              'e.g. Senior Flutter Developer',
              TextInputType.text,
            ),
          if (_isFieldVisible('resumeHeadline'))
            const SizedBox(height: 16),

          if (_isFieldVisible('jobCategory'))
            Obx(() => _buildDropdownWithLabel(
              'Job Category*',
              controller.resumeselectedJobCategory.value,
              controller.resumejobCategoryListValue,
              'job_category',
              controller.isLoadingCategories.value
                  ? 'Loading...'
                  : 'Select Category',
            )),
          if (_isFieldVisible('jobCategory'))
            const SizedBox(height: 16),

          if (_isFieldVisible('jobSubcategory'))
            Obx(() {
              String hintText;
              if (controller.isLoadingSubcategories.value) {
                hintText = 'Loading subcategories...';
              } else if (controller.resumeselectedCategoryID.value.isEmpty) {
                hintText = 'Select Category First';
              } else if (controller.resumejobSubcategoryListValue.isEmpty) {
                hintText = 'No subcategories available';
              } else {
                hintText = 'Select Subcategory';
              }

              return _buildDropdownWithLabel(
                'Job Subcategory*',
                controller.resumeselectedJobSubCategory.value,
                controller.resumejobSubcategoryListValue,
                'job_subcategory',
                hintText,
              );
            }),
          if (_isFieldVisible('jobSubcategory'))
            const SizedBox(height: 16),

          if (_isFieldVisible('jobSpeciality'))
            _buildTextFieldWithLabel(
              'Job Speciality',
              controller.resumejobSpecialityController,
              'e.g. Mobile App Development',
              TextInputType.text,
            ),
          if (_isFieldVisible('jobSpeciality'))
            const SizedBox(height: 16),

          if (_isFieldVisible('jobSubSpeciality'))
            _buildTagsInputField(
              'Job Sub Speciality',
              controller.resumejobSubSpecialityList,
              'Add sub speciality (press enter)',
            ),
        ],
      ),
    );
  }

  Widget _buildEmploymentPreferencesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employment Preferences',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
          const SizedBox(height: 16),

          if (_isFieldVisible('jobType'))
            _buildRadioOptions(
              'Job Type*',
              controller.resumejobTypeListValue,
              controller.resumeselectedJobType,
            ),
          if (_isFieldVisible('jobType'))
            const SizedBox(height: 16),

          if (_isFieldVisible('experience'))
            _buildExperienceSection(),
          if (_isFieldVisible('experience'))
            const SizedBox(height: 16),

          if (_isFieldVisible('expectedSalary'))
            _buildSalarySection(),
          if (_isFieldVisible('expectedSalary'))
            const SizedBox(height: 16),

          if (_isFieldVisible('accommodation'))
            _buildSwitchOption(
              'Accommodation Required',
              controller.resumeaccommodationRequired,
            ),
        ],
      ),
    );
  }

Widget _buildSalarySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Salary Amount Field
      _buildTextFieldWithLabel(
        'Expected Salary*',
        controller.resumeexpectedSalaryController,
        'e.g. 50000',
        TextInputType.number,
      ),
      
      const SizedBox(height: 16),
      
      // Salary Type Dropdown (if visible)
      if (_isFieldVisible('salaryType'))
        _buildSalaryTypeDropdown(),
    ],
  );
}
  Widget _buildSalaryTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Type',
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
          height: AppDimens().input_text_width,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColor().blackColor.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.resumeselectedSalaryType.value.isEmpty 
                  ? null 
                  : controller.resumeselectedSalaryType.value,
              hint: Text(
                'Select',
                style: TextStyle(
                  color: AppColor().blackColor.withOpacity(0.5),
                ),
              ),
              isExpanded: true,
              icon: SvgPicture.asset(ImageRes().downArrowSvg),
              items: controller.salaryTypeList.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor().blackColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.resumeselectedSalaryType.value = newValue;
                }
              },
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSkillsQualificationsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills & Qualifications',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
          const SizedBox(height: 16),

          if (_isFieldVisible('qualification'))
            _buildTextFieldWithLabel(
              'Highest Qualification*',
              controller.resumequalificationController,
              'e.g. B.Tech, MBA, etc.',
              TextInputType.text,
            ),
          if (_isFieldVisible('qualification'))
            const SizedBox(height: 16),

          if (_isFieldVisible('skills'))
            _buildTagsInputField(
              'Skills*',
              controller.resumeskillsList,
              'Add skills (press enter)',
            ),
          if (_isFieldVisible('skills'))
            const SizedBox(height: 16),

          if (_isFieldVisible('languages'))
            _buildTagsInputField(
              'Languages Known*',
              controller.resumelanguagesList,
              'Add languages (press enter)',
            ),
        ],
      ),
    );
  }

  Widget _buildLocationPreferencesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Preferences',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
          const SizedBox(height: 16),

          if (_isFieldVisible('preferredCountry'))
            _buildTextFieldWithLabel(
              'Preferred Country',
              controller.resumepreferredCountryController,
              'e.g. India, USA, etc.',
              TextInputType.text,
            ),
          if (_isFieldVisible('preferredCountry'))
            const SizedBox(height: 16),

          if (_isFieldVisible('preferredState'))
            _buildTextFieldWithLabel(
              'Preferred State',
              controller.resumepreferredStateController,
              'e.g. Maharashtra, California, etc.',
              TextInputType.text,
            ),
          if (_isFieldVisible('preferredState'))
            const SizedBox(height: 16),

          if (_isFieldVisible('preferredCity'))
            _buildTextFieldWithLabel(
              'Preferred City',
              controller.resumepreferredCityController,
              'e.g. Mumbai, Pune, etc.',
              TextInputType.text,
            ),
          if (_isFieldVisible('preferredCity'))
            const SizedBox(height: 16),

          if (_isFieldVisible('anyCity'))
            _buildSwitchOption(
              'Willing to work in any city',
              controller.resumeanyCity,
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Documents',
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: AppColor().blackColor,
            ),
          ),
          const SizedBox(height: 16),

          if (_isFieldVisible('documents'))
            _buildFileUploadSection(
              'Upload Resume*',
              controller.uploadResumeList,
              'Upload Resume',
              'PDF, DOC, DOCX up to 5MB',
              Icons.description,
            ),
          if (_isFieldVisible('documents'))
            const SizedBox(height: 16),

          if (_isFieldVisible('certificates'))
            _buildFileUploadSection(
              'Certificates',
              controller.certificateList,
              'Upload Certificates',
              'PDF, JPG, PNG up to 2MB each',
              Icons.card_membership,
            ),
          if (_isFieldVisible('certificates'))
            const SizedBox(height: 16),

          if (_isFieldVisible('shortVideo'))
            _buildFileUploadSection(
              'Short Video Introduction',
              controller.resumeshortVideoList,
              'Upload Video',
              'MP4, MOV up to 10MB',
              Icons.videocam,
            ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience*',
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          // For fresher category, force Fresher selection
          if (controller.selectedCategoryType.value.toUpperCase() == 'FRESHER') {
            controller.resumeexperiencesType.value = 'Fresher';
          }
          
          return Row(
            children: [
              _buildExperienceOption("Fresher", "Fresher"),
              const SizedBox(width: 12),
              if (controller.selectedCategoryType.value.toUpperCase() != 'FRESHER')
                _buildExperienceOption("Experienced", "Experienced"),
            ],
          );
        }),
        const SizedBox(height: 12),
        Obx(() {
          if (_isFieldVisible('yearsOfExperience') && 
              controller.resumeexperiencesType.value == "Experienced") {
            return _buildTextFieldWithLabel(
              'Years of Experience*',
              controller.resumeexperiencesController,
              'e.g. 2.5',
              TextInputType.numberWithOptions(decimal: true),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildExperienceOption(String title, String value) {
    return Obx(() {
      bool isSelected = controller.resumeexperiencesType.value == value;
      bool isDisabled = controller.selectedCategoryType.value.toUpperCase() == 'FRESHER' && 
                       value == 'Experienced';
      
      return GestureDetector(
        onTap: isDisabled ? null : () => controller.resumeexperiencesType.value = value,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColor().colorPrimary : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? AppColor().colorPrimary
                  : isDisabled
                      ? AppColor().blackColor.withOpacity(0.1)
                      : AppColor().blackColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? AppColor().whiteColor
                  : isDisabled
                      ? AppColor().blackColor.withOpacity(0.3)
                      : AppColor().blackColor,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDatePickerField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, controller),
          child: Container(
            height: AppDimens().input_text_width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor().blackColor.withOpacity(0.2),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.text.isEmpty ? hint : controller.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: controller.text.isEmpty
                        ? AppColor().blackColor.withOpacity(0.5)
                        : AppColor().blackColor,
                  ),
                ),
                Icon(Icons.calendar_today, color: AppColor().colorPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsInputField(
      String label, RxList<String> tagsList, String hint) {
    final TextEditingController textController = TextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor().blackColor.withOpacity(0.2),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tagsList
                    .map((tag) => Chip(
                          label: Text(tag),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => tagsList.remove(tag),
                          backgroundColor: AppColor().colorExp.withOpacity(0.3),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    tagsList.add(value.trim());
                    textController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchOption(String label, RxBool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: "Inter",
              fontWeight: FontWeight.w500,
              color: AppColor().blackColorMore,
            ),
          ),
        ),
        Obx(() => Switch(
              value: value.value,
              activeColor: AppColor().colorPrimary,
              onChanged: (newValue) => value.value = newValue,
            )),
      ],
    );
  }

  Widget _buildFileUploadSection(
    String label,
    RxList<dynamic> fileList,
    String buttonText,
    String fileInfo,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => fileList.isNotEmpty
            ? _buildUploadedFileList(fileList, label)
            : _buildUploadPlaceholder(icon, fileInfo)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => showCustomDialog(context, controller, label),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColor().colorPrimary,
                width: 1.5,
              ),
              color: AppColor().whiteColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppColor().colorPrimary),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    color: AppColor().colorPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder(IconData icon, String info) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().colorExp.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColor().blackColor.withOpacity(0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColor().blackColor.withOpacity(0.3)),
          const SizedBox(height: 8),
          Text(
            info,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "Inter",
              fontWeight: FontWeight.w400,
              color: AppColor().blackColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedFileList(RxList<dynamic> fileList, String type) {
    return Column(
      children: fileList.map((file) {
        String fileName = '';
        if (file is FileModel) {
          fileName = file.name ?? file.path?.split('/').last ?? 'Unknown File';
        } else {
          fileName = file.toString().split('/').last;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor().colorExp.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(_getFileIcon(type), color: AppColor().colorPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    color: AppColor().blackColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => fileList.remove(file),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getFileIcon(String type) {
    if (type.contains('Resume') || type.contains('Certificate')) {
      return Icons.description;
    } else if (type.contains('Photo')) {
      return Icons.photo;
    } else if (type.contains('Video')) {
      return Icons.videocam;
    }
    return Icons.attach_file;
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Widget _buildTextFieldWithLabel(
    String label,
    TextEditingController controller,
    String hint,
    TextInputType keyboardType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: AppDimens().input_text_width,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor().blackColor.withOpacity(0.2),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: AppColor().blackColor,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              fontFamily: "Inter",
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColor().blackColor.withOpacity(0.5),
                fontSize: 14,
                fontFamily: "Inter",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownWithLabel(
    String label,
    String selectedValue,
    List<String> options,
    String type,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            if (type == 'job_subcategory') {
              if (controller.resumeselectedCategoryID.value.isEmpty) {
                Utils.showCustomTosst("Please select a job category first");
                return;
              }
              if (controller.isLoadingSubcategories.value) {
                Utils.showCustomTosst("Loading subcategories...");
                return;
              }
              if (options.isEmpty) {
                Utils.showCustomTosst(
                    "No subcategories available for this category");
                return;
              }
            }

            if (options.isNotEmpty) {
              showDropDownList(controller, options, type);
            } else {
              Utils.showCustomTosst("No options available");
            }
          },
          child: Container(
            height: AppDimens().input_text_width,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor().blackColor.withOpacity(0.2),
                width: 1.5,
              ),
              color: AppColor().whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedValue.isEmpty ? hint : selectedValue,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      color: selectedValue.isEmpty
                          ? AppColor().blackColor.withOpacity(0.5)
                          : AppColor().blackColor,
                    ),
                  ),
                ),
                if (type == 'job_subcategory')
                  Obx(() {
                    if (controller.resumeselectedCategoryID.value.isEmpty) {
                      return Icon(Icons.lock_outline,
                          size: 18, color: Colors.grey);
                    } else if (controller.isLoadingSubcategories.value) {
                      return SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor().colorPrimary,
                        ),
                      );
                    } else if (options.isEmpty) {
                      return Icon(Icons.error_outline,
                          size: 18, color: Colors.orange);
                    } else {
                      return SvgPicture.asset(ImageRes().downArrowSvg);
                    }
                  })
                else
                  SvgPicture.asset(ImageRes().downArrowSvg),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOptions(
      String label, List<String> options, RxString selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: AppColor().blackColorMore,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                bool isSelected = selectedValue.value == option;
                return GestureDetector(
                  onTap: () {
                    selectedValue.value = option;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor().colorPrimary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColor().colorPrimary
                            : AppColor().blackColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColor().whiteColor
                            : AppColor().blackColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: AppColor().whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Checkbox(
                    value: controller.confirmationChecked.value,
                    onChanged: (value) {
                      controller.confirmationChecked.value = value ?? false;
                    },
                    activeColor: AppColor().colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I confirm that all the details provided are true and accurate to the best of my knowledge.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: AppColor().blackColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!controller.confirmationChecked.value) {
                      Utils.showCustomTosst(
                          "Please confirm the details before saving");
                      return;
                    }
                    controller.saveAsDraft();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColor().colorPrimary,
                        width: 1.5,
                      ),
                      color: AppColor().whiteColor,
                    ),
                    child: Center(
                      child: Text(
                        'Save as Draft',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: AppColor().colorPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!controller.confirmationChecked.value) {
                      Utils.showCustomTosst(
                          "Please confirm the details before submitting");
                      return;
                    }
                    controller.postResumeApi();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor().colorPrimary,
                    ),
                    child: Center(
                      child: Text(
                        'Submit Resume',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: AppColor().whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDropDownList(
      ResumeController healthJobController, List data, String type) {
    BuildContext context = Get.context as BuildContext;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Select ${_getDropdownTitle(type)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              color: AppColor().blackColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                onTap: () {
                                  healthJobController.onCategorySelect(
                                      data[index], type);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColor()
                                            .blackColor
                                            .withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    data[index] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w400,
                                      color: AppColor().blackColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDropdownTitle(String type) {
    switch (type) {
      case 'job_category':
        return 'Job Category';
      case 'job_subcategory':
        return 'Job Subcategory';
      case 'gender':
        return 'Gender';
      default:
        return 'Option';
    }
  }
}

void _showClearConfirmationDialog(
    BuildContext context, ResumeController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Clear Form'),
        content: const Text(
            'Are you sure you want to clear all form fields? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColor().blackColor,
                fontFamily: "Inter",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearForm();
              Navigator.of(context).pop();
              Utils.showCustomTosst('All fields cleared successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor().colorPrimary,
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Inter",
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showCustomDialog(
    BuildContext context, ResumeController controller, String type) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;

      return Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth * 0.9,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Source',
                  style: TextStyle(
                    fontSize: AppDimens().front_medium,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().colorPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.getFromGallery(false, type);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().colorPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.getFromGallery(true, type);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().colorPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: AppColor().blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}