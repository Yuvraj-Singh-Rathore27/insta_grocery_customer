import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import '../../../res/AppColor.dart';
import '../../../toolbar/TopBar.dart';
import 'buyer_product_details.dart';

class BuyerSubcategoryProduct extends StatelessWidget {
  final BuyerController buyerController = Get.find();

  BuyerSubcategoryProduct({super.key}) {
    // Load products for selected category safely
    Future.delayed(Duration.zero, () {
      buyerController.loadMarketPlaceProducts(
        categoryId: buyerController.selectedCategory.value.id!,
      );
    });
  }

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
        onPressed: () {},
        onTitleTapped: () {},
      ),

      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // CATEGORY TITLE
                Text(
                  buyerController.selectedCategory.value.name ?? "",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // SUBCATEGORY CHIPS
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: buyerController.subCategoryList.length,
                    itemBuilder: (context, index) {
                      final sub = buyerController.subCategoryList[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            sub.name ?? "",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // PRODUCT LIST
                buyerController.filteredProductList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(
                            "No products found",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            buyerController.filteredProductList.length,
                        itemBuilder: (context, index) {
                          final product =
                              buyerController.filteredProductList[index];

                          final imageUrl = (product.image_url != null &&
                                  product.image_url!.isNotEmpty)
                              ? product.image_url!.first
                              : (product.images ?? "");

                          return GestureDetector(
                            onTap: () {
                              Get.to(() => MProductDetails(product: product));
                            },

                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                            Icons.image_not_supported),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // DETAILS
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          "₹ ${product.price ?? 0}",
                                          style: TextStyle(
                                            color: AppColor().colorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          product.cityName ?? "Unknown",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      Icon(Icons.favorite_border,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 35),
                                      Text(
                                        product.updatedAt
                                                ?.split("T")
                                                .first ??
                                            "",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
