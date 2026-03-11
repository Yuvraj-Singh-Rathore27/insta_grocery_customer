import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/model/ProductModel.dart';
import 'package:insta_grocery_customer/utills/constant.dart';
import '../../../../controller/vender_controller.dart';
import '../../../../model/pharmacy_model.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppDimens.dart';
import '../../../../res/ImageRes.dart';
import '../../place_order/order_on_phone_call.dart';
import '../main_category/main_category.dart';

class ProductListTypeItem extends StatelessWidget {
  PharmacyController controller = Get.put(PharmacyController());
  ProductModel data;
  ProductListTypeItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor().whiteColor,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child:  Container(
          // margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColor().whiteColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      (data.logo == null || data.logo == "")
                          ? Container(
                        decoration: BoxDecoration(
                          color: AppColor().whiteColor,
                          border: Border.all(
                              width: 1, color: AppColor().whiteColor),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 70,
                        width: 70,
                        child: Image(
                          image: AssetImage(ImageRes().medicalStoreImage),
                          height: 70,
                          width: 70,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: AppColor().colorPrimary,
                          border: Border.all(
                              width: 1, color: AppColor().whiteColor),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Same radius as the container
                          child: Image.network(
                            data.logo.toString(),
                            height: 100,
                            width: 100,
                            fit: BoxFit
                                .cover, // Ensures the image covers the container properly
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name ?? '',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: AppDimens().front_larger,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: AppColor().blackColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '1 liter',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              color: AppColor().blackColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 30,
                                decoration: Constant.getBorderButtonWhite(),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: ()=>{
                                        controller.updateQuantity(data, "remove")
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor().red,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(0)),
                                            border:
                                            Border.all(color: AppColor().red)),
                                        height: 30,
                                        width: 30,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '-',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: AppDimens().front_larger,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.bold,
                                                color: AppColor().whiteColor,
                                              ),
                                            )),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColor().whiteColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(0)),
                                          border: Border.all(
                                              color: AppColor().whiteColor)),
                                      height: 30,
                                      width: 30,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          data.quntityadded.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: AppDimens().front_larger,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.bold,
                                            color: AppColor().blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()=>{
                                        controller.updateQuantity(data, "add")
                                      },
                                      child:   Container(
                                        decoration: BoxDecoration(
                                            color: AppColor().green_color,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(0)),
                                            border: Border.all(
                                                color: AppColor().green_color)),
                                        height: 30,
                                        width: 30,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '+',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: AppDimens().front_larger,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.bold,
                                                color: AppColor().blackColor,
                                              ),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                '₹ ${data.price}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: AppDimens().front_larger,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: AppColor().blackColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '₹ ${data.discount_price}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: AppDimens().front_larger,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: AppColor().blackColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
