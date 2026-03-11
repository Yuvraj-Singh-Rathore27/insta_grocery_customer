import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/job_module/LocationPickerScreen.dart';
import '../../controller/job_controller.dart';
import '../../res/AppColor.dart';
import '../../res/AppDimens.dart';
import '../../res/ImageRes.dart';
import '../../utills/constant.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  late JobProviderController controller;
  late double height, width;

  double getFormCompletion() {
    int totalFields = 12; // change if needed
    int filled = 0;

    if (controller.nameController.text.isNotEmpty) filled++;
    if (controller.resumeHeadingController.text.isNotEmpty) filled++;
    if (controller.selectedMainCategoryType.value.isNotEmpty) filled++;
    if (controller.selectedJobCategory.value.isNotEmpty) filled++;
    if (controller.selectedJobSubCategory.value.isNotEmpty) filled++;
    if (controller.selectedJobType.value.isNotEmpty) filled++;
    if (controller.selectedCity.value.isNotEmpty) filled++;
    if (controller.selectedMinimumExperience.value.isNotEmpty) filled++;
    if (controller.selectedExpectedSalary.value.isNotEmpty) filled++;
    if (controller.mobileNumberController.text.isNotEmpty) filled++;
    if (controller.emailId.text.isNotEmpty) filled++;
    if (controller.selectedGender.value.isNotEmpty) filled++;

    return filled / totalFields;
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(JobProviderController());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Job'),
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Obx(() {
                double progress = getFormCompletion();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile Completion ${(progress * 100).toInt()}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColor().colorPrimary,
                    ),
                  ],
                );
              }),
            ),
            Container(
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
                    'Job Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Posted by*',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: AppDimens().input_text_width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColor().blackColor.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: commonTextField(
                            controller.nameController,
                            "Name",
                            TextInputType.text,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),

            // Employment Type Section
            Container(
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
                    'Job Essential',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Job Heading',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: AppDimens().input_text_width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor().blackColor.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: commonTextField(
                      controller.resumeHeadingController,
                      'Job Heading',
                      TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Select Job Type",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // _buildMainTypeChip("CAREER", "🎓"),

                        // const SizedBox(width: 10),
                        _buildMainTypeChip("DOMESTIC", "🏠"),
                        // const SizedBox(width: 10),
                        //  _buildMainTypeChip("FRESHER", "🏠"),
                        // const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Job Category*',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: AppDimens().input_text_width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor().blackColor.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedMainCategoryType.value.isEmpty) {
                          Get.snackbar(
                            "Warning",
                            "Please select Job Type first",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade600,
                            colorText: Colors.white,
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.all(12),
                            borderRadius: 10,
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        showDropDownList(
                          controller,
                          controller.jobCategoryListValue,
                          'job_category',
                        );
                      },
                      child: Container(
                        height: AppDimens().input_text_width,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor().whiteColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  controller.selectedJobCategory.value == ''
                                      ? 'Select Category'
                                      : controller.selectedJobCategory.value,
                                  style: TextStyle(
                                    fontSize: AppDimens().front_regular,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColor,
                                  ),
                                )),
                            SvgPicture.asset(ImageRes().downArrowSvg),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Job Subcategory*',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: AppDimens().input_text_width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor().blackColor.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedMainCategoryType.value.isEmpty) {
                          Get.snackbar(
                            "Warning",
                            "Please select Job Type first",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red.shade600,
                            colorText: Colors.white,
                            icon: const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.all(12),
                            borderRadius: 10,
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        if (controller.selectedJobCategory.value.isEmpty) {
                          Get.snackbar(
                            "Warning",
                            "Please select Category first",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red.shade600,
                            colorText: Colors.white,
                            icon: const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                            margin: const EdgeInsets.all(12),
                            borderRadius: 10,
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        showDropDownList(
                          controller,
                          controller.jobSubcategoryListValue,
                          'job_subcategory',
                        );
                      },
                      child: Container(
                        height: AppDimens().input_text_width,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor().whiteColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Text(
                                  controller.selectedJobSubCategory.value == ''
                                      ? 'Select Subcategory'
                                      : controller.selectedJobSubCategory.value,
                                  style: TextStyle(
                                    fontSize: AppDimens().front_regular,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColor,
                                  ),
                                )),
                            SvgPicture.asset(ImageRes().downArrowSvg),
                          ],
                        ),
                      ),
                    ),
                  ),
                   const SizedBox(height: 16),
                  Text(
                    'Employment Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      color: AppColor().blackColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Job Type*',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  controller.jobTypeListValue.map((jobType) {
                                bool isSelected =
                                    controller.selectedJobType.value == jobType;
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedJobType.value = jobType;
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width -
                                            80) /
                                        2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColor().colorPrimary
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColor().colorPrimary
                                            : AppColor()
                                                .blackColor
                                                .withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 6),
                                        Text(
                                          jobType,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? AppColor().whiteColor
                                                : AppColor().blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 10),
                      Text(
                    'Minimum Experience Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => {
                      showDropDownList(
                        controller,
                        controller.minimumExperienceList,
                        'minimum_experience',
                      )
                    },
                    child: Container(
                      height: AppDimens().input_text_width,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColor().whiteColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor().blackColor.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                                controller.selectedMinimumExperience.value == ""
                                    ? 'Select Minimum Experience'
                                    : '${controller.selectedMinimumExperience.value} years',
                                style: TextStyle(
                                  fontSize: AppDimens().front_regular,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  color: AppColor().blackColor,
                                ),
                              )),
                          SvgPicture.asset(ImageRes().downArrowSvg),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Maximum Experience Range',
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
                      showDropDownList(controller, controller.maxExperienceList,
                          'max_experience');
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
                          Obx(
                            () => Text(
                              controller.selectedMaxExperience.value == ""
                                  ? 'Select Maximum Experience'
                                  : '${controller.selectedMaxExperience.value} years',
                              style: TextStyle(
                                fontSize: AppDimens().front_regular,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                color: AppColor().blackColor,
                              ),
                            ),
                          ),
                          SvgPicture.asset(ImageRes().downArrowSvg),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
Row(
  children: [

    /// Salary From
    Expanded(
      child: TextFormField(
        controller: controller.salaryFromController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Min Salary",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),

    const SizedBox(width: 12),

    /// Salary To
    Expanded(
      child: TextFormField(
        controller: controller.salaryToController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Max Salary",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  ],
),
const SizedBox(height: 20,),
Obx(() {
  return DropdownButtonFormField<String>(
    value: controller.selectedSalaryType.value,
    decoration: InputDecoration(
      labelText: "Salary Type",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    items: controller.salaryTypeList.map((type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Text(type),
      );
    }).toList(),
    onChanged: (value) {
      if (value != null) {
        controller.selectedSalaryType.value = value;
      }
    },
  );
}),

                ],
              ),
            ),

            // Job Location & Experience Section
   Container(
  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "Location",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 16),

      GestureDetector(
        onTap: () async {

          final result = await Get.to(() => MapLocationPickerScreen(
            latitude: controller.latitude.value,
            longitude: controller.longitude.value,
          ));

          if (result != null) {

            controller.cityNameController.text = result['city'] ?? "";
            controller.stateNameController.text = result['state'] ?? "";
            controller.countryController.text = result['country'] ?? "";

            controller.latitude.value = result['latitude'] ?? 0.0;
            controller.longitude.value = result['longitude'] ?? 0.0;

            setState(() {});
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [

              Expanded(
                child: Text(
                  controller.cityNameController.text.isEmpty
                      ? "Select Location on Map"
                      : "${controller.cityNameController.text}, ${controller.stateNameController.text}",
                  style: TextStyle(
                    fontSize: 14,
                    color: controller.cityNameController.text.isEmpty
                        ? Colors.grey
                        : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const Icon(Icons.location_on, color: Colors.red),

            ],
          ),
        ),
      ),

    ],
  ),
),
            // // Additional Requirements Section
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: AppColor().whiteColor,
            //     borderRadius: BorderRadius.circular(12),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 8,
            //         offset: const Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(height: 10),

            //       Text(
            //         'Additional Requirements',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontFamily: "Inter",
            //           fontWeight: FontWeight.w600,
            //           color: AppColor().blackColor,
            //         ),
            //       ),

            //       const SizedBox(height: 16),

            //       // Maximum Experience Range
            //       Text(
            //         'Languages',
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontFamily: "Inter",
            //           fontWeight: FontWeight.bold,
            //           color: AppColor().blackColorMore,
            //         ),
            //       ),
            //       const SizedBox(height: 5),
            //       Container(
            //         height: AppDimens().input_text_width,
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: AppColor().blackColor.withOpacity(0.3),
            //             width: 2,
            //           ),
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         child: commonTextField(controller.languageController,
            //             'Language', TextInputType.text),
            //       ),
            //       const SizedBox(
            //         height: 20,
            //       ),
            //       // Minimum Experience Range
                  

            //       const SizedBox(height: 16),

            //       // Salary Range
            //       Text(
            //         'Salary Range',
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontFamily: "Inter",
            //           fontWeight: FontWeight.w500,
            //           color: AppColor().blackColorMore,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       GestureDetector(
            //         onTap: () {
            //           showDropDownList(controller,
            //               controller.expectedSalaryList, 'Expected_Salary');
            //         },
            //         child: Container(
            //           height: AppDimens().input_text_width,
            //           padding: const EdgeInsets.symmetric(horizontal: 12),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(
            //               color: AppColor().blackColor.withOpacity(0.2),
            //               width: 1.5,
            //             ),
            //             color: AppColor().whiteColor,
            //           ),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Obx(
            //                 () => Text(
            //                   controller.selectedExpectedSalary.value == ""
            //                       ? 'Select Salary Range'
            //                       : controller.selectedExpectedSalary.value,
            //                   style: TextStyle(
            //                     fontSize: AppDimens().front_regular,
            //                     fontFamily: "Inter",
            //                     fontWeight: FontWeight.w400,
            //                     color: AppColor().blackColor,
            //                   ),
            //                 ),
            //               ),
            //               SvgPicture.asset(ImageRes().downArrowSvg),
            //             ],
            //           ),
            //         ),
            //       ),

            //       const SizedBox(height: 16),

            //       // Experience Type (Fresher / Experienced)
            //       Text(
            //         'Experience',
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontFamily: "Inter",
            //           fontWeight: FontWeight.w500,
            //           color: AppColor().blackColorMore,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Obx(
            //         () => Row(
            //           children: [
            //             GestureDetector(
            //               onTap: () {
            //                 controller.experiencesType.value = "Fresher";
            //               },
            //               child: Container(
            //                 height: AppDimens().input_text_width,
            //                 padding: const EdgeInsets.symmetric(horizontal: 20),
            //                 decoration: controller.experiencesType.value !=
            //                         'Experienced'
            //                     ? Constant.getSelectedExperienced()
            //                     : Constant.getNotSelectedExperienced(),
            //                 child: Row(
            //                   children: [
            //                     Text(
            //                       'Fresher',
            //                       style: TextStyle(
            //                         fontSize: AppDimens().front_regular,
            //                         fontFamily: "Inter",
            //                         fontWeight: FontWeight.w400,
            //                         color: AppColor().blackColor,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(width: 10),
            //             GestureDetector(
            //               onTap: () {
            //                 controller.experiencesType.value = "Experienced";
            //               },
            //               child: Container(
            //                 height: AppDimens().input_text_width,
            //                 padding: const EdgeInsets.symmetric(horizontal: 20),
            //                 decoration: controller.experiencesType.value ==
            //                         'Experienced'
            //                     ? Constant.getSelectedExperienced()
            //                     : Constant.getNotSelectedExperienced(),
            //                 child: Row(
            //                   children: [
            //                     Text(
            //                       'Experienced',
            //                       style: TextStyle(
            //                         fontSize: AppDimens().front_regular,
            //                         fontFamily: "Inter",
            //                         fontWeight: FontWeight.w400,
            //                         color: AppColor().blackColor,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(width: 10),
            //             controller.experiencesType.value == 'Experienced'
            //                 ? Container(
            //                     width: 100,
            //                     height: AppDimens().input_text_width,
            //                     decoration: BoxDecoration(
            //                       border: Border.all(
            //                         color:
            //                             AppColor().blackColor.withOpacity(0.2),
            //                         width: 1.5,
            //                       ),
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                     child: commonTextField(
            //                       controller.experiencesController,
            //                       '2.7 year',
            //                       TextInputType.text,
            //                     ),
            //                   )
            //                 : const SizedBox(width: 100),
            //           ],
            //         ),
            //       ),

            //       const SizedBox(height: 16),

            //     ],
            //   ),
            // ),



            Container(
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
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 📞 Contact Number
                  Text(
                    'Contact Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: AppDimens().input_text_width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor().blackColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: commonTextField(
                      controller.mobileNumberController,
                      'Mobile Number',
                      TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 📧 Mail ID
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: AppDimens().input_text_width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColor().blackColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: commonTextField(
                      controller.emailId,
                      'Enter Your Email',
                      TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Accommodation
                  // Text(
                  //   'Accommodation',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontFamily: "Inter",
                  //     fontWeight: FontWeight.w500,
                  //     color: AppColor().blackColorMore,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // GestureDetector(
                  //   onTap: () {
                  //     showDropDownList(controller, controller.accommodationList,
                  //         'Accommodation');
                  //   },
                  //   child: Container(
                  //     height: AppDimens().input_text_width,
                  //     padding: const EdgeInsets.symmetric(horizontal: 12),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       border: Border.all(
                  //         color: AppColor().blackColor.withOpacity(0.2),
                  //         width: 1.5,
                  //       ),
                  //       color: AppColor().whiteColor,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Obx(
                  //           () => Text(
                  //             controller.selectedAccommodation.value == ''
                  //                 ? 'Select Accommodation'
                  //                 : controller.selectedAccommodation.value,
                  //             style: TextStyle(
                  //               fontSize: AppDimens().front_regular,
                  //               fontFamily: "Inter",
                  //               fontWeight: FontWeight.w400,
                  //               color: AppColor().blackColor,
                  //             ),
                  //           ),
                  //         ),
                  //         SvgPicture.asset(ImageRes().downArrowSvg),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // ⚧ Gender Dropdown
                  // Text(
                  //   'Gender',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontFamily: "Inter",
                  //     fontWeight: FontWeight.w500,
                  //     color: AppColor().blackColorMore,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // GestureDetector(
                  //   onTap: () {
                  //     showDropDownList(
                  //         controller, controller.genderList, 'gender');
                  //   },
                  //   child: Container(
                  //     height: AppDimens().input_text_width,
                  //     padding: const EdgeInsets.symmetric(horizontal: 12),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       border: Border.all(
                  //         color: AppColor().blackColor.withOpacity(0.2),
                  //         width: 1.5,
                  //       ),
                  //       color: AppColor().whiteColor,
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Obx(
                  //           () => Text(
                  //             controller.selectedGender.value == ""
                  //                 ? 'Select Gender'
                  //                 : controller.selectedGender.value,
                  //             style: TextStyle(
                  //               fontSize: AppDimens().front_regular,
                  //               fontFamily: "Inter",
                  //               fontWeight: FontWeight.w400,
                  //               color: AppColor().blackColor,
                  //             ),
                  //           ),
                  //         ),
                  //         SvgPicture.asset(ImageRes().downArrowSvg),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Company Logo/Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Obx(() {
                    if (controller.images.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          controller.images.first,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (controller.uploadResumeList.isNotEmpty) {
                      final imageUrl =
                          controller.uploadResumeList.first.path ?? "";

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      );
                    }

                    return Icon(
                      Icons.cloud_upload,
                      size: 48,
                      color: AppColor().colorPrimary,
                    );
                  }),
                  const SizedBox(height: 12),

                  /// Title

                  /// Subtitle
                  Text(
                    'Upload Company Logo or Job Image\nJPG, PNG up to 2MB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      color: AppColor().blackColorMore,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Upload Button
                  GestureDetector(
                    onTap: () => {
                      showCustomDialog(context, controller, "Upload Resume")
                    },
                    child: Container(
                      height: AppDimens().input_text_width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: AppColor().colorAccentChn,
                          width: 1.5,
                        ),
                        color: AppColor().colorExp,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,

                            color: AppColor()
                                .blackColor, // Use your red brand color
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Choose File',
                            style: TextStyle(
                              fontSize: AppDimens().front_regular,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              color: AppColor().blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contact Information Section
            
            const SizedBox(height: 20),
            previewSection(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: AppColor().colorExp,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {
                controller.postJobByProviderApi(),
              },
              child: Container(
                height: 50,
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColor().colorPrimary,
                ),
                child: Center(
                  child: Text(
                    'Post Job',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      color: AppColor().whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget previewSection() {
    return Obx(() {
      List<Widget> previewItems = [];

      /// ------------------ IMAGE PREVIEW ------------------
      Widget imagePreview = const SizedBox();

      if (controller.images.isNotEmpty) {
        imagePreview = Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              controller.images.first,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (controller.uploadResumeList.isNotEmpty) {
       final imageUrl = controller.uploadResumeList.first.path ?? "";

        if (imageUrl.isNotEmpty) {
          imagePreview = Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
            ),
          );
        }
      }

      /// ------------------ FIELD BUILDER ------------------
      void addPreviewItem(String label, String value, IconData icon) {
        if (value.trim().isNotEmpty) {
          previewItems.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: AppColor().colorPrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "$label: ",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: value,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }

      /// ------------------ ADD FILLED FIELDS ------------------
      addPreviewItem("Posted By", controller.nameController.text, Icons.person);
      addPreviewItem(
          "Job Heading", controller.resumeHeadingController.text, Icons.work);
      addPreviewItem(
          "Category", controller.selectedJobCategory.value, Icons.category);
      addPreviewItem(
          "Subcategory", controller.selectedJobSubCategory.value, Icons.list);
      addPreviewItem("Job Type", controller.selectedJobType.value, Icons.badge);
      addPreviewItem(
          "Location", controller.selectedCity.value, Icons.location_on);
      addPreviewItem("Salary", controller.selectedExpectedSalary.value,
          Icons.currency_rupee);
      addPreviewItem("Experience", controller.selectedMinimumExperience.value,
          Icons.timeline);
      addPreviewItem(
          "Language", controller.languageController.text, Icons.language);
      addPreviewItem(
          "Mobile", controller.mobileNumberController.text, Icons.phone);
      addPreviewItem("Email", controller.emailId.text, Icons.email);
      addPreviewItem(
          "Gender", controller.selectedGender.value, Icons.person_outline);

      /// Hide preview completely if nothing filled
      if (previewItems.isEmpty &&
          controller.images.isEmpty &&
          controller.uploadResumeList.isEmpty) {
        return const SizedBox();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Row(
              children: [
                Icon(Icons.preview, color: AppColor().colorPrimary),
                const SizedBox(width: 8),
                const Text(
                  "Live Job Preview",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Image
            imagePreview,

            /// Fields
            ...previewItems,
          ],
        ),
      );
    });
  }

  Widget _buildMainTypeChip(String type, String emoji) {
    return Obx(() {
      final isSelected = controller.selectedMainCategoryType.value == type;

      return GestureDetector(
        onTap: () async {
          controller.selectedMainCategoryType.value = type;

          // 🔥 RESET CATEGORY + SUBCATEGORY
          controller.selectedJobCategory.value = "";
          controller.selectedJobSubCategory.value = "";
          controller.selectedCategoryID.value = "";
          controller.selecteSubdCategoryId.value = "";

          // 🔥 FETCH CATEGORY ACCORDING TO TYPE
          await controller.getJobTypeList(type);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColor().colorPrimary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text(emoji),
              const SizedBox(width: 6),
              Text(
                type.capitalizeFirst!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget commonTextField(
      TextEditingController passwordController, String hintType, keyboardType) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: AppColor().whiteColor),
      child: TextField(
        keyboardType: keyboardType,
        controller: passwordController,
        style: TextStyle(
          color: AppColor().blackColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          fontFamily: "Inter",
        ),
        obscureText: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintType,
        ),
      ),
    );
  }

  void showDropDownList(
      JobProviderController healthJobController, List data, String type) {
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
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                  onTap: () => {
                                        healthJobController.onCitySelect(
                                            data[index], type),
                                        Navigator.pop(context),
                                      },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(data[index] ?? ''),
                                    ),
                                  ));
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
}

Widget _addressField(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

void showCustomDialog(
    BuildContext context, JobProviderController controller, String type) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;

      return Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth * 0.9, // 90% of screen width
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
                  'Please select Option',
                  style: TextStyle(
                    fontSize: AppDimens().front_medium,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().colorPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Gallery Option
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
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        color: AppColor().whiteColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Camera Option
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
                    child: Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        color: AppColor().whiteColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Cancel Option
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
