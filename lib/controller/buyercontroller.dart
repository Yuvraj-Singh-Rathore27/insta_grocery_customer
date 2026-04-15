import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/screen/market_place/buyer/buyer_super_category.dart';
import 'package:insta_grocery_customer/screen/market_place/seller/seller_home.dart';

import '../model/common_model.dart';
import '../model/ProductModel.dart';
import '../preferences/UserPreferences.dart';
import '../webservices/WebServicesHelper.dart';
import '../utills/Utils.dart';


class BuyerController extends GetxController {
  // -------------------- STORAGE --------------------
  late GetStorage store;
  String userId = "";
  String access_token = "";
  var isLoading = false.obs;

  // -------------------- CATEGORY / SUBCATEGORY --------------------
  RxList<CommonModel> categoryList = <CommonModel>[].obs;
  RxList<CommonModel> subCategoryList = <CommonModel>[].obs;

  var selectedCategory = CommonModel().obs;
  var selectedSubCategory = CommonModel().obs;

  RxList<MpSuperCategoryModel> superCategoryList =
    <MpSuperCategoryModel>[].obs;

var selectedSuperCategory = MpSuperCategoryModel().obs;

  // -------------------- PRODUCTS --------------------
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> filteredProductList = <ProductModel>[].obs;

  TextEditingController searchController = TextEditingController();
   var selectedIndex = 0.obs;
 void changeIndex(int index) {
    selectedIndex.value = index;
    if(index == 1){
      Get.to(() => SellerHomePage());
      
    }
    else if(index==0){
      Get.to(MarketPlaceSuperCategoryScreen());
    }
  }

  // ========================== INIT ==========================
  @override
  void onInit() {
    super.onInit();

    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    access_token = store.read(UserPreferences.access_token) ?? "";

    loadCategories();
     loadSuperCategories();
  }

  // ===========================================================
  //                     LOAD CATEGORIES
  // ===========================================================
  Future<void> loadCategories() async {
  try {

    Map<String, dynamic> params = {
      "access_token": access_token,
    };

    // ⭐ If super category selected → send filter
    if (selectedSuperCategory.value.id != null) {
      params["super_category_id"] =
          selectedSuperCategory.value.id.toString();
    }

    var response =
        await WebServicesHelper().getMpcategoryList(params);

    if (response != null && response["status"] == 200) {
      categoryList.clear();

      var data = response["data"];
      if (data is List) {
        for (var item in data) {
          categoryList.add(CommonModel.fromJson(item));
        }
      }

      // ⭐ Auto-select first category
      if (categoryList.isNotEmpty) {
        selectedCategory.value = categoryList.first;

        loadSubCategories(selectedCategory.value.id.toString());
        loadMarketPlaceProducts(
            categoryId: selectedCategory.value.id!);
      }
    }

  } catch (e) {
    print("❌ loadCategories error: $e");
  }

  update();
}


  // ===========================================================
  //                     LOAD SUBCATEGORIES
  // ===========================================================
  Future<void> loadSubCategories(String categoryId) async {
    try {
      var response = await WebServicesHelper().getMpSubcatgory({
        "access_token": access_token,
        "category_id": categoryId,
      });

      if (response != null && response["status"] == 200) {
        subCategoryList.clear();

        var data = response["data"];

        if (data is List) {
          for (var item in data) {
            subCategoryList.add(CommonModel.fromJson(item));
          }
        }

        // Select first subcategory (optional display only)
        if (subCategoryList.isNotEmpty) {
          selectedSubCategory.value = subCategoryList.first;
        }
      }

    } catch (e) {
      print("❌ loadSubCategories error: $e");
    }
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


// get market place product as an inteerest 
Future<void> getMarketPlaceInterested(int userId)async{
  print("Get Market Place INterseted is callled");
  print("your sending user id is $userId");
  try{
    var response=await WebServicesHelper().getMarketPlaceInterest({
      "user_id":userId,

    });
    print("Api Response ---->$response");
    if(response !=null&& response["status"]==200){
      print("Intersetd Service Fetch Succesfully");
    }else{
      print("interset service found a error");
    }

  }catch(e){
    print("market place interested is an errro $e");
  }
}
  // Market Place Prodct 

  Future<void> markProductAsInterested(int productId) async {
  print("🔵 markProductAsInterested() CALLED");
  print("🔵 Sending -> user_id: $userId, product_id: $productId");

  try {
    var response = await WebServicesHelper().postMarketPlaceInterest({
      "user_id": userId,
      "product_id": productId,
      "accessToken": access_token,
    });

    print("🟣 API Response -> $response");

    if (response != null && response["status"] == 200) {
      print("🟢 Interest Success -> ${response["message"]}");
      Get.snackbar(
        "Success",
        response["message"] ?? "Marked as Interested",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("🔴 Interest Failed -> ${response?["message"]}");
      Get.snackbar(
        "Failed",
        response?["message"] ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    print("❌ markProductAsInterested ERROR: $e");
    Get.snackbar("Error", "Unable to submit interest");
  }
}



// Market Place Prodct 

  Future<void> markProductAsMessage(int productId,int recieveId,int senderId ,String message,) async {
  print("🔵 Market Place product message() CALLED");
  print("🔵 Sending -> recieverId: $recieveId, product_id: $productId,sender_id:$senderId,message:$message");

  try {
    var response = await WebServicesHelper().postMarketPlaceMessage({
      "receiver_id": recieveId,
      "product_id": productId,
      "sender_id":senderId,
      "message":message,
      "accessToken": access_token,
    });

    print("🟣 API Response -> $response");

    if (response != null && response["status"] == 200) {
      print("🟢 Message  Success -> ${response["message"]}");
     Get.snackbar(
  "Message Sent ✅",
  response["message"] ?? "Your message has been sent successfully",
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.green.shade600,
  colorText: Colors.white,
  margin: EdgeInsets.all(12),
  borderRadius: 10,
  icon: Icon(Icons.check_circle, color: Colors.white),
  duration: Duration(seconds: 2),
);
    } else {
      print("🔴 Message Sent Failed -> ${response?["message"]}");
     Get.snackbar(
  "Failed ❌",
  response?["message"] ?? "Something went wrong",
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.red.shade600,
  colorText: Colors.white,
  margin: EdgeInsets.all(12),
  borderRadius: 10,
  icon: Icon(Icons.error, color: Colors.white),
);
    }
  } catch (e) {
    print("❌ markProductMessage ERROR: $e");
    Get.snackbar(
  "Error ⚠️",
  "Unable to send message",
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.orange.shade700,
  colorText: Colors.white,
  margin: EdgeInsets.all(12),
  borderRadius: 10,
  icon: Icon(Icons.warning, color: Colors.white),
);
  }
}
void onSuperCategoryTap(MpSuperCategoryModel item) {
  selectedSuperCategory.value = item;

  print("Selected Super Category => ${item.name}");
}


// toggle button for interseted
void toggleInterest(ProductModel product) {
  product.isInterested.toggle();
}



  


  // ===========================================================
  //                     LOAD PRODUCTS (CATEGORY ONLY)
  // ===========================================================
  Future<void> loadMarketPlaceProducts({
  required int categoryId,
  int? subCategoryId,
}) async {
  try {
    isLoading.value = true; // 🔥 START LOADING

    productList.clear();
    filteredProductList.clear();

    Map<String, dynamic> body = {
      "access_token": access_token,
      "title": searchController.text,
      "mp_category_id": categoryId.toString(),
      "return_all": "false",
      "display_type": "active",
      "order_by": "created_at",
      "range": "50",
      "descending": "true",
      "page": 1,
      "size": 100,
    };

    if (subCategoryId != null) {
      body["mp_sub_category_id"] = subCategoryId.toString();
    }

    var response =
        await WebServicesHelper().getMarketPlaceProduct(body);

    if (response != null && response["status"] == 200) {
      var data = response["data"];

      if (data != null && data is List) {
        for (var item in data) {
          productList.add(ProductModel.fromJson(item));
        }
      }

      filteredProductList.assignAll(productList);
    }

  } catch (e) {
    print("❌ loadMarketPlaceProducts error: $e");
  } finally {
    isLoading.value = false; // 🔥 STOP LOADING
  }
}


  // ===========================================================
  //                          SEARCH
  // ===========================================================
  void searchProduct(String text) {
    if (text.isEmpty) {
      filteredProductList.assignAll(productList);
      return;
    }

    filteredProductList.assignAll(
      productList.where(
        (item) =>
            (item.title ?? '').toLowerCase().contains(text.toLowerCase()),
      ),
    );
  }
 String cleanPhoneNumber(String phone) {
  // Remove everything except digits
  String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');

  // Add country code if missing (India)
  if (cleaned.length == 10) {
    cleaned = "91$cleaned";
  }

  return "+$cleaned";
}


  // ===========================================================
  //                     ON CATEGORY TAP
  // ===========================================================
  void onCategoryTap(CommonModel category) {
    selectedCategory.value = category;

    loadSubCategories(category.id.toString());
    loadMarketPlaceProducts(categoryId: category.id!);
  }
}
