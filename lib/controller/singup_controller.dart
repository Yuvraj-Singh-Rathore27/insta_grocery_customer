import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/responsemodel/LoginOptRespone.dart';
import '../model/responsemodel/LoginResponse.dart';
import '../model/responsemodel/LoginResponseModelNew.dart';
import '../preferences/UserPreferences.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class RegisterController extends GetxController {
  SharedPreferences? prefs;

  TextEditingController nameController = new TextEditingController();
  TextEditingController lastController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController mobileNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var email = "".obs;
  var name = "".obs;
  var lastName = "".obs;
  var userName = "".obs;
  var password = "".obs;
  var mobile_number = "".obs;
  var otp = "".obs;
  RxBool is_check = false.obs;
  var login_type = "mobile_login".obs;
  var countryCode = "91".obs;
  RxBool passwordVisible = false.obs;
  var showOtpScreen = false.obs;

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    emailController.text = email.value;
    passwordController.text = password.value;

    super.onInit();
  }

  Future<void> genrateOptApiCall(BuildContext context) async {
    if (name.value.isEmpty) {
      Utils.showCustomTosstError("Please enter name.");
      return;
    }
    if (lastName.value.isEmpty) {
      Utils.showCustomTosstError("Please enter last name.");
      return;
    }

    // if (email.value.isEmpty) {
    //   Utils.showCustomTosstError("Please enter valid email.");
    //   return;
    // }
    // if (password.value.isEmpty) {
    //   Utils.showCustomTosstError("Please enter password");
    //   return;
    // }

    if (mobile_number.value.isEmpty) {
      Utils.showCustomTosstError("Please enter mobile number.");
      return;
    }
    if (mobile_number.value.length < 10) {
      Utils.showCustomTosstError("Please enter valid mobile number.");
      return;
    }

    final param = {
      "contact_number": mobile_number.value.toString(),
      "country_phone_code": "+91",
      "is_verification_required": false,
      "user_type": "user"
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response =
        await WebServicesHelper().getUserLogin(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      LoginOptRespone loginRespone = LoginOptRespone.fromJson(response);
      try {
        if (loginRespone.status == 200) {
          hideProgress(context);

          final data = loginRespone.data;
          if (data != null) {
            var otp = data.otp;
            mobile_number.value = mobile_number.value;
            showOtpScreen.value = true;
            // Get.to(() => OtpVerifictionSignupScreen( otp: otp,mobileNumber:mobile_number.value.toString()));
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

  Future<void> onSignupApiCall(BuildContext context) async {
    userName.value =
        "ashdasda" + DateTime.now().millisecondsSinceEpoch.toString();
    if (name.value.isEmpty) {
      Utils.showCustomTosstError("Please enter name.");
      return;
    }
    if (lastName.value.isEmpty) {
      Utils.showCustomTosstError("Please enter last name.");
      return;
    }

    if (otp.value.isEmpty) {
      Utils.showCustomTosstError("Please enter otp");
      return;
    }
    if (otp.value.length != 4) {
      Utils.showCustomTosstError("Please enter valid otp");
      return;
    }

    final param = {
      "first_name": name.value.toString(),
      "last_name": lastName.value.toString(),
      "contact_number": mobile_number.value.toString(),
      "otp": otp.value.toString(),
      // "email": email.value.toString(),
      // "password": password.value.toString(),
      "country_phone_code": "+${countryCode.value}",
      "access_token": "sdfdshsgfsgfsd",
      "device_token": "sdfdshsgfsgfsd",
      "device_type": "A",
      "timezone": "",
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response =
        await WebServicesHelper().userSignupApi(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      LoginResponseModelNew loginRespone =
          LoginResponseModelNew.fromJson(response);
      try {
        if (loginRespone.status == 200) {
          hideProgress(context);
          if (loginRespone.error!) {
            Utils.showCustomTosst(loginRespone.message ?? "");
          } else {
            Utils.showCustomTosst(loginRespone.message ?? "");
            final store = GetStorage();
            store.write(
                UserPreferences.user_id, loginRespone.data?.id.toString());
            store.write(UserPreferences.access_token,
                loginRespone.data?.accessToken.toString());
            Get.to(() => DashBord(0, ""));
            showOtpScreen.value = false;
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
