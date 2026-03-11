import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppDimens.dart';


import '../controller/vender_controller.dart';
import '../res/AppColor.dart';
import '../res/AppString.dart';
import '../res/ImageRes.dart';
import '../screen/daskboard/nearme_vender/VenderListingGoogleMap.dart';
import '../screen/side_menu/notifiction/my_notifiction.dart';
import '../webservices/ApiUrl.dart';

class TopBarCity extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool menuicon;
  final bool iconnotifiction;
  final bool is_supporticon;
  final bool is_whatsappicon;
   bool is_mapshow=false;
  final bool menuback;
  final bool is_wallaticon;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  TopBarCity({
    required this.title,
    required this.menuicon,
    required this.menuback,
    required this.iconnotifiction,
    required this.is_wallaticon,
    required this.is_mapshow,
    required this.is_supporticon,
    required this.is_whatsappicon,
    required this.onPressed,
    required this.onTitleTapped,
  }) : preferredSize = const Size.fromHeight(60.0);

  @override
  State<TopBarCity> createState() => _TopBarState();
}

class _TopBarState extends State<TopBarCity> with TickerProviderStateMixin {
  late final PharmacyController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PharmacyController());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 60,
        child: Container(
          color: AppColor().whiteColor,
          padding: EdgeInsets.all(5),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Row(
          children: [
            if (widget.menuback)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Image.asset(
                      ImageRes().img_back,
                      color: AppColor().colorPrimary,
                      height: 35,
                      width: 30,
                    ),
                  ),
                ),
              ),

            Container(
              child: Row(
                children: [GestureDetector(
                  onTap: () => widget.onPressed(),
                  child: Obx(
                        () => Align(
                      child: Text(
                        controller.city.value ?? '',
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
                ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Image(
                      height: 40,
                      width: 40,
                      fit: BoxFit.scaleDown,
                      image: AssetImage(ImageRes().downarrow),
                    ),
                  ),],
              ),
            )
            ]),

              // Padding(
              //   padding: EdgeInsets.all(2.0),
              //   child: Image(
              //     height: 30,
              //     width: 30,
              //     image: AssetImage(ImageRes().locationImage),
              //   ),
              // ),
              if (widget.is_mapshow)
                GestureDetector(
                  // onTap: () => Get.to(() =>  VenderListingGoogleMap()),
                  onTap: () => widget.onTitleTapped(),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: AppColor().whiteColor,
                      border: Border.all(width: 1, color: AppColor().colorPrimary),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    width: 120,
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Image(
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                        image: AssetImage(ImageRes().mapImagesView),
                      ),
                    ),
                  ),
                ),


            ],
          ),
        ),
      ),
    );
  }
}
