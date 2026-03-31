import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/skill_program.dart';
import 'skill_program_category_screen.dart';

class SkillProgramSuperCategoryScreen extends StatelessWidget {
  SkillProgramSuperCategoryScreen({super.key});

  final SkillProgramController controller =
      Get.put(SkillProgramController());

  @override
  Widget build(BuildContext context) {
    // 🔥 CALL API
    controller.getSuperCategories();

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Explore Skills",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        leading: const BackButton(color: Colors.black),
      ),

      body: Obx(() {
        if (controller.isSuperCategoryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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
                      hintText: "Search skills...",
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
                      "Browse Skills",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Discover amazing skill programs",
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
                  itemCount: controller.superCategoryList.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .82,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.superCategoryList[index];

                    return GestureDetector(
                 onTap: () async {
  final id = item.id ?? 0;

  // 🔥 CALL CATEGORY API (FILTER BY SUPER CATEGORY)
  await controller.getCategory(
    superCategoryId: id,
  );

  // 🔥 RESET FILTERS
  controller.filterCategoryId.value = 0;
  controller.filterSubCategoryId.value = 0;

  // 🔥 NAVIGATE TO CATEGORY SCREEN (NOT PROGRAM SCREEN)
  Get.to(() => const SkillProgramCategoryScreen());
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
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.school),
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
      }),
    );
  }
}