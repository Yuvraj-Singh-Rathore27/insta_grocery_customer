import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/utills/Utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controller/login_controller.dart';
import '../../controller/otp_verifiction_controller.dart';
import '../../controller/singup_controller.dart';
import '../../customwiget/my_elevated_button.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../../utills/CustomTextStyle.dart';
import '../../utills/Platfrom.dart';
import '../daskboard/DashBord.dart';
import '../forget_password/forget_screen.dart';

class OtpVerifictionSignupScreen extends StatefulWidget {
  final  otp;
  final mobileNumber;
  const OtpVerifictionSignupScreen(  {Key? key, required this.otp,required this.mobileNumber}) : super(key: key);

  @override
  State<OtpVerifictionSignupScreen> createState() => _OtpVerifictionScreenState(otp,mobileNumber);
}

class _OtpVerifictionScreenState extends State<OtpVerifictionSignupScreen> {
  RegisterController controller = Get.put(RegisterController());

  late double height, width;
  var  otp;
  var mobileNumber;

  _OtpVerifictionScreenState(this.otp, this.mobileNumber);

  @override
  Widget build(BuildContext context) {
    controller.mobile_number.value=mobileNumber;
    // controller.otp.value=otp;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageRes().app_bg_login),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(

              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.pop(context),
                        },
                        child: Container(
                            alignment: Alignment.topLeft,
                            child: Image(
                                width: 15,
                                height: 15,
                                image: AssetImage(ImageRes().back_icon))),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          alignment: Alignment.center,
                          child: Image(

                              image: AssetImage(ImageRes().img_otp))),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Verification Code',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                color: AppColor().whiteColor),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'We have sent the verification code to your mobile number',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.normal,
                                color: AppColor().whiteColor),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            mobileNumber.substring(0,6)+"****",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                color: AppColor().whiteColor),
                          )),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'your otp is for testing ${otp}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                color: AppColor().whiteColor),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Center(
                                  child: PinCodeTextField(
                                    showCursor: true,
                                    autoFocus: true,
                                    length: 4,

                                    obscureText: false,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor().whiteColor),
                                    keyboardType: TextInputType.number,

                                    pinTheme: PinTheme(
                                      borderWidth: 1.0,
                                      fieldOuterPadding:
                                      const EdgeInsets.only(right: 10),
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      activeFillColor:AppColor().whiteColor,
                                      selectedFillColor:AppColor().whiteColor,
                                      activeColor: AppColor().whiteColor,
                                      inactiveColor: AppColor().whiteColor,
                                      selectedColor: AppColor().whiteColor,
                                      fieldHeight: 50,
                                      fieldWidth: 50,
                                    ),

                                    animationType: AnimationType.fade,
                                    animationDuration:
                                    const Duration(milliseconds: 300),
                                    enablePinAutofill: true,
                                    onChanged: (code) {
                                      Utils().customPrint("Changed: " + code);
                                      if (code.length == 4) {
                                        controller.otp.value = code;
                                      }
                                    },
                                    onCompleted: (code) {
                                      if (code.length == 4) {
                                          controller.otp.value = code;
                                        //Onsubmit();
                                      }
                                    },
                                    appContext: context,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          MyElevatedButton(
                            // width: 200,
                            onPressed: () {
                              // Get.to(() => DashBord(0, ""));
                              // Utils.showCustomTosst("Under Working");
                              controller.onSignupApiCall(context);
                              // Get.to(() => DashBord(0, ""));
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColor().colorPrimary),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don’t get the code?  ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.normal,
                                    color: AppColor().whiteColor),
                              ),
                              GestureDetector(
                                onTap: ()=>{
                                  // Navigator.pop(context),

                                },
                                child:  Text(
                                  'Resend',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.bold,
                                      color: AppColor().whiteColor),
                                ),

                              ),

                            ],
                          )

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ));
  }
}
