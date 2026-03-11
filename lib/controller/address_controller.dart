
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/vender_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/AddressModel.dart';
import 'package:get_storage/get_storage.dart';

import '../model/autoComplete_prediction.dart';
import '../model/place_auto_complete_response.dart';
import '../model/responsemodel/BaseResponse.dart';
import '../model/responsemodel/StateResponseModel.dart';
import '../model/responsemodel/address_response_model.dart';
import '../model/responsemodel/place_details_response.dart';
import '../model/responsemodel/status_response_list.dart';
import '../model/slider_image_model.dart';
import '../model/slider_response_model.dart';
import '../model/state_model.dart';
import '../model/status_model.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/WebServicesHelper.dart';
import '../webservices/network_utility.dart';

class AddressController extends GetxController{
  SharedPreferences? prefs;
  String userId="";
  String accessToken="";
  RxList<SliderImageModel> bannerList=<SliderImageModel>[].obs;
  RxList<AddressModel> addressList=<AddressModel>[].obs;

  //
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController flatHoursAddressController = TextEditingController();
  TextEditingController areaStreetController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController googleMapController = TextEditingController();

  RxList cityList =<StateModel>[].obs;
  RxList<String> citySelectableList=<String>[].obs;

  var selectedCity="".obs;

  RxList StateList =<StateModel>[].obs;
  RxList<String> StateSelectableList=<String>[].obs;
  var selectedState="".obs;

  //google map address

  RxList<AutoCompletePrediction> predictions = <AutoCompletePrediction>[].obs;
  final placeController = TextEditingController();
  var pickupLocation=AutoCompletePrediction().obs;
  var address="".obs;
  final searchCity = "".obs;

  @override
  Future<void> onInit() async {

    print("On init ");
    final store = GetStorage();
    userId= store.read(UserPreferences.user_id);
    accessToken= store.read(UserPreferences.access_token);
    print("AddressController Userid => ${userId}");
    print("accessToken => ${accessToken}");

    debounce(searchCity, (_) async {
      if (searchCity.value.length >= 3) {
        placeAutoComplete();
      }
    }, time: const Duration(seconds: 1));

  }


  onCitySelect(var data, String type){
    if(type=='city_type'){
      selectedCity.value=data;
    }
    if(type=='state_type'){
      selectedState.value=data;
      var stateid="";
      for(int i=0;i<StateList.length;i++){
        if(selectedState.value==StateList[i].name){
          stateid=StateList[i].id.toString();
          break;
        }

      }

      getCityList(stateid);
    }

  }


  Future<void> getAddreessListing() async {
    final param = {
      "user_id":userId,
      "accessToken":accessToken,

    };
    Map<String, dynamic>? response = await WebServicesHelper().getUserAddressListing(param);
    Utils().customPrint('response on view ${response?.toString()}');


    if (response != null) {
      AddressResponseModel responseModel =AddressResponseModel.fromJson(response);
      try {
        if (responseModel.status==200) {
          if(responseModel.error==false&& responseModel.data!=null && responseModel.data?.deliveryAddress!=null){
            addressList.clear();
            addressList.addAll(responseModel.data!.deliveryAddress as Iterable<AddressModel>);
            addressList.refresh();
          }
          print("address List size ==> ${addressList.value.length}");
        } else {

        }

      } catch (E) {


      }
    } else {
    }
  }

  Future<void> getCityList(String stateId) async {

    // showLoaderDialog(context);
    Map<String, dynamic>? response = await WebServicesHelper().getCityListAddress(stateId);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      StateResponseModel responseModel = StateResponseModel.fromJson(response);
      try {
        if (responseModel.status == 200) {
          // hideProgress(context);
          cityList.value.addAll(responseModel.data as Iterable);

          for(int i=0; i<cityList.length;i++){
            citySelectableList.add(cityList[i].name??'');
          }

          citySelectableList.refresh();

        } else {
          Utils.showCustomTosst("Login failed");
          // hideProgress(context);
        }

      } catch (E) {
        // hideProgress(context);

      }
    } else {

    }
  }

  Future<void> getStateList() async {

    // showLoaderDialog(context);
    Map<String, dynamic>? response = await WebServicesHelper().getStateList();
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      StateResponseModel responseModel = StateResponseModel.fromJson(response);
      try {
        if (responseModel.status == 200) {
          // hideProgress(context);
          StateList.value.addAll(responseModel.data as Iterable);

          for(int i=0; i<StateList.length;i++){
            StateSelectableList.add(StateList[i].name??'');
          }

          StateSelectableList.refresh();

        } else {
          Utils.showCustomTosst("Login failed");
          // hideProgress(context);
        }

      } catch (E) {
        // hideProgress(context);

      }
    } else {

    }
  }

  Future<void> saveUserAddress() async {
    BuildContext? context = Get.context;


    if(nameController.text.isEmpty){
      Utils.showCustomTosstError("Please enter name.");
      return;
    }

    if(mobileNumberController.text.isEmpty){
      Utils.showCustomTosstError("Please enter mobile number.");
      return;
    }

    if(selectedCity.isEmpty){
      Utils.showCustomTosstError("Please select city.");
      return;
    }


    if(selectedState.isEmpty){
      Utils.showCustomTosstError("Please select state.");
      return;
    }

    var selected_city="";
    for(int i=0;i<cityList.length;i++){

      if(selectedCity.value==cityList[i].name){
        selected_city=cityList[i].name.toString();
        break;
      }

    }

    var selected_state="";
    for(int i=0;i<StateList.length;i++){

      if(selectedState.value==StateList[i].name){
        selected_state=StateList[i].name.toString();
        break;
      }

    }

    final param = {
      "user_id": userId,
      "accessToken":accessToken,
      "delivery_address": {
        "full_name": nameController.text,
        "mobile_number": mobileNumberController.text,
        "address_line1": flatHoursAddressController.text,
        "address_line2":areaStreetController.text,
        "landmark": landMarkController.text,
        "city": selected_city,
        "state":selected_state,
        "postal_code": pincodeController.text,
        "latitude": pickupLocation.value.lat.toString(),
        "longitude": pickupLocation.value.log.toString(),
        "is_default": false,
        "is_active": true
      },
      "updated_by": userId,
      "updated_by_id": userId
    };
    showLoaderDialog(context!);


      Map<String, dynamic>? response = await WebServicesHelper().addUserAddress(param);
      Utils().customPrint('response on view ${response?.toString()}');

      if (response != null) {
        BaseResponse responseModel = BaseResponse.fromJson(response);
        try {
          if (responseModel.status == 200) {
            Utils.showCustomTosst(responseModel.message??'Resume uploaded Successfully');
            hideProgress(context);
            getAddreessListing();
            Get.back();
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




  Future<dynamic> getPlaceDetails(var placeid,String type) async {
    Map<String, dynamic>? response = await WebServicesHelper().placeDetailsApi(placeid);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      PlaceDetails responseModel = PlaceDetails.fromJson(response);
      try {
        if (responseModel.status == "OK") {
          double? long= responseModel.result?.geometry?.location?.lng??0.0;
          double? lat= responseModel.result?.geometry?.location?.lat??0.0;
          if(type=="pickup") {
            pickupLocation.value.lat = lat;
            pickupLocation.value.log = long;
          }
        }

      } catch (E) {
        // hideProgress(context);

      }
    } else {

    }

  }
  Future<dynamic> getPlaceDetails2(var placeid,String type,PharmacyController pharmacyController) async {
    Map<String, dynamic>? response = await WebServicesHelper().placeDetailsApi(placeid);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      PlaceDetails responseModel = PlaceDetails.fromJson(response);
      try {
        if (responseModel.status == "OK") {
          double? long= responseModel.result?.geometry?.location?.lng??0.0;
          double? lat= responseModel.result?.geometry?.location?.lat??0.0;
          List<AddressComponents>? addressComponents = responseModel.result?.addressComponents;
          // Find the component with type "locality"
          AddressComponents? cityComponent = addressComponents?.firstWhere(
                (component) => component.types?.contains('locality') ?? false,
          );
          PharmacyController controller = Get.put(PharmacyController());
          controller.city.value=cityComponent!.longName!;
          if(type=="pickup") {
            pickupLocation.value.lat = lat;
            pickupLocation.value.log = long;
            pharmacyController.lat.value=lat;
            pharmacyController.lng.value=long;
            pharmacyController.getPharmacyList();
          }
        }

      } catch (E) {
        // hideProgress(context);

      }
    } else {

    }

  }


  void placeAutoComplete() async {
    var query = searchCity.value.trim();
    Uri uri =
    Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": "AIzaSyAhch18P_emZhw7RkyewrmLNk8Snhs0w4U",
    });
    print("query==>"+query);
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      var decode = jsonDecode(response);
      var result = PlaceAutoCompleteResponse.fromJson(decode);

      if(result.predictions!=null){
        print(result.predictions.toString());
        if(predictions!=null&& predictions.length>0){
          predictions.clear();
        }

        predictions.addAll(result.predictions!);
        predictions.refresh();


      }
    }
  }



}