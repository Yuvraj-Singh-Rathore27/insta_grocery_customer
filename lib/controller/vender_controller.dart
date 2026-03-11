import 'dart:convert';
import 'dart:ffi';

import 'dart:io';
import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_grocery_customer/controller/user_profile_controller.dart';
import 'package:insta_grocery_customer/model/AppBaseErrorResponse.dart';
import 'package:insta_grocery_customer/model/DoctorListModel.dart';
import 'package:insta_grocery_customer/model/common_model_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/ProductModel.dart';
import '../model/autoComplete_prediction.dart';
import '../model/common_model.dart';
import '../model/file_model.dart';
import '../model/pharmacy_model.dart';
import '../model/place_auto_complete_response.dart';
import '../model/responsemodel/BaseResponse.dart';
import '../model/responsemodel/CommonResponseModel.dart';
import '../model/responsemodel/CommonResponseModelNew.dart';
import '../model/responsemodel/FileUploadResponseModel.dart';
import '../model/responsemodel/StateResponseModel.dart';
import '../model/responsemodel/doctors_list_response_model.dart';
import '../model/responsemodel/pharmacy_response_list.dart';
import '../model/responsemodel/pharmcy_product_response.dart';
import '../model/responsemodel/place_details_response.dart';
import '../model/responsemodel/product_type_response.dart';
import '../model/responsemodel/store_porfile_response_model.dart';
import '../model/responsemodel/sub_category_response_model.dart';
import '../model/state_model.dart';
import '../model/store_profile_model.dart';
import '../preferences/UserPreferences.dart';
import '../screen/daskboard/DashBord.dart';
import '../screen/daskboard/nearme_vender/store_details.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/ApiUrl.dart';
import '../webservices/WebServicesHelper.dart';
import 'package:get_storage/get_storage.dart';
import '../model/storeVideoModel.dart';

import '../model/storeOfferModel.dart';
import '../model/responsemodel/storeOfferResponse.dart';



import '../webservices/network_utility.dart';
import 'package:http/http.dart' as http;

class PharmacyController extends GetxController {
  SharedPreferences? prefs;
  String access_token = "";
  String user_id = "";
  TextEditingController contactNumberPikerController = TextEditingController();
  TextEditingController searchInputController = new TextEditingController();
  final placeController = TextEditingController();
  var pickupLocation = AutoCompletePrediction().obs;
  var addresssValue = "".obs;
  var location = Map<String, String>().obs;
  var contactNumberPiker = "".obs;
  var address = "".obs;
  final searchCity = "".obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchStoreTypeController = TextEditingController();
  TextEditingController medicanNameContoller = TextEditingController();
  TextEditingController mobileNumberCallForOrder = TextEditingController();
  var searchMedicanname = "".obs;
  var searchKeyword = "".obs;
  var pickedImage = Rxn<File>();   // store selected image

  RxList<AutoCompletePrediction> predictions = <AutoCompletePrediction>[].obs;
  RxList<PharmayModel> venderList = <PharmayModel>[].obs;
  // Get Intersted
  RxList<dynamic> interestedServiceList = <dynamic>[].obs;

  RxList<PharmayModel> HomeVendorList = <PharmayModel>[].obs;

  RxList<PharmayModel> favoriteslist = <PharmayModel>[].obs;
  RxList<CommonModel> venderCategory = <CommonModel>[].obs;
  RxList<CommonModel> storeTypeCategory = <CommonModel>[].obs;

  RxList<CommonModel> BusinessCategory = <CommonModel>[].obs;
  RxList<CommonModel> AerospaceList = <CommonModel>[].obs;
  RxList<CommonModel> hospitalList = <CommonModel>[].obs;
  RxList<CommonModel> AutomobilesList = <CommonModel>[].obs;
  RxList<CommonModel> AgricultureList = <CommonModel>[].obs;
  RxList<CommonModel> Business_Advertising_List = <CommonModel>[].obs;
  RxList<CommonModel> Building_Construction_List = <CommonModel>[].obs;
  RxList<CommonModel> Clothing_Textiles_List = <CommonModel>[].obs;
  RxList<CommonModel> Education_coaching_List = <CommonModel>[].obs;
  RxList<CommonModel> Electronics_Mobiles_List = <CommonModel>[].obs;
  RxList<CommonModel> Entertainment_Media_List = <CommonModel>[].obs;
  RxList<CommonModel> Fashion_Jeweller_List = <CommonModel>[].obs;
  RxList<CommonModel> Food_Restaurant_List = <CommonModel>[].obs;
  RxList<CommonModel> HomeDecors_List = <CommonModel>[].obs;
  RxList<CommonModel> Grocery_List = <CommonModel>[].obs;
  RxList<CommonModel> Healthcare_List = <CommonModel>[].obs;
  RxList<CommonModel> Hotels_Resorts_List = <CommonModel>[].obs;
  RxList<CommonModel> Household_List = <CommonModel>[].obs;
  RxList<CommonModel> IT_Services_List = <CommonModel>[].obs;
  RxList<CommonModel> Legal_services_List = <CommonModel>[].obs;
  RxList<CommonModel> Sports_Fitness_List = <CommonModel>[].obs;
  RxList<CommonModel> Pets_List = <CommonModel>[].obs;
  RxList<CommonModel> Printings_List = <CommonModel>[].obs;
  RxList<CommonModel> RealEstate_List = <CommonModel>[].obs;
  RxList<CommonModel> Public_Utility_List = <CommonModel>[].obs;
  RxList<CommonModel> Transport_List = <CommonModel>[].obs;
  RxList<CommonModel> Tourism_List = <CommonModel>[].obs;
  // store video 
  RxList<VideoModel> myVideos=<VideoModel>[].obs;
  RxList<VideoModel> videoCategouryList=<VideoModel>[].obs;
  Rx<VideoModel?> selectedCateoury = Rx<VideoModel?>(null);
   final videoCategoryController = TextEditingController();
   Rx<VideoModel?> selectedCategoryVideo = Rx<VideoModel?>(null);
   RxBool isReactingVideo=false.obs;
   
  RxMap<int, int> videoReactionMap = <int, int>{}.obs;

// 🔥 STORE VIDEO DETAIL PER VIDEO ID
RxMap<int, VideoModel> videoDetailMap = <int, VideoModel>{}.obs;
RxBool isLoadingVideoDetail = false.obs;

RxList<StoreOfferModel> homeOfferList = <StoreOfferModel>[].obs;
RxList<StoreOfferModel> nearbyOfferList = <StoreOfferModel>[].obs;

RxList<StoreOfferModel> storeOfferList = <StoreOfferModel>[].obs;
RxBool isLoadingBusinessCategory = false.obs;







  



  RxList<CommonModelNew> servicesList = <CommonModelNew>[].obs;
  var selectedServices = CommonModelNew().obs;

  var selectedVenderCategory = CommonModel().obs;
  var selectedBusinessCategory = CommonModel().obs;
  RxBool isLoading = true.obs;
  RxInt currentVideoIndex = 0.obs;
  var store;
  int pagenumber = 1;
// ---------------- >
  var errorMessage = ''.obs;

  final List<File> images = <File>[].obs;
  PickedFile? pickedFile;
  RxList fileList = <FileModel>[].obs;
  var selectedPharmacy = PharmayModel().obs;
  var storeCode = "".obs;
  var selectedCategory = CommonModel().obs;
  var selectedSubCategory = CommonModel().obs;
  var selectedChildSubCategory = CommonModel().obs;
  var selectedMedicanSubCategory = CommonModel().obs;
  RxList<CommonModel> subCategoryList = <CommonModel>[].obs;
  RxList<CommonModel> ChildSubCategoryList = <CommonModel>[].obs;
  RxList<CommonModel> categoryList = <CommonModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<CommonModel> medicanSubCategoryList = <CommonModel>[].obs;
  RxList<ProductModel> medicanesProductList = <ProductModel>[].obs;
  RxList<ProductModel> genricMedicanProductList = <ProductModel>[].obs;
  RxList<ProductModel> genricMedicanFavoritesProductList = <ProductModel>[].obs;
  RxList<ProductModel> favoriteMedicanesProductList = <ProductModel>[].obs;

  RxList<ProductModel> cartList = <ProductModel>[].obs;
  RxBool isLoadingVideos=false.obs;
  RxBool isLoadingCategory=false.obs;
  var paymentMethod = "1".obs;
  final lat = 0.0.obs, lng = 0.0.obs;
  var city = "".obs;
  var selectedCity = StateModel().obs;
  var state = "".obs;
  RxList venderTagsList = <StateModel>[].obs;
  var selectedTag = StateModel().obs;
  double getCartTotal() {
  double total = 0;
  for (var item in cartList) {
    total += (item.price ?? 0);
  }
  return total;
}


  //dummy banner

  List<String> facilityList = <String>[
    'Waiting Area',
    'Pharmacist Advice',
    'Pharmacy',
    'Wheel Chair Advice',
    'Drinking Water',
    'Upi/Card Payment',
    'Instant Home Delivery',
    'COD Available'
  ].obs;

  List<String> productCategories =
      <String>['Medicines', 'Medical Devices', 'Ortho Supports'].obs;

  List<String> banners = <String>['1', '2', '3'].obs;

  RxList cityList = <StateModel>[].obs;
  RxList filteredCityList = <StateModel>[].obs;

  RxList<LatLng> points = <LatLng>[].obs;

  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  var markers = <String, Marker>{}.obs;

  RxDouble lat1 = 28.5354.obs; // Example latitude
  RxDouble lng1 = 77.2639.obs; // Example longitude

  // 🔥 STORE VIDEO DETAIL PER VIDEO ID
 RxBool isLoadingOffer = false.obs;
RxBool isStoreBasedOffer = false.obs;

RxBool isLoadingHomeOffer = false.obs;
RxBool isLoadingStoreOffer = false.obs;
RxMap<int, String> storeLocationMap = <int, String>{}.obs;
Rx<DateTime> currentTime = DateTime.now().obs;
  Timer? _countdownTimer;




  //enquires

  TextEditingController nameController = TextEditingController();
  TextEditingController vehiclenameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  RxList<DoctorModelList> doctorList = <DoctorModelList>[].obs;
  var business_type='b2c'.obs;


  RxInt selectedBusinessCategoryId = 0.obs;
RxInt selectedVenderCategoryId = 0.obs;

// offer map screen 
RxMap<String, Marker> offerMarkers = <String, Marker>{}.obs;
RxList<OfferCategoryModel> offerCategories = <OfferCategoryModel>[].obs;
RxList<OfferSubCategoryModel> offerSubCategories = <OfferSubCategoryModel>[].obs;
RxInt selectedOfferSubCategoryId = 0.obs;
RxBool isLoadingOfferSubCategory = false.obs;
RxInt selectedOfferCategoryId = 0.obs;




  @override
Future<void> onInit() async {
  super.onInit();   // important!

  prefs = await SharedPreferences.getInstance();

  user_id = GetStorage().read(UserPreferences.user_id);
  access_token = GetStorage().read(UserPreferences.access_token);
  storeCode.value = GetStorage().read(UserPreferences.store_code) ?? "";

  print("getPharmacyController user_id: $user_id");
  print("access_token: $access_token");
  print("storeCode: ${storeCode.value}");

  // Run only if storeCode exists
  if (storeCode.value.isNotEmpty && storeCode.value.contains("FREBOO")) {
    String code = storeCode.value.replaceAll("FREBOO", "");
    getStoreDetails(code);
  }

  // Debounce searchCity
  debounce(
    searchCity,
    (_) {
      if (searchCity.value.length >= 3) {
        placeAutoComplete();
      }
    },
    time: Duration(seconds: 1),
  );

  
 _startCountdownTimer();
}

  onTagSelect(StateModel data) {
    selectedTag.value = data;
    if (venderTagsList != null) {
      for (var i = 0; i < venderTagsList.value.length; i++) {
        venderTagsList.value[i].isSelected = false;
      }

      for (var i = 0; i < venderTagsList.value.length; i++) {
        if (venderTagsList.value[i].id == data.id) {
          if (venderTagsList.value[i].isSelected == false) {
            venderTagsList.value[i].isSelected = true;
          } else {
            venderTagsList.value[i].isSelected = false;
          }
        }
      }
    }
    venderTagsList.refresh();
    // selectedCity.value=data;
    getPharmacyList();
  }

  List<VideoModel> get filteredVideos {
  if (selectedCategoryVideo.value == null) {
    return myVideos;
  }
  return myVideos
      .where((v) => v.videoCategoryId == selectedCategoryVideo.value!.id)
      .toList();
}

  void filterCityList(String query) {
    if (query.isEmpty) {
      filteredCityList.value = List.from(cityList);
    } else {
      filteredCityList.value = cityList.value
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Notify listeners if using a state management solution like Provider or GetX
  }

  Future<void> getCityList() async {
    // showLoaderDialog(context);

    Map<String, dynamic>? response =
        await WebServicesHelper().getCityList2(pagenumber, 100);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      StateResponseModel responseModel = StateResponseModel.fromJson(response);
      try {
        if (responseModel.status == 200) {
          if (responseModel.data != null && responseModel.data!.isNotEmpty) {
            // hideProgress(context);
            cityList.value.addAll(responseModel.data as Iterable);
            pagenumber = pagenumber + 1;
            print("cityList==> ${cityList.length}");
            filteredCityList.value.addAll(cityList.value);
            getCityList();
          }
        } else {
          Utils.showCustomTosst("Login failed");
          // hideProgress(context);
        }
      } catch (E) {
        // hideProgress(context);
      }
    } else {}
  }

  onCitySelect(StateModel data) {
    city.value = data.name.toString();
    selectedCity.value = data;
    getPharmacyList();
  }

  addToCart(ProductModel productModel) {
    if (cartList.isNotEmpty) {
      bool isfound = false;
      for (int i = 0; i < cartList.length; i++) {
        if (cartList[i].id == productModel.id) {
          int qty = cartList[i].quntityadded! + 1;
          cartList[i].quntityadded = qty;
          isfound = true;
        }
      }
      if (!isfound) {
        productModel.quntityadded = 1;
        cartList.add(productModel);
      }
    } else {
      productModel.quntityadded = 1;
      cartList.add(productModel);
    }

    Utils.showCustomTosst("Product added cart successfully");
  }

  updateQuantity(ProductModel productModel, String action) {
    switch (action) {
      case "delete":
        if (cartList.isNotEmpty) {
          bool isfound = false;
          for (int i = 0; i < cartList.length; i++) {
            if (cartList[i].id == productModel.id) {
              cartList.removeAt(i);
            }
          }
        }
        cartList.refresh();
        break;
      case "remove":
        if (cartList.isNotEmpty) {
          bool isfound = false;
          for (int i = 0; i < cartList.length; i++) {
            if (cartList[i].id == productModel.id) {
              int qty = cartList[i].quntityadded! - 1;
              print("qty==> ${qty}");
              if (qty == 0) {
                print("qty1==> ${qty}");
                cartList.removeAt(i);
                isfound = true;
              } else {
                cartList[i].quntityadded = qty;
                isfound = true;
              }
            }
          }
          if (!isfound) {
            productModel.quntityadded = 1;
            cartList.add(productModel);
          }
        }
        cartList.refresh();
        break;
      case "add":
        if (cartList.isNotEmpty) {
          bool isfound = false;
          for (int i = 0; i < cartList.length; i++) {
            if (cartList[i].id == productModel.id) {
              int qty = cartList[i].quntityadded! + 1;
              cartList[i].quntityadded = qty;
              isfound = true;
            }
          }
          if (!isfound) {
            productModel.quntityadded = 1;
            cartList.add(productModel);
          }
        }
        cartList.refresh();
        break;
    }
  }

  getFromGallery(isCamera) async {
    /*   image = (await ImagePicker().pickImage(source: ImageSource.gallery));
    iamges1 = image;*/
    pickedFile = await ImagePicker().getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      print('path is => ${pickedFile?.path ?? ''}');
      File imageFile = File(pickedFile?.path ?? '');
      print('abc path is => ${imageFile.absolute ?? ''}');
      fileUpload(imageFile);
      images?.add(imageFile);
    }
  }

  Future<void> fileUpload(File images) async {
    BuildContext? context = Get.context;

    String filePath = ApiUrl.fileUploadUrl;
    showLoaderDialog(context!);
    Map<String, dynamic>? response =
        await WebServicesHelper().fileUpload(filePath, images);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      FileUploadResponseModel baseResponse =
          FileUploadResponseModel.fromJson(response);
      try {
        if (baseResponse.status == 200) {
          print("Loop1====>");
          fileList.clear();
          fileList.add(baseResponse.data);
          Utils.showCustomTosst(baseResponse.message ?? "");
          hideProgress(context);
        } else {
          Utils.showCustomTosst("Error image uploaded");
          hideProgress(context);
        }
      } catch (E) {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  Future<void> getPharmacyList() async {
    print("Get Pharmacy list api calll------------------------------->");
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "city_id": selectedCity.value.id ?? 0,
      "store_type_id": selectedVenderCategory.value.id ?? 0,
      "lat": lat.value,
      "lng": lng.value,
    };
    if (selectedTag != null && selectedTag != 'null') {
      param["store_tag_id"] = selectedTag.value.id.toString();
    } else {
      param["store_tag_id"] = '';
    }
    Map<String, dynamic>? response =
        await WebServicesHelper().getPharmacyList(param);
    if (response != null) {
      if (response['error'] == false) {
        PharmacyResponseModelList jobListResponse =
            PharmacyResponseModelList.fromJson(response);
        try {
          if (jobListResponse.status == 200) {
            if (venderList.isNotEmpty) {
              venderList.clear();
            }
            if (jobListResponse.data != null) {
              if (venderList.isNotEmpty) {
                venderList.clear();
              }
              venderList.addAll(jobListResponse.data ?? []);
              if (points.length > 0) {
                points.clear();
              }
              markers.clear();
              for (int i = 0; i < venderList.value.length; i++) {
                if (venderList.value[i].longitude!.isNotEmpty &&
                    venderList.value[i].latitude!.isNotEmpty) {
                  var marker = Marker(
                    markerId: MarkerId(venderList.value[i].name ?? ''),
                    position: LatLng(
                        double.parse(venderList.value[i].latitude ?? '0.0'),
                        double.parse(venderList.value[i].longitude ?? '0.0')),
                    // position: LatLng(lat1.value,lng1.value),
                    // icon: BitmapDescriptor.,
                    infoWindow: InfoWindow(
                      title: venderList.value[i].name ?? '',
                      snippet: venderList.value[i].name ?? '',
                      onTap: () {
                        selectedPharmacy.value = venderList.value[i];

                        Get.to(() => StoreDetailsPage());
                        // Handle info window tap event
                        print(venderList.value[i].name);
                      },
                    ),
                  );
                  markers[venderList.value[i].id.toString()] = marker;

                  points.add(LatLng(
                      double.parse(venderList.value[i].latitude ?? '0.0'),
                      double.parse(venderList.value[i].longitude ?? '0.0')));
                }
              }
              // var marker =  Marker(
              //   markerId: MarkerId('Test data'),
              //   position: LatLng(lat1.value,lng1.value),
              //   // icon: BitmapDescriptor.,
              //   infoWindow: InfoWindow(
              //     title: 'Test data',
              //     snippet: 'Test data',
              //     onTap: () {
              //       // Handle info window tap event
              //       print('InfoWindow1 clicked for Test data');
              //     },
              //   ),
              // );
              // markers["vishnu"] = marker;

              print("Marker length====> ${markers.length}");
            }
          } else {
            Utils.showCustomTosst("Doctor list");
          }
          isLoading.value = false;
        } catch (E) {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        if (venderList.isNotEmpty) {
          venderList.clear();
        }
      }
    } else {
      isLoading.value = false;
    }
  }

  // these is for pharmacy list

  // Future<void> getHomePharmacyList() async {
  //   user_id = GetStorage().read(UserPreferences.user_id);
  //   access_token = GetStorage().read(UserPreferences.access_token);
  //   final param = {
  //     "user_id": user_id,
  //     "access_token": access_token,
  //     "city_id": selectedCity.value.id ?? 0,
  //     "store_type_id": selectedVenderCategory.value.id ?? 0,
  //     "lat": lat.value,
  //     "lng": lng.value,
  //   };
  //   if (selectedTag != null && selectedTag != 'null') {
  //     param["store_tag_id"] = selectedTag.value.id.toString();
  //   } else {
  //     param["store_tag_id"] = '';
  //   }
  //   Map<String, dynamic>? response =
  //       await WebServicesHelper().getHomePharmacyList(param);
  //   if (response != null) {
  //     if (response['error'] == false) {
  //       PharmacyResponseModelList jobListResponse =
  //           PharmacyResponseModelList.fromJson(response);
  //       try {
  //         if (jobListResponse.status == 200) {
  //           if (HomeVendorList.isNotEmpty) {
  //             HomeVendorList.clear();
  //           }
  //           if (jobListResponse.data != null) {
  //             if (HomeVendorList.isNotEmpty) {
  //               HomeVendorList.clear();
  //             }
  //             HomeVendorList.addAll(jobListResponse.data ?? []);
  //             if (points.length > 0) {
  //               points.clear();
  //             }
  //             markers.clear();
  //             for (int i = 0; i < HomeVendorList.value.length; i++) {
  //               if (HomeVendorList.value[i].longitude!.isNotEmpty &&
  //                   HomeVendorList.value[i].latitude!.isNotEmpty) {
  //                 var marker = Marker(
  //                   markerId: MarkerId(HomeVendorList.value[i].name ?? ''),
  //                   position: LatLng(
  //                       double.parse(HomeVendorList.value[i].latitude ?? '0.0'),
  //                       double.parse(
  //                           HomeVendorList.value[i].longitude ?? '0.0')),
  //                   // position: LatLng(lat1.value,lng1.value),
  //                   // icon: BitmapDescriptor.,
  //                   infoWindow: InfoWindow(
  //                     title: HomeVendorList.value[i].name ?? '',
  //                     snippet: HomeVendorList.value[i].name ?? '',
  //                     onTap: () {
  //                       selectedPharmacy.value = HomeVendorList.value[i];

  //                       Get.to(() => StoreDetailsPage());
  //                       // Handle info window tap event
  //                       print(HomeVendorList.value[i].name);
  //                     },
  //                   ),
  //                 );
  //                 markers[HomeVendorList.value[i].id.toString()] = marker;

  //                 points.add(LatLng(
  //                     double.parse(HomeVendorList.value[i].latitude ?? '0.0'),
  //                     double.parse(
  //                         HomeVendorList.value[i].longitude ?? '0.0')));
  //               }
  //             }
  //             // var marker =  Marker(
  //             //   markerId: MarkerId('Test data'),
  //             //   position: LatLng(lat1.value,lng1.value),
  //             //   // icon: BitmapDescriptor.,
  //             //   infoWindow: InfoWindow(
  //             //     title: 'Test data',
  //             //     snippet: 'Test data',
  //             //     onTap: () {
  //             //       // Handle info window tap event
  //             //       print('InfoWindow1 clicked for Test data');
  //             //     },
  //             //   ),
  //             // );
  //             // markers["vishnu"] = marker;

  //             print("Marker length====> ${markers.length}");
  //           }
  //         } else {
  //           Utils.showCustomTosst("Doctor list");
  //         }
  //         isLoading.value = false;
  //       } catch (E) {
  //         isLoading.value = false;
  //       }
  //     } else {
  //       isLoading.value = false;
  //       if (HomeVendorList.isNotEmpty) {
  //         HomeVendorList.clear();
  //       }
  //     }
  //   } else {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> getHomePharmacyList() async {
    try {
      isLoading.value = true;
      print("🚀 STARTING getHomePharmacyList API CALL");

      user_id = GetStorage().read(UserPreferences.user_id);
      access_token = GetStorage().read(UserPreferences.access_token);

      final param = {
        "user_id": user_id,
        "access_token": access_token,
        "city_id": selectedCity.value.id ?? 0,
        "store_type_id": selectedVenderCategory.value.id ?? 0,
        "lat": lat.value,
        "lng": lng.value,
        "store_tag_id": (selectedTag != null && selectedTag != 'null')
            ? selectedTag.value.id.toString()
            : '',
      };

      // ✅ Check if lat/lng available
      if (lat.value == 0.0 || lng.value == 0.0) {
        print("❌ Missing latitude/longitude");
        errorMessage.value = 'Please enable location services';
        return;
      }

      print("🌐 Calling HomePharmacyList API with params: $param");
      Map<String, dynamic>? response =
          await WebServicesHelper().getHomePharmacyList(param);

      print("🔍 FULL API RESPONSE: ${jsonEncode(response)}");

      if (response != null) {
        // Accept multiple response formats
        final hasData = response['data'] ?? response['result'];
        final statusOk =
            (response['status'] == 200 || response['success'] == true);

        if (statusOk && hasData is List && hasData.isNotEmpty) {
          print("🎯 Loaded ${hasData.length} facilities");

          HomeVendorList.clear();
          PharmacyResponseModelList jobListResponse =
              PharmacyResponseModelList.fromJson({'data': hasData});
          HomeVendorList.addAll(jobListResponse.data!);
        } else {
          print("⚠️ No facilities found in API response");
          HomeVendorList.clear();
          errorMessage.value =
              response['message'] ?? 'No healthcare facilities found';
        }
      } else {
        print("❌ NULL response from server");
        errorMessage.value = 'No response from server';
        HomeVendorList.clear();
      }
    } catch (e) {
      print("💥 EXCEPTION in getHomePharmacyList: $e");
      errorMessage.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
      print("🏁 getHomePharmacyList COMPLETED");
    }
  }

  Future<void> getTagServicesList() async {
    final param = {
      "store_type_id": selectedVenderCategory.value.id.toString() ?? "0",
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getTagServiceList(param);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      StateResponseModel responseModel = StateResponseModel.fromJson(response);
      try {
        if (responseModel.status == 200) {
          // hideProgress(context);
          venderTagsList.value.clear();
          venderTagsList.refresh();
          venderTagsList.value.addAll(responseModel.data as Iterable);
          // Sort by name (case insensitive)
          venderTagsList.value.sort((a, b) => (a.name ?? '')
              .toLowerCase()
              .compareTo((b.name ?? '').toLowerCase()));
          venderTagsList.refresh();
        } else {
          Utils.showCustomTosst("Not found");
          // hideProgress(context);
        }
      } catch (E) {
        // hideProgress(context);
      }
    } else {}
  }

  // Get Intersted Services

  Future<void> getInterestedServicesList() async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);

    final param = {
      "user_id": user_id,
      "access_token": access_token,
    };

    isLoading.value = true;
    print("🚀 STARTING getInterestedServicesList API CALL");

    Map<String, dynamic>? response =
        await WebServicesHelper().getIntersetedServices(param);

    if (response != null) {
      if (response['error'] == false) {
        try {
          if (response['status'] == 200) {
            final List<dynamic>? dataList = response['data'];

            if (dataList != null && dataList.isNotEmpty) {
              if (interestedServiceList.isNotEmpty) {
                interestedServiceList.clear();
              }

              interestedServiceList.addAll(dataList);
              print(
                  "🎯 Loaded ${interestedServiceList.length} interested services");
            } else {
              print("⚠️ No interested services found");
              interestedServiceList.clear();
            }
          } else {
            Utils.showCustomTosst(response['message'] ?? "No services found");
          }

          isLoading.value = false;
        } catch (e) {
          print("💥 Exception while parsing Interested Services: $e");
          isLoading.value = false;
        }
      } else {
        print("⚠️ API returned error: ${response['message']}");
        Utils.showCustomTosst(response['message'] ?? "Something went wrong");
        isLoading.value = false;
      }
    } else {
      print("❌ NULL response from getIntersetedServices API");
      isLoading.value = false;
    }

    print("🏁 getInterestedServicesList COMPLETED");
  }

  Future<void> getFavoritesPharmacyList() async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {"user_id": user_id, "access_token": access_token};
    Map<String, dynamic>? response =
        await WebServicesHelper().getFavoritePharmcyList(param);
    if (response != null) {
      if (response['error'] == false) {
        PharmacyResponseModelList jobListResponse =
            PharmacyResponseModelList.fromJson(response);
        try {
          if (jobListResponse.status == 200) {
            if (jobListResponse.data != null) {
              if (favoriteslist.isNotEmpty) {
                favoriteslist.clear();
              }
              favoriteslist.addAll(jobListResponse.data ?? []);
              // if(points.length>0){
              //   points.clear();
              // }
              // for(int i=0;i<list.value.length;i++){
              //
              //   if(list.value[i].longitude!.isNotEmpty && list.value[i].latitude!.isNotEmpty ){
              //
              //     var marker = Marker(
              //       markerId: MarkerId(list.value[i].name??''),
              //       position: LatLng(double.parse(list.value[i].latitude??'0.0'),
              //           double.parse(list.value[i].longitude??'0.0')),
              //       // position: LatLng(lat1.value,lng1.value),
              //       // icon: BitmapDescriptor.,
              //       infoWindow: InfoWindow(
              //         title: list.value[i].name??'',
              //         snippet: list.value[i].name??'',
              //         onTap: () {
              //           Get.to(() =>  PharmacyDetails(data: list.value[i]));
              //           // Handle info window tap event
              //           print(list.value[i]);
              //         },
              //       ),
              //     );
              //     markers[list.value[i].id.toString()] = marker;
              //
              //     points.add(LatLng(double.parse(list.value[i].latitude??'0.0'),
              //         double.parse(list.value[i].longitude??'0.0')));
              //   }
              // }
              // var marker =  Marker(
              //   markerId: MarkerId('Test data'),
              //   position: LatLng(lat1.value,lng1.value),
              //   // icon: BitmapDescriptor.,
              //   infoWindow: InfoWindow(
              //     title: 'Test data',
              //     snippet: 'Test data',
              //     onTap: () {
              //       // Handle info window tap event
              //       print('InfoWindow1 clicked for Test data');
              //     },
              //   ),
              // );
              // markers["vishnu"] = marker;

              // print("Marker length====> ${markers.length}");
            }
          } else {
            Utils.showCustomTosst("Doctor list");
          }
          isLoading.value = false;
        } catch (E) {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  // favorites
  Future<void> addFavoritesPharmacy(var pharmcy_id) async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "entity_id": pharmcy_id,
      "vendor_type": ApiUrl.providerTypePharmacy,
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "access_token": access_token,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().addFavoritesPharmacy(param);
    if (response != null) {
      BaseResponse jobListResponse = BaseResponse.fromJson(response);
      try {
        if (jobListResponse.status == "200") {
          Utils.showCustomTosst(jobListResponse.message ?? '');
        } else {
          Utils.showCustomTosst(jobListResponse.message ?? '');
        }
        isLoading.value = false;
      } catch (E) {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> deleteFavoritesPharmacy(var pharmcy_id) async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "entity_id": pharmcy_id,
      "vendor_type": ApiUrl.providerTypePharmacy,
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "access_token": access_token,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().deleteFavoritesItemPharmacy(param);
    if (response != null) {
      BaseResponse jobListResponse = BaseResponse.fromJson(response);
      try {
        if (jobListResponse.status == "200") {
          Utils.showCustomTosst(jobListResponse.message ?? '');
          getFavoritesPharmacyList();
        } else {
          Utils.showCustomTosst(jobListResponse.message ?? '');
          getFavoritesPharmacyList();
        }
        isLoading.value = false;
      } catch (E) {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> addFavoritesMedicine(int index, var pharmacy_product_id,
      var pharmacy_product_type, var type) async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "vendor_type": ApiUrl.providerTypePharmacy,
      "created_by": user_id,
      "pharmacy_product_type": pharmacy_product_type,
      "pharmacy_product_id": pharmacy_product_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "access_token": access_token,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().addFavoritesPharmacy(param);
    if (response != null) {
      BaseResponse jobListResponse = BaseResponse.fromJson(response);
      try {
        if (jobListResponse.status == "200") {
          if (type == "1") {
            medicanesProductList[index].isfavorite = true;
            medicanesProductList.refresh();
          } else {
            genricMedicanProductList[index].isfavorite = true;
            genricMedicanProductList.refresh();
          }

          Utils.showCustomTosst(jobListResponse.message ?? '');
        } else {
          if (type == "1") {
            medicanesProductList[index].isfavorite = true;
            medicanesProductList.refresh();
          } else {
            genricMedicanProductList[index].isfavorite = true;
            genricMedicanProductList.refresh();
          }

          Utils.showCustomTosst(jobListResponse.message ?? '');
        }
        isLoading.value = false;
      } catch (E) {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> getFavoriteMedicineList() async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "vendor_type": ApiUrl.providerTypePharmacy,
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "access_token": access_token,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getFavoriteMedicanList(param);
    if (response != null) {
      // hideProgress(context);

      PhmarcyProductResponse responeModel =
          PhmarcyProductResponse.fromJson(response);
      try {
        if (responeModel.status == 200 && responeModel.data!.isNotEmpty) {
          if (genricMedicanFavoritesProductList.length > 0) {
            genricMedicanFavoritesProductList.clear();
          }
          if (favoriteMedicanesProductList.length > 0) {
            favoriteMedicanesProductList.clear();
          }
          List<ProductModel> allList = <ProductModel>[];
          allList.addAll(responeModel.data!);

          List<ProductModel> genric = <ProductModel>[];
          List<ProductModel> medicanList = <ProductModel>[];
          for (int i = 0; i < allList.length; i++) {
            if (allList[i].medicine_type == "generic") {
              genric.add(allList[i]);
            } else {
              medicanList.add(allList[i]);
            }
          }

          favoriteMedicanesProductList.addAll(medicanList);
          favoriteMedicanesProductList.refresh();

          genricMedicanFavoritesProductList.addAll(genric);
          genricMedicanFavoritesProductList.refresh();
        } else {
          if (genricMedicanFavoritesProductList.length > 0) {
            genricMedicanFavoritesProductList.clear();
          }
          Utils.showCustomTosst(responeModel.message ?? '');
        }
        isLoading.value = false;
      } catch (E) {
        // hideProgress(context);
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      // hideProgress(context);
    }
  }

  Future<void> deleteFavoriteMedicine(var pharmacy_product_id) async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "pharmacy_product_id": pharmacy_product_id,
      "vendor_type": ApiUrl.providerTypePharmacy,
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "access_token": access_token,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().deleteFavoriteMedicine(param);
    if (response != null) {
      BaseResponse jobListResponse = BaseResponse.fromJson(response);
      try {
        if (jobListResponse.status == "200") {
          Utils.showCustomTosst(jobListResponse.message ?? '');
          getFavoriteMedicineList();
        } else {
          Utils.showCustomTosst(jobListResponse.message ?? '');
          getFavoriteMedicineList();
        }
        isLoading.value = false;
      } catch (E) {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> pharmacyOrderCreate(int pharmacy_id) async {
    if (pickupLocation == null) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }
    if (location.isEmpty) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }

    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    if (fileList.length == 0) {
      Utils.showCustomTosst("Please upload precision");
      return;
    }
    BuildContext? context = Get.context;
    showLoaderDialog(context!);
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "pharmacy_id": pharmacy_id.toString(),
      "prescription": fileList.value[0].path.toString(),
      "cash_on_delivery": true,
      "comments": "",
      'delivery_address': location.toJson(),
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "transaction_id": "",
      "booking_by": "user",
      "user_id": user_id,
      "store_id": pharmacy_id,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().pharmacyOrderCreate(param);
    if (response != null) {
      if (response['error'] == false) {
        BaseResponse baseResponse = BaseResponse.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            Utils.showCustomTosst(baseResponse.message ?? "");
            hideProgress(context);
            Get.to(() => DashBord(0, ""));
          } else {
            hideProgress(context);
            Utils.showCustomTosst("Some error please try again later");
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  Future<dynamic> getPlaceDetails(var placeid, String type) async {
    Map<String, dynamic>? response =
        await WebServicesHelper().placeDetailsApi(placeid);
    Utils().customPrint('response on view ${response?.toString()}');

    if (response != null) {
      PlaceDetails responseModel = PlaceDetails.fromJson(response);
      try {
        if (responseModel.status == "OK") {
          double? long = responseModel.result?.geometry?.location?.lng ?? 0.0;
          double? lat = responseModel.result?.geometry?.location?.lat ?? 0.0;
          if (type == "pickup") {
            pickupLocation.value.lat = lat;
            pickupLocation.value.log = long;
            location.value = {
              'address': pickupLocation.value.description.toString(),
              'lat': lat.toString(),
              'long': long.toString(),
            };
          }
        }
      } catch (E) {
        // hideProgress(context);
      }
    } else {}
  }

  void placeAutoComplete() async {
    var query = searchCity.value.trim();
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": "AIzaSyAhch18P_emZhw7RkyewrmLNk8Snhs0w4U",
    });
    print("query==>" + query);
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      var decode = jsonDecode(response);
      var result = PlaceAutoCompleteResponse.fromJson(decode);

      if (result.predictions != null) {
        print(result.predictions.toString());
        if (predictions != null && predictions.length > 0) {
          predictions.clear();
        }

        predictions.addAll(result.predictions!);
        predictions.refresh();
      }
    }
  }

  getTotalAmount() {
    double finalAmount = 0;
    try {
      for (int i = 0; i < cartList.length; i++) {
        print("====>" + cartList[i].discount_price);
        var totalAmount = double.parse(cartList[i].quntityadded.toString()) *
                double.parse(cartList[i].discount_price) ??
            0.0;
        finalAmount = finalAmount + double.parse(totalAmount.toString());
      }
    } catch (E) {
      finalAmount = 0;
    }

    return finalAmount;
  }

  Future<void> pharmacyOrderCreateWithAddProduct() async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    if (pickupLocation == null) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }
    List products = [];
    double finalAmount = 0;
    for (int i = 0; i < cartList.length; i++) {
      var total_amount = double.parse(cartList[i].quntityadded.toString()) *
              double.parse(cartList[i].discount_price) ??
          0.0;
      finalAmount = finalAmount + double.parse(total_amount.toString());
      var data = {
        'id': cartList[i].id,
        'name': cartList[i].name ?? 'Product Name',
        'quantity': cartList[i].quntityadded,
        'delivery_address': pickupLocation.value.description.toString(),
        'total_amount': total_amount,
        "store_id": selectedPharmacy.value.id.toString(),
        'amount': cartList[i].price,
        'discount_price': cartList[i].discount_price,
        'cash_on_delivery': true
      };
      products.add(data);
    }

    BuildContext? context = Get.context;
    showLoaderDialog(context!);
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "pharmacy_id": selectedPharmacy.value.id.toString(),
      "products": products,
      "cash_on_delivery": true,
      "amount": finalAmount.toString(),
      "comments": "",
      "store_id": selectedPharmacy.value.id.toString(),
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by": user_id,
      'transaction_id': '',
      "updated_by_id": user_id,
      "booking_by": "user",
      "user_id": user_id,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().pharmacyOrderCreate(param);
    if (response != null) {
      if (response['error'] == false) {
        BaseResponse baseResponse = BaseResponse.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            Utils.showCustomTosst(baseResponse.message ?? "");
            hideProgress(context);
            cartList.clear();
            cartList.refresh();
            Get.to(() => DashBord(0, ""));
          } else {
            hideProgress(context);
            Utils.showCustomTosst("Some error please try again later");
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  getAddressFromLatLng(double lat, double lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url =
        '$_host?key=AIzaSyAhch18P_emZhw7RkyewrmLNk8Snhs0w4U&language=en&latlng=$lat,$lng';
    print("url==>" + url);
    if (lat != null && lng != null) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data == null && data["results"].lenght > 0) {
          return;
        }
        print(data.toString());
        String _formattedAddress = data["results"][0]["formatted_address"];
        final components = data['results'][0]['address_components'];

        for (var component in components) {
          final types = component['types'] as List;
          if (types.contains('locality')) {
            city.value = component['long_name'];
          }

          if (types.contains('administrative_area_level_1')) {
            state.value = component['long_name'];
          }
        }

        pickupLocation.value.lat = lat;
        pickupLocation.value.log = lng;
        data = {
          'description': _formattedAddress,
        };
        location.value = {
          'address': _formattedAddress.toString(),
          'lat': lat.toString(),
          'long': lng.toString(),
        };
        searchInputController.text = _formattedAddress.toString();
        pickupLocation.value.description = _formattedAddress;
        print("response111 ==== $_formattedAddress");
        addresssValue.value = _formattedAddress.toString();
        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }

  void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

//   call on phone

  void gotoChoosePharmcy() {
    if (mobileNumberCallForOrder.text == "") {
      Utils.showCustomTosst("Enter Mobile Number");
      return;
    }
    if (pickupLocation == null) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }
    if (location.isEmpty) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }

    // Get.to(() => PharmacyChooseForOrderPhoneListing());
  }

  Future<void> placOrderByPhone() async {
    if (pickupLocation == null) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }
    if (location.isEmpty) {
      Utils.showCustomTosstError("Please Select address.");
      return;
    }
    // if(mobileNumberCallForOrder.text.isEmpty){
    //   Utils.showCustomTosstError("Please enter mobile number .");
    //   return;
    // }

    if (fileList.length == 0) {
      Utils.showCustomTosstError("Please upload image .");
      return;
    }

    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);

    BuildContext? context = Get.context;
    showLoaderDialog(context!);
    // location['phone']=mobileNumberCallForOrder.text;

    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "store_id": selectedPharmacy.value.id.toString(),
      "cash_on_delivery": true,
      "comments": "",
      'delivery_address': location.toJson(),
      "created_by": user_id,
      "created_by_id": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id,
      "transaction_id": "",
      "phone": mobileNumberCallForOrder.text,
      "products_by_image": fileList.value[0].path.toString(),
      "booking_by": "user",
      "user_id": user_id,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().pharmacyOrderCreate(param);
    if (response != null) {
      if (response['error'] == false) {
        BaseResponse baseResponse = BaseResponse.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            Utils.showCustomTosst(baseResponse.message ?? "");
            hideProgress(context);
            Get.to(() => DashBord(0, ""));
          } else {
            hideProgress(context);
            Utils.showCustomTosst("Some error please try again later");
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  // Future<void> getBusinessTypecategory() async {
  //   BuildContext? context = Get.context;
  //   showLoaderDialog(context!);

  //   final param = {
  //     "user_id": user_id,
  //     "access_token": access_token,
  //     "business_type":business_type.value
  //   };
  //   Map<String, dynamic>? response =
  //       await WebServicesHelper().getBusinessTypeCategory(param);
  //   if (response != null) {
  //     if (response['error'] == false) {
  //       CommonResponseModel baseResponse =
  //           CommonResponseModel.fromJson(response);
  //       try {
  //         if (baseResponse.status == 200) {
  //           Utils.showCustomTosst(baseResponse.message ?? "");
  //           BusinessCategory.clear();
  //           BusinessCategory.addAll(baseResponse.data as Iterable<CommonModel>);
  //           BusinessCategory.sort(
  //               (a, b) => a.name.toString().compareTo(b.name.toString()));

  //           AerospaceList.addAll(BusinessCategory.where((item) =>
  //               item.name == "Aerospace & Drones" ||
  //               item.name == "Automobile Showrooms" ||
  //               item.name == "Automobile Service & Spares" ||
  //               item.name == "Automobile Services" ||
  //               item.name == "Pre owned vehicles" ||
  //               item.name?.trim().toString() == "Automobile Showrooms"));
  //           AerospaceList.refresh();

  //           hospitalList.addAll(BusinessCategory.where((item) =>
  //               item.name == "Home Nursing" ||
  //               item.name == "Surgical stores" ||
  //               item.name == "Dental care" ||
  //               item.name == "Ayush" ||
  //               item.name == "Pre owned vehicles" ||
  //               item.name?.trim().toString() == "Physiotherapy" ||
  //               item.name?.trim().toString() == "Opticals" ||
  //               item.name?.trim().toString() == "Scan centers" ||
  //               item.name?.trim().toString() == "Laboratories" ||
  //               item.name?.trim().toString() == "Pharmacies" ||
  //               item.name?.trim().toString() == "Hospitals & Clinics"));
  //           hospitalList.refresh();

  //           // AutomobilesList.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Automobile Showrooms"
  //           //     ||  item.name == "Automobile Service & Spares"
  //           //     ||  item.name == "Pre owned vehicles"
  //           //
  //           //     )
  //           // );
  //           // AutomobilesList.refresh();

  //           AgricultureList.addAll(BusinessCategory.where((item) =>
  //               item.name == "Agriculture Automobiles" ||
  //               item.name == "Agriculture Services" ||
  //               item.name == "Agriculture Equipments" ||
  //               item.name == "Agri Automobiles" ||
  //               item.name == "Agri Services" ||
  //               item.name == "Agri Automobiles" ||
  //               item.name == "Agri Services"));
  //           AgricultureList.refresh();

  //           Business_Advertising_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Advertising" ||
  //               item.name == "Business services" ||
  //               item.name == "Business consultants" ||
  //               item.name == "Finance & Insurances" ||
  //               item.name == "Accountings" ||
  //               item.name == "Financial services" ||
  //               item.name == "Jobs and Matrimony" ||
  //               item.name == "Jobs & Matrimony" ||
  //               item.name == "Advertising and Marketing" ||
  //               item.name == "Business services" ||
  //               item.name == "Finance and Accountings" ||
  //               item.name == "Financial services and Investments" ||
  //               item.name == "Jobs and Matrimony" ||
  //               item.name == "Employment & Matrimony" ||
  //               item.name == "Jobs & Matrimony services"));
  //           Business_Advertising_List.refresh();

  //           Building_Construction_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Building construction" ||
  //               item.name == "Building construction" ||
  //               item.name == "Building Construction" ||
  //               item.name == "Building Materials" ||
  //               item.name == "Tiles & Granites" ||
  //               item.name == "Tiles & Granites " ||
  //               item.name == "Clothing and Textiles" ||
  //               item.name == "Clothing & Textiles"));
  //           Building_Construction_List.refresh();

  //           // Clothing_Textiles_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //
  //           //     )
  //           // );
  //           // Clothing_Textiles_List.refresh();
  //           Education_coaching_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Education and Coaching" ||
  //               item.name == "Education & Coaching" ||
  //               item.name == "Education & Coaching" ||
  //               item.name == "Books and Stationary" ||
  //               item.name == "Books & Stationary" ||
  //               item.name == "Electronics & Mobiles" ||
  //               item.name == "Electronics and  Mobiles"));
  //           Education_coaching_List.refresh();
  //           //
  //           // Electronics_Mobiles_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //
  //           //
  //           //     )
  //           // );
  //           // Electronics_Mobiles_List.refresh();

  //           Entertainment_Media_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Entertainment and Media" ||
  //               item.name == "News & Media" ||
  //               item.name == "Entertainment services" ||
  //               item.name == "Fashion & Jewellery" ||
  //               item.name == "Leather and Footwear" ||
  //               item.name == "Leather & Footwear" ||
  //               item.name == "News and Media" ||
  //               item.name == "Saloon services" ||
  //               item.name == "Fashion and Jewellery" ||
  //               item.name == "Leather goods"));
  //           Entertainment_Media_List.refresh();

  //           // Fashion_Jeweller_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Saloon services"||
  //           //         item.name == "Fashion and Jewellery"
  //           //        ||  item.name == "Leather goods"
  //           //     )
  //           // );
  //           // Fashion_Jeweller_List.refresh();

  //           Food_Restaurant_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Foods and Restaurants" ||
  //               item.name == "Foods & Restaurants" ||
  //               item.name == "Furniture & Decors" ||
  //               item.name == "Furniture and Home decors"));
  //           Food_Restaurant_List.refresh();

  //           // HomeDecors_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Furniture and Home decors"
  //           //     )
  //           // );
  //           // HomeDecors_List.refresh();

  //           Grocery_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Grocery and Daily needs" ||
  //               item.name == "Grocery & Daily needs" ||
  //               item.name == "Ambulances" ||
  //               item.name == "Ambulance services" ||
  //               item.name == "Healthcare and Medical services" ||
  //               item.name == "Healthcare services" ||
  //               item.name == "Wellness and Spa"));
  //           Grocery_List.refresh();

  //           // Healthcare_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Ambulance services"
  //           //     || item.name == "Healthcare and Medical services"
  //           //     || item.name == "Wellness and Spa"
  //           //     )
  //           // );
  //           // Healthcare_List.refresh();

  //           Hotels_Resorts_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Hotels and Resorts" ||
  //               item.name == "Hotels & Resorts" ||
  //               item.name == "Household services"));
  //           Hotels_Resorts_List.refresh();

  //           // Household_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Household services"
  //           //     )
  //           // );
  //           // Household_List.refresh();

  //           IT_Services_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "IT Services & technology" ||
  //               item.name == "IT & technology" ||
  //               item.name == "Legal services" ||
  //               item.name == "Legal Advisors and services"));
  //           IT_Services_List.refresh();

  //           // Legal_services_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Legal Advisors and services"
  //           //     )
  //           // );
  //           // Legal_services_List.refresh();

  //           Sports_Fitness_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Sports and Fitness" ||
  //               item.name == "Sports & Fitness" ||
  //               item.name == "Pets & Pet supplies" ||
  //               item.name == "Pets and Pet supplies" ||
  //               item.name == "Pets & supplies"));
  //           Sports_Fitness_List.refresh();

  //           // Pets_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Pets and Pet supplies"
  //           //     )
  //           // );
  //           // Pets_List.refresh();

  //           Printings_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Printing services" ||
  //               item.name == "Printing services" ||
  //               item.name == "Printing Services" ||
  //               item.name == "Real estate and Land developers" ||
  //               item.name == "Real estate"));
  //           Printings_List.refresh();

  //           // RealEstate_List.addAll(
  //           //     BusinessCategory.where((item) =>
  //           //     item.name == "Real estate and Land developers"
  //           //     )
  //           // );
  //           // RealEstate_List.refresh();

  //           Public_Utility_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Public utilities" ||
  //               item.name == "Spiritual and Astrology" ||
  //               item.name == "Spiritual & Astrology"));
  //           Public_Utility_List.refresh();

  //           Transport_List.addAll(BusinessCategory.where((item) =>
  //               item.name == "Couriers & Parcels" ||
  //               item.name == "Transportation and Logistics" ||
  //               item.name == "Transportation & Logistics" ||
  //               item.name == "Tourism & Travels" ||
  //               item.name == "Couriers and Deliveries" ||
  //               item.name == "Tourism and Travels"));
  //           Transport_List.refresh();

  //           Tourism_List.addAll(BusinessCategory.where(
  //               (item) => item.name == "Tourism and Travels"));
  //           Tourism_List.refresh();

  //           hideProgress(context);
  //         } else {
  //           hideProgress(context);
  //           ;
  //         }
  //       } catch (E) {
  //         hideProgress(context);
  //       }
  //     } else {
  //       hideProgress(context);
  //     }
  //   } else {
  //     hideProgress(context);
  //   }
  // }

  Future<void> getBusinessTypecategory() async {
  BuildContext? context = Get.context;

  // ✅ LOADER ON
  isLoadingBusinessCategory.value = true;

  final param = {
    "user_id": user_id,
    "access_token": access_token,
    "business_type": business_type.value
  };

  Map<String, dynamic>? response =
      await WebServicesHelper().getBusinessTypeCategory(param);

  if (response != null) {
    if (response['error'] == false) {
      CommonResponseModel baseResponse =
          CommonResponseModel.fromJson(response);
      try {
        if (baseResponse.status == 200) {
          Utils.showCustomTosst(baseResponse.message ?? "");

          BusinessCategory.clear();
          BusinessCategory.addAll(
              baseResponse.data as Iterable<CommonModel>);

          BusinessCategory.sort(
              (a, b) => a.name.toString().compareTo(b.name.toString()));

          AerospaceList.clear();
          AerospaceList.addAll(BusinessCategory.where((item) =>
              item.name == "Aerospace & Drones" ||
              item.name == "Automobile Showrooms" ||
              item.name == "Automobile Service & Spares" ||
              item.name == "Automobile Services" ||
              item.name == "Pre owned vehicles" ||
              item.name?.trim() == "Automobile Showrooms"));
          AerospaceList.refresh();

          hospitalList.clear();
          hospitalList.addAll(BusinessCategory.where((item) =>
              item.name == "Home Nursing" ||
              item.name == "Surgical stores" ||
              item.name == "Dental care" ||
              item.name == "Ayush" ||
              item.name?.trim() == "Physiotherapy" ||
              item.name?.trim() == "Opticals" ||
              item.name?.trim() == "Scan centers" ||
              item.name?.trim() == "Laboratories" ||
              item.name?.trim() == "Pharmacies" ||
              item.name?.trim() == "Hospitals & Clinics"));
          hospitalList.refresh();

          AgricultureList.clear();
          AgricultureList.addAll(BusinessCategory.where((item) =>
              item.name == "Agriculture Automobiles" ||
              item.name == "Agriculture Services" ||
              item.name == "Agriculture Equipments" ||
              item.name == "Agri Automobiles" ||
              item.name == "Agri Services"));
          AgricultureList.refresh();

          Business_Advertising_List.clear();
          Business_Advertising_List.addAll(BusinessCategory.where((item) =>
              item.name == "Advertising" ||
              item.name == "Business services" ||
              item.name == "Business consultants" ||
              item.name == "Finance & Insurances" ||
              item.name == "Accountings" ||
              item.name == "Financial services" ||
              item.name == "Jobs and Matrimony" ||
              item.name == "Jobs & Matrimony" ||
              item.name == "Advertising and Marketing" ||
              item.name == "Finance and Accountings" ||
              item.name == "Financial services and Investments" ||
              item.name == "Employment & Matrimony" ||
              item.name == "Jobs & Matrimony services"));
          Business_Advertising_List.refresh();

          Building_Construction_List.clear();
          Building_Construction_List.addAll(BusinessCategory.where((item) =>
              item.name == "Building construction" ||
              item.name == "Building Construction" ||
              item.name == "Building Materials" ||
              item.name == "Tiles & Granites" ||
              item.name == "Clothing and Textiles" ||
              item.name == "Clothing & Textiles"));
          Building_Construction_List.refresh();

          Education_coaching_List.clear();
          Education_coaching_List.addAll(BusinessCategory.where((item) =>
              item.name == "Education and Coaching" ||
              item.name == "Education & Coaching" ||
              item.name == "Books and Stationary" ||
              item.name == "Books & Stationary" ||
              item.name == "Electronics & Mobiles" ||
              item.name == "Electronics and  Mobiles"));
          Education_coaching_List.refresh();

          Entertainment_Media_List.clear();
          Entertainment_Media_List.addAll(BusinessCategory.where((item) =>
              item.name == "Entertainment and Media" ||
              item.name == "News & Media" ||
              item.name == "Entertainment services" ||
              item.name == "Fashion & Jewellery" ||
              item.name == "Leather and Footwear" ||
              item.name == "Saloon services" ||
              item.name == "Leather goods"));
          Entertainment_Media_List.refresh();

          Food_Restaurant_List.clear();
          Food_Restaurant_List.addAll(BusinessCategory.where((item) =>
              item.name == "Foods and Restaurants" ||
              item.name == "Foods & Restaurants" ||
              item.name == "Furniture & Decors" ||
              item.name == "Furniture and Home decors"));
          Food_Restaurant_List.refresh();

          Grocery_List.clear();
          Grocery_List.addAll(BusinessCategory.where((item) =>
              item.name == "Grocery and Daily needs" ||
              item.name == "Grocery & Daily needs" ||
              item.name == "Ambulances" ||
              item.name == "Ambulance services" ||
              item.name == "Healthcare and Medical services" ||
              item.name == "Healthcare services" ||
              item.name == "Wellness and Spa"));
          Grocery_List.refresh();

          Hotels_Resorts_List.clear();
          Hotels_Resorts_List.addAll(BusinessCategory.where((item) =>
              item.name == "Hotels and Resorts" ||
              item.name == "Hotels & Resorts" ||
              item.name == "Household services"));
          Hotels_Resorts_List.refresh();

          IT_Services_List.clear();
          IT_Services_List.addAll(BusinessCategory.where((item) =>
              item.name == "IT Services & technology" ||
              item.name == "IT & technology" ||
              item.name == "Legal services" ||
              item.name == "Legal Advisors and services"));
          IT_Services_List.refresh();

          Sports_Fitness_List.clear();
          Sports_Fitness_List.addAll(BusinessCategory.where((item) =>
              item.name == "Sports and Fitness" ||
              item.name == "Sports & Fitness" ||
              item.name == "Pets & Pet supplies" ||
              item.name == "Pets and Pet supplies" ||
              item.name == "Pets & supplies"));
          Sports_Fitness_List.refresh();

          Printings_List.clear();
          Printings_List.addAll(BusinessCategory.where((item) =>
              item.name == "Printing services" ||
              item.name == "Printing Services" ||
              item.name == "Real estate and Land developers" ||
              item.name == "Real estate"));
          Printings_List.refresh();

          Public_Utility_List.clear();
          Public_Utility_List.addAll(BusinessCategory.where((item) =>
              item.name == "Public utilities" ||
              item.name == "Spiritual and Astrology" ||
              item.name == "Spiritual & Astrology"));
          Public_Utility_List.refresh();

          Transport_List.clear();
          Transport_List.addAll(BusinessCategory.where((item) =>
              item.name == "Couriers & Parcels" ||
              item.name == "Transportation and Logistics" ||
              item.name == "Transportation & Logistics" ||
              item.name == "Tourism & Travels" ||
              item.name == "Couriers and Deliveries" ||
              item.name == "Tourism and Travels"));
          Transport_List.refresh();

          Tourism_List.clear();
          Tourism_List.addAll(
              BusinessCategory.where((item) =>
                  item.name == "Tourism and Travels"));
          Tourism_List.refresh();
        }
      } catch (e) {
        print("getBusinessTypecategory ERROR => $e");
      }
    }
  }

  // ✅ LOADER OFF (MOST IMPORTANT)
  isLoadingBusinessCategory.value = false;
}


  Future<void> getStoreTypeCategory() async {
    BuildContext? context = Get.context;
    showLoaderDialog(context!);
    print("store_group_id==>" + selectedBusinessCategory.value.id.toString());
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "store_group_id": selectedBusinessCategory.value.id.toString(),
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getStoreTypeCategory(param);
    if (response != null) {
      if (response['error'] == false) {
        CommonResponseModel baseResponse =
            CommonResponseModel.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            Utils.showCustomTosst(baseResponse.message ?? "");
            venderCategory.clear();
            venderCategory.addAll(baseResponse.data as Iterable<CommonModel>);
            venderCategory
                .sort((a, b) => a.name.toString().compareTo(b.name.toString()));

            hideProgress(context);
          } else {
            hideProgress(context);
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  Future<void> getMainCatgory() async {
    BuildContext? context = Get.context;
    // showLoaderDialog(context!);

    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "store_type_id": selectedVenderCategory.value.id.toString(),
    };
    print("DTAA==>" + param.toString());
    Map<String, dynamic>? response =
        await WebServicesHelper().getMainCatgory(param);
    if (response != null) {
      if (response['error'] == false) {
        CommonResponseModel baseResponse =
            CommonResponseModel.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            // Utils.showCustomTosst(baseResponse.message??"");
            categoryList.clear();
            List<CommonModel> temcategoryList = <CommonModel>[];
            temcategoryList.addAll(baseResponse.data as Iterable<CommonModel>);
            temcategoryList.sort((a, b) {
              return (a.name ?? '').compareTo(b.name ?? '');
            });

            categoryList.addAll(temcategoryList);
            categoryList.refresh();
            // categoryList.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
            // hideProgress(context);
          } else {
            // hideProgress(context);;
          }
        } catch (E) {
          // hideProgress(context);
        }
      } else {
        // hideProgress(context);
      }
    } else {
      // hideProgress(context);
    }
  }

  Future<void> getSubcatgory() async {
    BuildContext? context = Get.context;
    showLoaderDialog(context!);

    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "product_category_id": selectedCategory.value.id.toString(),
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getSubcatgory(param);
    if (response != null) {
      if (response['error'] == false) {
        CommonResponseModel baseResponse =
            CommonResponseModel.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            Utils.showCustomTosst(baseResponse.message ?? "");

            List<CommonModel> temcategoryList = <CommonModel>[];
            temcategoryList.addAll(baseResponse.data as Iterable<CommonModel>);
            temcategoryList.sort((a, b) {
              return (a.name ?? '').compareTo(b.name ?? '');
            });

            subCategoryList.clear();
            subCategoryList.addAll(temcategoryList);
            getProductList();
            // if(subCategoryList.isNotEmpty){
            //   selectedSubCategory.value=subCategoryList[0];
            //   // getProductList();
            //   // getChildSubCategory();
            // }
            hideProgress(context);
          } else {
            hideProgress(context);
            ;
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  Future<void> getChildSubCategory() async {
    BuildContext? context = Get.context;
    showLoaderDialog(context!);

    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "product_sub_category_id": selectedSubCategory.value.id.toString(),
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getChildSubCategory(param);
    if (response != null) {
      if (response['error'] == false) {
        CommonResponseModel baseResponse =
            CommonResponseModel.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            // Utils.showCustomTosst(baseResponse.message??"");
            ChildSubCategoryList.clear();
            ChildSubCategoryList.addAll(
                baseResponse.data as Iterable<CommonModel>);
            hideProgress(context);
          } else {
            hideProgress(context);
            ;
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  Future<void> getProductList() async {
    print("ENTER===>");
    var param = {
      "pharmacy_id": selectedPharmacy.value.id.toString(),
      "access_token": access_token,
      "category_id": selectedCategory.value.id.toString(),
      // "sub_category_id": selectedSubCategory.value.id.toString(),
      // "store_id":selectedPharmacy.value.id.toString()
      // "category_id": selectedCategory.value.id.toString(),
      // "category_id": "12",
      // "sub_category_id": "6",
      "store_id": selectedPharmacy.value.id.toString()
    };
    BuildContext? context = Get.context;
    showLoaderDialog(context!);

    Map<String, dynamic>? response =
        await WebServicesHelper().getProductList(param);

    if (response != null) {
      hideProgress(context);

      PhmarcyProductResponse responeModel =
          PhmarcyProductResponse.fromJson(response);
      try {
        if (responeModel.status == 200 && responeModel.data!.isNotEmpty) {
          if (productList.length > 0) {
            productList.clear();
          }
          productList.addAll(responeModel.data!);
        } else {
          if (productList.length > 0) {
            productList.clear();
          }
          Utils.showCustomTosst("No product found");
        }
        isLoading.value = false;
      } catch (E) {
        hideProgress(context);
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      hideProgress(context);
    }
  }

  Future<void> getStoreDetails(store_id) async {
    print("store_id==> ${store_id.toString()}");
    final param = {"store_id": store_id, "access_token": access_token};
    Map<String, dynamic>? response =
        await WebServicesHelper().getStoreDetails(param);
    Utils().customPrint('getStoreDetails---> on view ${response?.toString()}');

    if (response != null) {
      StoreDetailsResponseModel baseResponse =
          StoreDetailsResponseModel.fromJson(response);
      try {
        if (baseResponse.status == 200) {
          StoreProfileModel? storeProfileModel = baseResponse.data;
          var data = {
            "name": storeProfileModel?.name ?? '',
            "id": storeProfileModel?.id ?? 0
          };
          selectedPharmacy.value = PharmayModel.fromJson(data);

          print("getStoreDetails==>" + selectedPharmacy.value.toString());

          List<StoreTypeModel>? storetList = baseResponse.data?.storeType;
          if (storetList != null && storetList.length > 0) {
            var storeType = {
              "name": storetList[0].storeType?.name ?? '',
              "id": storetList[0].storeType?.id ?? 0,
            };
            selectedVenderCategory.value = CommonModel.fromJson(storeType);

            print(
                "getStoreDetails==>" + selectedVenderCategory.value.toString());
          }
          getMainCatgory();
        } else {
          // Utils.showCustomTosst("Login failed2");
          // hideProgress(context);
        }
      } catch (E) {
        print("getStoreDetails--->${E.toString()}");
      }
    } else {
      print("getStoreDetails--->else");
    }
  }

  Future<void> createLog(store_id, action_type) async {
    print("store_id==> ${store_id.toString()}");
    final param = {
      "store_id": store_id,
      "user_id": user_id,
      "action_type": action_type,
      "access_token": access_token,
      "host_name": "host_name",
      "ip_address": "ip_address",
      "application_name": "Customer",
      "target_object": store_id.toString(),
    };

    Map<String, dynamic>? response = await WebServicesHelper().createLog(param);
    Utils().customPrint('getStoreDetails---> on view ${response?.toString()}');

    if (response != null) {
      BaseResponse baseResponse = BaseResponse.fromJson(response);
      try {
        if (baseResponse.status == 200) {
          print("Event save--->");
          // Utils.showCustomTosst("event info save successfully");
        } else {
          // Utils.showCustomTosst("Login failed2");
          // hideProgress(context);
        }
      } catch (E) {
        print("Event save--->${E.toString()}");
      }
    } else {
      // print("getStoreDetails--->else");
    }
  }

  Future<void> getStoreTypeCategorySearch(name) async {
    BuildContext? context = Get.context;
    showLoaderDialog(context!);
    print("store_group_id==>" + selectedBusinessCategory.value.id.toString());
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "name": name,
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getStoreTypeCategorySearch(param);
    if (response != null) {
      if (response['error'] == false) {
        CommonResponseModel baseResponse =
            CommonResponseModel.fromJson(response);
        try {
          if (baseResponse.status == 200) {
            Utils.showCustomTosst(baseResponse.message ?? "");
            storeTypeCategory.clear();
            storeTypeCategory
                .addAll(baseResponse.data as Iterable<CommonModel>);
            storeTypeCategory
                .sort((a, b) => a.name.toString().compareTo(b.name.toString()));

            hideProgress(context);
          } else {
            hideProgress(context);
          }
        } catch (E) {
          hideProgress(context);
        }
      } else {
        hideProgress(context);
      }
    } else {
      hideProgress(context);
    }
  }

  Future<List<LatLng>> getRoute(double slatitude, double longitude,
      double dlatitude, double dlongitude) async {
    print(
        'origin=${slatitude},${longitude}&destination=${dlatitude},${dlongitude}');

    // dlatitude=28.5089564;
    // dlongitude=77.2100563;
    List<LatLng> points = <LatLng>[];
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${slatitude},${longitude}&destination=${dlatitude},${dlongitude}&key=AIzaSyAhch18P_emZhw7RkyewrmLNk8Snhs0w4U'));

    print("response===> ${response.body}");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      points =
          _decodePolyline(json['routes'][0]['overview_polyline']['points']);
      return points;
    }
    return points;
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  Future<void> getServicesListApi() async {
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "store_type_id": selectedVenderCategory.value.id.toString(),
      "store_id": selectedPharmacy.value.id.toString(),
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().getServicesListByStoreId(param);
    if (response != null) {
      CommonResponseModelNew baseResponse =
          CommonResponseModelNew.fromJson(response);
      if (baseResponse.status == 200) {
        // Utils.showCustomTosst(baseResponse.message??"");
        servicesList.clear();
        servicesList.addAll(baseResponse.data as Iterable<CommonModelNew>);
        servicesList
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<bool> addIntrestedServicesByUser() async {
    UserProfileController userProfileController =
        Get.put(UserProfileController());
    nameController.text =
        userProfileController.userData.value.data?.userProfile?.firstName ?? '';
    // userProfileController.userData.value.data?.userProfile?.lastName;
    mobileNumberController.text =
        userProfileController.userData.value.data!.contactNumber!;
    BuildContext? context = Get.context;
    if (vehiclenameController.text.toString() == "") {
      Utils.showCustomTosstError("Please enter  Name");
      return false;
    }

    // if(nameController.text.toString()==""){
    //   Utils.showCustomTosstError("Please enter name");
    //   return;
    // }
    // if(mobileNumberController.text.toString()==""){
    //   Utils.showCustomTosstError("Please enter mobile number");
    //   return;
    // }
    if (descriptionController.text.toString().isEmpty) {
      Utils.showCustomTosstError("Please enter description");
      return false;
    }
    showLoaderDialog(context!);
    user_id = GetStorage().read(UserPreferences.user_id);
    access_token = GetStorage().read(UserPreferences.access_token);
    final param = {
      "user_id": user_id,
      "access_token": access_token,
      "store_id": selectedPharmacy.value.id.toString(),
      "service_id": selectedServices.value.id.toString(),
      "customer_name": nameController.text.toString(),
      "vehicle_name": vehiclenameController.text.toString(),
      "customer_number": mobileNumberController.text.toString(),
      "description": descriptionController.text.toString(),
      "created_by": "",
      "photo": fileList.isNotEmpty
    ? fileList.map((e) => {"url": e.path.toString()}).toList()
    : [],


  "created_by_id": user_id,
      "created_by": user_id,
      "updated_by": user_id,
      "updated_by_id": user_id
    };
    Map<String, dynamic>? response =
        await WebServicesHelper().addIntrestedServicesByUser(param);
    if (response != null) {
      BaseResponse baseResponse = BaseResponse.fromJson(response);
      if (baseResponse.status == 200) {
        Utils.showCustomTosst(baseResponse.message ?? "");
        hideProgress(context);
      }
      hideProgress(context);
      return true;
    } else {
      hideProgress(context);
      return false;
    }
  }

  /// Get doctors list - Filter by store_id
  Future<void> getDoctorsListUrl() async {
    try {
      // Include store_id in the request parameters
      final param = {
        "accessToken": access_token,
        "store_id": selectedPharmacy.value.id
            .toString() // Add store_id to filter doctors by store
      };

      isLoading.value = true;

      Map<String, dynamic>? response =
          await WebServicesHelper().getDoctorsList(param);
      if (response != null) {
        DoctorsResponseModel responseModel =
            DoctorsResponseModel.fromJson(response);
        if (responseModel.status == 200) {
          doctorList.clear();

          // Filter doctors by store_id if needed (optional - backend should handle this)
          final allDoctors = responseModel.data ?? [];
          doctorList.addAll(allDoctors);
          doctorList.refresh();
          print("Loaded ${doctorList.length} doctors for store $user_id");
        } else {
          Utils.showCustomTosstError(
              responseModel.message ?? "Failed to load doctors");
        }
      } else {
        Utils.showCustomTosstError("Failed to load doctors list");
      }
    } catch (e) {
      print("Error loading doctors: $e");
      Utils.showCustomTosstError("Error loading doctors");
    } finally {
      isLoading.value = false;
    }
  }


Future<void> calculateDistanceForSelectedPharmacy() async {
  try {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double shopLat = double.tryParse(selectedPharmacy.value.latitude ?? "0") ?? 0;
    double shopLng = double.tryParse(selectedPharmacy.value.longitude ?? "0") ?? 0;

    double distanceInMeters = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      shopLat,
      shopLng,
    );

    selectedPharmacy.value.distance = distanceInMeters / 1000;
    selectedPharmacy.refresh();

    print("Distance calculated = ${selectedPharmacy.value.distance}");
  } catch (e) {
    print("ERROR calculating distance: $e");
  }
}




// GET STORE VIDEOS 

 Future<void> getAllVideoCategoryApi() async {
    isLoadingCategory.value = true;

    final response =
        await WebServicesHelper().getAllStoreVideoCategoury({});

    isLoadingCategory.value = false;

    if (response != null && response['status'] == 200) {
      final List list = response['data'] ?? [];

      videoCategouryList.value =
          list.map((e) => VideoModel.fromJson(e)).toList();

      if (videoCategouryList.isNotEmpty) {
        selectedCateoury.value = videoCategouryList.first;
        videoCategoryController.text =
            videoCategouryList.first.id.toString();
      }
    } else {
      Utils.showCustomTosstError(
        response?['message'] ?? "Failed to load categories",
      );
    }
  }


Future<void> getStoreVideoApi() async {
  // 🔐 Token check
  if (access_token.isEmpty) {
    Utils.showCustomTosstError("Unauthorized");
    return;
  }

  isLoadingVideos.value = true;

  try {
    final int? storeId = selectedPharmacy.value.id; // ✅ int OR null

    // 🔥 PARAM BUILD (IMPORTANT PART)
    final Map<String, dynamic> param = {
      "access_token": access_token,
    };

    // ✅ ONLY ADD store_id IF IT EXISTS
    if (storeId != null) {
      param["store_id"] = storeId;
    }

    final response =
        await WebServicesHelper().getStoreVideo(param);

    if (response != null && response['status'] == 200) {
      final List list = response['data'] ?? [];

      myVideos.value =
          list.map((e) => VideoModel.fromJson(e)).toList();

      videoReactionMap.clear();

      // 🔥 Load first video detail (optional)
      if (myVideos.isNotEmpty) {
        getVideoDetail(myVideos.first.id);
      }
    } else {
      Utils.showCustomTosstError(
        response?['message'] ?? "Failed to load videos",
      );
    }
  } catch (e) {
    Utils.showCustomTosstError("Something went wrong");
    print("getStoreVideoApi ERROR => $e");
  } finally {
    isLoadingVideos.value = false;
  }
}


  // store video reaction
Future<void> postVideoReaction({
  required int videoId,
  int? reaction,
  String? comment,
}) async {
  try {
    if (isReactingVideo.value) return; // 🔒 debounce
    isReactingVideo.value = true;

    final Map<String, dynamic> param = {
      "video_id": videoId,
      "user_id": user_id,
      "created_by": user_id,
      "created_by_id": user_id,
    };

    // ✅ SEND ONLY ONE THING
    if (reaction != null) {
      param["reaction"] = reaction;
    }

    if (comment != null && comment.trim().isNotEmpty) {
      param["comment"] = comment.trim();
    }

    final response =
        await WebServicesHelper().postStoreReactionVideo(param);

    if (response != null && response['status'] == 200) {
      await getVideoDetail(videoId);
    }
  } catch (e) {
    print("postVideoReaction ERROR => $e");
  } finally {
    isReactingVideo.value = false;
  }
}





Future<void> getVideoDetail(int videoId) async {
  try {
    isLoadingVideoDetail.value = true;

    final param = {
      "video_id": videoId.toString(), // 🔴 VERY IMPORTANT (string)
    };

    final response = await WebServicesHelper()
        .getAllStoreVideoDescreptionDetail(param);

    isLoadingVideoDetail.value = false;

    if (response != null && response['status'] == 200) {
      // ✅ response['data'] contains { video, stats, reactions }
     videoDetailMap[videoId] =
    VideoModel.fromJson(response['data']);

    } else {
      Utils.showCustomTosstError(
        response?['message'] ?? "Failed to load video detail",
      );
    }
  } catch (e) {
    isLoadingVideoDetail.value = false;
    print("getVideoDetail ERROR => $e");
    Utils.showCustomTosstError("Something went wrong");
  }
}



Map<String, dynamic> getMyReactionData(int videoId) {
final detail = videoDetailMap[videoId];  if (detail == null) {
    return {"reaction": 0, "comment": ""};
  }

  final myReaction = detail.reactions.firstWhereOrNull(
    (r) => r['user']?['id'] == int.tryParse(user_id),
  );

  return {
    "reaction": myReaction?['reaction'] ?? 0,
    "comment": myReaction?['comment'] ?? "",
  };
}



// get store api 
Future<void> getStoreOfferApi({int? storeId}) async {
  try {
    isLoadingOffer.value = true;

    final Map<String, dynamic> param = {
      "access_token": access_token,
      if (storeId != null) "store_id": storeId,
    };

    print("📦 OFFER PARAM => $param");

    final response =
        await WebServicesHelper().getStoreOffer(param);

    if (response == null) {
      if (storeId != null) {
        storeOfferList.clear();
      } else {
        homeOfferList.clear();
      }
      return;
    }

    final offerResponse =
        StoreOfferResponseModel.fromJson(response);

    if (offerResponse.error == false &&
        offerResponse.data != null) {

      if (storeId != null) {
        storeOfferList
          ..clear()
          ..addAll(offerResponse.data!);

        print("🏪 STORE OFFERS => ${storeOfferList.length}");
      } else {
        homeOfferList
          ..clear()
          ..addAll(offerResponse.data!);
        filterNearbyOffers();
        await loadNearbyOffersOnMap();


        print("🏠 HOME OFFERS => ${homeOfferList.length}");
        print("🏠 HOME OFFERS => ${homeOfferList.length}");
      }

    } else {
      if (storeId != null) {
        storeOfferList.clear();
      } else {
        homeOfferList.clear();
      }
    }
  } catch (e) {
    print("❌ getStoreOfferApi ERROR => $e");
  } finally {
    isLoadingOffer.value = false;
  }
}

Future<void> fetchStoreLocation(StoreOfferModel offer) async {
  try {
    if (offer.store?.latitude == null ||
        offer.store?.longitude == null ||
        offer.store?.id == null) return;

    final lat = double.tryParse(offer.store!.latitude!);
    final lng = double.tryParse(offer.store!.longitude!);

    if (lat == null || lng == null) return;

    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final locationName =
          "${place.subLocality ?? ''}, ${place.locality ?? ''}".trim();

      storeLocationMap[offer.store!.id!] =
          locationName.isNotEmpty ? locationName : "Nearby";
    }
  } catch (e) {
    print("❌ Reverse geocoding error: $e");
  }
}


void _startCountdownTimer() {
  _countdownTimer?.cancel();

  _countdownTimer =
      Timer.periodic(const Duration(seconds: 1), (timer) {
    currentTime.value = DateTime.now();
  });
}



// filter for nearby offer show only  
void filterNearbyOffers({double radiusKm = 50}) {
  nearbyOfferList.clear();

  if (lat.value == 0.0 || lng.value == 0.0) {
    print("User location not available");
    return;
  }

  for (var offer in homeOfferList) {
    final storeLat = double.tryParse(offer.store?.latitude ?? "");
    final storeLng = double.tryParse(offer.store?.longitude ?? "");

    if (storeLat == null || storeLng == null) continue;

    double distanceInMeters = Geolocator.distanceBetween(
      lat.value,
      lng.value,
      storeLat,
      storeLng,
    );

    double distanceKm = distanceInMeters / 1000;

    if (distanceKm <= radiusKm) {
      nearbyOfferList.add(offer);
    }
  }

  print("Nearby offers count = ${nearbyOfferList.length}");
}


Future<void> loadNearbyOffersOnMap() async {
  offerMarkers.clear();

  for (var offer in nearbyOfferList) {
    final latStr = offer.store?.latitude;
    final lngStr = offer.store?.longitude;

    if (latStr == null || lngStr == null) continue;

    final lat = double.tryParse(latStr);
    final lng = double.tryParse(lngStr);

    if (lat == null || lng == null) continue;

    final marker = Marker(
      markerId: MarkerId("offer_${offer.id}"),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: offer.name ?? "Offer",
        snippet: offer.store?.name ?? "",
      ),
    );

    offerMarkers["offer_${offer.id}"] = marker;
  }
}
Future<void> getOfferCategoriesApi() async {
  try {
    isLoadingCategory.value = true;

    Map<String, dynamic>? response =
        await WebServicesHelper().getStoreOfferCategory({});

    if (response != null && response['status'] == 200) {

      final List list = response['data'] ?? [];

      offerCategories.clear();

      offerCategories.addAll(
        list.map((e) => OfferCategoryModel.fromJson(e)).toList(),
      );

      // ✅ ✅ ADD THIS SORTING PART
      offerCategories.sort((a, b) =>
          (a.name ?? "")
              .toLowerCase()
              .compareTo((b.name ?? "").toLowerCase()));

      offerCategories.refresh();

      print("Offer Categories Loaded => ${offerCategories.length}");
    } else {
      print("Offer category API failed");
    }
  } catch (e) {
    print("getOfferCategoriesApi ERROR => $e");
  } finally {
    isLoadingCategory.value = false;
  }
}

Future<void> getOfferSubCategoriesApi(int categoryId) async {
  try {
    isLoadingOfferSubCategory.value = true;

    final param = {
      "offer_category_id": categoryId,
    };

    Map<String, dynamic>? response =
        await WebServicesHelper().getStoreOfferSubCategory(param);

    if (response != null && response['status'] == 200) {
      final List list = response['data'] ?? [];

      offerSubCategories.clear();
      offerSubCategories.addAll(
        list.map((e) => OfferSubCategoryModel.fromJson(e)).toList(),
      );

      print("Subcategories Loaded => ${offerSubCategories.length}");
    } else {
      offerSubCategories.clear();
    }
  } catch (e) {
    print("getOfferSubCategoriesApi ERROR => $e");
  } finally {
    isLoadingOfferSubCategory.value = false;
  }
}



// void filterNearbyOffersByCategory({double radiusKm = 50}) {
//   nearbyOfferList.clear();

//   if (lat.value == 0.0 || lng.value == 0.0) return;

//   for (var offer in homeOfferList) {

//     // Category filter
//     if (selectedOfferCategoryId.value != 0 &&
//         offer.offerCategoryId != selectedOfferCategoryId.value) {
//       continue;
//     }

//     final storeLat = double.tryParse(offer.store?.latitude ?? "");
//     final storeLng = double.tryParse(offer.store?.longitude ?? "");

//     if (storeLat == null || storeLng == null) continue;

//     double distanceInMeters = Geolocator.distanceBetween(
//       lat.value,
//       lng.value,
//       storeLat,
//       storeLng,
//     );

//     double distanceKm = distanceInMeters / 1000;

//     if (distanceKm <= radiusKm) {
//       nearbyOfferList.add(offer);
//     }
//   }

//   loadNearbyOffersOnMap();
// }


void filterNearbyOffersByCategory({double radiusKm = 50}) {
  nearbyOfferList.clear();

  if (lat.value == 0.0 || lng.value == 0.0) return;

  for (var offer in homeOfferList) {

    // Category filter
    if (selectedOfferCategoryId.value != 0 &&
        offer.offerCategoryId != selectedOfferCategoryId.value) {
      continue;
    }

    // Subcategory filter
    if (selectedOfferSubCategoryId.value != 0 &&
        offer.subcategory?.id != selectedOfferSubCategoryId.value) {
      continue;
    }

    final storeLat = double.tryParse(offer.store?.latitude ?? "");
    final storeLng = double.tryParse(offer.store?.longitude ?? "");

    if (storeLat == null || storeLng == null) continue;

    double distanceInMeters = Geolocator.distanceBetween(
      lat.value,
      lng.value,
      storeLat,
      storeLng,
    );

    double distanceKm = distanceInMeters / 1000;

    if (distanceKm <= radiusKm) {
      nearbyOfferList.add(offer);
    }
  }

  loadNearbyOffersOnMap();
}








 

  
}

