import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/HospitalModel.dart';
import '../model/filtter_model.dart';
import '../model/responsemodel/hospital_response_list.dart';
import '../preferences/UserPreferences.dart';
import '../res/AppColor.dart';
import '../res/ImageRes.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';


class HospitalController extends GetxController{

  late GetStorage store ;
  String userId="";
  String access_token="";
  RxList<HospitalModel> hospitalList=<HospitalModel>[].obs;
  RxList<FilterModel> filterList = <FilterModel>[].obs;
  TextEditingController searchController= TextEditingController();
  var searchKeyword = "".obs;
  List<String> banners=<String>['1','2','3'].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    store = GetStorage();
    userId= store.read(UserPreferences.user_id);
    access_token= store.read(UserPreferences.access_token);
    filterList.add(FilterModel.fromJson(
        {"image": ImageRes().medicine_search, "id": 1, "name": 'Emergency',"color":AppColor().searchFillterColor1}));
    filterList.add(FilterModel.fromJson(
        {"image": ImageRes().surgery_search, "id": 2, "name": 'Medicine',"color":AppColor().searchFillterColor2}));
    filterList.add(FilterModel.fromJson(
        {"image": ImageRes().paediatrics_search, "id": 3, "name": 'Surgery',
          "color":AppColor().searchFillterColor3}));
    filterList.add(FilterModel.fromJson(
        {"image": ImageRes().Orthopedics_search, "id": 4, "name": 'Orthopedics',
          "color":AppColor().searchFillterColor3}));
    filterList.refresh();

    // getHospitalList();
    super.onInit();
  }

  Future<void> getHospitalList() async {
    BuildContext? context=Get.context;
    final param = {
      "user_id":userId,
      "access_token":access_token,
      "name":searchKeyword.value.toString()
    };
    showLoaderDialog(context!);

    Map<String, dynamic>? response = await WebServicesHelper().getHospitalList(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      HospitalResponseModelList responseModelList =HospitalResponseModelList.fromJson(response);

      try {
        if (responseModelList.status==200) {
          hideProgress(context);
          if(responseModelList.data!=null){
            if(hospitalList.isNotEmpty){
              hospitalList.clear();
            }
            hospitalList.addAll(responseModelList.data??[]);
          }
        } else {
          // Utils.showCustomTosst("Login failed");
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