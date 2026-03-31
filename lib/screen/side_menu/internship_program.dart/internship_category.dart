import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/internship_controller.dart';
import 'internship_program.dart';

class InternshipCategoryScreen extends StatelessWidget {
  final int superCategoryId;

  InternshipCategoryScreen({super.key, required this.superCategoryId});

  final InternshipController controller =
      Get.find<InternshipController>();

  @override
  Widget build(BuildContext context) {

    /// 🔥 CALL CATEGORY API WITH SUPER CATEGORY ID
    controller.getCategory(superCategoryId: superCategoryId);

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Select Category",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        leading: const BackButton(color: Colors.black),
      ),

      body: Obx(() {

        if (controller.isCategoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// 📌 HEADER
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
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
                      "Find categories by selection",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// 🔥 GRID VIEW (same as super category)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.categoryList.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .82,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.categoryList[index];

                    final id = item['id'] ?? 0;
                    final name = item['name'] ?? "";
                    final image = item['image']?[0]?['path'];

                    return GestureDetector(
                    onTap: () async {
  final id = item['id'] ?? 0;

  /// SELECT CATEGORY
  controller.selectedCategoryId.value = id;
  controller.selectedSubCategoryId.value = 0;

  /// LOAD SUBCATEGORY
  await controller.getSubCategory(id);

  /// OPEN WIDGET
  Get.bottomSheet(
    subCategoryBottomSheet(controller),
    isScrollControlled: true,
  );
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

                            /// 🖼 IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: image != null
                                  ? Image.network(
                                      image,
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
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.category),
                                    ),
                            ),

                            const SizedBox(height: 10),

                            /// 📝 NAME
                            Text(
                              name,
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
      }),
    );
  }


  Widget subCategoryBottomSheet(InternshipController controller) {
  return Container(
    height: Get.height * 0.65,
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      children: [

        /// 🔥 HANDLE
        Container(
          height: 5,
          width: 50,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        /// 🧾 TITLE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Select SubCategory",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Get.back(),
            )
          ],
        ),

        const Divider(),

        /// 🔥 GRID VIEW (3x3)
        Expanded(
          child: Obx(() {
            if (controller.isSubCategoryLoading.value) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            if (controller.subCategoryList.isEmpty) {
              return const Center(
                  child: Text("No SubCategory Found"));
            }

            return GridView.builder(
              itemCount: controller.subCategoryList.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 🔥 3 columns
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .85,
              ),
              itemBuilder: (context, index) {
                final item = controller.subCategoryList[index];

                final id = item['id'] ?? 0;
                final name = item['name'] ?? "";
                final image = item['image']?[0]?['path'];

                final isSelected =
                    controller.selectedSubCategoryId.value == id;

                return GestureDetector(
                  onTap: () {
                    /// ✅ SELECT SUB CATEGORY
                    controller.selectedSubCategoryId.value = id;

                    /// 🔥 FILTER
                    controller.filterInternshipsBySubCategory(id);

                    /// CLOSE
                    Get.back();

                    /// NAVIGATE
                    Get.to(() => const InternshipListScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
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

                        /// 🖼 IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: image != null
                              ? Image.network(
                                  image,
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.category),
                                ),
                        ),

                        const SizedBox(height: 8),

                        /// 📝 NAME
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    ),
  );
}
}