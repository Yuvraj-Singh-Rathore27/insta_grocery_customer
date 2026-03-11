import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/screen/job_module/PostJobScreen.dart';
import '../../controller/job_controller.dart';
import './resume_detail_view.dart'; // Add this import

class MyPostedJobsScreen extends StatelessWidget {
  final JobProviderController controller = Get.put(JobProviderController());

  MyPostedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Posted Jobs'),
        backgroundColor: AppColor().colorPrimary,
        centerTitle: true,
        foregroundColor: Colors.white,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.refresh, size: 30),
            onPressed: () {
              print("Refresh Screen");
            },
            
          ),
        ],
      ),
      body: Column(
        children: [
          // Debug Info Banner
          Obx(() => Container(
            padding: const EdgeInsets.all(8),
            color: AppColor().bgAppColor,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Text(
                        'Total Jobs:${controller.myPostedJobs.length}',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColor().red,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),

          // Main Content
          Expanded(
            child: Obx(() {
              if (controller.isLoadingMyJobs.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading your posted jobs...'),
                    ],
                  ),
                );
              }

              if (controller.myPostedJobs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Jobs Found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'User ID: ${controller.userId}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          controller.getMyPostedJobs();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              return _buildJobsList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.myPostedJobs.length,
      itemBuilder: (context, index) {
        final job = controller.myPostedJobs[index];
        
        final jobId = job['id'] ?? 'N/A';
        final jobHeading = job['job_heading'] ?? 'No Title';
        final company = job['job_posted_by'] ?? 'Unknown';
        final location = '${job['city'] ?? ''}, ${job['state'] ?? ''}'.trim();
        final salaryFrom = job['salary_from']??'Not Closed';
        final salaryTo = job['salary_to']??'Not Closed' ;
        final salary = '$salaryFrom - $salaryTo';
        final workType = job['work_type'] ?? 'Not Specified';
        final isActive = job['is_active'] ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobHeading,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By: ${capitalize(company)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Job Details
                _buildJobDetail(Icons.location_on, location.isNotEmpty ? location : 'No location'),
                _buildJobDetail(Icons.work, workType),
                _buildJobDetail(Icons.currency_rupee_sharp, salary),

                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColor().colorPrimary),
                        ),
                        onPressed: () {
                          _viewApplicants(jobId, jobHeading);
                        },
                        child: const Text('View Applicants'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJobDetail(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              capitalize(text),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _viewApplicants(dynamic jobId, String jobTitle) {
    if (jobId == 'N/A') {
      Get.snackbar(
        'Error',
        'Cannot view applicants for this job',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    controller.getApplicantsForJob(int.tryParse(jobId.toString()) ?? 0);
    
    // Show applicants bottom sheet
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Apply Applicantes',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoadingApplicants.value) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (controller.jobApplicants.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text('No applicants yet'),
                  ),
                );
              }
              
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.jobApplicants.length,
                  itemBuilder: (context, index) {
                    final applicant = controller.jobApplicants[index];
                    final jobSeeker = applicant['job_seeker'] ?? {};
                    final name = jobSeeker['full_name'] ?? 'Unknown';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(capitalize(name).isNotEmpty ? name[0].toUpperCase() : '?'),
                        ),
                        title: Text(capitalize(name)),
                        subtitle: Text(jobSeeker['email'] ?? 'No email'),
                        // 🎯 ADD THE VIEW RESUME BUTTON HERE
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Navigate to resume screen
                            Get.to(() => ResumeDetailView(resume: jobSeeker));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor().colorPrimary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('View Resume'),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

String capitalize(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }