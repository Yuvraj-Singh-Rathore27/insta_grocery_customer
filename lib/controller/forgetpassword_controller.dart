
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/responsemodel/ForgetOtpRespone.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../screen/forget_password/password_reset_screen.dart';
import '../screen/login/login_screen.dart';
import '../utills/Utils.dart';
import '../utills/Validation.dart';
import '../webservices/WebServicesHelper.dart';

class ForgetPasswordController extends GetxController{
  SharedPreferences? prefs;
  TextEditingController emailController= new TextEditingController();
  TextEditingController passwordController= new TextEditingController();
  TextEditingController confirmPasswordController= new TextEditingController();
  TextEditingController OtpController= new TextEditingController();
  var email="".obs;
  var otp="".obs;
  var password="".obs;
  var confirm_password="".obs;
  RxBool passwordVisible=false.obs;
  RxBool confirmPasswordVisible=false.obs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    super.onInit();

  }

  Future<void> sendForgetOtpApiCall(BuildContext context) async {
    if(email.value.isEmpty){
      Utils.showCustomTosst("Please enter valid email.");
      return;
    }
    if(!Validation.isvalidEmail(email.value.toString())){
      Utils.showCustomTosst("Please enter valid email.");
      return;
    }

    final param = {
      "to_email":email.value.toString(),
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response = await WebServicesHelper().getForgetpasswordOtp(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      ForgetOtpRespone respone = ForgetOtpRespone.fromJson(response);
      try {
        hideProgress(context);
        if (respone.status == 200) {
          if(respone.error??true){
            Utils.showCustomTosstError(respone.message??"Email not found in system, please check");
            // Get.to(()=>ResetPasswordScreen());
          }else{
            Get.to(()=>ResetPasswordScreen());
          }

        } else {
          Utils.showCustomTosst("Login failed");
          hideProgress(context);
        }

      } catch (E) {
        hideProgress(context);

      }
    } else {
      hideProgress(context);
    }
  }

  Future<void> resetPasswordApi(BuildContext context) async {

    if(password.value.isEmpty){
      Utils.showCustomTosst("Please enter password.");
      return;
    }

    if(password.value!=confirm_password.value){
      Utils.showCustomTosst("password and confrim password must be same");
      return;
    }
    if(otp.value.isEmpty){
      Utils.showCustomTosst("Please enter OTP.");
      return;
    }
    final param = {
      "otp":otp.value.toString(),
      "password":password.value.toString(),
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response = await WebServicesHelper().resetPasswordApi(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      ForgetOtpRespone respone = ForgetOtpRespone.fromJson(response);
      try {
        if (respone.status == 200) {
          hideProgress(context);
          Utils.showCustomTosst("Password changed successfully");
          Get.offAll(() => LoginScreen());

        } else {
          Utils.showCustomTosst("Login failed");
          hideProgress(context);
        }

      } catch (E) {
        hideProgress(context);

      }
    } else {
      hideProgress(context);
    }
  }

}