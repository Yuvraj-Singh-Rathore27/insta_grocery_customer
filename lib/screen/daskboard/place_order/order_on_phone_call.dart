import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/vender_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBarCity.dart';
import '../../../utills/constant.dart';
import '../../../webservices/ApiUrl.dart';
import '../nearme_vender/chages_location/search_location_finder_pharmcy.dart';

class OrderOnPhoneCall extends StatefulWidget {
  OrderOnPhoneCall({Key? key}) : super(key: key);

  @override
  State<OrderOnPhoneCall> createState() => _PharmacyDetailsState();
}

class _PharmacyDetailsState extends State<OrderOnPhoneCall> {
  late double height, width;
  PharmacyController controller = Get.find<PharmacyController>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarCity(
          title: "",
          menuicon: false,
          menuback: true,
          iconnotifiction: true,
          is_wallaticon: true,
          is_mapshow: false,
          is_supporticon: false,
          is_whatsappicon: false,
          onPressed: () => {},
          onTitleTapped: () => {}),
      body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Delivery location :',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      color: AppColor().blackColor,
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () => {
                            controller.predictions.clear(),
                            Get.to(() =>
                                SearchLocationPharmcyFinder(type: "pickup")),
                          },
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColor().grey_li,
                                    width:
                                        1, //                   <--- border width here
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          5.0) //                 <--- border radius here
                                      )),
                              height: 50,
                              width: MediaQuery.of(context).size.width - 10,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  textAlign: TextAlign.start,
                                  controller.pickupLocation.value == null ||
                                          controller.pickupLocation.value
                                                  .description ==
                                              null
                                      ? "Select Delivery location"
                                      : controller
                                          .pickupLocation.value.description!,
                                  // obscureText: false,
                                  style: TextStyle(
                                    color: AppColor().blackColor,
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: EdgeInsets.all(5),
              //   child: Align(
              //     alignment: Alignment.topLeft,
              //     child: Text(
              //       'Mobile Number:',
              //       textAlign: TextAlign.start,
              //       style: TextStyle(
              //         fontSize: AppDimens().front_medium,
              //         fontFamily: "Inter",
              //         fontWeight: FontWeight.normal,
              //         color: AppColor().blackColor,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),

              // Container(
              //   height: 45,
              //   margin: const EdgeInsets.all(10),
              //   child: TextField(
              //     keyboardType: TextInputType.phone,
              //     style: TextStyle(
              //       color: AppColor().blackColor,
              //     ),
              //     obscureText: false,
              //     controller: controller.mobileNumberCallForOrder,
              //     onChanged: (value) {
              //       controller.mobileNumberCallForOrder.text = value;
              //     },
              //     decoration: InputDecoration(
              //       labelText: "Enter Mobile Number",
              //       labelStyle: TextStyle(color: AppColor().colorPrimary),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: AppColor().colorPrimary,
              //         ),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: AppColor().colorPrimary,
              //         ),
              //       ),
              //       suffixIcon: Image(
              //         width: 20,
              //         height: 20,
              //         image: AssetImage(ImageRes().img_icon_mobile),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),

              Padding(
                padding: EdgeInsets.all(5),
                child:   Align(
                  alignment: Alignment.topLeft,
                  child:  Text(
                    'Upload  Image :',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      color: AppColor().blackColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: ()=>{
                    showCustomDialog(context,controller)
                  },
                  child:  Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                          height: 40,
                          decoration: Constant.getBgEditTextBox(),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Upload Item List',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  color: AppColor().colorPrimary),
                            ),
                          )))),

              Obx(() =>  SizedBox(
                height: 110,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.fileList.length,
                  itemBuilder: (context, index) {

                    return Align(
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child:  Image.network(controller.fileList![index].path.toString(),
                              height: 80,
                              width: 100,
                            )
                        ));
                  },
                ),
              ),),

              const SizedBox(
                height: 20,
              ),

              Padding(
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () => {
                      controller.createLog(controller.selectedPharmacy.value.id,ApiUrl.EVENT_ORDER),
                      controller.placOrderByPhone(),
                    },
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: AppColor().colorPrimary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Place Order',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.normal,
                                color: AppColor().whiteColor),
                          ),
                        )),
                  )),
            ],
          )),
    );
  }

  void showCustomDialog(BuildContext context, PharmacyController controller) {
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
                            height: 40,
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
                            height: 40,
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

  Widget commonTextField(
      TextEditingController passwordController, String hintType, keyboardType) {
    return Container(
      height: 50,
      // color: AppColor().whiteColor,
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor().colorGrayLess, width: 1),
          color: AppColor().whiteColor),
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
}
