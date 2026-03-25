import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../controller/skill_program.dart';
import '../../../model/skill_program.dart';
import '../../../res/AppColor.dart';

class SkillProgramScreen extends StatefulWidget {
  const SkillProgramScreen({super.key});

  @override
  State<SkillProgramScreen> createState() => _SkillProgramScreenState();
}

class _SkillProgramScreenState extends State<SkillProgramScreen> {
  final SkillProgramController controller = Get.put(SkillProgramController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ensure data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.skillProgramList.isEmpty) {
        controller.getSkillProgramList();
      }
      controller.getCategory();
      controller.getType();
    });
  }

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
            "Skill Programs",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15,
            ),
          ),
          centerTitle: true,
          actions: [
            // Filter Button with Badge
            Obx(() => Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterDialog(context),
                    ),
                    if (controller.hasActiveFilters)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${controller.activeFiltersCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                )),
            // Search Button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(context),
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
            final bool isLoading = controller.isLoading.value ||
                controller.isCategoryLoading.value ||
                controller.isTypeLoading.value;

            return Column(
              children: [
                // Filter Section
                _buildFilterSection(),
                
                // Stats Section
                _buildStatsSection(),
                
                // List Section
                Expanded(
                  child: isLoading
                      ? _buildShimmerLoading()
                      : controller.skillProgramList.isEmpty
                          ? _buildEmptyState()
                          : _buildSkillProgramList(),
                ),
              ],
            );
          }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAdvancedFilterDialog(context),
          icon: Icon(Icons.filter_alt, color: AppColor().whiteColor),
          label: Obx(() => Text(
                controller.hasActiveFilters
                    ? 'Filters (${controller.activeFiltersCount})'
                    : 'Advanced Filters',
                style: TextStyle(color: AppColor().whiteColor),
              )),
          backgroundColor: AppColor().colorPrimary,
        ),
      ),
    );
  }

  // ============================================
  // FILTER SECTION
  // ============================================
  
  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor().colorPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: AppColor().colorPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Filter Skill Programs",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      if (controller.hasActiveFilters) {
                        return TextButton(
                          onPressed: controller.clearFilters,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColor().colorPrimary,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                          ),
                          child: const Text("Clear All"),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // Category Dropdown
                Obx(() => _buildDropdownField(
                  value: controller.filterCategoryId.value == 0
                      ? null
                      : controller.filterCategoryId.value,
                  hint: "Select Category",
                  items: controller.categoryList.map((e) {
                    return DropdownMenuItem<int>(
                      value: e['id'],
                      child: Text(
                        e['name'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.filterByCategory(val);
                    }
                  },
                  isLoading: controller.isCategoryLoading.value,
                )),
                const SizedBox(height: 16),

                // Type Dropdown
                Obx(() => _buildDropdownField(
                  value: controller.filterTypeId.value == 0
                      ? null
                      : controller.filterTypeId.value,
                  hint: "Select Program Type",
                  items: controller.typeList.map((e) {
                    return DropdownMenuItem<int>(
                      value: e['id'],
                      child: Text(
                        e['name'],
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.filterByType(val);
                    }
                  },
                  isLoading: controller.isTypeLoading.value,
                )),
                const SizedBox(height: 16),

                // Program Mode Dropdown
                Obx(() => _buildDropdownField(
                  value: controller.filterProgramMode.value.isEmpty
                      ? null
                      : controller.filterProgramMode.value,
                  hint: "Select Program Mode",
                  items: controller.programModeList.map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(
                        mode.toUpperCase(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.filterByProgramMode(val);
                    }
                  },
                  isLoading: false,
                )),

                // Active Filters Chips
                Obx(() {
                  if (controller.hasActiveFilters) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (controller.filterCategoryId.value != 0)
                            _buildFilterChip(
                              label: _getCategoryName(controller.filterCategoryId.value),
                              onDelete: () => controller.filterByCategory(0),
                            ),
                          if (controller.filterTypeId.value != 0)
                            _buildFilterChip(
                              label: _getTypeName(controller.filterTypeId.value),
                              onDelete: () => controller.filterByType(0),
                            ),
                          if (controller.filterProgramMode.value.isNotEmpty)
                            _buildFilterChip(
                              label: controller.filterProgramMode.value.toUpperCase(),
                              onDelete: () => controller.filterByProgramMode(''),
                            ),
                          if (controller.filterTitle.value.isNotEmpty)
                            _buildFilterChip(
                              label: 'Search: ${controller.filterTitle.value}',
                              onDelete: () {
                                controller.searchTitleController.clear();
                                controller.filterByTitle('');
                              },
                            ),
                          if (controller.filterMinPrice.value > 0 || controller.filterMaxPrice.value > 0)
                            _buildFilterChip(
                              label: _getPriceRangeText(),
                              onDelete: () => controller.filterByPriceRange(0, 0),
                            ),
                          if (controller.filterFeesType.value.isNotEmpty)
                            _buildFilterChip(
                              label: 'Fee: ${controller.filterFeesType.value}',
                              onDelete: () => controller.filterByFeesType(''),
                            ),
                          if (controller.filterDisplayType.value.isNotEmpty)
                            _buildFilterChip(
                              label: 'Status: ${controller.filterDisplayType.value}',
                              onDelete: () => controller.filterByDisplayType(''),
                            ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<T>(
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

  // ============================================
  // STATS SECTION
  // ============================================
  
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor().colorPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(() => Text(
              "${controller.skillProgramList.length} programs found",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor().whiteColor,
              ),
            )),
          ),
          const Spacer(),
          if (controller.hasActiveFilters)
            TextButton.icon(
              onPressed: controller.clearFilters,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text("Clear Filters"),
              style: TextButton.styleFrom(
                foregroundColor: AppColor().colorPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================
  // SKILL PROGRAM LIST
  // ============================================
  
  Widget _buildSkillProgramList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.skillProgramList.length,
      itemBuilder: (context, index) {
        final program = controller.skillProgramList[index];
        return _buildSkillProgramCard(program);
      },
    );
  }

  Widget _buildSkillProgramCard(SkillProgram program) {
    // Get image URL from the image data
    String? imageUrl = _getImageUrl(program.image);
    
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
          onTap: () => _showProgramDetails(program),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row with Image and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
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
                            child: imageUrl != null && imageUrl.isNotEmpty
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
                            program.title ?? "Untitled",
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
                                  program.location ?? "Location not specified",
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
                                program.duration ?? "Duration not specified",
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
                        label: _getCategoryNameFromProgram(program.categoryId),
                        color: AppColor().colorPrimary,
                        icon: Icons.category,
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        label: program.programMode ?? "Mode",
                        color: _getModeColor(program.programMode ?? ""),
                        icon: Icons.school,
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        label: program.feesType == 'free' ? "FREE" : "₹${program.price ?? 0}",
                        color: program.feesType == 'free' ? Colors.green : Colors.orange,
                        icon: program.feesType == 'free' ? Icons.celebration : Icons.currency_rupee,
                      ),
                      if (program.typeId != null && program.typeId != 0) ...[
                        const SizedBox(width: 8),
                        _buildTag(
                          label: _getTypeName(program.typeId!),
                          color: Colors.purple,
                          icon: Icons.label,
                        ),
                      ],
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

                // Status and View Details
                Row(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (program.isActive == true)
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (program.isActive == true)
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            program.isActive == true ? Icons.check_circle : Icons.cancel,
                            size: 14,
                            color: program.isActive == true ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            program.isActive == true ? "Active" : "Inactive",
                            style: TextStyle(
                              fontSize: 12,
                              color: program.isActive == true ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // View Details Button
                    TextButton.icon(
                      onPressed: () => _showProgramDetails(program),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text("View Details"),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColor().colorPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================
  // DIALOGS AND MODALS
  // ============================================
  
  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    searchController.text = controller.filterTitle.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Programs'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter program title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (value) {
              controller.filterByTitle(value);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.filterByTitle(searchController.text);
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Program Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterOption(
                        'All',
                        controller.filterProgramMode.value.isEmpty,
                        () {
                          controller.filterByProgramMode('');
                          Navigator.pop(context);
                        },
                      ),
                      ...controller.programModeList.map((mode) {
                        return _buildFilterOption(
                          mode,
                          controller.filterProgramMode.value == mode,
                          () {
                            controller.filterByProgramMode(mode);
                            Navigator.pop(context);
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Fees Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterOption(
                        'All',
                        controller.filterFeesType.value.isEmpty,
                        () {
                          controller.filterByFeesType('');
                          Navigator.pop(context);
                        },
                      ),
                      _buildFilterOption(
                        'Paid',
                        controller.filterFeesType.value == 'paid',
                        () {
                          controller.filterByFeesType('paid');
                          Navigator.pop(context);
                        },
                      ),
                      _buildFilterOption(
                        'Free',
                        controller.filterFeesType.value == 'free',
                        () {
                          controller.filterByFeesType('free');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterOption(
                        'All',
                        controller.filterDisplayType.value.isEmpty,
                        () {
                          controller.filterByDisplayType('');
                          Navigator.pop(context);
                        },
                      ),
                      _buildFilterOption(
                        'Active',
                        controller.filterDisplayType.value == 'active',
                        () {
                          controller.filterByDisplayType('active');
                          Navigator.pop(context);
                        },
                      ),
                      _buildFilterOption(
                        'Inactive',
                        controller.filterDisplayType.value == 'inactive',
                        () {
                          controller.filterByDisplayType('inactive');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.clearFilters();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear All'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAdvancedFilterDialog(BuildContext context) {
    int? tempCategoryId = controller.filterCategoryId.value != 0 ? controller.filterCategoryId.value : null;
    int? tempTypeId = controller.filterTypeId.value != 0 ? controller.filterTypeId.value : null;
    String? tempProgramMode = controller.filterProgramMode.value.isNotEmpty ? controller.filterProgramMode.value : null;
    int? tempMinPrice = controller.filterMinPrice.value > 0 ? controller.filterMinPrice.value : null;
    int? tempMaxPrice = controller.filterMaxPrice.value > 0 ? controller.filterMaxPrice.value : null;
    String? tempFeesType = controller.filterFeesType.value.isNotEmpty ? controller.filterFeesType.value : null;
    String? tempDisplayType = controller.filterDisplayType.value.isNotEmpty ? controller.filterDisplayType.value : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Advanced Filters'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category Dropdown
                      Obx(() => DropdownButtonFormField<int?>(
                            value: tempCategoryId,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Categories'),
                              ),
                              ...controller.categoryList.map((category) {
                                return DropdownMenuItem(
                                  value: category['id'],
                                  child: Text(category['name']),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                tempCategoryId = value;
                              });
                            },
                          )),
                      const SizedBox(height: 16),
                      
                      // Type Dropdown
                      Obx(() => DropdownButtonFormField<int?>(
                            value: tempTypeId,
                            decoration: const InputDecoration(
                              labelText: 'Program Type',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Types'),
                              ),
                              ...controller.typeList.map((type) {
                                return DropdownMenuItem(
                                  value: type['id'],
                                  child: Text(type['name']),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                tempTypeId = value;
                              });
                            },
                          )),
                      const SizedBox(height: 16),
                      
                      // Program Mode Dropdown
                      DropdownButtonFormField<String?>(
                        value: tempProgramMode,
                        decoration: const InputDecoration(
                          labelText: 'Program Mode',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Modes'),
                          ),
                          ...controller.programModeList.map((mode) {
                            return DropdownMenuItem(
                              value: mode,
                              child: Text(mode.toUpperCase()),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            tempProgramMode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Price Range
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Min Price',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                tempMinPrice = value.isNotEmpty ? int.tryParse(value) : null;
                              },
                              controller: TextEditingController(
                                text: tempMinPrice != null ? tempMinPrice.toString() : '',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Max Price',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                tempMaxPrice = value.isNotEmpty ? int.tryParse(value) : null;
                              },
                              controller: TextEditingController(
                                text: tempMaxPrice != null ? tempMaxPrice.toString() : '',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Fees Type
                      DropdownButtonFormField<String?>(
                        value: tempFeesType,
                        decoration: const InputDecoration(
                          labelText: 'Fees Type',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All'),
                          ),
                          const DropdownMenuItem(
                            value: 'paid',
                            child: Text('Paid'),
                          ),
                          const DropdownMenuItem(
                            value: 'free',
                            child: Text('Free'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            tempFeesType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Display Type (Status)
                      DropdownButtonFormField<String?>(
                        value: tempDisplayType,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All'),
                          ),
                          const DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          const DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            tempDisplayType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    controller.clearFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.applyAdvancedFilters(
                      categoryId: tempCategoryId,
                      typeId: tempTypeId,
                      programMode: tempProgramMode,
                      minPrice: tempMinPrice,
                      maxPrice: tempMaxPrice,
                      feesType: tempFeesType,
                      displayType: tempDisplayType,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            );
          },
        );
      },
    );
  }

 void _showProgramDetails(SkillProgram program) {
  String? imageUrl = _getImageUrl(program.image);
  
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            if (imageUrl != null && imageUrl.isNotEmpty) 
              const SizedBox(height: 16),
            
            // Title
            Text(
              program.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Mode Badge
            if (program.programMode != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getModeColor(program.programMode!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  program.programMode!.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            
            // Details
            _buildDetailRow(Icons.access_time, 'Duration', program.duration ?? 'N/A'),
            _buildDetailRow(Icons.attach_money, 'Price', 
              program.feesType == 'free' ? 'Free' : '₹${program.price ?? 0}'),
            _buildDetailRow(Icons.location_on, 'Location', program.location ?? 'N/A'),
            _buildDetailRow(Icons.category, 'Category', _getCategoryNameFromProgram(program.categoryId)),
            _buildDetailRow(Icons.label, 'Type', _getTypeName(program.typeId ?? 0)),
            _buildDetailRow(Icons.info, 'Status', program.isActive == true ? 'Active' : 'Inactive'),
            
            const SizedBox(height: 16),
            
            // Description
            if (program.description != null && program.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.description!,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            
            const SizedBox(height: 24),
            
            // Button Row with Apply and Close
  Row(
  children: [
    Expanded(
      child: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey.shade700,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Close'),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: Obx(() {
        // Directly observe appliedProgramIds to make it reactive
        final bool alreadyApplied = controller.appliedProgramIds.contains(program.id ?? 0);
        
        return ElevatedButton(
          onPressed: (controller.isPosting.value || alreadyApplied) 
              ? null 
              : () => controller.handleApplyProgram(program),
          style: ElevatedButton.styleFrom(
            backgroundColor: alreadyApplied 
                ? Colors.green 
                : AppColor().colorPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isPosting.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  alreadyApplied ? '✓ Applied' : 'Apply',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
        );
      }),
    ),
  ],
),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onTap();
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: AppColor().colorPrimary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColor().colorPrimary : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
        Icons.school,
        size: 35,
        color: Colors.grey.shade400,
      ),
    );
  }

  // ============================================
  // LOADING AND EMPTY STATES
  // ============================================
  
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
                Icons.school_outlined,
                size: 60,
                color: AppColor().colorPrimary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.hasActiveFilters
                  ? "No Programs Match Your Filters"
                  : "No Skill Programs Available",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.hasActiveFilters
                  ? "Try adjusting your filters to see more results"
                  : "Check back later for new skill programs",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            if (controller.hasActiveFilters)
              ElevatedButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text("Clear Filters"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // HELPER METHODS
  // ============================================
  
  String? _getImageUrl(dynamic imageData) {
    if (imageData == null) return null;
    
    if (imageData is List && imageData.isNotEmpty) {
      final firstImage = imageData.first;
      if (firstImage is Map) {
        return firstImage['path'] ?? firstImage['url'];
      }
      if (firstImage is String) {
        return firstImage;
      }
    }
    
    if (imageData is Map) {
      return imageData['path'] ?? imageData['url'];
    }
    
    if (imageData is String) {
      return imageData;
    }
    
    return null;
  }

  Color _getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'online':
        return Colors.blue;
      case 'offline':
        return Colors.orange;
      case 'hybrid':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryName(int categoryId) {
    final category = controller.categoryList.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Unknown'},
    );
    return category['name'] ?? 'Unknown';
  }

  String _getCategoryNameFromProgram(int? categoryId) {
    if (categoryId == null || categoryId == 0) return 'Uncategorized';
    final category = controller.categoryList.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Uncategorized'},
    );
    return category['name'] ?? 'Uncategorized';
  }

  String _getTypeName(int typeId) {
    if (typeId == 0) return 'Not specified';
    final type = controller.typeList.firstWhere(
      (t) => t['id'] == typeId,
      orElse: () => {'name': 'Not specified'},
    );
    return type['name'] ?? 'Not specified';
  }

  String _getPriceRangeText() {
    if (controller.filterMinPrice.value > 0 && controller.filterMaxPrice.value > 0) {
      return '₹${controller.filterMinPrice.value} - ₹${controller.filterMaxPrice.value}';
    } else if (controller.filterMinPrice.value > 0) {
      return '≥ ₹${controller.filterMinPrice.value}';
    } else if (controller.filterMaxPrice.value > 0) {
      return '≤ ₹${controller.filterMaxPrice.value}';
    }
    return '';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}