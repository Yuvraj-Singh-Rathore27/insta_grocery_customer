import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/job_controller.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final JobProviderController controller = Get.find<JobProviderController>();

  @override
  void initState() {
    super.initState();
    controller.debugJobData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor().colorPrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Jobs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() => 
                    controller.selectedCategoryFilter.isNotEmpty ||
                    controller.selectedSubCategoryFilter.isNotEmpty ||
                    controller.selectedJobTypeFilter.isNotEmpty ||
                    controller.selectedExperienceFilter.isNotEmpty ||
                    controller.selectedLanguages.isNotEmpty ||
                    controller.selectedAccommodationFilter.isNotEmpty ||
                    controller.selectedSalaryExpectationFilter.isNotEmpty ||
                    controller.selectedLocationTypeFilter.isNotEmpty ||
                    controller.selectedPreferredCityFilter.isNotEmpty ||
                    controller.selectedTags.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller.clearAdvancedFilters();
                          setState(() {});
                        },
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : SizedBox()
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filter
                    _buildCategoryFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Subcategory Filter
                    Obx(() => controller.selectedCategoryFilter.isNotEmpty && 
                              controller.getAvailableSubCategories().isNotEmpty
                        ? _buildSubCategoryFilter()
                        : SizedBox()),
                    
                    const SizedBox(height: 20),
                    
                    // Tags Filter - FIXED: Only show when subcategory is selected AND tags are available
                    Obx(() {
                      if (controller.selectedSubCategoryFilter.isEmpty) {
                        return SizedBox(); // Don't show anything if no subcategory selected
                      }
                      
final availableTags = controller.getAvailableTagsForFilter();
                      if (availableTags.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tags',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No tags available for "${controller.selectedSubCategoryFilter.value}"',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      
                      return _buildTagsFilter();
                    }),
                    
                   
                    
                    // Job Type Filter
                    _buildJobTypeFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Experience Filter
                    _buildExperienceFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Languages Filter
                    _buildLanguagesFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Accommodation Filter
                    _buildAccommodationFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Salary Expectation Filter
                    _buildSalaryExpectationFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Location Type Filter
                    _buildLocationTypeFilter(),
                    
                    const SizedBox(height: 20),
                    
                    // Preferred City Filter
                    _buildPreferredCityFilter(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Apply Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
            

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                   GestureDetector(
                    onTap: () => {
                   Navigator.of(context).pop()
                    },
                    child: Container(
                      height: 50,
                      width: 140,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(border: Border.all(color: AppColor().colorPrimary,width: 1),borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text("Close",style: TextStyle(fontWeight: FontWeight.bold),),),

                    ),

                  ),
                  GestureDetector(
                    onTap: () => {
                     controller.applyFilters(),
                     Navigator.of(context).pop()
                    },
                    child: Container(
                      height: 50,
                      width: 140,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: AppColor().colorPrimary,borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text("Apply Filter",style: TextStyle(color: AppColor().whiteColor,fontWeight: FontWeight.bold),),),

                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = controller.getAvailableCategories();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        if (categories.isEmpty) ...[
          Text(
            'No categories available',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: controller.selectedCategoryFilter.value.isEmpty 
                  ? null 
                  : controller.selectedCategoryFilter.value,
              isExpanded: true,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: Colors.white,
              hint: const Text('Select Category'),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text(
                    'All Categories',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ...categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                controller.onCategoryFilterChanged(value);
                setState(() {});
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubCategoryFilter() {
final subCategories = controller.jobSubTypeList.map((e) => e.name ?? "").toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subcategory',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        if (subCategories.isEmpty) ...[
          Text(
            'No subcategories available for this category',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: controller.selectedSubCategoryFilter.value.isEmpty 
                  ? null 
                  : controller.selectedSubCategoryFilter.value,
              isExpanded: true,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: Colors.white,
              hint: const Text('Select Subcategory'),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text(
                    'All Subcategories',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ...subCategories.map((subCategory) {
                  return DropdownMenuItem<String>(
                    value: subCategory,
                    child: Text(
                      subCategory,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                   controller.onSubCategoryFilterChanged(value);
                // Clear tags when subcategory changes
                controller.selectedTags.clear();
                controller.applyFilters();
                setState(() {});
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildJobTypeFilter() {
    final jobTypes = controller.getAvailableJobTypes();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: controller.selectedJobTypeFilter.value.isEmpty 
                ? null 
                : controller.selectedJobTypeFilter.value,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            dropdownColor: Colors.white,
            hint: const Text('Select Job Type'),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text(
                  'All Job Types',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ...jobTypes.map((jobType) {
                return DropdownMenuItem<String>(
                  value: jobType,
                  child: Text(
                    jobType,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              controller.selectedJobTypeFilter.value = value ?? '';
              controller.applyFilters();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: controller.selectedExperienceFilter.value.isEmpty 
                ? null 
                : controller.selectedExperienceFilter.value,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            dropdownColor: Colors.white,
            hint: const Text('Select Experience'),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text(
                  'Any Experience',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ...controller.experienceOptions.map((experience) {
                return DropdownMenuItem<String>(
                  value: experience,
                  child: Text(
                    experience,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              controller.selectedExperienceFilter.value = value ?? '';
              controller.applyFilters();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        // Language selection chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.languageOptions.map((language) {
            final isSelected = controller.selectedLanguages.contains(language);
            return FilterChip(
              label: Text(language),
              selected: isSelected,
              onSelected: (selected) {
                controller.toggleLanguage(language);
                setState(() {});
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: AppColor().colorPrimary.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColor().colorPrimary : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              checkmarkColor: AppColor().colorPrimary,
            );
          }).toList(),
        ),
        
        // Show selected languages
        Obx(() {
          if (controller.selectedLanguages.isEmpty) {
            return SizedBox();
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Selected Languages:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: controller.selectedLanguages.map((language) {
                  return Chip(
                    label: Text(language),
                    onDeleted: () {
                      controller.toggleLanguage(language);
                      setState(() {});
                    },
                    backgroundColor: AppColor().colorPrimary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: AppColor().colorPrimary,
                      fontSize: 12,
                    ),
                    deleteIconColor: AppColor().colorPrimary,
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAccommodationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accommodation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: controller.selectedAccommodationFilter.value.isEmpty 
                ? null 
                : controller.selectedAccommodationFilter.value,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            dropdownColor: Colors.white,
            hint: const Text('Select Accommodation'),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text(
                  'Any Accommodation',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ...controller.accommodationOptions.map((accommodation) {
                return DropdownMenuItem<String>(
                  value: accommodation,
                  child: Text(
                    accommodation,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              controller.selectedAccommodationFilter.value = value ?? '';
              controller.applyFilters();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryExpectationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Expectation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: controller.selectedSalaryExpectationFilter.value.isEmpty 
                ? null 
                : controller.selectedSalaryExpectationFilter.value,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            dropdownColor: Colors.white,
            hint: const Text('Select Salary Range'),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text(
                  'Any Salary',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ...controller.salaryExpectationOptions.map((salary) {
                return DropdownMenuItem<String>(
                  value: salary,
                  child: Text(
                    salary,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              controller.selectedSalaryExpectationFilter.value = value ?? '';
              controller.applyFilters();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: controller.selectedLocationTypeFilter.value.isEmpty 
                ? null 
                : controller.selectedLocationTypeFilter.value,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            dropdownColor: Colors.white,
            hint: const Text('Select Location Type'),
            items: [
              const DropdownMenuItem<String>(
                value: '',
                child: Text(
                  'Any Location',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ...controller.locationTypeOptions.map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(
                    location,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ],
            onChanged: (value) {
              controller.selectedLocationTypeFilter.value = value ?? '';
              controller.applyFilters();
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreferredCityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred City',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: controller.selectedPreferredCityFilter.value),
          decoration: InputDecoration(
            hintText: 'Enter preferred city...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColor().colorPrimary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          onChanged: (value) {
            controller.selectedPreferredCityFilter.value = value;
            controller.applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildTagsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags for "${controller.selectedSubCategoryFilter.value}"',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        Obx(() {
          if (controller.isLoadingTags.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          
          final availableTags = controller.getAvailableTagsForFilter();
          
          if (availableTags.isEmpty) {
            return Text(
              'No tags available for this subcategory',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            );
          }
          
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: null,
              isExpanded: true,
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: Colors.white,
              hint: Text(
                controller.selectedTags.isEmpty 
                    ? 'Select Tags' 
                    : '${controller.selectedTags.length} tag(s) selected',
              ),
              items: [
                if (controller.selectedTags.isNotEmpty)
                  DropdownMenuItem<String>(
                    value: '_clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, size: 18, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Clear All Tags',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ...availableTags.map((tag) {
                  final isSelected = controller.selectedTags.contains(tag);
                  return DropdownMenuItem<String>(
                    value: tag,
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColor().colorPrimary : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColor().colorPrimary : Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColor().colorPrimary,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                if (value == '_clear_all') {
                  controller.clearSelectedTags();
                } else if (value != null) {
                  controller.toggleTag(value);
                }
                setState(() {});
              },
            ),
          );
        }),

        // Show selected tags as chips
        Obx(() {
          if (controller.selectedTags.isEmpty) {
            return SizedBox();
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Selected Tags:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: controller.selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () {
                      controller.toggleTag(tag);
                      setState(() {});
                    },
                    backgroundColor: AppColor().colorPrimary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: AppColor().colorPrimary,
                      fontSize: 12,
                    ),
                    deleteIconColor: AppColor().colorPrimary,
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }
}