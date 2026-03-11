import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/toolbar/TopBar.dart';
import 'package:get/get.dart';
import '../../../../controller/vender_controller.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppDimens.dart';
import '../../../../res/ImageRes.dart';
import '../VenderList.dart';

class StoreTypeSearch extends StatefulWidget {
  const StoreTypeSearch({super.key});

  @override
  State<StoreTypeSearch> createState() => _StoreTypeSearchState();
}

class _StoreTypeSearchState extends State<StoreTypeSearch> {
  PharmacyController controller = Get.put(PharmacyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor().whiteColor,
        appBar: TopBar(
            title: '',
            menuicon: false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            onPressed: () => {
                  // showcityList(controller)
                },
            onTitleTapped: () => {}),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: AppColor().blackColor,
                      ),
                      obscureText: false,
                      controller: controller.searchStoreTypeController,
                      onChanged: (value) => {
                        controller.searchKeyword.value = value,
                        if (controller.searchKeyword.value.length > 3)
                          {
                            controller.getStoreTypeCategorySearch(
                                controller.searchKeyword.value)
                          }
                        else if (controller.searchKeyword.value.length == 0)
                          {}
                      },
                      decoration: InputDecoration(
                          labelText: "Search By Name ...  ",
                          labelStyle: TextStyle(
                              color: AppColor().blackColor,
                              fontSize: AppDimens().front_regular),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor().blackColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor().colorPrimary),
                          ),
                          suffixIcon: Image(
                              width: 20,
                              height: 20,
                              image: AssetImage(ImageRes().img_icon_mobile))),
                    ),
                  ),
                  Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.storeTypeCategory.length,
                        itemBuilder: (context, index) {
                          final item = controller.storeTypeCategory[index];
                          return GestureDetector(
                            onTap: () {
                              controller.selectedVenderCategory.value = item;
                              Get.to(() => VenderListing());
                            },
                            child: Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Image.network(
                                          item.photos![0].path.toString(),
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ))),
                                Text(
                                  item.name ?? '',
                                  style: TextStyle(
                                    fontSize: AppDimens().front_medium,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Helvetica",
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ))
                  // Obx(() =>  ListView.builder(
                  //   scrollDirection: Axis.vertical,
                  //   itemCount: controller.storeTypeCategory.length,
                  //   itemBuilder: (context, index) {
                  //     final item = controller.storeTypeCategory[index];
                  //     return GestureDetector(
                  //       onTap: () {
                  //         // controller.selectedBusinessCategory.value = item;
                  //         // Get.to(() => StoreTypeScreen());
                  //       },
                  //       child: Text(
                  //         'asghdsaghgha',
                  //         style: TextStyle(
                  //           fontSize: AppDimens().front_small_small11,
                  //           fontWeight: FontWeight.bold,
                  //           fontFamily: "Helvetica",
                  //           color: Colors.black,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //         maxLines: 2,
                  //         // overflow: TextOverflow.ellipsis,
                  //       ),);
                  //   },
                  // ),
                  // )
                ],
              )),
        ));
  }
}
