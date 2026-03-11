import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/AppBaseErrorResponse.dart';
import '../model/blood_group_model.dart';
import '../model/common_model.dart';
import '../model/family_member_model.dart';
import '../model/responsemodel/BaseResponse.dart';
import '../model/responsemodel/CommonResponseModel.dart';
import '../model/responsemodel/family_response_list.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';


class FamilyMemberController  extends GetxController{

  TextEditingController firstNameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController dobController= TextEditingController();
  TextEditingController mobileNumberConrtoller= TextEditingController();

  var firstName="".obs;
  var lastName="".obs;
  var email="".obs;
  var dob="".obs;
  var mobileNumber="".obs;
  RxList list=[].obs;
  var bloodGroup="A +".obs;
  late GetStorage store ;
  String userId="";
  String access_token="";
  RxList relationList =<CommonModel>[].obs;
  RxList genderList =<String>[].obs;
  var selectedRelation=CommonModel().obs;
  var gender=''.obs;
  RxList<FamilyMemberModel> familyMemberList=<FamilyMemberModel>[].obs;
  RxBool isLoading=true.obs;
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    store = GetStorage();
    userId= store.read(UserPreferences.user_id);
    access_token= store.read(UserPreferences.access_token);
    genderList.value.add("Male");
    genderList.value.add("FeMale");
    initBloodArray();
    // getFamilyMemberList();
  }

  onSelectRelation(CommonModel data){
    selectedRelation.value=data;
  }
  onSelectGender(String data){
    gender.value=data;
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

  Future<void> getFamilyMemberList() async {
    BuildContext? context=Get.context;
    final param = {
      "user_id":userId,
      "access_token":access_token
    };
    showLoaderDialog(context!);

    Map<String, dynamic>? response = await WebServicesHelper().getFamilyMemberList(param);
    Utils().customPrint('response on view ${response?.toString()}');


    try {
      if (response != null) {
        FamilyResponseModelList responseModelList =FamilyResponseModelList.fromJson(response);
        if (responseModelList.status==200) {

          if(responseModelList.data!=null){
            if(familyMemberList.isNotEmpty){
              familyMemberList.clear();
            }
            isLoading.value=false;
            familyMemberList.addAll(responseModelList.data??[]);
          }
          isLoading.value=false;
          hideProgress(context);
        } else {
          isLoading.value=false;
          // Utils.showCustomTosst("Login failed");
          hideProgress(context);
        }

      } else {
        isLoading.value=false;
        hideProgress(context);
      }


    } catch (E) {
      hideProgress(context);

    }

  }

  Future<void> getRelationShipList() async {
    final param = {
      "user_id":userId,
      "access_token":access_token
    };

    Map<String, dynamic>? response = await WebServicesHelper().getRelationShipList(param);
    Utils().customPrint('response on view ${response?.toString()}');
    if (response != null) {
      CommonResponseModel responseModel =CommonResponseModel.fromJson(response);
      try {
        if (responseModel.status==200) {
            relationList.value.addAll(responseModel.data as Iterable);
        } else {
          // Utils.showCustomTosst(responseModel.message??'');
        }

      } catch (E) {
      }
    } else {
    }
  }


  Future<void> deleteFamilyMember(var id) async {
    final param = {
      "user_id":userId,
      "id":id,
      "access_token":access_token
    };

    Map<String, dynamic>? response = await WebServicesHelper().deleteFamilyMember(param);
    Utils().customPrint('response on view ${response?.toString()}');
    if (response != null) {
      CommonResponseModel responseModel =CommonResponseModel.fromJson(response);
      try {
        if (responseModel.status==200) {
          Utils.showCustomTosst(responseModel.message??'');
          getFamilyMemberList();
        } else {
          // Utils.showCustomTosst(responseModel.message??'');
        }

      } catch (E) {
      }
    } else {
    }
  }





  Future<void> addFamilyMember() async {
  if(firstName.value==''){
    Utils.showCustomTosstError("Please enter firstName.");
    return;
  }
    if(lastName.value==''){
      Utils.showCustomTosstError("Please enter lastName.");
      return;
    }
  if(selectedRelation.value==null){
    Utils.showCustomTosstError("Please select Relation.");
    return;
  }
  if(gender.value==null){
    Utils.showCustomTosstError("Please select gender.");
    return;
  }
    BuildContext? context=Get.context;
    final param = {
      'first_name':firstName.value,
      'last_name':lastName.value,
      'birth_date':'2023-09-03',
      'gender':gender.value=="Male"?'m':'f',
      'blood_group_id':'1',
      'relationship_id':selectedRelation.value.id,
      'created_by':userId,
      'created_by_id':userId,
      'updated_by':userId,
      'updated_by_id':userId,
      "user_id":userId,
      "access_token":access_token
    };
    showLoaderDialog(context!);

    Map<String, dynamic>? response = await WebServicesHelper().addFamilyMember(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      BaseResponse loginRespone =BaseResponse.fromJson(response);
      try {
        if (loginRespone.status==200) {
          hideProgress(context);
          Utils.showCustomTosst(loginRespone.message??'1');
          getFamilyMemberList();
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