import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/sellercontroller.dart';
import 'package:insta_grocery_customer/controller/mp_add_product_controller.dart';

import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/res/AppDimens.dart';
import 'package:insta_grocery_customer/toolbar/TopBar.dart';
import '../../../model/ProductModel.dart';
import 'package:insta_grocery_customer/screen/market_place/seller/seller_product_listing.dart';


class FavouriteProduct extends StatefulWidget {
  const FavouriteProduct({super.key});

  @override
  State<FavouriteProduct> createState() => _FavouriteProductState();
}

class _FavouriteProductState extends State<FavouriteProduct> {
  final SellerController sellerController = Get.put(SellerController());
  final MpAddProductController productController = Get.put(MpAddProductController());

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Header Section
              // Buyer Interested Section
              _buildInterestedProductsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestedProductsSection() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor().whiteColor,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor().whiteColor,
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Buyer Interested (${sellerController.enquiriesCount.value})",
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Helvetica",
                      color: Colors.black,
                    ),
                  ),
                  // Refresh button
                  IconButton(
                    onPressed: () => sellerController.refreshInterestedProducts(),
                    icon: Icon(Icons.refresh, color: Colors.blue),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),

          if (sellerController.isLoading.value)
            _buildLoadingIndicator()
          else if (sellerController.errorMessage.isNotEmpty)
            _buildErrorWidget()
          else if (sellerController.interestedProducts.isEmpty)
            _buildEmptyWidget()
          else
            _buildInterestedProductsList(),
        ],
      ),
    ));
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Loading interested buyers...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          SizedBox(height: 10),
          Text(
            sellerController.errorMessage.value,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => sellerController.refreshInterestedProducts(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.people_outline, color: Colors.grey, size: 40),
          SizedBox(height: 10),
          Text(
            'No interested buyers found',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            'When buyers show interest in your products, they will appear here.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestedProductsList() {
    return Obx(() => ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(12),
      itemCount: sellerController.interestedProducts.length,
      itemBuilder: (context, index) {
        final product = sellerController.interestedProducts[index];
        return _buildProductItem(product);
      },
    ));
  }

  Widget _buildProductItem(ProductModel product) {
    return GestureDetector(
      // onTap: () {
      //   // Navigate to product details if needed
      //   Get.to(() => SellerProductListingPage());
      // },
      child: Container(
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
            // Product Image with error handling
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildProductImage(product),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   
                    capitalizeFirstLetter(product.title ?? product.name ?? 'Product ${product.product_id}'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  _buildPriceWidget(product),
                  SizedBox(height: 4),
                  if (product.cityName != null || product.stateName != null)
                    _buildLocationWidget(product),
                  SizedBox(height: 4),
                  Text(
                    product.description ?? "Buyer interested in this product",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Obx(() => Icon(
  product.isInterested.value
      ? Icons.favorite
      : Icons.favorite_border,
  color: product.isInterested.value
      ? Colors.red
      : Colors.grey[700],
)),
                SizedBox(height: 40),
                Text(
                  timeAgo(product.createdAt ?? ''),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    // Check if we have real images or just placeholder
    bool hasRealImages = product.image_url != null && 
                        product.image_url!.isNotEmpty &&
                        !(product.image_url!.first.contains('example.com'));
    
    if (hasRealImages) {
      return Image.network(
        product.image_url!.first,
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Icon(Icons.shopping_bag, color: Colors.grey[400], size: 40),
    );
  }

  Widget _buildPriceWidget(ProductModel product) {
    // Check if we have real price or placeholder
    bool hasRealPrice = product.price != null && 
                       product.price != "0" && 
                       product.price != "Contact for price";
    
    if (hasRealPrice) {
      return Row(
        children: [
          if (product.discount_price != null && product.discount_price != "0")
            Text(
              '₹${product.price ?? '0'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          SizedBox(width: 8),
          Text(
            '₹${product.discount_price ?? product.price ?? '0'}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      );
    } else {
      return Text(
        product.price ?? "Contact for price",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.orange,
        ),
      );
    }
  }

  Widget _buildLocationWidget(ProductModel product) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 14, color: Colors.grey),
        SizedBox(width: 4),
        Text(
          '${product.cityName ?? ''}${product.cityName != null && product.stateName != null ? ', ' : ''}${product.stateName ?? ''}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox(String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("🎯 FavouriteProduct initState called");
  }
}

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




