import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/live_offer/OfferNearbyMapScreen.dart';
import 'package:insta_grocery_customer/screen/side_menu/live_offer/live_offer.dart';
import '../../../controller/vender_controller.dart';
import '../../../res/AppColor.dart';

class OfferDashboardScreen extends StatefulWidget {
  const OfferDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OfferDashboardScreen> createState() =>
      _OfferDashboardScreenState();
}

class _OfferDashboardScreenState
    extends State<OfferDashboardScreen> {

  final PharmacyController controller = Get.find();

  @override
  void initState() {
    super.initState();

    /// 🔥 Call APIs only once
    controller.getOfferCategoriesApi();
    controller.getStoreOfferApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Explore Offers",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔎 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: "Search offers, stores...",
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 📦 Title
              const Text(
                "Browse Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Discover amazing offers near you",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              /// 🧱 CATEGORY GRID
              Obx(() {

                /// 🔄 Show Loader
                if (controller.isLoadingCategory.value) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                /// ❌ If empty
                if (controller.offerCategories.isEmpty) {
                  return const Center(
                      child: Text("No categories available"));
                }

                /// ✅ Show Grid
                return GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: controller.offerCategories.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.75, // Adjusted for better 3-column ratio
  ),
  itemBuilder: (context, index) {
    final category = controller.offerCategories[index];

    final imageUrl =
        (category.image != null &&
                category.image!.isNotEmpty &&
                category.image!.first.path != null &&
                category.image!.first.path!.isNotEmpty)
            ? category.image!.first.path
            : null;

    return GestureDetector(
      onTap: () {
        controller.selectedOfferCategoryId.value =
            category.id ?? 0;

        controller.selectedOfferSubCategoryId.value = 0;

        controller.getOfferSubCategoriesApi(
            category.id ?? 0);

        controller.filterNearbyOffersByCategory();

        Get.to(() => const LiveOfferScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🖼 Category Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_offer,
                          size: 40,
                          color: Colors.red,
                        );
                      },
                    )
                  : const Icon(
                      Icons.local_offer,
                      size: 40,
                      color: Colors.red,
                    ),
            ),

            const SizedBox(height: 8),

            /// 📛 Category Name
            Text(
              category.name ?? "",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  },
);
              }),
            ],
          ),
        ),
      ),

      /// ➕ Floating Button
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColor().colorPrimary,
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),

      /// 📌 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColor().colorPrimary,
        onTap: (index) {
          if (index == 1) {
            Get.to(() => const NearbyOfferMapScreen());
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "NearBy-Events",
          ),
        ],
      ),
    );
  }
}