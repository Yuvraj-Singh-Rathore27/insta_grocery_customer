import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import 'package:insta_grocery_customer/controller/mp_add_product_controller.dart';

import 'package:insta_grocery_customer/screen/market_place/buyer/buyer_category.dart';
import 'package:insta_grocery_customer/screen/market_place/buyer/buyer_product_details.dart';
import 'package:insta_grocery_customer/screen/market_place/seller/seller_home.dart';

import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import '../../../res/ImageRes.dart';
import '../../../toolbar/TopBar.dart';
import 'buyer_subcategory_product.dart';


class BuyerHome extends StatelessWidget {
  final BuyerController buyerController = Get.put(BuyerController());
  final MpAddProductController mpController = Get.put(MpAddProductController());
  

  BuyerHome({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      buyerController.loadCategories();
      mpController.loadMarketPlaceProducts();   // Load API
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

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              _buildSearchBox(),
              const SizedBox(height:10,),
              buildCategorySection(),
              SizedBox(height: 10),
              // _buildFeaturedListing(),
              SizedBox(height: 10),
              _buildLatestListing(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // -----------------------------------------------------------
  //                       SEARCH BOX
  // -----------------------------------------------------------
  Widget _buildSearchBox() {
    return Container(
  height: 50,
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  child: TextField(
    keyboardType: TextInputType.text,
    style: TextStyle(
      color: AppColor().blackColor,
      fontSize: AppDimens().front_regular,
    ),
    controller: mpController.searchController,
    onChanged: (value) {
      mpController.loadMarketPlaceProducts();
    },
    decoration: InputDecoration(
      hintText: "Search products...", // use hintText instead of labelText for cleaner look
      hintStyle: TextStyle(
        color: Colors.grey.shade600,
        fontSize: AppDimens().front_regular,
      ),
      prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
      filled: true,
      fillColor: Colors.grey.shade200, // subtle background
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // rounded corners
        borderSide: BorderSide.none, // remove harsh border
      ),
    ),
  ),
);
  }

  // -----------------------------------------------------------
  //                      CATEGORY TITLE ROW
  // -----------------------------------------------------------
 // -----------------------------------------------------------
//                   CATEGORY SECTION (NEW UI)
// -----------------------------------------------------------

Widget buildCategorySection() {
  return Obx(
    () => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // ---------------- HEADER ----------------
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Categories",
                  style: TextStyle(
                    fontSize: AppDimens().front_medium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => BuyerAllCategoryList()),
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: AppDimens().front_medium,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),
          Divider(),

          SizedBox(height: 18),

          // ---------------- CATEGORY LIST ----------------
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: buyerController.categoryList.length,
              itemBuilder: (context, index) {
                final item = buyerController.categoryList[index];

                // ---------------- SAFE IMAGE PATH ----------------
                String imagePath = "";
                if (item.photos != null &&
                    item.photos!.isNotEmpty &&
                    item.photos![0].path != null &&
                    item.photos![0].path!.isNotEmpty) {
                  imagePath = item.photos![0].path!;
                }

                return GestureDetector(
                  onTap: () {
                    buyerController.selectedCategory.value = item;
                    buyerController.loadSubCategories(item.id.toString());
                    Get.to(() => BuyerSubcategoryProduct());
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            imagePath,
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 60,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(Icons.image, size: 35),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          item.name ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: AppDimens().front_12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Helvetica",
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}


  // -----------------------------------------------------------
  //                     FEATURED LISTING (STATIC)
  // -----------------------------------------------------------
  Widget _buildFeaturedListing() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  Featured Listing",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens().front_medium),
              ),
              Text(
                "View All",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens().front_medium),
              ),
            ],
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "https://e-clinicx.s3.ap-south-1.amazonaws.com/admin/photo/download_1746030322373.jpg",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text("Product Name",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ 2000.00"),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  //                   LATEST LISTING (API DATA)
  // -----------------------------------------------------------
 Widget _buildLatestListing() {
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // ---------------- HEADER ----------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Latest Listing",
            style: TextStyle(
              fontSize: AppDimens().front_medium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 15),

        Obx(() {
          final list = mpController.productList;

          if (list.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "No Latest Products Found",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final item = list[index];

              // ---------------- SAFE IMAGE CHECK ----------------
              String imagePath = "";
              if (item.image_url != null && item.image_url!.isNotEmpty) {
                imagePath = item.image_url!.first;
              } else if (item.images != null && item.images!.isNotEmpty) {
                imagePath = item.images!;
              } else if (item.logo != null && item.logo!.isNotEmpty) {
                imagePath = item.logo!;
              }

              return GestureDetector(
                onTap: () => Get.to(() => MProductDetails(product: item)),

                child: Container(
                  margin: EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // ---------------- IMAGE ----------------
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                        child: Image.network(
                          imagePath,
                          height: 110,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            height: 110,
                            width: 120,
                            color: Colors.grey.shade200,
                            child:
                                Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // ---------------- PRODUCT DETAILS ----------------
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              // ---------- TITLE ----------
                              Text(
                                capitalizeFirstLetter(item.title ?? ""),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),

                              // ---------- PRICE ----------
                              Text(
                                "₹ ${item.price ?? 0}",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor().colorPrimary,
                                ),
                              ),
                              SizedBox(height: 10),

                              // ---------- CITY & TIME ----------
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.cityName ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ---------------- RIGHT SIDE ACTIONS ----------------
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: Column(
                          children: [
                            
IconButton(
  onPressed: () {
    buyerController.toggleInterest(item);
  },
  icon: Icon(
    item.isInterested ? Icons.favorite : Icons.favorite_border,
    color: item.isInterested ? Colors.red : Colors.grey,
  ),
),

                            SizedBox(height: 35),

                            Text(
                              timeAgo(item.createdAt ?? ""),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    ),
  );
}


  // -----------------------------------------------------------
  //                      BOTTOM BUTTON
  // -----------------------------------------------------------
  Widget _buildBottomButton() {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColor().whiteColor.withOpacity(0.1),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () => Get.to(() => SellerHomePage()),
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Become Seller',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColor().whiteColor,
                      fontFamily: "Inter",fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      );
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
    return "";
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return "";
  return text[0].toUpperCase() + text.substring(1);
}
