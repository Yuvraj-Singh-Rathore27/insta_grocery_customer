import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/ProductModel.dart';
import '../preferences/UserPreferences.dart';
import '../webservices/WebServicesHelper.dart';

// ⬇️ Import MpAddProductController – IMPORTANT
import 'mp_add_product_controller.dart';

class SellerController extends GetxController {
  // -------------------- STORAGE --------------------
  late GetStorage store;
  String userId = "";
  String access_token = "";

  // -------------------- LOADING STATES --------------------
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // -------------------- INTERESTED PRODUCTS --------------------
  RxList<ProductModel> interestedProducts = <ProductModel>[].obs;

  // -------------------- COUNTS --------------------
  var activeListingsCount = "0".obs;
  var productViewsCount = "0".obs;
  var enquiriesCount = "0".obs;

  @override
  void onInit() {
    super.onInit();

    store = GetStorage();
    userId = store.read(UserPreferences.user_id) ?? "";
    access_token = store.read(UserPreferences.access_token) ?? "";

    print("🎯 SellerController initialized with userId: $userId");

    // Fetch interest list first
    fetchInterestedProducts();

    // Fetch active listings count from MpAddProductController
    fetchActiveListings();
  }

  // ===========================================================
  //     FETCH ACTIVE LISTINGS FROM MpAddProductController
  // ===========================================================
  void fetchActiveListings() {
    try {
      // Get MpAddProductController instance
      MpAddProductController mpController = Get.find<MpAddProductController>();

      // Count active products
      activeListingsCount.value = mpController.productList.length.toString();

      print("🟢 Active Listings Count: ${activeListingsCount.value}");
    } catch (e) {
      print("❌ Error loading active listings: $e");
      activeListingsCount.value = "0";
    }
  }

  // ===========================================================
  //     FETCH INTERESTED PRODUCTS
  // ===========================================================
  Future<void> fetchInterestedProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print("🟡 Fetching interested products for user: $userId");

      var response = await WebServicesHelper().getMarketPlaceInterest({
        "user_id": userId,
        "accessToken": access_token,
      });

      print("🔵 API Response ----> $response");

      if (response != null && response["status"] == 200) {
        interestedProducts.clear();

        var data = response["data"];
        if (data is List) {
          for (var interestItem in data) {
            int? productId = _toInt(interestItem['product_id']);
            if (productId != null) {
              print("🟡 Fetching details for product ID: $productId");

              var productDetail = await fetchProductDetails(productId);
              if (productDetail != null) {
                productDetail.isInterested = true;
                interestedProducts.add(productDetail);
                print("🟢 Added product: ${productDetail.title ?? productDetail.name}");
              }
            }
          }
        }

        // Update enquiries count
        enquiriesCount.value = interestedProducts.length.toString();
        print("🟢 Enquiries Count Updated: ${enquiriesCount.value}");

      } else {
        errorMessage.value = response?["message"] ?? "Failed to fetch interested products";
        enquiriesCount.value = "0";
      }
    } catch (e) {
      errorMessage.value = "Error fetching interested products: $e";
      enquiriesCount.value = "0";
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  //     GET PRODUCT DETAILS BY ID
  // ===========================================================
  Future<ProductModel?> fetchProductDetails(int productId) async {
    try {
      var response = await WebServicesHelper().getProductById({
        "product_id": productId,
        "accessToken": access_token,
      });

      if (response != null && response["status"] == 200) {
        return ProductModel.fromJson(response["data"]);
      } else {
        print("❌ Error fetching product detail: ${response?['message']}");
      }
    } catch (e) {
      print("❌ Exception fetching product details: $e");
    }
    return null;
  }

  // ===========================================================
  //     REFRESH INTERESTED PRODUCTS
  // ===========================================================
  void refreshInterestedProducts() {
    fetchInterestedProducts();
    fetchActiveListings();
  }

  // ===========================================================
  //     GETTERS
  // ===========================================================
  String getActiveListingsCount() => activeListingsCount.value;
  String getProductViewsCount() => productViewsCount.value;
  String getEnquiriesCount() => enquiriesCount.value;

  // ===========================================================
  //     HELPER
  // ===========================================================
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  // ===========================================================
  //     CLEAR DATA
  // ===========================================================
  void clearData() {
    interestedProducts.clear();
    isLoading.value = false;
    errorMessage.value = '';
    activeListingsCount.value = "0";
    productViewsCount.value = "0";
    enquiriesCount.value = "0";
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
