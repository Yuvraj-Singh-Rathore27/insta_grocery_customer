import 'dart:ui';
import 'package:flutter/material.dart';
import '../controller/vender_controller.dart';
import '../res/AppColor.dart';
import '../res/AppDimens.dart';
import '../res/AppString.dart';
import '../res/ImageRes.dart';
import 'package:get/get.dart';

import '../screen/daskboard/nearme_vender/checkout/checkout.dart';

class TopBarNew extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  bool menuicon;
  final bool iconnotifiction;
  final bool is_supporticon;
  final bool is_whatsappicon;
  final bool menuback;
  final bool is_wallaticon;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  TopBarNew(
      {required this.title,
        required this.menuicon,
        required this.menuback,
        required this.iconnotifiction,
        required this.is_wallaticon,
        required this.is_supporticon,
        required this.is_whatsappicon,
        required this.onPressed,
        required this.onTitleTapped})
      : preferredSize = const Size.fromHeight(60.0);

  @override
  State<TopBarNew> createState() =>
      _TopBarState(this.menuicon, this.menuback, this.iconnotifiction);
}

class _TopBarState extends State<TopBarNew> with TickerProviderStateMixin {
  bool menuicon = false;
  bool menuback = false;
  bool iconnotifiction = false;
  late final PharmacyController controller;

  _TopBarState(bool menuicon, bool menuback, bool iconnotifiction) {
    this.menuicon = menuicon;
    this.menuback = menuback;
    this.iconnotifiction = iconnotifiction;
  }

  bool isAnimationActive = false;

  @override
  void dispose() {
    super.dispose();
  }

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
              color: AppColor().bgAppColor,
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side (menu or back icon)
                      Row(
                        children: [
                          menuicon
                              ? GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    color: AppColor().colorPrimary,
                                    ImageRes().img_menu,
                                    height: 35,
                                    width: 30,
                                  ),
                                )),
                          )
                              : GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    ImageRes().img_back,
                                    color: AppColor().colorPrimary,
                                    height: 35,
                                    width: 30,
                                  ),
                                )),
                          ),
                        ],
                      ),

                      // Right side (notification and cart icon)
                      Row(
                        children: [
                          // Notification Icon
                          GestureDetector(
                            onTap: () {
                              // Navigate to notification page
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 5.0, 5.0, 5.0),
                              child: Image(
                                  color: AppColor().colorPrimary,
                                  height: 28,
                                  width: 28,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                      ImageRes().notification_s_c)),
                            ),
                          ),
                          // Cart Icon with Counter
                          GestureDetector(
                            onTap: () {
                              Get.to(() => CheckoutPage());

                              // Navigate to cart page
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image(

                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          ImageRes().cartIcon)),
                                ),
                                Obx(() {
                                  // Display counter dynamically
                                  int cartCount = controller.cartList.length;
                                  return cartCount > 0
                                      ? Container(
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '$cartCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                      : const SizedBox.shrink();
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
