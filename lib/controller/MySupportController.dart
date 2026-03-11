import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/responsemodel/BaseResponse.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class MySupportController extends GetxController{

  late GetStorage store ;
  String userId="";
  String accessToken="";

  TextEditingController complainInputController= TextEditingController();
  TextEditingController SuggestionInputController= TextEditingController();

  var complainText="".obs;
  var suggestionText="".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    store = GetStorage();
    userId= store.read(UserPreferences.user_id);
    accessToken= store.read(UserPreferences.access_token);
    print("UserProfileController Userid => ${userId}");
    print("UserProfileController accessToken => ${accessToken}");


  }


  Future<void> submitComplains(BuildContext context) async {
    if(complainText.value.isEmpty){
      Utils.showCustomTosstError("Please enter your complain.");
      return;
    }


    final param = {
      "submission_type":"complaints",
      "content":complainText.value.toString(),
      "user_id":userId,
      "title":"complain",
      "user_type":"user",
      "created_by_id":userId,
      "updated_by":userId,
      "updated_by_id":userId,
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response = await WebServicesHelper().submitFeedback(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      BaseResponse loginRespone =BaseResponse.fromJson(response);
      try {
        if (loginRespone.status==200) {
          hideProgress(context);
          if(loginRespone.error!){
            Utils.showCustomTosst(loginRespone.message??'1');
          }else{
            Utils.showCustomTosst(loginRespone.message??'2');

          }
        } else {
          Utils.showCustomTosst("Network issues ,please try after some time");
          hideProgress(context);
        }

      } catch (E) {
        hideProgress(context);

      }
    } else {
      hideProgress(context);
    }
  }


  Future<void> submitSuggestion(BuildContext context) async {
    if(suggestionText.value.isEmpty){
      Utils.showCustomTosstError("Please enter your suggestion .");
      return;
    }


    final param = {
      "submission_type":"suggestions",
      "content":suggestionText.value.toString(),
      "user_id":userId,
      "title":"complain",
      "user_type":"user",
      "created_by_id":userId,
      "updated_by":userId,
      "updated_by_id":userId,
    };
    showLoaderDialog(context);

    Map<String, dynamic>? response = await WebServicesHelper().submitFeedback(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      BaseResponse loginRespone =BaseResponse.fromJson(response);
      try {
        if (loginRespone.status==200) {
          hideProgress(context);
          if(loginRespone.error!){
            Utils.showCustomTosst(loginRespone.message??'1');
          }else{
            Utils.showCustomTosst(loginRespone.message??'2');

          }
        } else {
          Utils.showCustomTosst("Network issues ,please try after some time");
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