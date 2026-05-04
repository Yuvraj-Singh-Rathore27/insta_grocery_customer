import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/vechile_profile/VechileRegisterScreen.dart';
import 'package:insta_grocery_customer/screen/side_menu/vechile_profile/VehicleMapScreenn.dart';
import 'package:insta_grocery_customer/screen/side_menu/vechile_profile/VehicleProfileScreen.dart';
import '../../../controller/vechile_controller.dart';

class VehicleHomeScreen extends StatefulWidget {
  const VehicleHomeScreen({super.key});

  @override
  State<VehicleHomeScreen> createState() => _VehicleHomeScreenState();
}

class _VehicleHomeScreenState extends State<VehicleHomeScreen> {
  final controller = Get.put(VehicleController());

  @override
  void initState() {
    super.initState();

    // 🔥 IMPORTANT API CALL
    controller.fetchNearbyVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3EEF6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Vehicle Management",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categoryList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final category = controller.categoryList[index];

            String imageUrl = "";
            if (category.image != null && category.image!.isNotEmpty) {
              imageUrl = category.image![0].path ?? "";
            }

            return GestureDetector(
              onTap: () async {
                // 🔥 SHOW LOADER DIALOG
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                await controller.onCategorySelected(category);
                await controller.fetchNearbyVehicles();

                // 🔥 CLOSE LOADER
                Get.back();

                _openSubCategoryBottomSheet(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(imageUrl, height: 70)
                        : const Icon(Icons.image, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Get.to(() => VehiclePostScreen());
          } else if (index == 3) {
            Get.to(() => VehicleProfileScreen());
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: "Activity"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ================= SUBCATEGORY =================
  void _openSubCategoryBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          if (controller.isLoadingSubCategories.value) {
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select SubCategory",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.subCategoryList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final sub = controller.subCategoryList[index];

                  String imageUrl = "";
                  if (sub.image != null && sub.image!.isNotEmpty) {
                    imageUrl = sub.image![0].path ?? "";
                  }

                  // 🔥 VEHICLE CHECK
                  bool hasVehicle = controller.nearbyVehicles.any((v) {
                    final vSubId =
                        (v['subcategory_id'] ?? v['subcategory']?['id'])
                            ?.toString();

                    final vCatId =
                        (v['category_id'] ?? v['category']?['id'])?.toString();

                    return vSubId == sub.id.toString() &&
                        vCatId ==
                            controller.selectedCategory.value?.id.toString();
                  });

                  return GestureDetector(
                    onTap: () {
                      if (hasVehicle) {
                        controller.onSubCategorySelected(sub);
                        Get.back();
                        Get.to(() => VehicleMapScreen());
                      } else {
                        // 🔥 SHOW POPUP
                        Get.snackbar(
                          "No Vehicles",
                          "No vehicles available in nearby for this category",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: Opacity(
                      opacity: hasVehicle ? 1 : 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            imageUrl.isNotEmpty
                                ? Image.network(imageUrl, height: 60)
                                : const Icon(Icons.directions_car, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              sub.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
