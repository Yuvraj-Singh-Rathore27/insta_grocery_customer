import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import '../model/common_model.dart';
import '../model/ProductModel.dart';
import '../preferences/UserPreferences.dart';
import '../webservices/WebServicesHelper.dart';

class BuyerController extends GetxController {
  // -------------------- STORAGE --------------------
  late GetStorage store;
  String userId = "";
  String access_token = "";

  // -------------------- CATEGORY / SUBCATEGORY --------------------
  RxList<CommonModel> categoryList = <CommonModel>[].obs;
  RxList<CommonModel> subCategoryList = <CommonModel>[].obs;

  var selectedCategory = CommonModel().obs;
  var selectedSubCategory = CommonModel().obs;

  // -------------------- PRODUCTS --------------------
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> filteredProductList = <ProductModel>[].obs;

  TextEditingController searchController = TextEditingController();

  // ========================== INIT ==========================
  @override
  void onInit() {
    super.onInit();

    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    access_token = store.read(UserPreferences.access_token) ?? "";

    loadCategories();
  }

  // ===========================================================
  //                     LOAD CATEGORIES
  // ===========================================================
  Future<void> loadCategories() async {
    try {
      var response = await WebServicesHelper().getMpcategoryList({
        "access_token": access_token,
      });

      if (response != null && response["status"] == 200) {
        categoryList.clear();

        var data = response["data"];
        if (data is List) {
          for (var item in data) {
            categoryList.add(CommonModel.fromJson(item));
          }
        }

        // Auto-select first category
        if (categoryList.isNotEmpty) {
          selectedCategory.value = categoryList.first;

          loadSubCategories(selectedCategory.value.id.toString());
          loadMarketPlaceProducts(categoryId: selectedCategory.value.id!);
        }
      }

    } catch (e) {
      print("❌ loadCategories error: $e");
    }
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
        "Success",
        response["message"] ?? "Marked as message",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("🔴 Message Sent Failed -> ${response?["message"]}");
      Get.snackbar(
        "Failed",
        response?["message"] ?? "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    print("❌ markProductMessage ERROR: $e");
    Get.snackbar("Error", "Unable to submit Message");
  }
}


// toggle button for interseted
void toggleInterest(ProductModel item) async {
  item.isInterested = !item.isInterested; // update UI
  productList.refresh();                  // refresh list

  if (item.isInterested) {
    await markProductAsInterested(item.id!);
  }
}




  


  // ===========================================================
  //                     LOAD PRODUCTS (CATEGORY ONLY)
  // ===========================================================
  Future<void> loadMarketPlaceProducts({required int categoryId}) async {
    try {
      var response = await WebServicesHelper().getMarketPlaceProduct({
        "access_token": access_token,
        "title": searchController.text,
        "mp_category_id": categoryId.toString(),
        "return_all": "false",
        "display_type": "active",
        "order_by": "created_at",
        "range":"50",
        "descending": "true",
        "page": 1,
        "size": 100,
      });

      if (response != null && response["status"] == 200) {
        productList.clear();
        filteredProductList.clear();

        var data = response["data"];

        if (data is List) {
          for (var item in data) {
            productList.add(ProductModel.fromJson(item));
          }
        }

        filteredProductList.assignAll(productList);
      }

    } catch (e) {
      print("❌ loadMarketPlaceProducts error: $e");
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


  // ===========================================================
  //                     ON CATEGORY TAP
  // ===========================================================
  void onCategoryTap(CommonModel category) {
    selectedCategory.value = category;

    loadSubCategories(category.id.toString());
    loadMarketPlaceProducts(categoryId: category.id!);
  }
}
