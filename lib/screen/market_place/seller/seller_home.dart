import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/sellercontroller.dart';
import 'package:insta_grocery_customer/controller/mp_add_product_controller.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/res/AppDimens.dart';
import 'package:insta_grocery_customer/toolbar/TopBar.dart';
import '../../../model/ProductModel.dart';
import 'seller_product_listing.dart';

import 'add_product.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final SellerController sellerController = Get.put(SellerController());
  final MpAddProductController productController =
      Get.put(MpAddProductController());

  @override
  void initState() {
    super.initState();
    // Load products when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.loadMarketPlaceProducts();
    });
    print("🎯 SellerHomePage initState called");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(
        title: '',
        menuicon: false,
        menuback: true,
        iconnotifiction: true,
        is_wallaticon: true,
        is_supporticon: false,
        is_whatsappicon: false,
        onPressed: () => {},
        onTitleTapped: () => {},
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await productController.loadMarketPlaceProducts();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                
                // Listings Summary
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        "Our  Products Listings summary",
                        style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Summary Boxes
                Obx(() {
                  final activeCount = productController.productList
                      .where((e) => e.isActive)
                      .length;

                  final inactiveCount = productController.productList
                      .where((e) => !e.isActive)
                      .length;
                  final totalproducts = productController.productList.length;
                  final favauriteproducts=sellerController.enquiriesCount.value;

                  // final soldCount = productController.productList
                  //     .where((e) => e.isSold == true) // if available
                  //     .length;

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildTopItem(activeCount.toString(), "Active"),
                        _divider(),
                        _buildTopItem(inactiveCount.toString(), "Inactive"),
                        _divider(),
                        _buildTopItem(favauriteproducts.toString(), "Favourite"),
                        _divider(),
                        _buildTopItem(totalproducts.toString(),
                            "Total"), // static for now
                      ],
                    ),
                  );
                }),
                SizedBox(height: 10),

                // View Listings Button
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: isTablet ? screenWidth * 0.5 : double.infinity,
                    height: isTablet ? 60 : 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(FavouriteProduct());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor().colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'View Favourites Products',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Product List Section
                _buildProductListSection(isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildProductListSection(bool isTablet) {
    return Obx(() {
      if (productController.isLoading.value) {
        return _buildLoadingIndicator(isTablet);
      }

      if (productController.productList.isEmpty) {
        return _buildEmptyProductWidget(isTablet);
      }

      final activeProducts =
          productController.productList.where((p) => p.isActive).toList();

      final inactiveProducts =
          productController.productList.where((p) => !p.isActive).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ACTIVE PRODUCTS SECTION
          if (activeProducts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 10, bottom: 5),
              child: Text(
                "Active Products",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildProductList(activeProducts, isTablet),
          ],

          SizedBox(height: 20),

          // INACTIVE PRODUCTS SECTION
          if (inactiveProducts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 10, bottom: 5),
              child: Text(
                "Inactive Products",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildProductList(inactiveProducts, isTablet),
          ],
        ],
      );
    });
  }

  Widget _buildTopItem(String value, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products, bool isTablet) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product, isTablet);
      },
    );
  }

  Widget _buildProductCard(ProductModel product, bool isTablet) {
    double imageSize = isTablet ? 120 : 100;
    String? imageUrl = product.getValidImageUrl();

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildProductImage(imageUrl, imageSize),
          ),
          SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizeFirstLetter(
                      product.title ?? product.name ?? 'Product ${product.id}'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 18 : 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                _buildPriceWidget(product, isTablet),
                SizedBox(height: 10),

                // Location Widget with async location fetching
                FutureBuilder<String>(
                  future: product.getAddressFromCoordinates(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: Colors.green),
                            SizedBox(width: 6),
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.grey),
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Loading location...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    String location = snapshot.data ?? "Location not provided";

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: location.contains('not provided')
                                ? Colors.grey
                                : Colors.green,
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 8),

                // Time ago
                Text(
                  timeAgo(product.createdAt ?? ""),
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),

          // Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // EDIT BUTTON (Styled like your example)
              ElevatedButton(
                onPressed: () {
                  productController.loadProductForEdit(product);
                  Get.to(() => AddProduct(product: product, isEdit: true));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8),
                  minimumSize: Size(36, 36),
                ),
                child: Icon(Icons.edit, size: 18, color: Colors.white),
              ),

              SizedBox(height: 8),

              // TOGGLE BUTTON
              IconButton(
                icon: Icon(
                  product.isActive ? Icons.toggle_on : Icons.toggle_off,
                  color: product.isActive ? Colors.green : Colors.grey,
                  size: 35,
                ),
                onPressed: () async {
                  await productController.activateDeactivateProduct(
                    product.id!,
                    !product.isActive,
                  );
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl, double imageSize) {
    if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != "null") {
      return Image.network(
        imageUrl,
        height: imageSize,
        width: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("❌ Image load error: $error for URL: $imageUrl");
          return _buildPlaceholderImage(imageSize);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      return _buildPlaceholderImage(imageSize);
    }
  }

  Widget _buildPlaceholderImage(double imageSize) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported,
              size: imageSize * 0.4, color: Colors.grey[400]),
          SizedBox(height: 4),
          Text(
            'No Image',
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceWidget(ProductModel product, bool isTablet) {
    bool hasRealPrice = product.price != null &&
        product.price != "0" &&
        product.price != "Contact for price";

    if (hasRealPrice) {
      return Text(
        "₹ ${product.price ?? 0}",
        style: TextStyle(
          fontSize: isTablet ? 18 : 15,
          color: AppColor().colorPrimary,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        product.price ?? "Contact for price",
        style: TextStyle(
          fontSize: isTablet ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: Colors.orange,
        ),
      );
    }
  }

  Widget _buildLoadingIndicator(bool isTablet) {
    double iconSize = isTablet ? 80 : 60;

    return Container(
      height: isTablet ? 400 : 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: iconSize,
                color: AppColor().colorPrimary,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Loading products...',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please wait',
              style: TextStyle(
                fontSize: isTablet ? 14 : 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProductWidget(bool isTablet) {
    double iconSize = isTablet ? 100 : 80;

    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: iconSize),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap "View listings" to add your first product',
            style: TextStyle(
                color: Colors.grey[600], fontSize: isTablet ? 16 : 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Helper Functions
String timeAgo(String dateString) {
  try {
    DateTime created = DateTime.parse(dateString);
    Duration diff = DateTime.now().difference(created);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";
    if (diff.inDays < 7) return "${diff.inDays} days ago";

    return "${created.day}/${created.month}/${created.year}";
  } catch (e) {
    return "Recently";
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return "";
  return text[0].toUpperCase() + text.substring(1);
}
