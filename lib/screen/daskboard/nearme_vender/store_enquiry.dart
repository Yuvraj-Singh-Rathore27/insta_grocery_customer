import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/vender_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBar.dart';
import '../../../utills/constant.dart';
import '../../../webservices/ApiUrl.dart';
import 'EquirySucess.dart';

class StoreEnquiryScreen extends StatefulWidget {
  const StoreEnquiryScreen({super.key});

  @override
  State<StoreEnquiryScreen> createState() => _StoreEnquiryScreenState();
}

class _StoreEnquiryScreenState extends State<StoreEnquiryScreen> {
  PharmacyController controller = Get.put(PharmacyController());
  late double height, width;


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: AppColor().colorGrayLess2,
    appBar: TopBar(
    title: '',
    menuicon: false,
    menuback: true,
    iconnotifiction: true,
    is_wallaticon: true,
    is_supporticon: false,
    is_whatsappicon: false,
    onPressed: () => {
    },
    onTitleTapped: () => {}),
    body: SingleChildScrollView(
      child:  Padding(
        padding: EdgeInsets.all(10),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Patient Name',
                style: TextStyle(
                    fontSize: AppDimens().front_12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: AppColor().blackColor),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(controller.vehiclenameController,
                      'Patient Name', TextInputType.text)),
              SizedBox(
                height: 10,
              ),

              // Text(
              //   'Enter Name',
              //   style: TextStyle(
              //       fontSize: AppDimens().front_12,
              //       fontFamily: "Inter",
              //       fontWeight: FontWeight.w400,
              //       color: AppColor().blackColor),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //     height: AppDimens().input_text_width,
              //     child: commonTextField(controller.nameController,
              //         'Enter Name', TextInputType.text)),
              // SizedBox(
              //   height: 10,
              // ),
              //
              //
              // Text(
              //   'Enter Mobile Number',
              //   style: TextStyle(
              //       fontSize: AppDimens().front_12,
              //       fontFamily: "Inter",
              //       fontWeight: FontWeight.w400,
              //       color: AppColor().blackColor),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //     height: AppDimens().input_text_width,
              //     child: commonTextField(controller.mobileNumberController,
              //         'Enter Name', TextInputType.number)),
              //
              // const SizedBox(
              //   height: 10,
              // ),

              // Text(
              //   'Upload Image',
              //   style: TextStyle(
              //       fontSize: AppDimens().front_12,
              //       fontFamily: "Inter",
              //       fontWeight: FontWeight.w400,
              //       color: AppColor().blackColor),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              //
              // GestureDetector(
              //   onTap: () => {
              //     showCustomDialog(
              //         context, controller, "Upload Images")
              //   },
              //   child: Container(
              //     height: AppDimens().input_text_width,
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     decoration: Constant.getSelectedExperienced(),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           'Upload Image',
              //           style: TextStyle(
              //               fontSize: AppDimens().front_small,
              //               fontFamily: "Inter",
              //               fontWeight: FontWeight.w400,
              //               color: AppColor().blackColor),
              //         ),
              //         const SizedBox(
              //           width: 10,
              //         ),
              //         SvgPicture.asset(ImageRes().uploadeDoc)
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Text(
                'Description',
                style: TextStyle(
                    fontSize: AppDimens().front_12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                    color: AppColor().blackColor),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 100,
                  child: commonTextField(controller.descriptionController,
                      'Enter Deascirption', TextInputType.text)),

              const SizedBox(
                height: 30,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xffEBF4FF),
                ),
                child: GestureDetector(
                  onTap: () async => {
                  controller.createLog(controller.selectedPharmacy.value.id, ApiUrl.EVENT_ENQUIREY),
                    await controller.addIntrestedServicesByUser()
                    .then((value) => {

                      if(value){
                        showCustomSucessDialog(context),
                      }

                    })
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 25,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color(0xff145B9C),
                    ),
                    child:  Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "UltimaPro",
                            fontStyle: FontStyle.normal,
                            fontSize: AppDimens().front_larger),
                      ),
                    ),
                  ),
                ),),




            ]),
      ),
    ));
  }

  Widget commonTextField(
      TextEditingController passwordController, String hintType, keyboardType) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      decoration: Constant.getSelectedExperienced(),
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

  void showCustomDialog(BuildContext context,
      PharmacyController controller, String type) {
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
                            controller.getFromGallery(false)
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
                            controller.getFromGallery(true)
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

  void showCustomSucessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button to close
      builder: (BuildContext context) {
        return SuccessDialog(
          referenceNumber: '12344',
          onGoHome: () {
            // Navigate to the home screen
            Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
          onViewEnquiries: () {
            // Navigate to the enquiries list screen
            Navigator.of(context).pushNamed('/my-enquiries');
          },
        );
      },
    );
  }

}
