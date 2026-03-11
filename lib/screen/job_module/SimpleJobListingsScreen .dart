import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import '../../controller/job_controller.dart';
import 'searchJobList.dart';
import 'filter_dialog.dart'; // Add this import

class SimpleJobListingsScreen extends StatelessWidget {
  const SimpleJobListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobProviderController controller = Get.find<JobProviderController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Job Listings',
        ),
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Filter Section
              const SizedBox(
                height: 20,
              ),

              _buildSearchBar(controller),

              // Results Count
              _buildResultsCount(controller),

              // Job List
              Expanded(
                child: _buildJobList(controller),
              ),
            ],
          ),

          // Persistent Filter Button
          _buildFilterButton(controller, context),
        ],
      ),
    );
  }

  // Persistent Filter Button at Bottom
  Widget _buildFilterButton(
      JobProviderController controller, BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: FloatingActionButton.extended(
              onPressed: () {
                _showFilterDialog(context);
              },
              backgroundColor: controller.isFilterApplied.value
                  ? Colors.orange.shade600
                  : AppColor().colorPrimary,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              label: Text(
                controller.isFilterApplied.value
                    ? 'Filters Applied'
                    : 'Filter Jobs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FilterDialog(),
    );
  }

  Widget _buildSearchBar(JobProviderController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx(() => TextField(
              onChanged: (value) {
                controller.searchJobs(value);
              },
              decoration: InputDecoration(
                hintText: 'Search your dream job...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor().colorPrimary,
                ),
                suffixIcon: controller.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          controller.clearSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            )),
      ),
    );
  }

  Widget _buildResultsCount(JobProviderController controller) {
    return Obx(() {
      final hasSearch = controller.searchQuery.isNotEmpty;
      final hasFilters =
    controller.selectedCategoryID.value.isNotEmpty ||
    controller.selectedJobTypeFilters.isNotEmpty ||
    controller.isFilterApplied.value;
      final displayList = hasSearch
          ? controller.searchedJobList
          : (hasFilters ? controller.filteredJobList : controller.jobListing);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              '${displayList.length} jobs found',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasSearch) ...[
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'for "${controller.searchQuery.value}"',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor().colorPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildJobList(JobProviderController controller) {
    return Obx(() {
      // Determine which list to display based on active filters/search
      
      final hasSearch = controller.searchQuery.isNotEmpty;
     final hasFilters =
    controller.selectedCategoryID.value.isNotEmpty ||
    controller.selectedJobTypeFilters.isNotEmpty ||
    controller.isFilterApplied.value;
      final displayList = hasSearch
          ? controller.searchedJobList
          : (hasFilters ? controller.filteredJobList : controller.jobListing);
print("Showing list: "
    "${hasSearch ? "searchedJobList" : hasFilters ? "filteredJobList" : "jobListing"}");

    print("Total jobListing: ${controller.jobListing.length}");
print("Total filteredJobList: ${controller.filteredJobList.length}");
print("SelectedCategoryID: ${controller.selectedCategoryID.value}");
      if (displayList.isEmpty) {
        return _buildEmptyState(controller, hasSearch);
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            return searchJobList(
              data: displayList[index],
              clickUpdate: (data) {
                controller.applyJobApi(data.id!, data);
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(JobProviderController controller, bool hasSearch) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.list_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            hasSearch ? 'No Jobs Found' : 'No Job Listings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Try adjusting your search or filters'
                : 'You haven\'t posted any jobs yet',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          if (hasSearch || controller.isFilterApplied.value) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                controller.clearAllFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor().colorPrimary,
                foregroundColor: Colors.white,
              ),
              child: Text('Clear Search & Filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, JobProviderController controller) {
    bool isSelected = controller.selectedJobTypeFilters.contains(label);

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          controller.selectedJobTypeFilters.remove(label);
        } else {
          controller.selectedJobTypeFilters.add(label);
        }
        controller.applyFilters();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor().colorPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColor().colorPrimary
                : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
