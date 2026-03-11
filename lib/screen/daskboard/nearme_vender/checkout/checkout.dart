import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/toolbar/TopBarNew.dart';
import 'package:insta_grocery_customer/utills/constant.dart';

import '../../../../controller/vender_controller.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppDimens.dart';
import '../chages_location/search_location_finder_pharmcy.dart';
import '../items/catgory_product.dart';
import '../items/product_list_type_item.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _PharmacyListingState();
}

class _PharmacyListingState extends State<CheckoutPage> {
  final PharmacyController controller = Get.put(PharmacyController());
  late double height, width;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

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
        onPressed: () {},
        onTitleTapped: () {},
      ), 
      body:Column(
          children: [
            Obx(
              () => controller.cartList.isEmpty
                  ? Container(
                      height: MediaQuery.of(context).size.height-300,
                      child: Center(
                        child: Text("Your cart Empty", style: TextStyle(
                          fontSize: AppDimens().front_larger,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          color: AppColor().blackColor,
                        ),),
                      ))
                  : Container(
                height: MediaQuery.of(context).size.height-450,
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics:
                  // NeverScrollableScrollPhysics(), // Prevent scrolling inside SingleChildScrollView
                  itemCount: controller.cartList.length,
                  // itemCount: 10,
                  itemBuilder: (context, index) {
                    return ProductListTypeItem(
                        data: controller.cartList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      bottomNavigationBar:Obx(() =>controller.cartList.isEmpty? Text(""): SizedBox(
        height: 300,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              margin: EdgeInsets.fromLTRB(10,5,20,5),
              child: Text(
                'Choose Delivery Location',
                style: TextStyle(
                  fontSize: AppDimens().front_medium,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().grey_Li,
                ),
              ),
            ),

           Align(
             child:  Padding(
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
                                 color: AppColor().whiteColor,
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
           ),

            Container(
              margin: EdgeInsets.fromLTRB(20,10,20,10),
              child:    Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().grey_Li,
                    ),
                  ),
                  Text(
                    '₹ ${controller.getTotalAmount()}',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().grey_Li,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20,5,20,5),
              child:    Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Fee',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().grey_Li,
                    ),
                  ),
                  Text(
                    '₹ 0',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().grey_Li,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20,5,20,5),
              child:    Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated Total',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColor,
                    ),
                  ),
                  Text(
                    '₹ ${controller.getTotalAmount()}',
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().blackColor,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: ()=>{
                controller.pharmacyOrderCreateWithAddProduct()
              },
              child:  Container(
                margin: EdgeInsets.all(20),
                height: 50,
                decoration: BoxDecoration(
                    color: AppColor().colorPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: AppColor().colorPrimary)),
                alignment: Alignment.center,
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    fontSize: AppDimens().front_larger,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().whiteColor,
                  ),
                ),
              ),
            )

          ],
        ),
      )),

    );
  }
}
