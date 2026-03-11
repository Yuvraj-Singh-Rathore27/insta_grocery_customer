

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/blood_group_model.dart';
import '../model/responsemodel/LoginResponseModelNew.dart';
import '../preferences/UserPreferences.dart';
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
    userId= store.read(UserPreferences.user_id);
    accessToken= store.read(UserPreferences.access_token);
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
    BuildContext? context=Get.context;
    final param = {
      "user_id":userId,
      "accessToken":accessToken,
    };

    Map<String, dynamic>? response = await WebServicesHelper().getUserDetails(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      if(response['status']==401){

        final  store = GetStorage();
        store.erase();
        Navigator.pushAndRemoveUntil(
          context!,
          MaterialPageRoute(
            builder: (BuildContext context) =>  LoginScreen(),
          ),
              (route) => false,
        );
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

  Future<void> deleteAccount() async {
    BuildContext? context=Get.context;
    final param = {
      "user_id":userId,
      "accessToken":accessToken,
      "activate":'true',
    };

    Map<String, dynamic>? response = await WebServicesHelper().makeUserActive(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      if(response['status']==401){

        final  store = GetStorage();
        store.erase();
        Navigator.pushAndRemoveUntil(
          context!,
          MaterialPageRoute(
            builder: (BuildContext context) =>  LoginScreen(),
          ),
              (route) => false,
        );
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