
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/JobModel.dart';
import 'package:get_storage/get_storage.dart';

import '../model/responsemodel/status_response_list.dart';
import '../model/slider_image_model.dart';
import '../model/slider_response_model.dart';
import '../model/status_model.dart';
import '../preferences/UserPreferences.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';

class HomePageController extends GetxController{
  SharedPreferences? prefs;
  String userId="";
  String accessToken="";
  List<JobModel> jobList = <JobModel>[].obs;
  RxList<StatusModel> statusList=<StatusModel>[].obs;
  RxList<SliderImageModel> bannerList=<SliderImageModel>[].obs;
  RxList<SliderImageModel> storeGroupbannerList=<SliderImageModel>[].obs;

  @override
  Future<void> onInit() async {

    print("On init ");
    final store = GetStorage();
    userId= store.read(UserPreferences.user_id);
    accessToken= store.read(UserPreferences.access_token);
    print("HomePageController Userid => $userId");
    print("accessToken => $accessToken");
  }


  Future<void> getBannerList() async {
    final param = {
      "user_id":userId,
      "accessToken":accessToken,
      "banner_type":"Home Page"
    };

    Map<String, dynamic>? response = await WebServicesHelper().getBannerList(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      SliderResponseModel responseModel =SliderResponseModel.fromJson(response);
      try {
        if (responseModel.status==200) {
          if(responseModel.error==false&& responseModel.data!=null){
            bannerList.clear();
            for(int i=0;i<responseModel.data!.length;i++){
              print("Banner List size  ==>${i} ${responseModel.data?[i].bannerPath?.length}");
              bannerList.addAll(responseModel.data?[i].bannerPath as Iterable<SliderImageModel>);
            }
            bannerList.refresh();
          }
          print("Banner List size ==> ${bannerList.value.length}");
        } else {

        }

      } catch (E) {


      }
    } else {
    }
  }

  Future<void> getBannerStoreList(store_group_id) async {
    final param = {
      "user_id":userId,
      "accessToken":accessToken,
      "banner_type":"Group Type",
      "store_group_id":store_group_id.toString()
    };

    Map<String, dynamic>? response = await WebServicesHelper().getBannerList(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      SliderResponseModel responseModel =SliderResponseModel.fromJson(response);
      try {
        if (responseModel.status==200) {
          if(responseModel.error==false&& responseModel.data!=null){
            storeGroupbannerList.clear();
            for(int i=0;i<responseModel.data!.length;i++){
              print("Banner List size  ==>${i} ${responseModel.data?[i].bannerPath?.length}");
              storeGroupbannerList.addAll(responseModel.data?[i].bannerPath as Iterable<SliderImageModel>);
            }
            storeGroupbannerList.refresh();
          }
          print("storeGroupbannerList List size ==> ${storeGroupbannerList.value.length}");
        } else {

        }

      } catch (E) {


      }
    } else {
    }
  }


  Future<void> getBookingStatusList() async {
    final param = {
      "user_id":userId,
      "accessToken":accessToken,

    };

    Map<String, dynamic>? response = await WebServicesHelper().getBookingStatusList(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {

      StatusResponseModelList responseModelList =StatusResponseModelList.fromJson(response);
      try {
        if (responseModelList.status==200 && responseModelList.error!) {
            if(statusList.isNotEmpty){
              statusList.clear();
            }
            statusList.addAll(responseModelList.data as Iterable<StatusModel>);

        }

      } catch (E) {
        print(E);
      }
    } else {
    }
  }







}