import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import 'package:insta_grocery_customer/screen/market_place/seller/add_product.dart';
import 'buyer_home.dart';

class MarketPlaceSuperCategoryScreen extends StatelessWidget {
  MarketPlaceSuperCategoryScreen({super.key});

  final BuyerController controller = Get.put(BuyerController());

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Explore Marketplace",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        leading: const BackButton(color: Colors.black),
      ),

      body: GetBuilder<BuyerController>(
        builder: (c) {
          return SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 10),

                // ⭐ SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search categories...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ⭐ TITLE SECTION
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xffe9dddd),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Browse Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Discover amazing products around you",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ⭐ GRID
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: c.superCategoryList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: .82,
                    ),
                    itemBuilder: (context, index) {
                      final item = c.superCategoryList[index];

                      return GestureDetector(
                        onTap: () {
                          controller.onSuperCategoryTap(item);
                          Get.to(() => BuyerHome());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(.05),
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // ⭐ IMAGE
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: item.images != null &&
                                        item.images!.isNotEmpty &&
                                        item.images!.first.path != null &&
                                        item.images!.first.path!.isNotEmpty
                                    ? Image.network(
                                        item.images!.first.path!,
                                        height: 55,
                                        width: 55,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 55,
                                        width: 55,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: const Icon(Icons.category),
                                      ),
                              ),

                              const SizedBox(height: 10),

                              // ⭐ NAME
                              Text(
                                item.name ?? "",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    floatingActionButton: Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.red.withOpacity(0.4),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: IconButton(
      icon: const Icon(Icons.add, color: Colors.white, size: 30),
      onPressed: () {
        Get.to(() => AddProduct());
      },
    ),
  ),

  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

  // ✅ BOTTOM NAV BAR
  bottomNavigationBar: Obx(() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          /// 🔥 HOME
          GestureDetector(
            onTap: () {
              controller.changeIndex(0);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: controller.selectedIndex.value == 0
                      ? Colors.red
                      : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.selectedIndex.value == 0
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 40), // FAB space

          /// 🔥 MY EVENTS
          GestureDetector(
            onTap: () {
              controller.changeIndex(1);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: controller.selectedIndex.value == 1
                      ? Colors.red
                      : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  "My Products",
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.selectedIndex.value == 1
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }),
    );
  }
}