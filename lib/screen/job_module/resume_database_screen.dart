import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/screen/job_module/candidate_full_profile_screen.dart';
import '../../controller/job_controller.dart';
import '../../model/candidate_resume_model.dart';

class ResumeDatabaseScreen extends StatelessWidget {
  ResumeDatabaseScreen({super.key});

  final JobProviderController controller = Get.put(JobProviderController());

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Resume Database",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            Text("Find candidates",
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// SEARCH BAR
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * .04, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search candidates",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            /// FILTER DROPDOWNS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * .04),
              child: Column(
  children: [

    /// CATEGORY
    Obx(() {
      return DropdownButtonFormField<String>(
        isExpanded: true,
        value: controller.selectedCategoryFilter.value.isEmpty
            ? null
            : controller.selectedCategoryFilter.value,
        hint: const Text("Category"),
        items: controller.jobCategoryListValue
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (value) {

          controller.selectedCategoryFilter.value = value ?? "";

          /// reset subcategory
          controller.selectedSubCategoryFilter.value = "";
          controller.selecteSubdCategoryId.value = "";

          controller.jobSubcategoryListValue.clear();
          controller.jobSubTypeList.clear();

          /// find category id
          for (var category in controller.jobTypeList) {
            if (category.name == value) {
              controller.selectedCategoryID.value =
                  category.id.toString();
              break;
            }
          }
          controller.getCandidateResumeList();
          /// fetch subcategories
          controller.getJobSubcategoryList();
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }),

    const SizedBox(height: 12),

    /// SUBCATEGORY
    Obx(() {
      return DropdownButtonFormField<int>(
  isExpanded: true,

  value: controller.selecteSubdCategoryId.value.isEmpty
      ? null
      : int.tryParse(controller.selecteSubdCategoryId.value),

  hint: const Text("Subcategory"),

  items: controller.jobSubTypeList
      .map(
        (sub) => DropdownMenuItem<int>(
          value: sub.id,
          child: Text(
            sub.name ?? "",
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
      .toList(),

  onChanged: (value) {

    if (value == null) return;

    controller.selecteSubdCategoryId.value = value.toString();

    /// store display name
    for (var sub in controller.jobSubTypeList) {
      if (sub.id == value) {
        controller.selectedSubCategoryFilter.value = sub.name ?? "";
        break;
      }
    }

    controller.getCandidateResumeList();
  },

  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),

);
    }),

    const SizedBox(height: 10),

Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {

      controller.selectedCategoryFilter.value = "";
      controller.selectedSubCategoryFilter.value = "";
      controller.selectedCategoryID.value = "";
      controller.selecteSubdCategoryId.value = "";

      controller.getCandidateResumeList();

    },
    child: const Text("Clear Filters"),
  ),
),

  ],
)
            ),

            const SizedBox(height: 10),

            /// CANDIDATE LIST
            Expanded(
              child: Obx(() {

                if (controller.isLoadingCandidateResume.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.candidateResumeList.isEmpty) {
                  return const Center(child: Text("No Candidates Found"));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: width * .04),
                  itemCount: controller.candidateResumeList.length,
                  itemBuilder: (context, index) {

                    final candidate =
                        controller.candidateResumeList[index];

                    return CandidateCard(candidate: candidate);
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}


class CandidateCard extends StatelessWidget {
  final CandidateData candidate;

  const CandidateCard({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    String? imageUrl;

    if (candidate.photo != null && candidate.photo!.isNotEmpty) {
      imageUrl =
          candidate.photo!.first.fileUrl ?? candidate.photo!.first.path;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [

              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: Image.network(
                    imageUrl ?? "",
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      candidate.fullName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      candidate.resumeHeadline ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.bookmark_border),
            ],
          ),

          const SizedBox(height: 12),

          /// LOCATION & EXPERIENCE
          Wrap(
            spacing: 20,
            runSpacing: 6,
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(candidate.preferredCity ?? "Unknown"),
                ],
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.work_outline,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("${candidate.experience ?? "0"} years"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// SKILLS
         if (candidate.skills != null)
  Wrap(
    spacing: 6,
    runSpacing: 6,
    children: candidate.skills!
        .where((skill) =>
            skill != null &&
            skill.toString().trim().isNotEmpty)
        .take(4)
        .map(
          (skill) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              skill
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", ""),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        )
        .toList(),
  ),
          const SizedBox(height: 12),

          /// FOOTER
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [

              Text(
                "₹${candidate.expectedSalary?.toStringAsFixed(0) ?? "0"}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),

              SizedBox(
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor().colorPrimary,
                    padding: EdgeInsets.symmetric(
                        horizontal: width * .04),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Get.to(CandidateFullProfileScreen(candidate: candidate));
                  },
                  child: const Text("View Profile",style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}