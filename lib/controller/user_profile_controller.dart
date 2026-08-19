

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/blood_group_model.dart';
import '../model/responsemodel/LoginResponseModelNew.dart';
import '../preferences/session_manager.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../screen/login/login_screen.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class UserProfileController extends GetxController {

  TextEditingController firstNameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController dobController= TextEditingController();
  TextEditingController mobileNumberController= TextEditingController();
  TextEditingController whatsappNumberController= TextEditingController();
  TextEditingController emergencyContactNumberController= TextEditingController();
  TextEditingController heightController= TextEditingController();
  TextEditingController weightController= TextEditingController();

  var firstName="".obs;
  var lastName="".obs;
  var email="".obs;
  var dob="".obs;
  var mobileNumber="".obs;
  var whatsappNumber="".obs;
  var emergencyNumber="".obs;
  var height="".obs;
  var weight="".obs;
  var bloodGroup="A +".obs;
  RxList list=[].obs;
  late GetStorage store ;
  String userId="";
  String accessToken="";
  var userData= LoginResponseModelNew().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
     store = GetStorage();
    // Read through SessionManager: a missing key used to be assigned straight
    // into these non-nullable Strings, which threw a TypeError in onInit and
    // took the whole home screen down with it.
    userId = SessionManager.userId;
    accessToken = SessionManager.accessToken;
     print("UserProfileController Userid => ${userId}");
     print("UserProfileController accessToken => ${accessToken}");

    initBloodArray();



  }
  void initBloodArray(){
    BloodGroup b=BloodGroup();
    b.name="O +";
    b.isSelected=false;
    list.add(b);

    BloodGroup b2=BloodGroup();
    b2.name="O -";
    b2.isSelected=false;
    list.add(b2);


    BloodGroup b3=BloodGroup();
    b3.name="A +";
    b3.isSelected=false;
    list.add(b3);

    BloodGroup b4=BloodGroup();
    b4.name="A -";
    b4.isSelected=false;
    list.add(b4);

    BloodGroup b5=BloodGroup();
    b5.name="B +";
    b5.isSelected=false;
    list.add(b5);


    BloodGroup b6=BloodGroup();
    b6.name="B -";
    b6.isSelected=false;
    list.add(b6);

    BloodGroup b7=BloodGroup();
    b7.name="AB +";
    b7.isSelected=false;
    list.add(b7);

    BloodGroup b8=BloodGroup();
    b8.name="AB -";
    b8.isSelected=false;
    list.add(b8);


  }

  void updateSelected(BloodGroup data){
    print("Onclick");
    for(int i=0;i< list.length;i++){
      if(data.name==list[i].name){
        if(list[i].isSelected==true){
          list[i].isSelected==false;
          bloodGroup.value="";
        }else{
          list[i].isSelected==true;
          bloodGroup.value=list[i].name;
        }
      }
    }
    list.refresh();

  }



  Future<void> getUserDetails() async {
    // The session may have been written after this controller was created
    // (login → dashboard reuses the same instance), so read it again here
    // instead of trusting the values captured in onInit.
    userId = SessionManager.userId;
    accessToken = SessionManager.accessToken;

    if (userId.isEmpty) return;

    final param = {
      "user_id":userId,
      "accessToken":accessToken,
    };

    Map<String, dynamic>? response = await WebServicesHelper().getUserDetails(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      if(response['status']==401){
        await _forceLogout();
        return;

      }
      LoginResponseModelNew loginRespone =LoginResponseModelNew.fromJson(response);
      try {
        if (loginRespone.status==200) {

            userData.value=loginRespone;

            // The endpoint returns the account's current access token. Saving
            // it here keeps the stored token alive when the server rotates or
            // re-issues it, and repairs sessions written by older builds that
            // never stored a token at all.
            final String? freshToken = loginRespone.data?.accessToken;
            if (freshToken != null && freshToken.isNotEmpty) {
              await SessionManager.saveAccessToken(freshToken);
              accessToken = SessionManager.accessToken;
            }

            print("DAATAA=> ${userData.value.data?.userProfile?.firstName}");

        } else {
        }

      } catch (E) {
      }
    } else {
    }
  }

  /// Ends the session after the server rejected our token.
  ///
  /// This used to call `store.erase()`, which wiped every GetStorage key —
  /// session, store code and everything else — and then pushed the login
  /// screen through a possibly-null context. Only the session keys are
  /// cleared now, and navigation goes through Get so it can't crash on a
  /// missing context.
  Future<void> _forceLogout() async {
    await SessionManager.clear();

    userId = "";
    accessToken = "";

    Utils.showCustomTosstError("Session expired, please log in again");
    Get.offAll(() => LoginScreen());
  }

  Future<void> deleteAccount() async {
    final param = {
      "user_id":userId,
      "accessToken":accessToken,
      "activate":'true',
    };

    Map<String, dynamic>? response = await WebServicesHelper().makeUserActive(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      if(response['status']==401){
        await _forceLogout();
        return;

      }
      LoginResponseModelNew loginRespone =LoginResponseModelNew.fromJson(response);
      try {
        if (loginRespone.status==200) {

          userData.value=loginRespone;
          print("DAATAA=> ${userData.value.data?.userProfile?.firstName}");

        } else {
        }

      } catch (E) {
      }
    } else {
    }
  }



}