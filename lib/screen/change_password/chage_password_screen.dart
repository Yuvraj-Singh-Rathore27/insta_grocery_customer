
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../customwiget/my_elevated_button.dart';
import '../../res/AppColor.dart';
import '../../res/ImageRes.dart';
import '../../toolbar/TopBar.dart';
import '../../utills/CustomTextStyle.dart';
import '../../utills/Platfrom.dart';
import '../login/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late double height, width;
  bool is_check=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(
            title: '',
            menuicon:false,
            menuback: true,
            iconnotifiction: true,
            is_wallaticon: true,
            is_supporticon: false,
            is_whatsappicon: false,
            onPressed: ()=>{

            },
            onTitleTapped: ()=>{

            }
        ),
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageRes().img_bg_app),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                'Reset',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().whiteColor),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  'Password ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      color: AppColor().whiteColor),
                )),
            SizedBox(
              height: 170 ,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  'Create a New Password',
                  style: CustomTextStyle.textFormFieldLight,
                ),

                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: false,
                  onChanged: (value) => {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: false,
                  onChanged: (value) => {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: false,
                  onChanged: (value) => {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'OTP',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                MyElevatedButton(
                  width: 200,
                  onPressed: () {
                    Get.offAll(() => LoginScreen());

                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
