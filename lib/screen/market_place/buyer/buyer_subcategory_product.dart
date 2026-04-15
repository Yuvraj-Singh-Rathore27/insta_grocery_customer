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
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                /// 🔥 IMAGE + FLOATING HEART
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        product.getValidImageUrl() ?? "",
                        height: 150,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// ❤️ FLOATING FAVORITE
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Obx(() => GestureDetector(
                            onTap: () {
                              controller.toggleInterest(product);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: product.isInterested.value
                                    ? Colors.red
                                    : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: Icon(
                                product.isInterested.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 16,
                                color: product.isInterested.value
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          )),
                    ),

                    /// 🔥 DISCOUNT BADGE

                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "OFF",
                          style: TextStyle(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        product.title ?? product.name ?? "Product",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// PRICE
                      Text(
                        _formatPrice(product.price),
                        style: TextStyle(
                          color: AppColor().colorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// LOCATION
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 13, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              product.getDisplayLocation(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// CHAT BUTTON (MODERN)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "Chat",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null || price == "0") return "Price on request";
    return "₹ ${price.toString()}";
  }
}
