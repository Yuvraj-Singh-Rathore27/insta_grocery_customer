import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../model/AddressModel.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';


class AddressItem extends StatelessWidget {
  final AddressModel data;
  const AddressItem({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Card(
      color: AppColor().whiteColor,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      // Define how the card's content should be clipped
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(

    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
    color: AppColor().whiteColor,
    borderRadius: const BorderRadius.all(Radius.circular(10))),
    child:   Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start  ,
          children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(
                 data.fullName??'',
                 textAlign: TextAlign.start,
                 style: TextStyle(
                     fontSize: AppDimens().front_regular,
                     fontFamily: "Inter",
                     fontWeight: FontWeight.bold,
                     color: AppColor().blackColor),
               ),
               Text(
                 data.isDefault==false?"Make as Default":"",
                 textAlign: TextAlign.start,
                 style: TextStyle(
                     fontSize: AppDimens().front_regular,
                     fontFamily: "Inter",
                     fontWeight: FontWeight.bold,
                     color: AppColor().green_color),
               ),
             ],
           ),
            Text(
              data.addressLine1??'',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: AppDimens().front_regular,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor),
            ),
            Text(
              data.addressLine2??'',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: AppDimens().front_regular,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor),
            ),
            Text(
            data.landmark??'',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: AppDimens().front_regular,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor),
            ),
            Text(
              "${data.state}, ${data.city}, India",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: AppDimens().front_regular,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor),
            ),
            Text(
              "Pincode-${data.postalCode}",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: AppDimens().front_regular,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().blackColor),
            ),
            Text(
              "View location",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: AppDimens().front_regular,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: AppColor().colorPrimary),
            ),

          ],
        ),
      ),

    ));
  }
}
