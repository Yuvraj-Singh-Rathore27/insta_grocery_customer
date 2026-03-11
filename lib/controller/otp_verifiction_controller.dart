
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/responsemodel/LoginResponseModelNew.dart';
import '../preferences/UserPreferences.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';
import 'package:get_storage/get_storage.dart';

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
              Utils.showCustomTosst(loginRespone.message??'2');
              final store = GetStorage();
              store.write(UserPreferences.user_id, loginRespone.data?.id.toString());
              store.write(UserPreferences.access_token, loginRespone.data?.accessToken.toString());
             //  prefs = await SharedPreferences.getInstance();
             //  prefs?.setString(UserPreferences.user_id, loginRespone.data?.id.toString()??"");
             // prefs?.setString(UserPreferences.access_token, loginRespone.data?.accessToken??'');

              Get.to(() => DashBord(0, ""));
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