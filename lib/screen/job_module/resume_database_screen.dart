import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/job_controller.dart';
import '../../model/candidate_resume_model.dart';
import '../../res/AppColor.dart';
import 'candidate_full_profile_screen.dart';

class ResumeDatabaseScreen extends StatelessWidget {
  ResumeDatabaseScreen({super.key});

  final JobProviderController controller =
      Get.put(JobProviderController());

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
    if (controller.candidateResumeList.isEmpty) {
      controller.getCandidateResumeList();
    }
  });
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Resume Database"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFilterSheet(context),
        icon: const Icon(Icons.filter_alt_outlined),
        label: const Text("Filters"),
      ),

     body: Obx(() {
  return Column(
    children: [

      /// ⭐ FILTER CARD SECTION
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Column(
          children: [

           

            const SizedBox(height: 12),

            /// JOB TYPE

            DropdownButtonFormField<String>(
              value: controller.selectedResumeJobType.value.isEmpty
                  ? null
                  : controller.selectedResumeJobType.value,
              hint: const Text("Select Job Type"),
              decoration: _filterDecoration(),
              items: controller.getAvailableJobTypes()
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  controller.onResumeJobTypeChanged(v);
                }
              },
            ),

            const SizedBox(height: 14),

           

            DropdownButtonFormField<String>(
              value: controller.selectedCategoryFilter.value.isEmpty
                  ? null
                  : controller.selectedCategoryFilter.value,
              hint: const Text("Select Category"),
              decoration: _filterDecoration(),
              items: controller.jobCategoryListValue
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {

                controller.selectedCategoryFilter.value = value ?? "";
                controller.selectedSubCategoryFilter.value = "";
                controller.selecteSubdCategoryId.value = "";

                for (var category in controller.jobTypeList) {
                  if (category.name == value) {
                    controller.selectedCategoryID.value =
                        category.id.toString();
                    break;
                  }
                }

                controller.getJobSubcategoryList();
                controller.getCandidateResumeList();
              },
            ),

            const SizedBox(height: 14),

            /// SUB CATEGORY
           
            DropdownButtonFormField<int>(
              value: controller.selecteSubdCategoryId.value.isEmpty
                  ? null
                  : int.tryParse(
                  controller.selecteSubdCategoryId.value),
              hint: const Text("Select Subcategory"),
              decoration: _filterDecoration(),
              items: controller.jobSubTypeList
                  .map((sub) => DropdownMenuItem<int>(
                value: sub.id,
                child: Text(sub.name ?? ""),
              ))
                  .toList(),
              onChanged: (value) {
                controller.selecteSubdCategoryId.value =
                    value.toString();
                    controller.getCandidateResumeList();
                    
              },
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filter",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  GestureDetector(
                    onTap: ()=>{
controller.clearResumeFilters(),
                  controller.getCandidateResumeList()
                    },
                    child: Text("clear",style: TextStyle(color: AppColor().colorBlue,fontWeight:FontWeight.bold ),),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      /// ⭐ LIST
      Expanded(
        child: controller.isLoadingCandidateResume.value
            ? const Center(child: CircularProgressIndicator())
            : controller.candidateResumeList.isEmpty
            ? const Center(child: Text("No Candidates Found"))
            : ListView.builder(
          padding:
          EdgeInsets.symmetric(horizontal: width * .04),
          itemCount:
          controller.candidateResumeList.length,
          itemBuilder: (_, i) {
            final candidate =
            controller.candidateResumeList[i];
            return CandidateCard(candidate: candidate);
          },
        ),
      ),

      /// ⭐ BOTTOM BUTTON BAR
      Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(.06),
            )
          ],
        ),

        
      )
    ],
  );
})


    );
  }

  /// FILTER SHEET
  void _openFilterSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return _filterUI();
      },
    );
  }

  InputDecoration _filterDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade50,

    contentPadding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: AppColor().colorPrimary,
        width: 1.4,
      ),
    ),
  );
}

  Widget _filterUI() {

  final height = MediaQuery.of(Get.context!).size.height;

  return Obx(() => Container(
    height: height * .72,   // ⭐⭐⭐ MAIN FIX (NOT FULL SCREEN)
    padding: const EdgeInsets.all(18),

    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// DRAG HANDLE
        Center(
          child: Container(
            height: 5,
            width: 60,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        const Text(
          "Filter Candidates",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 14),

        /// ⭐⭐⭐ SCROLL AREA (IMPORTANT)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                
                _sectionTitle("Candidate Name"),

                TextField(
                  decoration: _inputDecoration().copyWith(
                    hintText: "Search Candidate Name",
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (v) {
                    controller.filterName.value = v;
                  },
                ),

                const SizedBox(height: 16),

                _sectionTitle("Preferred City"),

                TextField(
                  decoration: _inputDecoration().copyWith(
                    hintText: "Enter City",
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                  onChanged: (v) {
                    controller.filterCity.value = v;
                  },
                ),

                const SizedBox(height: 16),

                _sectionTitle("Experience"),

                DropdownButtonFormField<String>(
                  value: controller.filterExperience.value.isEmpty
                      ? null
                      : controller.filterExperience.value,
                  hint: const Text("Select Experience"),
                  decoration: _inputDecoration(),
                  items: ["0","1","2","3","4","5","10+"]
                      .map((e) => DropdownMenuItem(
                      value: e, child: Text("$e Years")))
                      .toList(),
                  onChanged: (v) {
                    controller.filterExperience.value = v ?? "";
                  },
                ),

                const SizedBox(height: 16),

                _sectionTitle("Expected Salary"),

                TextField(
                  decoration: _inputDecoration().copyWith(
                    hintText: "Enter Salary",
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                  onChanged: (v) {
                    controller.filterExpectedSalary.value = v;
                  },
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SwitchListTile(
                    title: const Text("Accommodation Required"),
                    value: controller.filterAccommodation.value,
                    onChanged: (v) {
                      controller.filterAccommodation.value = v;
                    },
                  ),
                ),

                const SizedBox(height: 10),

              ],
            ),
          ),
        ),

        /// ⭐ BUTTONS FIXED BOTTOM
        Row(
          children: [

            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  controller.clearResumeFilters();
                  Get.back();
                },
                child: const Text("Clear"),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.getCandidateResumeList();
                  Get.back();
                },
                child: const Text("Apply"),
              ),
            ),

          ],
        )

      ],
    ),
  ));
}
/// ⭐ SECTION TITLE
Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  );
}

/// ⭐ INPUT DECORATION
InputDecoration _inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
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