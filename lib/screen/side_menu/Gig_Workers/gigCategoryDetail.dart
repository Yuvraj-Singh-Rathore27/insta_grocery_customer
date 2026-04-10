import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import '../../../controller/gigs_works_controller.dart';
import './gigSearchScreen.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GigsController controller = Get.find<GigsController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1200;
    
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.selectedSuperCategoryName.value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (controller.selectedSuperCategoryId.value != 0) {
                controller.getCategory(
                  superCategoryId: controller.selectedSuperCategoryId.value,
                  superCategoryName: controller.selectedSuperCategoryName.value,
                );
              }
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isCategoryLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF3B82F6),
            ),
          );
        }
        
        if (controller.categoryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No categories available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (controller.selectedSuperCategoryId.value != 0) {
                      controller.getCategory(
                        superCategoryId: controller.selectedSuperCategoryId.value,
                        superCategoryName: controller.selectedSuperCategoryName.value,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor().colorPrimary,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        // Responsive grid
        int crossAxisCount;
        if (isDesktop) {
          crossAxisCount = 5;
        } else if (isTablet) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            final category = controller.categoryList[index];
            return _buildCategoryCard(context, category, controller);
          },
        );
      }),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, 
    dynamic category, 
    GigsController controller
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Show bottom sheet with subcategories
          _showSubCategoryBottomSheet(context, category, controller);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:  AppColor().colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Icon(
                  Icons.category,
                  size: 30,
                  color: AppColor().colorPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubCategoryBottomSheet(BuildContext context, dynamic category, GigsController controller) {
    // Fetch subcategories
    controller.getSubCategory(category.id, categoryName: category.name);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            final screenWidth = MediaQuery.of(context).size.width;
            final crossAxisCount = screenWidth < 600 ? 2 : 3;
            
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColor().colorPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  Icon(
                            Icons.category,
                            size: 24,
                            color: AppColor().colorPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  // Subcategories grid
                  Expanded(
                    child: Obx(() {
                      if (controller.isSubCategoryLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3B82F6),
                          ),
                        );
                      }
                      
                      if (controller.subCategoryList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.subdirectory_arrow_right,
                                size: 60,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No subcategories available',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  controller.getSubCategory(category.id, categoryName: category.name);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: controller.subCategoryList.length,
                        itemBuilder: (context, index) {
                          final subCategory = controller.subCategoryList[index];
                          return _buildSubCategoryGridItem(
                            context, 
                            subCategory, 
                            controller, 
                            category
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
      },
    );
  }

  Widget _buildSubCategoryGridItem(
  BuildContext context,
  dynamic subCategory,
  GigsController controller,
  dynamic parentCategory,
) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: InkWell(
      onTap: () {
        // Set the selected subcategory
        controller.setSubCategory(subCategory.id, subCategory.name);
        Navigator.pop(context); // Close subcategory bottom sheet
        
        // Navigate directly to GigSearchScreen
        Get.to(() => const GigSearchScreen());
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColor().colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  Icon(
                Icons.subdirectory_arrow_right,
                size: 28,
                color: AppColor().colorPrimary
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subCategory.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showActionBottomSheet(
  BuildContext context,
  dynamic subCategory,
  GigsController controller,
  dynamic parentCategory,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              subCategory.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              parentCategory.name,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.list_alt, color: Color(0xFF3B82F6)),
              title: const Text('View All Gigs'),
              onTap: () {
                controller.setSubCategory(subCategory.id, subCategory.name);
                Navigator.pop(context); // Close action bottom sheet
                Navigator.pop(context); // Close subcategory bottom sheet
                
                // Navigate to GigSearchScreen
                Get.to(() => const GigSearchScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_business, color: Color(0xFF10B981)),
              title: const Text('Create Gig Profile'),
              onTap: () {
                controller.setSubCategory(subCategory.id, subCategory.name);
                Navigator.pop(context); // Close action bottom sheet
                Navigator.pop(context); // Close subcategory bottom sheet
                Get.toNamed('/create-profile');
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    },
  );
}
}