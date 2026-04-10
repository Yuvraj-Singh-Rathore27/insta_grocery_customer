import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import '../../../res/AppColor.dart';
import '../../../toolbar/TopBar.dart';
import 'buyer_product_details.dart';
import '../../../model/ProductModel.dart';

class BuyerSubcategoryProduct extends StatelessWidget {
  final BuyerController buyerController = Get.find();

  BuyerSubcategoryProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: TopBar(
        title: buyerController.selectedSubCategory.value.name ?? "Products",
        menuicon: false,
        menuback: true,
        iconnotifiction: false,
        is_wallaticon: true,
        is_supporticon: false,
        is_whatsappicon: false,
        onPressed: () {},
        onTitleTapped: () {},
      ),

      /// 🔥 ONLY ONE OBX (IMPORTANT FIX)
      body: Obx(() {
        if (buyerController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (buyerController.filteredProductList.isEmpty) {
          return const Center(child: Text("No Products Found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: buyerController.filteredProductList.length,
          itemBuilder: (context, index) {
            final product = buyerController.filteredProductList[index];
            return ProductCard(product: product);
          },
        );
      }),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// 🔥 SEPARATE WIDGET (IMPORTANT FOR PERFORMANCE)
////////////////////////////////////////////////////////////////////////////////

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerController>();

    return GestureDetector(
      onTap: () {
        Get.to(() => MProductDetails(product: product));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🔥 IMAGE WITH BADGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    product.getValidImageUrl() ?? "",
                    height: 200,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 90,
                      width: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),

                /// 🔥 DISCOUNT BADGE
                if (product.discount_price != null &&
                    product.discount_price != "0")
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "OFF",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            /// 🔥 DETAILS
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                
                children: [
                  /// TITLE
                  Text(
                    product.title ?? product.name ?? "Product",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// PRICE ROW
                  Row(
                    children: [
                      Text(
                        _formatPrice(product.price),
                        style: TextStyle(
                          color: AppColor().colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(width: 6),

                      if (product.discount_price != null &&
                          product.discount_price != "0")
                        Text(
                          "₹ ${product.discount_price}",
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// LOCATION
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.getDisplayLocation(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔥 RIGHT ACTIONS
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// FAVORITE
                InkWell(
                  onTap: () {
                    controller.toggleInterest(product);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: product.isInterested
                          ? Colors.red.shade50
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      product.isInterested
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 18,
                      color: product.isInterested
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// CHAT
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_outline, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null || price == "0") return "Price on request";
    return "₹ ${price.toString()}";
  }
}