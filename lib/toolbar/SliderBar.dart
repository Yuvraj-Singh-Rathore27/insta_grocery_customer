import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insta_grocery_customer/controller/user_profile_controller.dart';

import 'package:insta_grocery_customer/screen/address_managment/address_listing.dart';
import 'package:insta_grocery_customer/screen/daskboard/store_job_module/store_job_detail.dart';import 'package:insta_grocery_customer/screen/market_place/buyer/buyer_super_category.dart';
import 'package:insta_grocery_customer/screen/side_menu/event_managment/event_managment_dashboard.dart';
import 'package:insta_grocery_customer/screen/side_menu/id_cards/idcards.dart';

import 'package:insta_grocery_customer/screen/side_menu/live_offer/offer_dashboard_screen.dart';
import 'package:insta_grocery_customer/screen/side_menu/skill_program/skill_program_super_category.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../controller/vender_controller.dart';
import '../preferences/UserPreferences.dart';
import '../res/AppColor.dart';
import '../res/AppDimens.dart';
import '../res/ImageRes.dart';
import '../screen/job_module/base_tab_helth_job.dart';
import '../screen/login/login_screen.dart';
import '../screen/side_menu/cms_page/cms_page.dart';
import '../screen/side_menu/internship_program.dart/internship_program_super_category.dart';
import '../screen/side_menu/Gig_Workers/gigWorkersHome.dart';


class SideMenuBar extends StatelessWidget {
  UserProfileController controller = Get.put(UserProfileController());
  UserPreferences? userPreferences;

  @override
  Widget build(BuildContext context) {
    userPreferences = new UserPreferences(context);
    PharmacyController pharmacycontroller = Get.put(PharmacyController());
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor().colorPrimary.withOpacity(0.2),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        color: AppColor().colorPrimary.withOpacity(0.2),
                        child: Column(
                          children: [
                            // Stack(
                            //   children: [
                            //     InkWell(
                            //       onTap: () {
                            //       },
                            //       child: CircleAvatar(
                            //         backgroundColor: AppColor().colorPrimary,
                            //         radius:
                            //             MediaQuery.of(context).size.height / 15,
                            //         child: CircleAvatar(
                            //           backgroundColor: Colors.white,
                            //           radius:
                            //               MediaQuery.of(context).size.height /
                            //                   15.5,
                            //         ),
                            //       ),
                            //     ),
                            //     Positioned(
                            //       bottom: 12.5,
                            //       right: 0,
                            //       //right: MediaQuery.of(context).size.width / 2 + 32.5,
                            //       child: GestureDetector(
                            //         onTap: () {
                            //           // Get.to(() => EditProfile());
                            //         },
                            //         child: CircleAvatar(
                            //           backgroundColor: AppColor().colorPrimary,
                            //           radius: 12.5,
                            //           child: const Icon(
                            //             Icons.edit,
                            //             size: 14,
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Obx(() => Text(
                                  controller.userData != null
                                      ? controller.userData.value.data
                                              ?.userProfile?.firstName ??
                                          ""
                                      : "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: AppDimens().front_regularX,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.bold,
                                      color: AppColor().blackColor),
                                )),
                            Obx(() => Text(
                                  controller.userData != null
                                      ? controller.userData.value.data
                                              ?.contactNumber ??
                                          ""
                                      : "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: AppDimens().front_regularX,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.normal,
                                      color: AppColor().blackColor),
                                )),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Home",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_larger,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      // ListTile(
                      //   leading: ImageIcon(
                      //     AssetImage(ImageRes().sideMenuDisplaySetting),
                      //   ),
                      //   title: Text(
                      //     "Display Settings",
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         fontSize: AppDimens().front_medium,
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: "Inter",
                      //         color: AppColor().blackColor),
                      //   ),
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      // ListTile(
                      //   leading: ImageIcon(
                      //     AssetImage(ImageRes().sideMenuMyFavorites),
                      //   ),
                      //   title: Text(
                      //     "My Favorites",
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         fontSize: AppDimens().front_medium,
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: "Inter",
                      //         color: AppColor().blackColor),
                      //   ),
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //   },
                      // ),
                      // ListTile(
                      //   leading: ImageIcon(
                      //     AssetImage(ImageRes().sideMenuMyOrder),
                      //   ),
                      //   title: Text(
                      //     "My Orders",
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         fontSize: AppDimens().front_medium,
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: "Inter",
                      //         color: AppColor().blackColor),
                      //   ),
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //
                      //   },
                      // ),

                      // ListTile(
                      //   leading: ImageIcon(
                      //     AssetImage(ImageRes().sideMenuNotifiction),
                      //   ),
                      //   title: Text(
                      //     "My Notifications",
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         fontSize: AppDimens().front_medium,
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: "Inter",
                      //         color: AppColor().blackColor),
                      //   ),
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //     Get.to(() => const NotificationPage());
                      //   },
                      // ),
                      // ListTile(
                      //   leading: ImageIcon(
                      //     AssetImage(ImageRes().sideMenuSupport),
                      //   ),
                      //   title: Text(
                      //     "My Support",
                      //     textAlign: TextAlign.start,
                      //     style: TextStyle(
                      //         fontSize: AppDimens().front_medium,
                      //         fontWeight: FontWeight.w400,
                      //         fontFamily: "Inter",
                      //         color: AppColor().blackColor),
                      //   ),
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //     Get.to(() => const MySupportsPage());
                      //   },
                      // ),

                      ListTile(
                        leading: Icon(
                          Icons.location_city,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "GIG Workers",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GigHubHomeScreen()),
                          );
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),


                      

                      ListTile(
                        leading: Icon(
                          Icons.location_city,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Address Management",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressListing()),
                          );
                        },
                      ),
                       Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),  
                      ListTile(     
                        leading: ImageIcon(
                          AssetImage(ImageRes().sideMenuDisplaySetting),
                        ),
                        title: Text(
                          "Market Place",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Get.to(() => MarketPlaceSuperCategoryScreen());
                        },
                      ),
                     
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.local_post_office,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Jobs",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Get.to(() => BaseTapHealthJob());
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.event,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Event Managment",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Get.to(() => EventManagementDashboard());
                          // Get.to(() => const MorePage());
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.local_offer,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Live  Offer",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Get.to(() => OfferDashboardScreen());
                          // Get.to(() => const MorePage());
                        },
                      ),

                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Privacy & Policy",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Get.to(() => CmsPage());
                          // Get.to(() => const MorePage());
                        },
                      ),

                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.local_post_office_outlined,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Store Jobs",
                          style: TextStyle(
                            fontSize: AppDimens().front_medium,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: AppColor().blackColor,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          // 👇 PASS JobListingModel OBJECT
                          Get.to(() => MyPostedJobDetailScreen());
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      ListTile(
                        leading: Icon(
                          Icons.local_post_office_outlined,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Internship_program",
                          style: TextStyle(
                            fontSize: AppDimens().front_medium,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: AppColor().blackColor,
                          ),
                        ),
                        onTap: () {
                          // 👇 PASS JobListingModel OBJECT
                          Get.to(() => InternshipSuperCategoryScreen());
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.local_post_office_outlined,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Skill_Program",
                          style: TextStyle(
                            fontSize: AppDimens().front_medium,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: AppColor().blackColor,
                          ),
                        ),
                        onTap: () {
                          // 👇 PASS JobListingModel OBJECT
                          Get.to(() => SkillProgramSuperCategoryScreen());
                        },
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.insert_drive_file,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "ID card",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          Get.to(() => IdCards());
                          // Get.to(() => const MorePage());
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Delete Account",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () {
                          showDeleteAccount(context);
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Switch ${pharmacycontroller.business_type.value == "b2b" ? "B2C" : "B2B"}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () {
                          pharmacycontroller.business_type.value == "b2b"
                              ? pharmacycontroller.business_type.value = "b2c"
                              : pharmacycontroller.business_type.value = "b2b";
                          pharmacycontroller.getBusinessTypecategory();
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: AppColor().blackColor,
                        ),
                        title: Text(
                          "Logout",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: AppDimens().front_medium,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter",
                              color: AppColor().blackColor),
                        ),
                        onTap: () {
                          showAlertDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 100,
                child: Center(
                  child: Container(
                    child: Text("Version-1.0.1",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                            color: AppColor().blackColor)),
                    transformAlignment: Alignment.center,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void closeDrawer(BuildContext context) {
    Navigator.pop(context);
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        /*  String token = prefs.getString("token");
        prefs.setString("token", "");*/
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        userPreferences?.removeValues();
        final store = GetStorage();
        store.erase();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
          (route) => false,
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Logout",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      ),
      content: const Text("Are you sure , you want to logout"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteAccount(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed: () async {
        controller.deleteAccount();
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        /*  String token = prefs.getString("token");
        prefs.setString("token", "");*/
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('token');
        await preferences.remove('user_id');
        await preferences.clear();
        userPreferences?.removeValues();
        final store = GetStorage();
        store.erase();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
          (route) => false,
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Delete Account",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
      ),
      content: const Text("Are you sure , you want to Delete Account"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
