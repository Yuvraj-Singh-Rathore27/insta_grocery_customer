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
    loadCategories();
    loadBrands();
    loadStates();
    loadMarketPlaceProducts();
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
    
    if (type == 'category') {
      selectedMainCategory.value = data;
      selectedSubCategory.value = CommonModel(); // Reset subcategory
      subCategoryList.clear(); // Clear previous subcategories
      
      // Load subcategories for selected category
      if (data.id != null) {
        loadSubCategories(data.id.toString());
      }
    } else if (type == 'subcategory') {
      selectedSubCategory.value = data;
    } else if (type == 'brands') {
      selectedBrands.value = data;
    } else if (type == 'state') { // NEW: Handle state selection
      selectedState.value = data;
      // You can also set the stateIdController if needed
    stateNameController.text = data.id?.toString() ?? '';
       loadCities(data.id.toString());
    } else if(type=='city'){
      selectedCity.value=data;
      stateNameController.text=data.id?.toString()??'';
    }
    
    update(); // Notify listeners
  }

  // Load categories method
  Future<void> loadCategories() async {
    print("Loading categories...");
    try {
      Map<String, dynamic>? response = await WebServicesHelper().getMpcategoryList({
        'access_token': access_token,
      });

      if (response != null && response['status'] == 200) {
        print("Categories loaded successfully");
        categoryList.clear();
        
        if (response['data'] != null) {
          List<dynamic> categoryData = response['data'];
          for (var item in categoryData) {
            categoryList.add(CommonModel.fromJson(item));
          }
          print("Loaded ${categoryList.length} categories");
        }
      } else {
        print("Failed to load categories: ${response?['message']}");
        Utils.showCustomTosst("Failed to load categories");
      }
    } catch (e) {
      print("Error loading categories: $e");
      Utils.showCustomTosst("Error loading categories");
    }
  }

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

  // fetch latitude and longitude
  Future<void> fetchCurrentLocation() async {
  print("📍 Fetching current location...");

  bool serviceEnabled;
  LocationPermission permission;

  // Check service enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Utils.showCustomTosst("Location services are disabled");
    return;
  }

  // Check permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Utils.showCustomTosst("Location permission denied");
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    Utils.showCustomTosst("Location permissions are permanently denied");
    return;
  }

  // Get location
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  print("📍 Location Found: ${position.latitude}, ${position.longitude}");

  latitudeController.text = position.latitude.toString();
  longitudeController.text = position.longitude.toString();

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
  if (selectedBrands.value.id == null) {
    Utils.showCustomTosstError("Please select brand");
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
    "brand_id": selectedBrands.value.id ?? 0,
    "state_name": selectedState.value.name ?? "",
    "city_name": selectedCity.value.name ?? "",
    "latitude": latitudeController.text,
    "longitude": longitudeController.text,
    "created_at": DateTime.now().toIso8601String(),
    "updated_at": DateTime.now().toIso8601String(),
    "user_id": int.tryParse(userId) ?? 0,
    "created_by": 1,
    "created_by_id": 1,
    "updated_by": 1,
    "updated_by_id": 1
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
  }

  update();
}


// update product 
Future<void> updateMarketPlaceProduct(int productId) async {
  BuildContext? context = Get.context;

  print("=== Starting Product Update for ID: $productId ===");

  // Validation same as Post
  if (titleController.text.isEmpty) {
    Utils.showCustomTosst("Please enter product title");
    return;
  }

  if (productpriceController.text.isEmpty) {
    Utils.showCustomTosst("Please enter product price");
    return;
  }

  // Image path
  String imagePath = "";
  if (fileList.isNotEmpty) {
    imagePath = fileList.first.path ?? "";
  }

  // Build param
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

  // ✔ update_at only
  "updated_at": DateTime.now().toIso8601String(),
};

  print("=== FINAL PUT PARAM ===");
  print(param);

  showLoaderDialog(context!);

  try {
    var response = await WebServicesHelper().updateMarketPlaceProduct(param);

    hideProgress(context);

    if (response != null && response["status"] == 200) {
      Utils.showCustomTosst("Product updated successfully");
      Get.back(); // Close screen
      await loadMarketPlaceProducts(); // Refresh list
    } else {
      Utils.showCustomTosst(response?["message"] ?? "Failed to update");
    }
  } catch (e) {
    hideProgress(context);
    print("PUT Error: $e");
  }
}
// PREFILL ALL FIELDS FOR EDIT PRODUCT
void loadProductForEdit(ProductModel product) {
  print("📌 Loading product in edit mode: ${product.id}");

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
  selectedState.value.name = product.stateName;
  selectedCity.value.name = product.cityName;
  latitudeController.text = product.latitude ?? "";
  longitudeController.text = product.longitude ?? "";

  // Manufacturer
  companyNameController.text = product.companyName ?? "";
  manufacturerDetailsController.text = product.manufacturerDetails ?? "";

  // Dropdown selections (IDs only)
  selectedMainCategory.value.id = product.mpCategoryId;
  selectedSubCategory.value.id = product.mpSubCategoryId;
  selectedBrands.value.id = product.brandId;

  // Image
  fileList.clear();
  if (product.images != null && product.images!.isNotEmpty) {
    fileList.add(FileModel(path: product.images));
  }

  update();
}


// Petch api for 
// Activate or Deactivate Product
Future<void> activateDeactivateProduct(int productId, bool activate) async {
  print("🔄 Updating product status... ID: $productId | Activate: $activate");

  try {
    Map<String, dynamic>? response =
        await WebServicesHelper().petchProductById({
      "product_id": productId,
      "activate": activate.toString(),
      "accessToken": access_token,
    });

    if (response != null && response["status"] == 200) {
      Utils.showCustomTosst(
          activate ? "Product activated successfully" : "Product deactivated");

      // Refresh product list
      await loadMarketPlaceProducts();
    } else {
      Utils.showCustomTosst(response?["message"] ?? "Failed to update status");
    }
  } catch (e) {
    print("❌ Error: $e");
    Utils.showCustomTosst("Error updating product status");
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
    await loadCategories();
  }

  // Refresh brands method
  Future<void> refreshBrands() async {
    await loadBrands();
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    await loadCategories();
    await loadBrands();
  }


}