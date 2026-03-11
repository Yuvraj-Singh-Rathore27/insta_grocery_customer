import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/forgetpassword_controller.dart';
import '../../customwiget/my_elevated_button.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  ForgetPasswordController controller = Get.put(ForgetPasswordController());

  late double height, width;
  bool is_check = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageRes().login_bg_new),
            fit: BoxFit.cover,
          ),
        )),
        Column(
          children: [
        SizedBox(
            height: 60,
            child: Container(
              // color: AppColor().whiteColor,
              padding: EdgeInsets.all(5),

              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            ImageRes().img_back,
                            color: AppColor().whiteColor,
                            height: 35,
                            width: 30,
                          ),
                        )),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Image.asset(ImageRes().acopo_logo,
                            color: AppColor().colorPrimary,
                            fit: BoxFit.contain,
                            height: 50,
                            width: 100)),
                  ),
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Forgot Password ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        color: AppColor().whiteColor),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Please enter your details. ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.normal,
                        color: AppColor().whiteColor),
                  )),
              const SizedBox(
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
                      TextField(
                        // obscureText: false,
                        style: TextStyle(
                          color: AppColor().whiteColor,
                        ),
                        controller: controller.emailController,
                        onChanged: (value) => {
                          controller.email.value = value,
                        },
                        decoration: InputDecoration(
                          labelText: "Email ID ",
                          labelStyle:
                              TextStyle(color: AppColor().whiteColor),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor().whiteColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor().whiteColor),
                          ),
                          suffixIcon: Image(
                              width: 20,
                              height: 20,
                              image: AssetImage(ImageRes().img_icon_email)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyElevatedButton(
                    // width: 200,
                    onPressed: () {
                      controller.sendForgetOtpApiCall(context);
                      // Get.to(() => ResetPasswordScreen());
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColor().colorPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          ],
        )
      ],
    )));
  }
}
