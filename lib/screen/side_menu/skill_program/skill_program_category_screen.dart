import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/skill_program.dart';
import 'skill_program.dart';

class SkillProgramCategoryScreen extends StatelessWidget {
  const SkillProgramCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SkillProgramController>();

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

        if (controller.categoryList.isEmpty) {
          return const Center(
            child: Text("No Categories Found"),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 10),

              /// 🔍 SEARCH
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
                      hintText: "Search category...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🎯 TITLE
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
                      "Select your category",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// 🔥 GRID (SAME LIKE SUPER CATEGORY)
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

                    return GestureDetector(
                      onTap: () async {
  final categoryId = item['id'] ?? 0;

  // 🔥 CALL SUB CATEGORY API
  await controller.getSubCategory(categoryId);

  // 🔥 OPEN BOTTOM SHEET
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return subCategoryBottomSheet(controller);
    },
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

                            /// 📷 IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: item['image'] != null &&
                                      item['image'].isNotEmpty &&
                                      item['image'][0]['path'] != null
                                  ? Image.network(
                                      item['image'][0]['path'],
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
                              item['name'] ?? "",
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


  Widget subCategoryBottomSheet(SkillProgramController controller) {
  return Container(
    height: Get.height * 0.6,
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
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        /// TITLE
        const Text(
          "Select Sub Category",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 15),

        /// 🔥 GRID (UPDATED)
        Expanded(
          child: Obx(() {
            if (controller.isSubCategoryLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.subCategoryList.isEmpty) {
              return const Center(child: Text("No Sub Categories"));
            }

            return GridView.builder(
              itemCount: controller.subCategoryList.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 🔥 3x3 GRID
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: .85,
              ),
              itemBuilder: (context, index) {
                final item = controller.subCategoryList[index];

                return GestureDetector(
                  onTap: () {
                    // 🔥 SET FILTER
                    controller.filterSubCategoryId.value =
                        item['id'] ?? 0;

                    // 🔥 CLOSE
                    Get.back();

                    // 🔥 NAVIGATE
                    Get.to(() => const SkillProgramScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        /// 📷 IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item['image'] != null &&
                                  item['image'].isNotEmpty &&
                                  item['image'][0]['path'] != null
                              ? Image.network(
                                  item['image'][0]['path'],
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
                                  child: const Icon(Icons.category, size: 20),
                                ),
                        ),

                        const SizedBox(height: 8),

                        /// 📝 NAME
                        Text(
                          item['name'] ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
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
        ),
      ],
    ),
  );
}
}