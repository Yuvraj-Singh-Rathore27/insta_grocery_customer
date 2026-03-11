import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/mp_add_product_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../toolbar/TopBar.dart';
import 'add_product.dart';

class SellerProductListingPage extends StatelessWidget {
  final MpAddProductController buyerController = Get.find();

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

      body: RefreshIndicator(
        onRefresh: () async {
          await buyerController.loadMarketPlaceProducts();
        },

        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                // ---------------------- SEARCH BAR ----------------------
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: buyerController.searchController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: AppColor().blackColor,
                      fontSize: AppDimens().front_regular,
                    ),
                    onChanged: (value) {
                      buyerController.loadMarketPlaceProducts();
                    },
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey.shade700),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // ---------------------- PRODUCT LIST ----------------------
                Obx(() {
                  if (buyerController.productList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          "No products found",
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey[700]),
                        ),
                      ),
                    );
                  }

                  final activeProducts = buyerController.productList
                      .where((p) => p.isActive)
                      .toList();

                  final inactiveProducts = buyerController.productList
                      .where((p) => !p.isActive)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ACTIVE SECTION
                      if (activeProducts.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12, top: 10, bottom: 5),
                          child: Text(
                            "Active Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      buildProductList(activeProducts),

                      SizedBox(height: 20),

                      // INACTIVE SECTION
                      if (inactiveProducts.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 12, top: 10, bottom: 5),
                          child: Text(
                            "Inactive Products",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      buildProductList(inactiveProducts),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),

      // ---------------------- BOTTOM ADD BUTTON ----------------------
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.white,
        child: Center(
          child: GestureDetector(
            onTap: () => Get.to(() => AddProduct()),
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor().whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PRODUCT CARD BUILDER
  // ==========================================================
  Widget buildProductList(List<dynamic> list) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.images ?? "",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) =>
                      Icon(Icons.image_not_supported, size: 50),
                ),
              ),

              SizedBox(width: 12),

              // DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeFirstLetter(item.title ?? ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "₹ ${item.price ?? 0}",
                      style: TextStyle(
                          fontSize: 15, color: AppColor().colorPrimary),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item.cityName ?? 'Location Not Provided',
                      style:
                          TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),

              // ACTIONS (EDIT + TOGGLE)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // EDIT BUTTON
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() =>
                          AddProduct(product: item, isEdit: true));
                    },
                    child: Icon(Icons.edit),
                  ),

                  // TOGGLE BUTTON
                  IconButton(
                    icon: Icon(
                      item.isActive
                          ? Icons.toggle_on
                          : Icons.toggle_off,
                      color: item.isActive ? Colors.green : Colors.grey,
                      size: 35,
                    ),
                    onPressed: () async {
                      await buyerController.activateDeactivateProduct(
                        item.id!,
                        !item.isActive,
                      );
                      buyerController.loadMarketPlaceProducts();
                    },
                  ),

                  SizedBox(height: 20),
                  Text(
                    timeAgo(item.createdAt ?? ""),
                    style:
                        TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

// ==========================================================
// HELPER FUNCTIONS
// ==========================================================
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
    return "";
  }
}

String capitalizeFirstLetter(String name) {
  if (name.isEmpty) return "";
  return name[0].toUpperCase() + name.substring(1);
}
