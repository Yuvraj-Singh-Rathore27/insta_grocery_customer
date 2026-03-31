import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import '../../../res/AppColor.dart';
import '../../../toolbar/TopBar.dart';
import 'buyer_product_details.dart';

class BuyerSubcategoryProduct extends StatelessWidget {
  final BuyerController buyerController = Get.find();

  BuyerSubcategoryProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: TopBar(
        title: buyerController.selectedSubCategory.value.name ?? "",
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

        if (buyerController.filteredProductList.isEmpty) {
          return Center(
            child: Text(
              "No products found",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: buyerController.filteredProductList.length,
          itemBuilder: (context, index) {

            final product =
                buyerController.filteredProductList[index];

            final imageUrl =
                (product.image_url != null &&
                        product.image_url!.isNotEmpty)
                    ? product.image_url!.first
                    : (product.images ?? "");

            return GestureDetector(
              onTap: () {
                Get.to(() => MProductDetails(product: product));
              },

              child: Container(
                margin: EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    /// IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 90,
                          width: 90,
                          color: Colors.grey.shade300,
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    /// DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            product.title ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "₹ ${product.price ?? 0}",
                            style: TextStyle(
                              color: AppColor().colorPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14,
                                  color: Colors.grey),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  product.cityName ?? "Unknown",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT SIDE
                    Column(
                      children: [

                        Obx(() => IconButton(
                              onPressed: () {
                                buyerController
                                    .toggleInterest(product);
                              },
                              icon: Icon(
                                product.isInterested
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: product.isInterested
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            )),

                        SizedBox(height: 20),

                        Text(
                          product.updatedAt
                                  ?.split("T")
                                  .first ??
                              "",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}