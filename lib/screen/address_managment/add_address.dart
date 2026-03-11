import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_grocery_customer/screen/address_managment/search_location_finder_address.dart';
import 'package:insta_grocery_customer/utills/constant.dart';
import '../../controller/address_controller.dart';
import '../../res/AppColor.dart';
import 'package:get/get.dart';

import '../../res/AppDimens.dart';
import '../../res/ImageRes.dart';
import '../../toolbar/TopBar.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late double height, width;
  AddressController addressController =Get.find<AddressController>();
  @override
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
    body:SingleChildScrollView(
        child:Container(
          color: Colors.white,
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Full Name',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(
                      addressController.nameController, 'Full Name',TextInputType.text, true)),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Mobile Number',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(
                      addressController.mobileNumberController, 'Mobile Number',TextInputType.number,true)),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Flat/House No, Building ,Company, Apartment',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(
                      addressController.flatHoursAddressController, 'Flat/House No',TextInputType.text,true)),
              const SizedBox(
                height: 10,
              ),

              Text(
                'Area,Street,Sector,Village',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(
                      addressController.areaStreetController, 'Area,Street,Sector,Village',TextInputType.text,true)),
              const SizedBox(
                height: 10,
              ),

              Text(
                'LandMark',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(
                      addressController.landMarkController, 'LandMark',TextInputType.text,true)),
              const SizedBox(
                height: 10,
              ),

              Text(
                'Pincode',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: AppDimens().input_text_width,
                  child: commonTextField(
                      addressController.pincodeController, 'Pincode',TextInputType.number,true)),
              const SizedBox(
                height: 10,
              ),

              Text(
                'State',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: ()=>{
                  showDropDownList(addressController, addressController.StateSelectableList, 'state_type')
                },
                child:  Container(
                  height: AppDimens().input_text_width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: Constant.getBgEditTextBox2(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() =>   Text(
                        addressController.selectedState.value==""? 'Select State':addressController.selectedState.value,
                        style: TextStyle(
                            fontSize: AppDimens().front_regular,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            color: AppColor().blackColor),
                      ),),

                      SvgPicture.asset(ImageRes().downArrowSvg)
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                'Town/City',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: ()=>{
                  showDropDownList(addressController, addressController.citySelectableList, 'city_type')
                },
                child:  Container(
                  height: AppDimens().input_text_width,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: Constant.getBgEditTextBox2(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() =>   Text(
                        addressController.selectedCity.value==""? 'Selected':addressController.selectedCity.value,
                        style: TextStyle(
                            fontSize: AppDimens().front_regular,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            color: AppColor().blackColor),
                      ),),

                      SvgPicture.asset(ImageRes().downArrowSvg)
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Text(
                'Select your Location',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColorMore),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child:Obx(() =>   GestureDetector(
                  onTap:()=>{
                    addressController.predictions.clear(),
                    Get.to(() =>
                        SearchLocationAddressFinder(type :"pickup")),
                  },
                  child:   Container(

                      padding: EdgeInsets.all(5),
                      decoration: Constant.getBgEditTextBox2(),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 10,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          textAlign: TextAlign.start,
                          addressController.pickupLocation.value==null||  addressController.pickupLocation.value.description==null? "Select Pickup Location":
                          addressController.pickupLocation.value.description!,
                          // obscureText: false,
                          style: TextStyle(
                            color: AppColor().blackColor,
                          ),
                        ),
                      )),

                ),),),

              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: ()=>{
                   addressController.saveUserAddress()
                  },
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 58,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),

                        color: AppColor().colorExp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(

                          height: 29,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),

                              color: AppColor().colorPrimary),
                          child: Center(
                            child: Text(
                              'Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: AppDimens().front_regular,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                  color: AppColor().whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        )
    ));}

  Widget commonTextField(TextEditingController passwordController,
      String hintType, keyboardType, enable) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      decoration: Constant.getBgEditTextBox2(),
      child: TextField(
        keyboardType: keyboardType,
        enabled: enable,
        controller: passwordController,

        style: TextStyle(color: AppColor().blackColor,
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

  void showDropDownList(AddressController addressController, List data,String type) {
    BuildContext context = Get.context as BuildContext;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                minChildSize: 0.2,
                maxChildSize: 0.75,
                builder: (_, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.remove,
                          color: Colors.grey[600],
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: data.length,
                            itemBuilder: (_, index) {
                              return GestureDetector(
                                  onTap: () => {
                                    addressController.onCitySelect(
                                        data[index],type),
                                    Navigator.pop(context),
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(data[index] ??
                                          ''),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressController.getStateList();
    });
  }

}
