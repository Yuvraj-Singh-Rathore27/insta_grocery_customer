import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/job_module/PostResumeScreen.dart';
import '../../controller/job_controller.dart';
import 'SimpleJobListingsScreen .dart';
import '../../res/AppColor.dart';
import './JobProviderDashboard.dart';
import 'package:insta_grocery_customer/screen/job_module/myPostedJobScreen.dart';
import 'package:insta_grocery_customer/screen/job_module/PostJobScreen.dart';
import './resume_database_screen.dart';

class BaseTapHealthJob extends StatelessWidget {
  BaseTapHealthJob({super.key});

  final JobProviderController controller =
      Get.put(JobProviderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.work,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Freebo Job",
                style: TextStyle(
                  color: AppColor().colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const PostResumeScreen());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor().colorYellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "My Resume",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),

      /// BODY
      body: Obx(() {
        if (controller.jobTypeList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Text(
                  "Select A Job Category",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),

              /// CATEGORY TYPE CHIPS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMainTypeChip("CAREER", "🎓"),
                      _buildMainTypeChip("BUSINESS", "🏢"),
                      _buildMainTypeChip("DOMESTIC", "🏠"),
                      _buildMainTypeChip("FRESHER", "👶"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DASHBOARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: jobProviderDashboardSection(context),
              ),

              const SizedBox(height: 20),

              /// DYNAMIC CATEGORY LAYOUT
              _buildDynamicCategoryLayout(context),
            ],
          ),
        );
      }),
    );
  }

  /// Build dynamic category layout - selected category becomes list item, others adjust
  Widget _buildDynamicCategoryLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          /// Use LayoutBuilder to get the available width
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 10,
                runSpacing: 14,
                children: List.generate(controller.jobTypeList.length, (index) {
                  final category = controller.jobTypeList[index];
                  
                  final int jobCountValue = controller
                      .getJobCountByCategory(category.id?.toString() ?? "");
                  final String jobCount = jobCountValue.toString();
                  
                  final isSelected = controller.selectedCategoryID.value == 
                      (category.id?.toString() ?? "");

                  /// If selected, show as horizontal list item (full width)
                  if (isSelected) {
                    return Container(
                      width: constraints.maxWidth,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: _buildSelectedCategoryItem(category, jobCount),
                    );
                  } 
                  /// Otherwise show as grid item (33% width for 3 columns)
                  else {
                    return SizedBox(
                      width: (constraints.maxWidth - 20) / 3, // 10 spacing * 2 = 20
                      child: _buildCategoryGridItem(context,category, jobCount),
                    );
                  }
                }),
              );
            },
          ),

          /// SUBCATEGORIES FOR SELECTED CATEGORY
          
        ],
      ),
    );
  }

  /// Selected category item (horizontal/full width)
  Widget _buildSelectedCategoryItem(category, String jobCount) {
    return GestureDetector(
      onTap: () async {
        // Collapse if already selected
        controller.selectedCategoryID.value = "";
        controller.selectedCategoryFilter.value = "";
        controller.jobSubTypeList.clear();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColor().colorPrimary,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(
                Icons.work_outline,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // ADD THIS - prevents unbounded height
                children: [
                  Text(
                    category.name ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    "$jobCount Jobs Available",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: AppColor().colorPrimary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Regular category grid item - REMOVED the isSelected parameter since it's not used
  Widget _buildCategoryGridItem( BuildContext context,category, String jobCount) {
    return GestureDetector(
     onTap: () async {

  controller.selectedCategoryFilter.value =
      category.name ?? "";

  controller.selectedCategoryID.value =
      category.id?.toString() ?? "";

  await controller.getJobSubcategoryList();

  _showSubCategorySheet(context);

},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ADD THIS - prevents unbounded height
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(
                Icons.work_outline,
                color: Colors.black,
                size: 20,
              ),
            ),

            const SizedBox(height: 8),

            // REMOVED Expanded widget - this was causing the issue
            Text(
              category.name ?? "",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "$jobCount Jobs",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showSubCategorySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Subcategory",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor().colorPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// SUBCATEGORY GRID
            Expanded(
              child: Obx(() {
                return GridView.builder(
                  itemCount: controller.jobSubTypeList.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final sub = controller.jobSubTypeList[index];

                    return GestureDetector(
                      onTap: () {
                        controller.selectedSubCategoryFilter.value =
                            sub.name ?? "";
                        controller.selecteSubdCategoryId.value =
                            sub.id.toString();

                        controller.applyFilters();

                        Get.back();

                        Get.to(() => const SimpleJobListingsScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColor().colorPrimary),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.work_outline,
                                color: AppColor().colorPrimary),
                            const SizedBox(height: 6),
                            Text(
                              sub.name ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
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
    },
  );
}

  /// Build subcategories grid
  Widget _buildSubcategoriesGrid() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: controller.jobSubTypeList.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Just change this to 3
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2, // Keep same aspect ratio
    ),
    itemBuilder: (context, index) {
      final sub = controller.jobSubTypeList[index];
      
      return GestureDetector(
        onTap: () {
          controller.selectedSubCategoryFilter.value =
              sub.name ?? "";
          controller.selecteSubdCategoryId.value =
              sub.id.toString();
          controller.applyFilters();
          Get.to(() => const SimpleJobListingsScreen());
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColor().colorPrimary),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.work_outline,
                size: 24,
                color: AppColor().colorPrimary,
              ),
              const SizedBox(height: 8),
              Text(
                sub.name ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    },
  );
}
  /// CATEGORY CHIP
  Widget _buildMainTypeChip(String type, String emoji) {
    return Obx(() {
      final isSelected =
          controller.selectedMainCategoryType.value == type;

      return GestureDetector(
        onTap: () {
          controller.selectedMainCategoryType.value = type;
          controller.getJobTypeList(type);
          // Clear expanded category when main type changes
          controller.selectedCategoryID.value = "";
          controller.jobSubTypeList.clear();
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor().colorPrimary
                : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border:
                Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // ADD THIS
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                type.capitalizeFirst!,
                style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ],
          ),
        ),
      );
    });
  }
}