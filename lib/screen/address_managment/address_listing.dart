import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/controller/address_controller.dart';
import 'package:insta_grocery_customer/screen/address_managment/add_address.dart';

import '../../res/AppColor.dart';
import '../../res/AppDimens.dart';
import '../../toolbar/TopBar.dart';
import 'item/address_list_item.dart';
import 'package:get/get.dart';

class AddressListing extends StatefulWidget {
  const AddressListing({super.key});

  @override
  State<AddressListing> createState() => _AddressListingState();
}

class _AddressListingState extends State<AddressListing> {
  AddressController addressController =Get.find<AddressController>();
  late double height, width;
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return  Scaffold(
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
        body:Container(
            margin: const EdgeInsets.all(10),
            child:Obx(() =>  ListView.builder(
              shrinkWrap: true,
              // the number of items in the list
              itemCount: addressController.addressList.length,
              // display each item of the product list
              itemBuilder: (context, index) {
                return AddressItem(data :addressController.addressList[index] );
              },
            ))
        ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColor().colorBottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
               GestureDetector(
                 onTap: ()=>{
                   Get.to(AddAddressScreen()),
                 },
                 child:  Container(
                     height: 30,
                     width: 200,
                     decoration: BoxDecoration(
                         color: AppColor().colorPrimary,
                         borderRadius:
                         const BorderRadius.all(Radius.circular(5))),
                     child: Align(
                       alignment: Alignment.center,
                       child: Text(
                         'Add New Address',
                         textAlign: TextAlign.start,
                         style: TextStyle(
                             fontSize: 16,
                             fontFamily: "Inter",
                             fontWeight: FontWeight.normal,
                             color: AppColor().whiteColor),
                       ),
                     )),
               )
              ],
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressController.getAddreessListing();
    });
  }

}
