import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/job_listing_model.dart';
import '../../res/AppColor.dart';
import '../job_module/jobDetailScreen.dart';
import '../../controller/job_controller.dart';

class searchJobList extends StatelessWidget {
  final JobListingModel data;
  final Function(JobListingModel) clickUpdate;
  final bool isApplied; // ✅ Added this

  const searchJobList({
    super.key,
    required this.data,
    required this.clickUpdate,
    this.isApplied = false, // ✅ Default value
  });

  @override
  Widget build(BuildContext context) {
    final JobProviderController controller = Get.find<JobProviderController>();

    return GestureDetector(
      onTap: () {
        Get.to(() => JobDetailScreen(job: data));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor().whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title and Hospital Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.jobPostedBy ?? '${data.jobHeading}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.bold,
                    color: AppColor().blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _getHospitalName(data.jobHeading ?? ''),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        color: AppColor().blackColorMoreC,
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColor().colorPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data.getFullLocation(),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Job Details Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Type and Shift
                Flexible(
                  flex: 1,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (data.jobType != null && data.jobType!.isNotEmpty)
                        _buildDetailChip(
                          data.jobType!,
                          Colors.blue.shade50,
                          Colors.blue.shade700,
                        ),
                      if (data.workType != null && data.workType!.isNotEmpty)
                        _buildDetailChip(
                          data.workType!,
                          Colors.orange.shade50,
                          Colors.orange.shade700,
                        ),
                      if ((data.jobType == null || data.jobType!.isEmpty) &&
                          (data.workType == null || data.workType!.isEmpty))
                        _buildDetailChip(
                          'Full Time',
                          Colors.grey.shade100,
                          Colors.grey.shade600,
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Salary
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data.getFormattedSalaryRange(),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      Text(
                        'Per Year',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Additional Info (Experience and Gender)
            if ((data.minExperience != null || data.maxExperience != null) ||
                (data.gender != null && data.gender!.isNotEmpty))
              Column(
                children: [
                  Row(
                    children: [
                      if (data.minExperience != null ||
                          data.maxExperience != null)
                        Expanded(
                          child: Text(
                            'Experience: ${data.minExperience ?? '0'} - ${data.maxExperience ?? '0'} years',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      if (data.gender != null && data.gender!.isNotEmpty)
                        Expanded(
                          child: Text(
                            'Gender: ${data.gender}',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),

            // Footer with Posted Date and Apply Button
            Container(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Posted Date
                  Text(
                    timeAgo(data.createdAt??''),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  // ✅ Apply Button
                  GestureDetector(
                    onTap: () {
                      if (isApplied) {
                        Get.snackbar(
                            "Notice", "You already applied for this job");
                      } else {
                        Get.dialog(Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "You Apply These Job",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Are You Sure You Want to apply these job?",
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor().grey_Li),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => {
                                        Get.back(),
                                        clickUpdate(data),
                                      },
                                      child: Text(
                                        "Yes, Apply",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColor().colorPrimary),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isApplied
                            ? Colors.green // ✅ stays green when applied
                            : AppColor().colorPrimary,
                      ),
                      child: Text(
                        isApplied ? 'Applied' : 'Apply',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: AppColor().whiteColor,
                        ),
                      ),
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

  // Helper method to create detail chips
  Widget _buildDetailChip(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  // Helper method to extract hospital name from job heading
  String _getHospitalName(String jobHeading) {
    if (jobHeading.toLowerCase().contains('rn cardiology')) {
      return 'Mercy Hospital';
    } else if (jobHeading.toLowerCase().contains('medical assistant')) {
      return 'HealthFirst Clinic';
    } else if (jobHeading.toLowerCase().contains('physical therapist')) {
      return 'Rehab Solutions';
    } else {
      List<String> parts = jobHeading.split(' ');
      return parts.length > 1 ? '${parts[0]} Hospital' : 'Healthcare Facility';
    }
  }

  // Helper method to generate posted date
  String timeAgo(String dateString) {
  try {
    DateTime created = DateTime.parse(dateString);
    Duration diff = DateTime.now().difference(created);

    if (diff.inSeconds < 60) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hrs ago";
    if (diff.inDays < 7) return "${diff.inDays} days ago";

    return "${created.day}/${created.month}/${created.year}";
  } catch (e) {
    return "";
  }
}}
