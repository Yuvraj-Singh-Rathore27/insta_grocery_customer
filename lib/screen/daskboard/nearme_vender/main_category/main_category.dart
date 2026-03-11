import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:insta_grocery_customer/toolbar/TopBarNew.dart';
import 'package:insta_grocery_customer/utills/constant.dart';

import '../../../../controller/vender_controller.dart';
import '../../../../controller/vender_controller.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/ImageRes.dart';
import '../../../../toolbar/TopBarCity.dart';
import '../items/vender_item.dart';
import '../product_listing/product_listing_sub_category.dart';

class MainCategoryListing extends StatefulWidget {
  MainCategoryListing({Key? key}) : super(key: key);

  @override
  State<MainCategoryListing> createState() => _PharmaryListingState();
}

class _PharmaryListingState extends State<MainCategoryListing> {
  PharmacyController controller = Get.put(PharmacyController());
  late double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor().bgAppColor,
        appBar: TopBarNew(
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
        body: Obx(() => controller.isLoading.value == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => controller.categoryList.isEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height - 200,
                              child: Center(
                                child: Text("No Data found."),
                              ))
                          :  Obx(() => GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: (width / height / .46), // Adjust ratio based on your design
                      children: controller.categoryList.map((item) {
                        return GestureDetector(
                          onTap: () {
                            controller.selectedCategory.value=item;
                            Get.to(() => ProductListingSubCategory());
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Stack(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(0),
                                            child:ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.network(
                                                  headers: {'Cache-Control': 'no-cache'},
                                                  item.logo.toString()+"?v=${DateTime.now().millisecondsSinceEpoch}",
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            color: Colors.black.withOpacity(0.5), // Semi-transparent background
                                            child: Text(
                                              item.name ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Helvetica",
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                    ),
                  ],
                ),
              )));
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMainCatgory();
    });
  }
}
