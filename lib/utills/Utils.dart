import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:insta_grocery_customer/res/AppDimens.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/AppColor.dart';
import '../res/AppString.dart';
import '../res/ImageRes.dart';
import '../screen/common/Progessbar.dart';
import '../webservices/ApiUrl.dart';


class Utils {
  static ProgessDialog? progessbar;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var permission;
  var addressLine1 = "".obs;
  var addressLine2 = "".obs;
  static var permissionAlow = false;
  static var language = "en".obs;
  static var language_country = "US".obs;
  static var stateV = "".obs;
  static var city = "".obs;
  static var country = "".obs;
  static var permission_deniedCount = 0.obs;
  static var permission_denied = false.obs;

  static showCustomTosst(String messgae) {
    // Fluttertoast.showToast(
    //     msg: messgae,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 2,
    //     backgroundColor: AppColor().blackColor,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    Get.context as BuildContext;
    showSnackBar(Get.context as BuildContext,messgae,false);
  }

  int daysBetween(DateTime today_pref, DateTime tomm_cale) {
    today_pref = DateTime(today_pref.year, today_pref.month, today_pref.day);
    tomm_cale = DateTime(tomm_cale.year, tomm_cale.month, tomm_cale.day);
    return (today_pref.difference(tomm_cale).inDays);
  }

  showErrorMessage(String title, String message) {
    Get.snackbar(
      "",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      borderRadius: 1,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.linear,
    );
  }

  getCurrentdateString() {
    final now = DateTime.now().toUtc();
    String dateS = now.toIso8601String().toString();
    return dateS;
  }

  funShare(String ref_code) async {
    try {
      await Share.share(
          "Bro Mere link se GMNG app download kar https://gmng.onelink.me/GRb6/refer Hum dono ko 10-10 rs cash milengy or fir dono sath me khelenge. Mera refer code dalna mat bhulna. code - ${ref_code}");
    } catch (e) {
      return null;
    }
  }

  shareTelegram(String ref_code) async {
    try {
      //SocialShare.shareTelegram(ref_code);
    } catch (e) {
      return null;
    }
  }

  launchCaller(var number) async {
    var  url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  // Future<void> launchCallerApp(String number) async {
  //   final Uri url = Uri.parse("tel:$number");
  //
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  Future<void> launchCallerApp(String phoneNumber) async {
    String number = "0$phoneNumber";;
    final Uri uri = Uri.parse('tel:$number');

    print('Attempting to launch: $uri');
    bool canLaunch = await canLaunchUrl(uri);
    print('Can launch: $canLaunch');

    if (canLaunch) {
      bool launched = await launchUrl(uri);
      print('Launched: $launched');
    } else {
      print('Could not launch: $uri');
      throw 'Could not launch $uri';
    }
  }

/*  launchInstagram() async {
    const nativeUrl = "instagram://user?username=severinas_app";
    const webUrl = "https://www.instagram.com/severinas_app/";
    if (await canLaunch(nativeUrl)) {
      await launch(nativeUrl);
    } else if (await canLaunch(webUrl)) {
      await launch(webUrl);
    } else {
    Utils().customPrint("can't open Instagram");
    }
  }*/
  shareInstagram(String ref_code) async {
    try {
     // SocialShare.shareInstagramStory(ref_code, appId: 'asads');
    } catch (e) {
      // Fluttertoast.showToast(msg: "not  installed");
      return null;
    }
  }

  funClan(String ref_code) async {
    try {
      await Share.share(ref_code);
    } catch (e) {
      return null;
    }
  }

  static showCustomTosstError(String messgae) {
    // Fluttertoast.showToast(
    //     msg: messgae,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 2,
    //     backgroundColor: AppColor().colorPrimary,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    Get.context as BuildContext;
    showSnackBar(Get.context as BuildContext,messgae,true);
  }
  static showSnackBar(BuildContext context,String messgae,bool error) {
    final snackBar = SnackBar(
      content: Text('${messgae}' ,
        style: TextStyle(
          color: AppColor().blackColor,
          fontSize: AppDimens().front_medium
    ),),
      backgroundColor:error?AppColor().whiteColor:AppColor().whiteColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      margin: EdgeInsets.all(50),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showProgessBar(BuildContext buildContext) {
    if (progessbar == null) {
      progessbar = new ProgessDialog(buildContext);
    }

    progessbar?.setMessage("please wait ..");
    progessbar?.show(buildContext);
  }

  static hideProgessBar() {
    if (progessbar == null) return;
    progessbar?.hide();
  }

  String genrateBasicAuth(String username, String password) {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return basicAuth;
  }

  static launchURLApp(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showDialogCustom(String title, String message) {
    Get.defaultDialog(
        title: "Welcome to Flutter Dev'S",
        middleText:
            "FlutterDevs is a protruding flutter app development company with "
            "an extensive in-house team of 30+ seasoned professionals who know "
            "exactly what you need to strengthen your business across various dimensions",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        middleTextStyle: TextStyle(color: Colors.black),
        radius: 30);
  }

  String getStartTimeHHMMSS(String time) {
    return DateFormat(
            "yyyy-MM-dd'T'HH:mm:ss") //here we can change format as we want
        .format(DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(time, true).toLocal());
  }


  String getBasicAuth(String username, String password) {
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    Utils().customPrint("Authrization =>>> ${basicAuth}");
    return basicAuth;
  }

  String genrateRendomNumber() {
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    return randomNumber.toString();
  }

  //custom loader
  static Future<void> alertForLocationRestriction(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'IMPORTANT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Wrap(
                children: [
                  Text(
                    'Sorry, If your current residence is from ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                  Text(
                    //' Assam, Odisha, Andhra Pradesh, Telangana, Nagaland & Sikkim,',
                    AppString.StateNameConcat != ''
                        ? AppString.StateNameConcat
                        : ' Assam, Odisha, Andhra Pradesh, Telangana, Nagaland & Sikkim,',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    ),
                  ),
                  Text(
                    ' You cannot participate in contests on GMNG',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
            ],
          );
        })) {
    }
  }

  static Future<void> alertForLocationRestrictionCounty(
      BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text(
              'IMPORTANT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "Inter",
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Wrap(
                children: [
                  Text(
                    'Sorry,',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                  Text(
                    ' You cannot participate in contests on GMNG because you are Out of India',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().clan_header_dark,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context, 'Ok');
                },
                child: Text('OK',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      color: AppColor().color_side_menu_header,
                    )),
              ),
            ],
          );
        })) {
    }
  }

  //here goes the function
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  String getDepositeBalnace(var deposit_bal) {
    //double varr=deposit_bal  as double;

    double varr = double.parse('${deposit_bal ?? "0"}');
    var deposite = varr / 100;

    var d2 = deposite.toPrecision(2);

    return d2.toString();
  }

  String getTodayDatesWithFormat() {
    // DateTime datetime  = DateTime.now().toUtc();
    DateTime datetime = DateTime.now();
    //2022-05-28T06:17:02.712Z
    //2022-06-12 20:41:24.528583
    String today = new DateFormat("yyyy/MM/dd'T'HH:mm:ss").format(datetime);
    // String today =new DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(new DateTime.now());
    Utils().customPrint("today== ${new DateTime.now()}");
    Utils().customPrint("today== ${today}");
    return today;
  }

  String getTodayDates() {
    DateTime datetime = DateTime.now();
    String dateTimeCurrent;

    if (AppString.serverTime != null && AppString.serverTime != '') {
      //server time
      dateTimeCurrent = getStartTimeHHMMSS(AppString.serverTime);
      Utils().customPrint("today current 1 ${dateTimeCurrent}");
    } else {
      //local time
      dateTimeCurrent =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(datetime);
      Utils().customPrint("today current 2 ${dateTimeCurrent}");
    }

    // Utils().customPrint("today== ${new DateTime.now()}");
    Utils().customPrint("today current ${dateTimeCurrent}");

    return dateTimeCurrent;
  }

  Future<String?> getTodayDatesPref() async {
    DateTime datetime = DateTime.now();
    String dateTimeCurrent;

    if (AppString.serverTime != null && AppString.serverTime != '') {
      //server time
      dateTimeCurrent = getStartTimeHHMMSS(AppString.serverTime);
      Utils().customPrint("dateTimeCurrent 1 ${dateTimeCurrent}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("location_Check_Date", dateTimeCurrent);
    } else {
      //local time
      dateTimeCurrent =
          new DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(datetime);
      Utils().customPrint("dateTimeCurrent 2 ${dateTimeCurrent}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("location_Check_Date", dateTimeCurrent);
    }

    // Utils().customPrint("today== ${new DateTime.now()}");
    Utils().customPrint("dateTimeCurrent ${dateTimeCurrent}");
  }

  customPrint(var data) async {
    try {
      if (ApiUrl().is_debug_mode) {
        print("$data");
      } else {}
    } catch (e) {}
  }

  void alertInsufficientBalance(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      //barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(ImageRes().hole_popup_bg))),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 280,
            child: Card(
              margin: EdgeInsets.only(top: 25, bottom: 10),
              elevation: 0,
              //color: AppColor().wallet_dark_grey,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image(
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/rupee.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            child: Image.asset(ImageRes().close_icon),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 5),
                      child: Text(
                        'Insufficient Balance',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 40, bottom: 10),
                      child: Text(
                        'We don\'t have sufficient balance to join this contest.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              //Get.offAll(() => DashBord(4, ""));
                              //Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width - 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().green_color_light,
                                    AppColor().green_color,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      1.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFF067906),
                                    //inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(00, 00),
                                    blurRadius: 00,
                                    color: Color(0xFFffffff),
                                    //inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Text(
                                "ADD MONEY",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text("  "),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(() => OfferWallScreen());
                              //Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width - 250,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor().button_bg_redlight,
                                    AppColor().button_bg_reddark,
                                  ],
                                ),

                                boxShadow: const [
                                  BoxShadow(
                                    offset: const Offset(
                                      0.0,
                                      1.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: .3,
                                    color: Color(0xFFED234B),
                                    //inset: true,
                                  ),
                                  BoxShadow(
                                    offset: Offset(00, 00),
                                    blurRadius: 00,
                                    color: Color(0xFFffffff),
                                    //inset: true,
                                  ),
                                ],

                                border: Border.all(
                                    color: AppColor().whiteColor, width: 2),
                                borderRadius: BorderRadius.circular(30),
                                // color: AppColor().whiteColor
                              ),
                              child: Text(
                                "GET FREE MONEY",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Nunito",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
        );
      },
    );
  }
}
