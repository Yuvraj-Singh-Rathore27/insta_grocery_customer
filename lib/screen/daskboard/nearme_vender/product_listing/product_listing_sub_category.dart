import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/daskboard/nearme_vender/checkout/checkout.dart';
import 'package:insta_grocery_customer/toolbar/TopBarNew.dart';

import '../../../../controller/vender_controller.dart';
import '../../../../res/AppColor.dart';

class ProductListingSubCategory extends StatefulWidget {
  ProductListingSubCategory({Key? key}) : super(key: key);

  @override
  State<ProductListingSubCategory> createState() =>
      _ProductListingSubCategoryState();
}

class _ProductListingSubCategoryState extends State<ProductListingSubCategory>
    with SingleTickerProviderStateMixin {
  final PharmacyController controller = Get.find();
  late double height, width;
 String? _sortBy;// Default sort option
  String _selectedFilter = 'All Products'; // Track selected filter

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.selectedCategory.value != null) {
        controller.getSubcatgory();
      }
      controller.getProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarNew(
        title: "",
        menuicon: false,
        menuback: true,
        iconnotifiction: true,
        is_wallaticon: true,
        is_supporticon: false,
        is_whatsappicon: false,
        onPressed: () {},
        onTitleTapped: () {},
      ),

      // BODY
      body: Column(
        children: [
          buildSearchBarWithFilter(),
          // TOP FILTER BAR (like in the image)
          _buildTopFilterBar(),
          
          // CHILD SUBCATEGORIES (Vertical list on left)
          _buildChildSubCategories(),
          
          // PRODUCTS GRID
          Expanded(
            child: _buildProductsList(),
          ),
          
          // BOTTOM CART BUTTON
          _buildBottomCartButton(),
        ],
      ),
    );
  }

  Widget _buildTopFilterBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // Filter tabs
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterTab("All Products", _selectedFilter == 'All Products', () {
                  setState(() {
                    _selectedFilter = 'All Products';
                  });
                }),
                SizedBox(width: 12),
                _filterTab("Electronics", _selectedFilter == 'Electronics', () {
                  setState(() {
                    _selectedFilter = 'Electronics';
                  });
                }),
                SizedBox(width: 12),
                _filterTab("Fashion", _selectedFilter == 'Fashion', () {
                  setState(() {
                    _selectedFilter = 'Fashion';
                  });
                }),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Product count and sort
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                "${controller.productList.length} Products",
                style: TextStyle(fontSize: 16, color: AppColor().blackColor,fontWeight: FontWeight.bold),
              )),
              
              SizedBox(
  height: 40, // fixed height
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
  value: _sortBy,
  hint: Text("Sort"),
  onChanged: (String? newValue) {
    setState(() {
      _sortBy = newValue;
    });
  },
  items: [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest First'
  ].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
)

    ),
  ),
),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterTab(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? AppColor().colorPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColor().colorPrimary : Colors.transparent,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColor().colorPrimary : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildChildSubCategories() {
    return Obx(() => controller.ChildSubCategoryList.isNotEmpty
        ? Container(
            height: 90,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.ChildSubCategoryList.length,
              itemBuilder: (context, index) {
                final item = controller.ChildSubCategoryList[index];
                return GestureDetector(
                  onTap: () {
                    // Handle category selection
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    width: 70,
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.grey[50],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.logo ?? "",
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Center(
                                child: Icon(
                                  Icons.category,
                                  size: 28,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          item.name ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : SizedBox());
  }

  Widget _buildProductsList() {
  return Obx(() {
    if (controller.productList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 60, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text(
              "No products found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(14),
      itemCount: controller.productList.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildProductCard(controller.productList[index]);
      },
    );
  });
}

 Widget _buildProductCard(item) {
  double discountPercentage = 0;
  bool hasDiscount = false;

  try {
    double original = double.tryParse(item.price.toString()) ?? 0;
    double discount = double.tryParse(item.discount_price.toString()) ?? 0;

    if (original > discount && discount > 0) {
      hasDiscount = true;
      discountPercentage = ((original - discount) / original) * 100;
    }
  } catch (_) {}

  return Container(
    margin: EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ------------------- IMAGE AREA -------------------
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: Stack(
            children: [
              Image.network(
                item.images ?? item.logo ?? "",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, size: 50),
                ),
              ),

              // DISCOUNT BADGE
              if (hasDiscount)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${discountPercentage.toStringAsFixed(0)}% OFF",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              // FAVORITE BUTTON
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    item.isfavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ------------------- DETAILS AREA -------------------
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAME
              Text(
                item.name ?? "Unnamed Product",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 6),

              // SHORT DESCRIPTION (combine fields)
              Text(
  (item.description == null || item.description.toString().trim().isEmpty)
      ? "Amazing Product"
      : item.description.toString(),
  style: TextStyle(
    fontSize: 14,
    color: Colors.grey[700],
  ),
),
              SizedBox(height: 8),

              // RATING
              Row(
                children: [
                  ...List.generate(
                    4,
                    (i) => Icon(Icons.star, color: Colors.orange, size: 18),
                  ),
                  Icon(Icons.star_half, color: Colors.orange, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "(4.5) 2,345 reviews",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),

              SizedBox(height: 14),

              // PRICE + ADD BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // PRICE SECTION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount)
                        Text(
                          "₹${item.price}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        "₹${hasDiscount ? item.discount_price : item.price}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),

                  // ADD BUTTON
                  GestureDetector(
                    onTap: () => controller.addToCart(item),
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  Widget _buildBottomCartButton() {
    return Obx(() => controller.cartList.isNotEmpty
        ? Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => Get.to(() => CheckoutPage()),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "View Cart (${controller.cartList.length} items)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "₹${_calculateCartTotal()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox());
  }

  // Helper method to calculate cart total
  String _calculateCartTotal() {
    double total = 0;
    for (var item in controller.cartList) {
      try {
        double price = double.tryParse(item.price.toString()) ?? 0;
        // Use discounted price if available
        if (item.discount_price != null && item.discount_price.toString().isNotEmpty) {
          double discountPrice = double.tryParse(item.discount_price.toString()) ?? 0;
          if (discountPrice > 0 && discountPrice < price) {
            price = discountPrice;
          }
        }
        total += price * (item.quntityadded ?? 1);
      } catch (e) {
        print("Error calculating price for item: $e");
      }
    }
    return total.toStringAsFixed(0);
  }


  Widget buildSearchBarWithFilter() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    child: Row(
      children: [
        // 🔍 Search Field
        Expanded(
          child: SizedBox(
            height: 40, // Match filter button height
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search for products...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ⚙️ Filter Button
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.tune, color: Colors.white, size: 20),
        ),
      ],
    ),
  );
}
}