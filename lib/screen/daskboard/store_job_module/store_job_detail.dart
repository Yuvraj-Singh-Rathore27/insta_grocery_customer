import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/store_job_controller.dart';
import '../../../res/AppColor.dart';
import '../../../model/store_job_model.dart';

class MyPostedJobDetailScreen extends StatelessWidget {
  MyPostedJobDetailScreen({super.key});

  final JobPostController controller = Get.put(JobPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Posted Jobs'),
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            /// 🔥 STORE TYPE FILTER
            _filterSection(),

            /// 🔥 JOB LIST
            Expanded(
              child: controller.jobs.isEmpty
                  ? _emptyView()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.jobs.length,
                      itemBuilder: (context, index) {
                        final job = controller.jobs[index];
                        return Column(
                          children: [
                            _jobCard(job),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  // ================= FILTER =================
  Widget _filterSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.white,
    child: Obx(() {
      if (controller.isLoadingStoreTypes.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.storeTypes.isEmpty) {
        return const Text(
          "No store types available",
          style: TextStyle(color: Colors.grey),
        );
      }

      return DropdownButtonFormField<int>(
        value: controller.selectedStoreTypeId.value == 0
            ? null
            : controller.selectedStoreTypeId.value,
        hint: const Text(
          "All Store Types",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        dropdownColor: Colors.white,
        items: [
          const DropdownMenuItem<int>(
            value: 0,
            child: Text("All Store Types"),
          ),
          ...controller.storeTypes.map((e) {
            return DropdownMenuItem<int>(
              value: e.id,
              child: Text(
                e.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          }),
        ],
        onChanged: (value) {
          if (value == null || value == 0) {
            controller.clearFilter();
          } else {
            controller.filterByStoreType(value);
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          // 🔥 NO BORDER
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          // 🔥 RED WHEN FOCUSED
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      );
    }),
  );
}


  // ================= JOB CARD =================
  Widget _jobCard(JobListingModel job) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 TITLE + ICON ROW
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                job.jobTitle ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.bookmark_border, color: Colors.grey),
            const SizedBox(width: 12),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),

        const SizedBox(height: 6),

        /// 🔹 JOB TYPE
       Row(
  children: [
    const Icon(Icons.work_outline, size: 16, color: Colors.grey),
    const SizedBox(width: 6),
    Text(
      job.jobType ?? 'N/A',
      style: const TextStyle(color: Colors.grey),
    ),
  ],
),


        const SizedBox(height: 12),
        const Divider(),

        /// 🔹 DETAILS
        _infoRow(Icons.description, "Description", job.description),
        _infoRow(Icons.trending_up, "Experience",
            "${job.experienceMin} - ${job.experienceMax} Years"),
        _infoRow(Icons.currency_rupee, "Salary",
            "₹ ${job.salaryFrom} - ₹ ${job.salaryTo}"),
        _infoRow(Icons.location_on, "Location", job.latitude ?? ''),
        _infoRow(Icons.date_range, "Last Apply Date", job.lastApplyDate),
        _infoRow(Icons.store, "Store Type", job.storeType?.name??'Store Type Not Given'),

        const SizedBox(height: 14),

        /// 🔹 SKILLS / TAGS
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: (job.skills ?? []).map((skill) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                skill,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        /// 🔹 APPLY BUTTON
        SizedBox(
  width: double.infinity,
  child: Obx(() {
    final isApplied = controller.appliedJobIds.contains(job.id);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isApplied ? Colors.grey : Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: isApplied
          ? null
          : () {
              controller.applyJobApi(job.id!, job);
            },
      child: Text(
        isApplied ? "Already Applied" : "Apply Job",
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }),
),

      ],
    ),
  );
}


Widget _infoRow(IconData icon, String title, String? value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.red),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: "$title: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value ?? ''),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


  // ================= EMPTY =================
  Widget _emptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No Jobs Found', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
