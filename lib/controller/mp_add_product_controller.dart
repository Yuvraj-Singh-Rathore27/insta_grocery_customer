import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/common_model.dart';
import '../model/file_model.dart';
import '../model/ProductModel.dart';
import '../model/responsemodel/FileUploadResponseModel.dart';
import '../preferences/UserPreferences.dart';
import '../screen/dialog/helperProgressBar.dart';
import '../utills/Utils.dart';
import '../webservices/ApiUrl.dart';
import '../webservices/WebServicesHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';


class MpAddProductController extends GetxController {
  late GetStorage store;
  String userId = "";
  String access_token = "";
  PickedFile? pickedFile;
  RxList fileList = <FileModel>[].obs;
  final List<File> images = <File>[].obs;

  RxList<CommonModel> brandsList = <CommonModel>[].obs;
  RxList<CommonModel> categoryList = <CommonModel>[].obs;
  RxList<CommonModel> subCategoryList = <CommonModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> filteredProductList = <ProductModel>[].obs;



  TextEditingController searchController = TextEditingController();

  var selectedBrands = CommonModel().obs;
  var selectedMainCategory = CommonModel().obs;
  var selectedSubCategory = CommonModel().obs;
  var selectedChildSubCategory = CommonModel().obs;


  // Existing controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController decriptionController = TextEditingController();
  TextEditingController hashtagController=TextEditingController();
  TextEditingController productpriceController = TextEditingController();
  TextEditingController productOfferpriceController = TextEditingController();

  // New controllers for additional fields
  TextEditingController titleController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController selfLifeController = TextEditingController();
  TextEditingController manufacturerDetailsController = TextEditingController();
  TextEditingController discountPercentageController = TextEditingController();
  TextEditingController compositionsController = TextEditingController();
  TextEditingController sizesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController packSizeController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController cityNameController= TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  // Get Selecyt State 
  RxList<CommonModel> stateList=<CommonModel>[].obs;
  var selectedState=CommonModel().obs;
  // Add Variables to Store City List
  RxList<CommonModel> cityList=<CommonModel>[].obs;
  var selectedCity=CommonModel().obs;

  RxList<MpSuperCategoryModel> superCategoryList =
    <MpSuperCategoryModel>[].obs;

var selectedSuperCategory = MpSuperCategoryModel().obs;
final RxBool isLoading = false.obs;
RxList<dynamic> placeSuggestions = <dynamic>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    store = GetStorage();
    userId = store.read(UserPreferences.user_id);
    access_token = store.read(UserPreferences.access_token) ?? "";
    print("User ID: $userId");
    print("Access Token: $access_token");
    
    // Load categories and brands when controller initializes
    
    loadBrands();
    loadStates();
    loadMarketPlaceProducts();
    loadSuperCategories();
   
  }

  // load city 

  Future<void> loadCities(String stateId) async {
  print("🌍 Loading cities for state: $stateId");

  try {
    Map<String, dynamic>? response =
        await WebServicesHelper().getCityListAddress(stateId);

    if (response != null && response['status'] == 200) {
      cityList.clear();

      if (response['data'] != null) {
        List<dynamic> cityData = response['data'];

        for (var item in cityData) {
          cityList.add(CommonModel.fromJson(item));
        }

        print("✅ Loaded ${cityList.length} cities");
      }
    } else {
      print("❌ Failed to load cities: ${response?['message']}");
      Utils.showCustomTosst("Failed to load cities");
    }
  } catch (e) {
    print("🔥 Error loading cities: $e");
    Utils.showCustomTosst("Error loading cities");
  }

  update();
}

  // Load State 
  Future<void> loadStates() async {
    print("Loading states...");
    try {
      Map<String, dynamic>? response = await WebServicesHelper().getStateList();

      if (response != null && response['status'] == 200) {
        print("States loaded successfully");
        stateList.clear();
        
        if (response['data'] != null) {
          List<dynamic> stateData = response['data'];
          for (var item in stateData) {
            stateList.add(CommonModel.fromJson(item));
          }
          print("Loaded ${stateList.length} states");
        }
      } else {
        print("Failed to load states: ${response?['message']}");
        Utils.showCustomTosst("Failed to load states");
      }
    } catch (e) {
      print("Error loading states: $e");
      Utils.showCustomTosst("Error loading states");
    }
    update();
  }

  // Updated onSelectCategory method to include state
  onSelectCatrgory(var data, String type) {
  print("Selected $type: ${data.name} (ID: ${data.id})");

  if (type == 'super_category') {
    selectedSuperCategory.value = data;

    // 🔥 RESET BELOW DATA
    selectedMainCategory.value = CommonModel();
    selectedSubCategory.value = CommonModel();

    categoryList.clear();
    subCategoryList.clear();

    // 🔥 LOAD CATEGORY BASED ON SUPER CATEGORY
    if (data.id != null) {
      loadCategoriesBySuperId(data.id.toString());
    }
  }

  else if (type == 'category') {
    selectedMainCategory.value = data;

    selectedSubCategory.value = CommonModel();
    subCategoryList.clear();

    if (data.id != null) {
      loadSubCategories(data.id.toString());
    }
  }

  else if (type == 'subcategory') {
    selectedSubCategory.value = data;
  }

  else if (type == 'brands') {
    selectedBrands.value = data;
  }

  else if (type == 'state') {
    selectedState.value = data;
    stateNameController.text = data.id?.toString() ?? '';
    loadCities(data.id.toString());
  }

  else if (type == 'city') {
    selectedCity.value = data;
    stateNameController.text = data.id?.toString() ?? '';
  }

  update();
}

Future<void> loadCategoriesBySuperId(String superId) async {
  print("📦 Loading categories for Super Category: $superId");

  try {
    Map<String, dynamic>? response =
        await WebServicesHelper().getMpcategoryList({
      'access_token': access_token,
      'super_category_id': superId, // 🔥 IMPORTANT
    });

    if (response != null && response['status'] == 200) {
      categoryList.clear();

      if (response['data'] != null) {
        for (var item in response['data']) {
          categoryList.add(CommonModel.fromJson(item));
        }

        print("✅ Loaded ${categoryList.length} categories");
      }
    } else {
      Utils.showCustomTosst("Failed to load categories");
    }
  } catch (e) {
    print("Error: $e");
  }

  update();
}


  // Load categories method
  // Load brands method
  Future<void> loadBrands() async {
    print("Loading brands...");
    try {
      Map<String, dynamic>? response = await WebServicesHelper().getMPBrandList({
        'access_token': access_token,
      });

      if (response != null && response['status'] == 200) {
        print("Brands loaded successfully");
        brandsList.clear();
        
        if (response['data'] != null) {
          List<dynamic> brandData = response['data'];
          for (var item in brandData) {
            brandsList.add(CommonModel.fromJson(item));
          }
          print("Loaded ${brandsList.length} brands");
        }
      } else {
        print("Failed to load brands: ${response?['message']}");
        Utils.showCustomTosst("Failed to load brands");
      }
    } catch (e) {
      print("Error loading brands: $e");
      Utils.showCustomTosst("Error loading brands");
    }
    update();
  }

  // Load subcategories method
  Future<void> loadSubCategories(String categoryId) async {
    print("Loading subcategories for category: $categoryId");
    try {
      Map<String, dynamic>? response = await WebServicesHelper().getMpSubcatgory({
        'access_token': access_token,
        'category_id': categoryId,
      });

      if (response != null && response['status'] == 200) {
        print("Subcategories loaded successfully");
        subCategoryList.clear();
        
        if (response['data'] != null) {
          List<dynamic> subCategoryData = response['data'];
          for (var item in subCategoryData) {
            subCategoryList.add(CommonModel.fromJson(item));
          }
          print("Loaded ${subCategoryList.length} subcategories");
        }
      } else {
        print("Failed to load subcategories: ${response?['message']}");
        Utils.showCustomTosst("Failed to load subcategories");
      }
    } catch (e) {
      print("Error loading subcategories: $e");
      Utils.showCustomTosst("Error loading subcategories");
    }
    update();
  }


  
Future<void> loadSuperCategories() async {
  print("📦 Loading Super Categories...");

  try {
    Map<String, dynamic>? response =
        await WebServicesHelper().getMarketPlaceSuperCategory({
      'access_token': access_token,
    });

    if (response != null && response['status'] == 200) {
      superCategoryList.clear();

      if (response['data'] != null) {
        List<dynamic> data = response['data'];

        for (var item in data) {
          superCategoryList.add(MpSuperCategoryModel.fromJson(item));
        }

        print("✅ Loaded ${superCategoryList.length} Super Categories");
      }
    } else {
      print("❌ Failed Super Category Load");
      Utils.showCustomTosst("Failed to load super categories");
    }
  } catch (e) {
    print("🔥 Error Super Category: $e");
  }

  update();
}


  // fetch latitude and longitude
  Future<void> fetchCurrentLocation() async {
  print("📍 Fetching current location...");

  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Utils.showCustomTosst("Location services are disabled");
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Utils.showCustomTosst("Location permission denied");
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    Utils.showCustomTosst("Location permanently denied");
    return;
  }

  // ✅ GET LAT LNG
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  double lat = position.latitude;
  double lng = position.longitude;

  print("📍 Location: $lat , $lng");

  latitudeController.text = lat.toString();
  longitudeController.text = lng.toString();

  // 🔥 NEW: GET ADDRESS FROM LAT LNG
  List<Placemark> placemarks =
      await placemarkFromCoordinates(lat, lng);

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks.first;

    print("📍 State: ${place.administrativeArea}");
    print("📍 City: ${place.locality}");

    // ✅ SET STATE & CITY
    selectedState.value = CommonModel(name: place.administrativeArea);
    selectedCity.value = CommonModel(name: place.locality);

    stateNameController.text = place.administrativeArea ?? "";
    cityNameController.text = place.locality ?? "";
  }

  update();
}
  

  getFromGallery(isCamera, booking_id) async {
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
      images.add(imageFile);
    }
  }

  getFromGalleryForProfile(isCamera) async {
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
      images.add(imageFile);
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
          bool isFound = false;
          print('isFound===>${isFound}');
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

  // Product Submission Method - Fixed version
// Product Submission Method - Fixed version
Future<void> postMarketPlaceProduct() async {
  BuildContext? context = Get.context;

  print("=== Starting Marketplace Product Submission ===");

  // Validate token first
  if (access_token.isEmpty) {
    Utils.showCustomTosstError("Please login again. Session expired.");
    return;
  }

  // -------------------------
  //   FORM VALIDATION
  // -------------------------
  if (titleController.text.isEmpty) {
    Utils.showCustomTosstError("Please enter product title");
    return;
  }
  if (nameController.text.isEmpty) {
    Utils.showCustomTosstError("Please enter product name");
    return;
  }
  if (productpriceController.text.isEmpty) {
    Utils.showCustomTosstError("Please enter product price");
    return;
  }
  if (selectedMainCategory.value.id == null) {
    Utils.showCustomTosstError("Please select main category");
    return;
  }
  
  // -------------------------
  //   IMAGE PATH
  // -------------------------
  String imagePath = "";
  if (fileList.isNotEmpty && fileList.first != null) {
    imagePath = fileList.first.path ?? "";
    print("Image Path: $imagePath");
  }

  // -------------------------
  //   FINAL API PARAMETERS
  // -------------------------
  final param = {
    "title": titleController.text,
    "description": decriptionController.text,
    "hashtag":hashtagController.text,
    "product_code": productCodeController.text,
    "self_life": selfLifeController.text,
    "manufacturer_details": manufacturerDetailsController.text,
    "discount_price": productOfferpriceController.text.isNotEmpty
        ? productOfferpriceController.text
        : "0",
    "discount_percentage": discountPercentageController.text,
    "price": double.tryParse(productpriceController.text) ?? 0.0,
    "images": imagePath,
    "logo": imagePath,
    "compositions": compositionsController.text,
    "sizes": sizesController.text,
    "quantity": int.tryParse(quantityController.text) ?? 0,
    "company_name": companyNameController.text,
    "strength": strengthController.text,
    "pack_size": int.tryParse(packSizeController.text) ?? 0,
    "specification": [],
    "bar_code": barCodeController.text,
    "mp_category_id": selectedMainCategory.value.id ?? 0,
    "mp_sub_category_id": selectedSubCategory.value.id ?? 0,
    "brand_id": null,
    "state_name": selectedState.value.name ?? "",
    "city_name": selectedCity.value.name ?? "",
    "latitude": latitudeController.text,
    "longitude": longitudeController.text,
    "created_at": DateTime.now().toIso8601String(),
    "updated_at": DateTime.now().toIso8601String(),
    "user_id": int.tryParse(userId) ?? 0,
    "created_by": int.tryParse(userId) ?? 0,
    "created_by_id": int.tryParse(userId) ?? 0,
    "updated_by": int.tryParse(userId) ?? 0,
    "updated_by_id": int.tryParse(userId) ?? 0
  };




  print("=== FINAL PARAM SENT TO API ===");
  print(param);

  // -------------------------
  //   API CALL WITH CORRECT HEADERS
  // -------------------------
  showLoaderDialog(context!);

  try {
    String url = ApiUrl.Add_Product_Market_place;

    print("🔑 Using Authorization Bearer token");
    
    Map<String, dynamic>? response = await WebServicesHelper().PostMarketPlaceProduct(
      url,
      param,
      headers: {
        "Authorization": "Bearer $access_token",  // ✅ CORRECT HEADER
        "Content-Type": "application/json",
      },
    );

    hideProgress(context);

    if (response != null) {
      print("📡 Response Status: ${response['status']}");
      print("📡 Response Message: ${response['message']}");
      
      if (response["status"] == 200 || response["status"] == 201) {
        Utils.showCustomTosst(response["message"] ?? "Product added successfully");
        clearForm();
        Get.back();
      } else {
        Utils.showCustomTosst(response["message"] ?? "Failed to add product");
      }
    } else {
      Utils.showCustomTosst("No response from server");
    }
  } catch (e) {
    hideProgress(context);
    print("Error submitting product: $e");
    Utils.showCustomTosst("An error occurred while submitting product");
  }
}
  // Get Market Place Product 
  // Load Marketplace Products (Simple GET API)
Future<void> loadMarketPlaceProducts() async {
  print("📦 Loading marketplace products...");

  try {
    isLoading.value = true;  // ✅ Set loading to true
    
    String keyword = searchController.text.trim();
  
    Map<String, dynamic> params = {
      "access_token": access_token,
      "return_all": "false",
      "display_type": "all",
      "order_by": "created_at",
      "descending": "true",
      "page": 1,
      "size": 50,
    };

    // Decide search type
    if (keyword.isNotEmpty) {
      // if user types only "#", don't call API
      if (keyword == "#") {
        return;
      }

      if (keyword.startsWith("#") && keyword.length > 1) {
        params["hashtag"] = keyword;
      } else {
        params["title"] = keyword;
      }
    }

    Map<String, dynamic>? response =
        await WebServicesHelper().getMarketPlaceProduct(params);

    if (response != null && response['status'] == 200) {
      productList.clear();
      filteredProductList.clear();

      if (response["data"] != null) {
        for (var item in response['data']) {
          productList.add(ProductModel.fromJson(item));
        }

        filteredProductList.addAll(productList);
      }
    }
  } catch (e) {
    print("Error: $e");
  } finally {
    isLoading.value = false;  // ✅ Set loading to false
    update();
  }
}

// update product 
Future<void> updateMarketPlaceProduct(int productId) async {
  BuildContext? context = Get.context;

  print("=== Starting Product Update for ID: $productId ===");

  // ---------------- VALIDATION ----------------
  if (titleController.text.isEmpty) {
    Utils.showCustomTosst("Please enter product title");
    return;
  }

  if (productpriceController.text.isEmpty) {
    Utils.showCustomTosst("Please enter product price");
    return;
  }

  // ---------------- IMAGE ----------------
  String imagePath = "";
  if (fileList.isNotEmpty) {
    imagePath = fileList.first.path ?? "";
  }

  // ---------------- GET ORIGINAL PRODUCT ----------------
  ProductModel? originalProduct =
      productList.firstWhereOrNull((p) => p.id == productId);

  // ---------------- FINAL PARAM ----------------
  final param = {
    "product_id": productId.toString(),
    "access_token": access_token,

    "title": titleController.text,
    "description": decriptionController.text,
    "product_code": productCodeController.text,
    "self_life": selfLifeController.text,
    "manufacturer_details": manufacturerDetailsController.text,
    "discount_price": productOfferpriceController.text.isNotEmpty
        ? productOfferpriceController.text
        : "0",
    "discount_percentage": discountPercentageController.text,
    "price": double.tryParse(productpriceController.text) ?? 0.0,

    "images": imagePath,
    "logo": imagePath,

    "compositions": compositionsController.text,
    "sizes": sizesController.text,
    "quantity": int.tryParse(quantityController.text) ?? 0,
    "company_name": companyNameController.text,
    "strength": strengthController.text,
    "pack_size": int.tryParse(packSizeController.text) ?? 0,
    "specification": [],

    "bar_code": barCodeController.text,
    "mp_category_id": selectedMainCategory.value.id ?? 0,
    "mp_sub_category_id": selectedSubCategory.value.id ?? 0,
    "brand_id": selectedBrands.value.id ?? 0,

    "state_name": selectedState.value.name ?? "",
    "city_name": selectedCity.value.name ?? "",
    "latitude": latitudeController.text,
    "longitude": longitudeController.text,

    // ✅ IMPORTANT FIELDS
    "created_at": originalProduct?.createdAt ??
        DateTime.now().toIso8601String(),
    "updated_at": DateTime.now().toIso8601String(),

    // 🔥🔥 FIX (THIS WAS MISSING)
    "updated_by": 1,
    "updated_by_id": 1,
  };

  print("=== FINAL PUT PARAM ===");
  print(param);

  showLoaderDialog(context!);

  try {
    isLoading.value = true;

    var response =
        await WebServicesHelper().updateMarketPlaceProduct(param);

    hideProgress(context);

    if (response != null && response["status"] == 200) {
      Utils.showCustomTosst("✅ Product updated successfully");

      Get.back(); // close screen

      await loadMarketPlaceProducts(); // refresh list
    } else {
      Utils.showCustomTosst(
          response?["message"] ?? "❌ Failed to update");
    }
  } catch (e) {
    hideProgress(context);
    print("PUT Error: $e");

    Utils.showCustomTosst("❌ Error updating product");
  } finally {
    isLoading.value = false;
    update();
  }
}
// PREFILL ALL FIELDS FOR EDIT PRODUCT
Future loadProductForEdit(ProductModel product) async {
  print("📌 Loading product in edit mode: ${product.id}");

  // Store original created_at in a temporary variable
  _originalCreatedAt = product.createdAt;
  _originalProductId = product.id;
  
  // Basic Info
  titleController.text = product.title ?? "";
  nameController.text = product.name ?? "";
  decriptionController.text = product.description ?? "";
  productCodeController.text = product.productCode ?? "";
  barCodeController.text = product.barCode ?? "";

  // Composition
  compositionsController.text = product.compositions ?? "";
  strengthController.text = product.strength ?? "";
  selfLifeController.text = product.selfLife ?? "";

  // Packaging
  sizesController.text = product.sizes ?? "";
  quantityController.text = product.quntity?.toString() ?? "";
  packSizeController.text = product.packSize?.toString() ?? "";

  // Pricing
  productpriceController.text = product.price?.toString() ?? "";
  productOfferpriceController.text = product.discount_price ?? "";
  discountPercentageController.text = product.discountPercentage ?? "";

  // Location
  selectedState.value = CommonModel(name: product.stateName, id: 0);
  selectedCity.value = CommonModel(name: product.cityName, id: 0);
  stateNameController.text = product.stateName ?? "";
  cityNameController.text = product.cityName ?? "";
  latitudeController.text = product.latitude ?? "";
  longitudeController.text = product.longitude ?? "";

  // Manufacturer
  companyNameController.text = product.companyName ?? "";
  manufacturerDetailsController.text = product.manufacturerDetails ?? "";

  // Dropdown selections (IDs only)
 // ✅ Set category properly
selectedMainCategory.value = CommonModel(
  id: product.mpCategoryId,
);

// 🔥 IMPORTANT: Load subcategories FIRST
if (product.mpCategoryId != null) {
  await loadSubCategories(product.mpCategoryId.toString());
}

// ✅ Then set subcategory
selectedSubCategory.value = CommonModel(
  id: product.mpSubCategoryId,
);
  selectedBrands.value.id = product.brandId;

  // Image
  fileList.clear();
  if (product.images != null && product.images!.isNotEmpty) {
    fileList.add(FileModel(path: product.images));
  }

  update();
}

// Add these variables at the top of your controller
String? _originalCreatedAt;
int? _originalProductId;
// Petch api for 
// Activate or Deactivate Product

Future<void> activateDeactivateProduct(int productId, bool activate) async {
  print("🔄 Updating product status... ID: $productId | Activate: $activate");

  // Show loading toast
  Utils.showCustomTosst(activate ? "Activating product..." : "Deactivating product...");

  try {
    isLoading.value = true;
    
    Map<String, dynamic>? response =
        await WebServicesHelper().petchProductById({
      "product_id": productId,
      "activate": activate.toString(),
      "accessToken": access_token,
    });

    if (response != null && response["status"] == 200) {
      // Success toast with proper styling
      Utils.showCustomTosst(
        activate ? "✓ Product activated successfully" : "✓ Product deactivated successfully",
      );

      // Refresh product list
      await loadMarketPlaceProducts();
    } else {
      // Error toast
      Utils.showCustomTosstError(
        response?["message"] ?? "Failed to update product status",
      );
    }
  } catch (e) {
    print("❌ Error: $e");
    // Error toast
    Utils.showCustomTosstError("Error updating product status. Please try again.");
  } finally {
    isLoading.value = false;
    update();
  }
}


Future<void> searchCity(String input) async {
  if (input.isEmpty) return;

  final response =
      await WebServicesHelper().getPlaceAutocomplete(input);

  final data = jsonDecode(response.body);

 placeSuggestions.value = data['predictions'] ?? [];
}

Future<void> selectPlace(String placeId) async {
  final response =
      await WebServicesHelper().getPlaceDetails(placeId);

  if (response.statusCode != 200) {
    print("❌ API Error");
    return;
  }

  final data = jsonDecode(response.body);

  /// ✅ CHECK STATUS FIRST
  if (data['status'] != "OK") {
    print("❌ Google API Error: ${data['status']}");
    return;
  }

  /// ✅ SAFE ACCESS
  final result = data['result'];

  if (result == null || result['geometry'] == null) {
    print("❌ Invalid result data");
    return;
  }

  double lat = result['geometry']['location']['lat'];
  double lng = result['geometry']['location']['lng'];

  latitudeController.text = lat.toString();
  longitudeController.text = lng.toString();

  /// 🔥 GET CITY/STATE
  List<Placemark> placemarks =
      await placemarkFromCoordinates(lat, lng);

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks.first;

    selectedCity.value = CommonModel(name: place.locality);
    selectedState.value = CommonModel(name: place.administrativeArea);

    cityNameController.text = place.locality ?? "";
    stateNameController.text = place.administrativeArea ?? "";
  }

  update();
}


  // Method to clear form after submission
  void clearForm() {
    print("Clearing form data...");
    
    titleController.clear();
    nameController.clear();
    decriptionController.clear();
    productCodeController.clear();
    selfLifeController.clear();
    manufacturerDetailsController.clear();
    productpriceController.clear();
    productOfferpriceController.clear();
    discountPercentageController.clear();
    compositionsController.clear();
    sizesController.clear();
    quantityController.clear();
    companyNameController.clear();
    strengthController.clear();
    packSizeController.clear();
    barCodeController.clear();
    stateNameController.clear();
    cityNameController.clear();
    latitudeController.clear();
    longitudeController.clear();
    
    selectedBrands.value = CommonModel();
    selectedMainCategory.value = CommonModel();
    selectedSubCategory.value = CommonModel();
    selectedChildSubCategory.value = CommonModel();
    
    selectedState.value = CommonModel();
    
    fileList.clear();
    images.clear();
    subCategoryList.clear();
    
    print("Form cleared successfully");
    update();
  }

  // Method to validate form
  bool validateForm() {
    if (titleController.text.isEmpty) {
      Utils.showCustomTosst("Please enter product title");
      return false;
    }
    if (nameController.text.isEmpty) {
      Utils.showCustomTosst("Please enter product name");
      return false;
    }
    if (productpriceController.text.isEmpty) {
      Utils.showCustomTosst("Please enter product price");
      return false;
    }
    if (selectedMainCategory.value.id == null) {
      Utils.showCustomTosst("Please select main category");
      return false;
    }
    return true;
  }

  // Refresh categories method
Future<void> refreshCategories() async {
  if (selectedSuperCategory.value.id != null) {
    await loadCategoriesBySuperId(
        selectedSuperCategory.value.id.toString());
  } else {
    print("❌ Super Category not selected");
  }
}

  // Refresh brands method
  Future<void> refreshBrands() async {
    await loadBrands();
  }

Future<void> refreshAllData() async {
  await loadBrands();

  // 🔥 Load categories based on selected super category
  if (selectedSuperCategory.value.id != null) {
    await loadCategoriesBySuperId(
        selectedSuperCategory.value.id.toString());
  } else {
    categoryList.clear();
    subCategoryList.clear();
    print("⚠️ No super category selected");
  }
}

}