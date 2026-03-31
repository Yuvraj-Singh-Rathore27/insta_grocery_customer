import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../utills/Utils.dart';

import '../../../controller/internship_controller.dart';
import '../../../res/AppColor.dart';
import '../../../res/AppDimens.dart';
import './intern_ship_detail.dart';

class InternshipListScreen extends StatefulWidget {
  const InternshipListScreen({super.key});

  @override
  State<InternshipListScreen> createState() => _InternshipListScreenState();
}

class _InternshipListScreenState extends State<InternshipListScreen> {
  final InternshipController controller = Get.put(InternshipController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            "Internships",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Add search functionality
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey.shade200,
              height: 1,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.refreshList,
          color: AppColor().colorPrimary,
          backgroundColor: Colors.white,
          strokeWidth: 2,
          child: Obx(() {
            // Combined loading states
            final bool isLoading = controller.isLoading.value ||
                controller.isCategoryLoading.value ||
                controller.isSubCategoryLoading.value;

            return Column(
              children: [
                // Filter Section
                // _buildFilterSection(),
                
                // Stats Section
                _buildStatsSection(),
                
                // List Section
                Expanded(
                  child: isLoading
                      ? _buildShimmerLoading()
                      : controller.filteredInternshipList.isEmpty
                          ? _buildEmptyState()
                          : _buildInternshipList(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

// Widget _buildFilterSection() {
//   return Container(
//     margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.shade200,
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: Material(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: AppColor().colorPrimary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.filter_list,
//                       color: AppColor().colorPrimary,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     "Filter Internships",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const Spacer(),
//                   if (controller.selectedCategoryId.value != 0 ||
//                       controller.selectedSubCategoryId.value != 0)
//                     TextButton(
//                       onPressed: () {
//                         controller.selectedCategoryId.value = 0;
//                         controller.selectedSubCategoryId.value = 0;
//                         controller.subCategoryList.clear();
//                         controller.filteredInternshipList
//                             .assignAll(controller.internshipList);
//                       },
//                       style: TextButton.styleFrom(
//                         foregroundColor: AppColor().colorPrimary,
//                         minimumSize: Size.zero,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                       ),
//                       child: const Text("Clear All"),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Category Dropdown
//               Obx(() => _buildDropdownField(
//                 value: controller.selectedCategoryId.value == 0
//                     ? null
//                     : controller.selectedCategoryId.value,
//                 hint: "Select Category",
//                 items: controller.categoryList.map((e) {
//                   return DropdownMenuItem<int>(
//                     value: e['id'],
//                     child: Text(
//                       e['name'],
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (val) {
//                   if (val != null) {
//                     controller.getSubCategory(val);
//                   }
//                 },
//                 isLoading: controller.isCategoryLoading.value,
//               )),
//               const SizedBox(height: 16),

//               // Subcategory Dropdown - Improved with empty state handling
//               Obx(() {
//                 // Check if category is selected
//                 if (controller.selectedCategoryId.value == 0) {
//                   return _buildDisabledDropdownField(
//                     hint: "Select a category first",
//                     icon: Icons.lock,
//                   );
//                 }
                
//                 // Check if loading
//                 if (controller.isSubCategoryLoading.value) {
//                   return _buildDisabledDropdownField(
//                     hint: "Loading subcategories...",
//                     isLoading: true,
//                   );
//                 }
                
//                 // Check if no subcategories available
//                 if (controller.subCategoryList.isEmpty) {
//                   return _buildDisabledDropdownField(
//                     hint: "No subcategories available",
//                     icon: Icons.info_outline,
//                   );
//                 }

//                 // Show subcategory dropdown with items
//                 return _buildDropdownField(
//                   value: controller.selectedSubCategoryId.value == 0
//                       ? null
//                       : controller.selectedSubCategoryId.value,
//                   hint: "Select Subcategory",
//                   items: controller.subCategoryList.map((e) {
//                     return DropdownMenuItem<int>(
//                       value: e['id'],
//                       child: Text(
//                         e['name'],
//                         style: const TextStyle(fontSize: 15),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (val) {
//                     if (val != null) {
//                       controller.selectedSubCategoryId.value = val;
//                       controller.filterInternshipsBySubCategory(val);
//                     }
//                   },
//                   isLoading: false,
//                 );
//               }),

//               // Active Filters
//               Obx(() {
//                 if (controller.selectedCategoryId.value != 0 ||
//                     controller.selectedSubCategoryId.value != 0) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: [
//                         if (controller.selectedCategoryId.value != 0)
//                           _buildFilterChip(
//                             label: controller.categoryList.firstWhere(
//                               (e) => e['id'] == controller.selectedCategoryId.value,
//                               orElse: () => {'name': 'Category'},
//                             )['name'] ?? 'Category',
//                             onDelete: () {
//                               controller.selectedCategoryId.value = 0;
//                               controller.selectedSubCategoryId.value = 0;
//                               controller.subCategoryList.clear();
//                               controller.filteredInternshipList
//                                   .assignAll(controller.internshipList);
//                             },
//                           ),
//                         if (controller.selectedSubCategoryId.value != 0)
//                           _buildFilterChip(
//                             label: controller.subCategoryList.firstWhere(
//                               (e) => e['id'] == controller.selectedSubCategoryId.value,
//                               orElse: () => {'name': 'Subcategory'},
//                             )['name'] ?? 'Subcategory',
//                             onDelete: () {
//                               controller.selectedSubCategoryId.value = 0;
//                               controller.filterInternshipsBySubCategory(0);
//                             },
//                           ),
//                       ],
//                     ),
//                   );
//                 }
//                 return const SizedBox.shrink();
//               }),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Helper method for disabled dropdown fields
Widget _buildDisabledDropdownField({
  required String hint,
  bool isLoading = false,
  IconData? icon,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor().colorPrimary,
              ),
            ),
          if (isLoading) const SizedBox(width: 8),
          if (icon != null && !isLoading)
            Icon(
              icon,
              size: 18,
              color: Colors.grey.shade500,
            ),
          if (icon != null && !isLoading) const SizedBox(width: 8),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(
                color: isLoading ? AppColor().colorPrimary : Colors.grey.shade500,
                fontSize: 15,
                fontStyle: isLoading ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    ),
  );
}

// Keep your existing _buildDropdownField method
Widget _buildDropdownField({
  required int? value,
  required String hint,
  required List<DropdownMenuItem<int>> items,
  required Function(int?) onChanged,
  required bool isLoading,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<int>(
        value: value,
        isExpanded: true,
        hint: Row(
          children: [
            if (isLoading)
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColor().colorPrimary,
                ),
              ),
            if (isLoading) const SizedBox(width: 8),
            Text(
              isLoading ? "Loading..." : hint,
              style: TextStyle(
                color: isLoading ? Colors.grey : Colors.black54,
                fontSize: 15,
              ),
            ),
          ],
        ),
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: AppColor().colorPrimary,
        ),
        items: items,
        onChanged: isLoading ? null : onChanged,
      ),
    ),
  );
}
  
  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor().colorPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor().colorPrimary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColor().colorPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: 16,
              color: AppColor().colorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor().colorBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(() => Text(
              "${controller.filteredInternshipList.length} internships found",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor().whiteColor,
              ),
            )),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  "Sort by: Latest",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.filteredInternshipList.length,
      itemBuilder: (context, index) {
        final item = controller.filteredInternshipList[index];
        return _buildInternshipCard(item);
      },
    );
  }

  Widget _buildInternshipCard(dynamic item) {
  String? imageUrl = item.image != null &&
      item.image!.isNotEmpty &&
      item.image![0].path != null &&
      item.image![0].path!.startsWith("http")
      ? item.image![0].path
      : null;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Navigate to internship details
          Get.to(() => InternshipDetailScreen(internship: item));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Image and Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with gradient overlay
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholderImage();
                                  },
                                )
                              : _buildPlaceholderImage(),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor().colorPrimary,
                                  AppColor().colorPrimary.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title and Basic Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.heading ?? "Untitled",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.location ?? "Location not specified",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${item.duration ?? 'Duration'} • ${item.internshipType ?? 'Type'}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tags Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTag(
                      label: item.subcategory?.name ?? "Uncategorized",
                      color: AppColor().colorPrimary,
                      icon: Icons.category,
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      label: item.postingType ?? "General",
                      color: Colors.orange,
                      icon: Icons.business_center,
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      label: "₹${item.charges ?? '0'}",
                      color: Colors.green,
                      icon: Icons.currency_rupee,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Divider
              Divider(
                color: Colors.grey.shade200,
                height: 1,
              ),
              const SizedBox(height: 12),

              // Action Buttons
              Row(
  children: [
    // Apply Button
    Expanded(
      child: Obx(() => _buildActionButton(
        onPressed: controller.isApplying.value 
            ? () {} // Empty function when disabled
            : () {
                if (controller.isApplied(item.id!)) {
                  Get.snackbar(
                    "Already Applied",
                    "You have already applied for this internship",
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  controller.applyForInternship(item.id!, item);
                }
              },
        icon: controller.isApplying.value
            ? Icons.hourglass_empty
            : (controller.isApplied(item.id!) 
                ? Icons.check_circle 
                : Icons.send),
        label: controller.isApplying.value
            ? "Applying..."
            : (controller.isApplied(item.id!) 
                ? "Applied" 
                : "Apply"),
        color: controller.isApplying.value
            ? Colors.white.withOpacity(0.7)
            : AppColor().whiteColor,
        textColor: controller.isApplying.value
            ? Colors.white.withOpacity(0.7)
            : AppColor().whiteColor,
        backgroundColor: controller.isApplying.value
            ? AppColor().colorPrimary.withOpacity(0.5)
            : (controller.isApplied(item.id!) 
                ? Colors.green 
                : AppColor().colorPrimary),
      )),
    ),
    const SizedBox(width: 12),

    // View Details Button
    Expanded(
      child: _buildActionButton(
        onPressed: () {
          Get.to(() => InternshipDetailScreen(internship: item));
        },
        icon: Icons.visibility,
        label: "Details",
        color: AppColor().whiteColor,
        textColor: AppColor().whiteColor,
        backgroundColor: AppColor().colorBlue,
      ),
    ),
  ],
),  ],
              ),
            
          ),
        ),
      ),
    
  );
}

  Widget _buildPlaceholderImage() {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
        ),
      ),
      child: Icon(
        Icons.business_center,
        size: 35,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildTag({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 14,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_center_outlined,
                size: 60,
                color: AppColor().colorPrimary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No Internships Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your filters or\n find a new internship",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
          ],
        ),
      ),
    );
  }

  // void _showApplicantsBottomSheet(dynamic internship) {
  //   Get.bottomSheet(
  //     Container(
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(24),
  //           topRight: Radius.circular(24),
  //         ),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Handle
  //           Container(
  //             margin: const EdgeInsets.only(top: 12),
  //             height: 4,
  //             width: 40,
  //             decoration: BoxDecoration(
  //               color: Colors.grey.shade300,
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
            
  //           // Header
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                     color: AppColor().colorPrimary.withOpacity(0.1),
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Icon(
  //                     Icons.people,
  //                     color: AppColor().colorPrimary,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         internship.heading ?? "Applicants",
  //                         style: const TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         "12 applicants • 5 new",
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           color: Colors.grey.shade600,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () => Get.back(),
  //                   icon: const Icon(Icons.close),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           // Applicants List
  //           Flexible(
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               padding: const EdgeInsets.symmetric(horizontal: 20),
  //               itemCount: 5,
  //               itemBuilder: (context, index) {
  //                 return Container(
  //                   margin: const EdgeInsets.only(bottom: 12),
  //                   padding: const EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey.shade50,
  //                     borderRadius: BorderRadius.circular(12),
  //                     border: Border.all(
  //                       color: Colors.grey.shade200,
  //                     ),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       CircleAvatar(
  //                         radius: 20,
  //                         backgroundColor: AppColor().colorPrimary.withOpacity(0.1),
  //                         child: Text(
  //                           "JD",
  //                           style: TextStyle(
  //                             color: AppColor().colorPrimary,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             const Text(
  //                               "John Doe",
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.w600,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               "Applied 2 days ago",
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 8,
  //                           vertical: 4,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: Colors.green.shade50,
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: Text(
  //                           "New",
  //                           style: TextStyle(
  //                             fontSize: 11,
  //                             color: Colors.green.shade700,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),

  //           // View All Button
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Get.back();
  //                   // Navigate to full applicants list
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColor().colorPrimary,
  //                   foregroundColor: Colors.white,
  //                   padding: const EdgeInsets.symmetric(vertical: 14),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                 ),
  //                 child: const Text("View All Applicants"),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}