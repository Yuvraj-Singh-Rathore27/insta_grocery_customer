import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/job_module/searchJobList.dart';
import '../../controller/job_controller.dart';
import '../../controller/resume_controller.dart';

import '../../model/job_listing_model.dart';
import '../../res/AppColor.dart';
import '../../res/AppDimens.dart';
import '../../res/ImageRes.dart';
import '../../utills/constant.dart';

class UserHealthJobSeeker extends StatefulWidget {
  const UserHealthJobSeeker({super.key});

  @override
  State<UserHealthJobSeeker> createState() => _UserHealthJobSeekerState();
}

class _UserHealthJobSeekerState extends State<UserHealthJobSeeker> {
  JobProviderController controller = Get.put(JobProviderController());
  ResumeController controller1 = Get.put(ResumeController());

  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: 255,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColor().searchFillterColor2,
                    ),
                    margin: const EdgeInsets.all(20),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => {
                                controller.selectedType.value = "1",
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: controller.selectedType.value == '1'
                                    ? Constant.getBorderSelected()
                                    : Constant.getBorderUnSelected(),
                                child: Text(
                                  'Post Resume',
                                  style: TextStyle(
                                      fontSize: AppDimens().front_regular,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.normal,
                                      color: AppColor().blackColor),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () => {
                                      controller.selectedType.value = "2",
                                    },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration:
                                      controller.selectedType.value == '2'
                                          ? Constant.getBorderSelected()
                                          : Constant.getBorderUnSelected(),
                                  child: Text(
                                    'Search Jobs',
                                    style: TextStyle(
                                        fontSize: AppDimens().front_regular,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.normal,
                                        color: AppColor().blackColor),
                                  ),
                                )),
                          ],
                        ))),
              ),
              Obx(() => controller.selectedType.value == "1"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Basic',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              SizedBox(
                                  height: AppDimens().input_text_width,
                                  child: commonTextField(
                                      controller.nameController,
                                      'Name',
                                      TextInputType.text)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Resume Heading',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                  height: AppDimens().input_text_width,
                                  child: commonTextField(
                                      controller.resumeHeadingController,
                                      'Resume Heading',
                                      TextInputType.text)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => {
                                  showDropDownList(controller,
                                      controller.genderList, 'gender')
                                },
                                child: Container(
                                  height: AppDimens().input_text_width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().whiteColor),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() => Text(
                                            controller.selectedGender.value ==
                                                    ''
                                                ? 'Selected'
                                                : controller
                                                    .selectedGender.value,
                                            style: TextStyle(
                                                fontSize:
                                                    AppDimens().front_regular,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: AppColor().blackColor),
                                          )),
                                      SvgPicture.asset(ImageRes().downArrowSvg)
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Date of Birth',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: AppDimens().input_text_width,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor().whiteColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Selected',
                                      style: TextStyle(
                                          fontSize: AppDimens().front_regular,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w400,
                                          color: AppColor().blackColor),
                                    ),
                                    SvgPicture.asset(ImageRes().downArrowSvg)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // ex

                              Text(
                                'Experience',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => {
                                        controller.experiencesType.value =
                                            "Fresher"
                                      },
                                      child: Container(
                                        height: AppDimens().input_text_width,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: controller
                                                    .experiencesType.value !=
                                                'Experienced'
                                            ? Constant.getSelectedExperienced()
                                            : Constant
                                                .getNotSelectedExperienced(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Fresher',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppDimens().front_regular,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor().blackColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () => {
                                              controller.experiencesType.value =
                                                  "Experienced"
                                            },
                                        child: Container(
                                          height: AppDimens().input_text_width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: controller
                                                      .experiencesType.value ==
                                                  'Experienced'
                                              ? Constant
                                                  .getSelectedExperienced()
                                              : Constant
                                                  .getNotSelectedExperienced(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Experienced',
                                                style: TextStyle(
                                                    fontSize: AppDimens()
                                                        .front_regular,
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        AppColor().blackColor),
                                              ),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    controller.experiencesType.value ==
                                            'Experienced'
                                        ? SizedBox(
                                            width: 100,
                                            height:
                                                AppDimens().input_text_width,
                                            child: commonTextField(
                                                controller
                                                    .experiencesController,
                                                '2.7 year',
                                                TextInputType.text))
                                        : SizedBox(
                                            width: 100,
                                          ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              // oth..

                              Text(
                                'Preferred Work Location',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => {
                                  showDropDownList(
                                      controller,
                                      controller.citySelectableList,
                                      'city_type')
                                },
                                child: Container(
                                  height: AppDimens().input_text_width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().whiteColor),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => Text(
                                          controller.selectedCity.value == ""
                                              ? 'Selected'
                                              : controller.selectedCity.value,
                                          style: TextStyle(
                                              fontSize:
                                                  AppDimens().front_regular,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w400,
                                              color: AppColor().blackColor),
                                        ),
                                      ),
                                      SvgPicture.asset(ImageRes().downArrowSvg)
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                'Job type',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => {
                                  showDropDownList(
                                      controller,
                                      controller.jobCategoryListValue,
                                      'job_type')
                                },
                                child: Container(
                                  height: AppDimens().input_text_width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().whiteColor),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => Text(
                                          controller.selectedJobType.value == ''
                                              ? 'Selected'
                                              : controller
                                                  .selectedJobType.value,
                                          style: TextStyle(
                                              fontSize:
                                                  AppDimens().front_regular,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w400,
                                              color: AppColor().blackColor),
                                        ),
                                      ),
                                      SvgPicture.asset(ImageRes().downArrowSvg)
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Subcategory type',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => {
                                  showDropDownList(
                                      controller,
                                      controller.jobSubcategoryListValue,
                                      'job_subcategory')
                                },
                                child: Container(
                                  height: AppDimens().input_text_width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColor().whiteColor),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(
                                        () => Text(
                                          controller.selecteSubdCategoryName
                                                      .value ==
                                                  ''
                                              ? 'Selected'
                                              : controller
                                                  .selecteSubdCategoryName
                                                  .value,
                                          style: TextStyle(
                                              fontSize:
                                                  AppDimens().front_regular,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w400,
                                              color: AppColor().blackColor),
                                        ),
                                      ),
                                      SvgPicture.asset(ImageRes().downArrowSvg)
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                'Expected Salary',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                  onTap: () => {
                                        showDropDownList(
                                            controller,
                                            controller.expectedSalaryList,
                                            'Expected_Salary')
                                      },
                                  child: Container(
                                    height: AppDimens().input_text_width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColor().whiteColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() => Text(
                                              controller.selectedExpectedSalary
                                                          .value ==
                                                      ""
                                                  ? 'Selected'
                                                  : controller
                                                      .selectedExpectedSalary
                                                      .value,
                                              style: TextStyle(
                                                  fontSize:
                                                      AppDimens().front_regular,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor().blackColor),
                                            )),
                                        SvgPicture.asset(
                                            ImageRes().downArrowSvg)
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              //Accommodation

                              Text(
                                'Accommodation',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                  onTap: () => {
                                        showDropDownList(
                                            controller,
                                            controller.accommodationList,
                                            'Accommodation')
                                      },
                                  child: Container(
                                    height: AppDimens().input_text_width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColor().whiteColor),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => Text(
                                            controller.selectedAccommodation
                                                        .value ==
                                                    ''
                                                ? 'Selected'
                                                : controller
                                                    .selectedAccommodation
                                                    .value,
                                            style: TextStyle(
                                                fontSize:
                                                    AppDimens().front_regular,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: AppColor().blackColor),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                            ImageRes().downArrowSvg)
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),

                              // con
                              Text(
                                'Contact Number',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),
                              SizedBox(
                                  height: AppDimens().input_text_width,
                                  child: commonTextField(
                                      controller.mobileNumberController,
                                      'Mobile Number',
                                      TextInputType.number)),
                              const SizedBox(
                                height: 10,
                              ),

                              //mail
                              Text(
                                'Mail id',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                    color: AppColor().blackColorMore),
                              ),

                              SizedBox(
                                  height: AppDimens().input_text_width,
                                  child: commonTextField(controller.emailId,
                                      'Email id', TextInputType.text)),
                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () => {
                                      showCustomDialog(context, controller,
                                          "Upload Certificates")
                                    },
                                    child: Container(
                                      height: AppDimens().input_text_width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          border: Border.all(
                                              color: AppColor().colorAccentChn,
                                              width: 1),
                                          color: AppColor().colorExp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Upload Certificates',
                                            style: TextStyle(
                                                fontSize:
                                                    AppDimens().front_small,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w400,
                                                color: AppColor().blackColor),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SvgPicture.asset(
                                              ImageRes().uploadeDoc)
                                        ],
                                      ),
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => {
                                        showCustomDialog(context, controller,
                                            "Upload Resume")
                                      },
                                      child: Container(
                                        height: AppDimens().input_text_width,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            border: Border.all(
                                                color:
                                                    AppColor().colorAccentChn,
                                                width: 1),
                                            color: AppColor().colorExp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Upload Resume',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppDimens().front_small,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor().blackColor),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SvgPicture.asset(
                                                ImageRes().uploadeDoc)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 90,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                      fontSize: AppDimens().front_regular,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w400,
                                      color: AppColor().blackColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Obx(
                              () => SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                      itemCount: controller.jobTypeList.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Container(
                                              height: AppDimens().containerBox,
                                              width: AppDimens().containerBox,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 00),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColor()
                                                          .colorBgText,
                                                      width: 1),
                                                  color:
                                                      AppColor().colorBgBorder),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                      ImageRes().doctorIcon),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    controller
                                                            .jobTypeList[index]
                                                            .name ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: AppDimens()
                                                            .front_regular,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColor()
                                                            .blackColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        );
                                      })),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(() => ListView.builder(
                                itemCount: controller.jobListing.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return searchJobList(
                                    data: controller.jobListing[index],
                                    clickUpdate: (JobListingModel data) {
                                      controller.applyJobApi(data.id!, data);

                                      // Call your function here with the necessary parameters
                                      // For example: updateFunction(controller.jobListing[index]);
                                    },
                                  );
                                }))
                          ],
                        ),
                      ),
                    ))
            ],
          ),
          Obx(
            () => controller.selectedType.value == "1"
                ? Positioned(
                    bottom: 4,
                    child: GestureDetector(
                        onTap: () => {
                              controller1.postResumeApi(),
                            },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 58,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: AppColor().colorExp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 29,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColor().colorPrimary),
                                child: Center(
                                  child: Text(
                                    'Save',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: AppDimens().front_regular,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        color: AppColor().whiteColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ),
        ],
      ),
    );
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
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: "Inter",
        ),
        obscureText: false,
        // Hide the text for password input
        decoration: InputDecoration(
          // Set individual properties if needed, but for no decoration, use an empty InputDecoration
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

  void showCustomDialog(
      BuildContext context, JobProviderController controller, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width - 20,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please select Option',
                      style: TextStyle(
                          fontSize: AppDimens().front_medium,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          color: AppColor().colorPrimary)),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () => {
                                Navigator.of(context).pop(),
                                controller.getFromGallery(false, type)
                              },
                          child: Container(
                            alignment: Alignment.center,
                            width: width - 30,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor().colorPrimary,
                                ),
                                color: AppColor().colorPrimary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Text(
                              'Gallery',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: AppColor().whiteColor),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () => {
                                Navigator.of(context).pop(),
                                controller.getFromGallery(true, type)
                              },
                          child: Container(
                            alignment: Alignment.center,
                            width: width - 30,
                            height: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor().colorPrimary,
                                ),
                                color: AppColor().colorPrimary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Text(
                              'Camera',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: AppColor().whiteColor),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
