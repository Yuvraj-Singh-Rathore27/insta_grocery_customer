import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';

import '../../../model/CategoryItem.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBar.dart';
import 'buyer_subcategory_product.dart';

class BuyerAllCategoryList extends StatelessWidget {
  final List<CategoryItem> categories = [
    CategoryItem(name: "Electronics", imagePath: "assets/electronics.png"),
    CategoryItem(name: "Mobiles", imagePath: "assets/mobiles.png"),
    CategoryItem(name: "Furniture", imagePath: "assets/furniture.png"),
    CategoryItem(name: "Vehicles", imagePath: "assets/vehicles.png"),
    CategoryItem(name: "Fashion", imagePath: "assets/fashion.png"),
    CategoryItem(name: "Appliances", imagePath: "assets/appliances.png"),
    CategoryItem(name: "Properties", imagePath: "assets/properties.png"),
    CategoryItem(name: "Sports", imagePath: "assets/sports.png"),
    CategoryItem(name: "Hobbies", imagePath: "assets/hobbies.png"),
    CategoryItem(name: "Fashion", imagePath: "assets/fashion2.png"),
    CategoryItem(name: "Beauty", imagePath: "assets/beauty.png"),
    CategoryItem(name: "Books", imagePath: "assets/books.png"),
  ];

  @override
  Widget build(BuildContext context) {
    BuyerController buyerController = Get.find<BuyerController>();
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBar(
            title: '',
            menuicon: false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            onPressed: () => {},
            onTitleTapped: () => {}),
        body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        child: Text("Market Place All Category",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,)),
                      )),

                  Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: AppColor().blackColor,
                      ),
                      obscureText: false,
                      controller: buyerController.searchController,
                      onChanged: (value) => {

                      },
                      decoration: InputDecoration(
                          enabled: true,
                          labelText: "Search By Name ...  ",
                          labelStyle: TextStyle(
                              color: AppColor().blackColor,
                              fontSize: AppDimens().front_regular),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor().blackColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor().blackColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: AppColor().colorPrimary),
                          ),
                          suffixIcon: Image(
                              width: 20,
                              height: 20,
                              color: AppColor().blackColor,
                              image: AssetImage(ImageRes().surgery_search))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColor().whiteColor),
                    child: Column(
                      children: [

                    Obx(() =>   GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // if inside a scroll view
                      padding: const EdgeInsets.all(10),
                      itemCount: buyerController.categoryList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {

                        return GestureDetector(
                          onTap: () {
                            // controller.selectedBusinessCategory.value = item;
                            Get.to(() => BuyerSubcategoryProduct());
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(12)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            20), // adjust the radius as needed
                                        child: Image.network(
                                          buyerController.categoryList[index].photos![0].path.toString(),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                      ))),

                              const SizedBox(height: 6),
                              Text(
                                buyerController.categoryList[index].name.toString(),
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}