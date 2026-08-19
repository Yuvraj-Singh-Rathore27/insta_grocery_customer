
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/responsemodel/LoginOptRespone.dart';
import '../model/responsemodel/LoginResponse.dart';
import '../model/responsemodel/LoginResponseModelNew.dart';
import '../preferences/UserPreferences.dart';
import '../preferences/session_manager.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../screen/otp_verifiction/otp_verifiction_screen.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class LoginController extends GetxController{
  SharedPreferences? prefs;

TextEditingController emailController= TextEditingController();
TextEditingController mobileController= TextEditingController();
TextEditingController passwordController= TextEditingController();
TextEditingController storeCodeController= TextEditingController();
  var mobileNumber="".obs;
  var email="".obs;
  var storeIdCode="".obs;
  // var email="vishnu@gmail.com".obs;
  // var password="vishnu@1234".obs;
  var password="".obs;
  RxBool is_check = false.obs;
  var login_type="mobile_login".obs;
  var countryCode="91".obs;
  RxBool passwordVisible=false.obs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    emailController.text=email.value;
    passwordController.text=password.value;
    // storeCodeController.text="FREBOO20";
    // mobileController.text="8107357227";
    super.onInit();

  }

  Future<void> onSubmit(BuildContext context) async {
    if(mobileNumber.value.isEmpty){
      Utils.showCustomTosstError("Please enter mobile number.");
      return;
    }
    if(mobileNumber.value.length<10){
      Utils.showCustomTosstError("Please enter valid mobile number.");
      return;
    }
    if(storeIdCode.isNotEmpty){
      if(!storeIdCode.contains("FREBOO")){
        Utils.showCustomTosstError("Please enter valid store id ");
        return;
      }
    }

    final param = {
      "contact_number":mobileNumber.value.toString(),
      "country_phone_code":"+${countryCode.value}",
      "is_verification_required":true,
      "user_type":"user"
    };
    showLoaderDialog(context);
    print("Pram is ${param}");

    Map<String, dynamic>? response = await WebServicesHelper().getUserLogin(param);
    Utils().customPrint('response on view1 ${response?.toString()}');

    if (response != null) {
      LoginOptRespone loginRespone =
      LoginOptRespone.fromJson(response);
      try {
        if (loginRespone.status == 200) {
            hideProgress(context);
            if(loginRespone.error!){
              Utils.showCustomTosstError(loginRespone.message??"");
            }else{
              final data = loginRespone.data;
              if(data!=null){
                final store = GetStorage();
                store.write(UserPreferences.store_code, storeIdCode.value.toString());
                var otp=data.otp;
                Get.to(() => OtpVerifictionScreen( otp: otp,mobileNumber:mobileNumber.value.toString()));

              }

            }
        } else {

          hideProgress(context);

          Utils.showCustomTosst("User not found ");
        }

      } catch (E) {
        hideProgress(context);

      }
    } else {
      hideProgress(context);
    }
  }


  Future<void> apiLoginWithPssword(BuildContext context) async {
    if(email.value.isEmpty){
      Utils.showCustomTosstError("Please enter email");
      return;
    }
    if(password.value.isEmpty){
      Utils.showCustomTosstError("Please enter password");
      return;
    }


    final param = {
      "username":email.value.toString(),
      "password":password.value.toString(),
      "user_type":"user"
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response = await WebServicesHelper().loginWithPassword(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      LoginResponseModelNew loginRespone =LoginResponseModelNew.fromJson(response);
      try {
        if (loginRespone.status==200) {
          hideProgress(context);
          if(loginRespone.error!){
            Utils.showCustomTosst(loginRespone.message??'1');
          }else{
            // Both keys are saved together and awaited. This path used to save
            // the user id only, which left the customer with a session that
            // had no token: every authenticated call went out as
            // "Bearer null", the first 401 wiped the storage, and the next
            // launch showed the login screen again.
            final bool saved = await SessionManager.saveSession(
              userId: loginRespone.data?.id,
              accessToken: loginRespone.data?.accessToken,
            );

            if (!saved) {
              Utils.showCustomTosstError(
                  "Login failed, please try again");
              return;
            }

            Utils.showCustomTosst(loginRespone.message??'2');

            // offAll, so the back button can't return to the login screen of
            // a session that is already active.
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