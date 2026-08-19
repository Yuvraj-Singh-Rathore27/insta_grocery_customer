
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/responsemodel/LoginResponseModelNew.dart';
import '../preferences/session_manager.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class OtpVerificationController extends GetxController{
  SharedPreferences? prefs;

TextEditingController nameController= new TextEditingController();
TextEditingController mobileNumberController= new TextEditingController();
TextEditingController emailController= new TextEditingController();
TextEditingController passwordController= new TextEditingController();
  var email="".obs;
  var name="".obs;
  var password="".obs;
  var mobile_number="".obs;
  var otp="".obs;
  RxBool is_check = false.obs;
  var login_type="mobile_login".obs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    emailController.text=email.value;
    passwordController.text=password.value;

    super.onInit();

  }

  Future<void> onSubmit(BuildContext context) async {
    if(mobile_number.value.isEmpty){
      Utils.showCustomTosstError("Please enter mobile number.");
      return;
    }
    if(otp.value.isEmpty){
      Utils.showCustomTosstError("Please enter otp");
      return;
    }
    if(otp.value.length!=4){
      Utils.showCustomTosstError("Please enter valid otp");
      return;
    }
    final param = {
      "contact_number":mobile_number.value.toString(),
      "otp":otp.value.toString(),
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response = await WebServicesHelper().apiLoginOtpVarification(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      LoginResponseModelNew loginRespone =LoginResponseModelNew.fromJson(response);
      try {
        if (loginRespone.status==200) {
            hideProgress(context);
            if(loginRespone.error!){
              Utils.showCustomTosst(loginRespone.message??'1');
            }else{
              // Awaited, and refused when the response carries no user id —
              // navigating on an empty session is what made the app look
              // logged in until it was reopened.
              final bool saved = await SessionManager.saveSession(
                userId: loginRespone.data?.id,
                accessToken: loginRespone.data?.accessToken,
              );

              if (!saved) {
                Utils.showCustomTosstError("Login failed, please try again");
                return;
              }

              Utils.showCustomTosst(loginRespone.message??'2');

              Get.offAll(() => DashBord(0, ""));
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
}