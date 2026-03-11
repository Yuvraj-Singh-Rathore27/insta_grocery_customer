import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/screen/job_module/PostResumeScreen.dart';
import '../../model/job_listing_model.dart';
import '../../controller/job_controller.dart';

class JobDetailScreen extends StatelessWidget {
  final JobListingModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // ✅ Initialize controller using GetX
    final JobProviderController controller = Get.find<JobProviderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: AppColor().whiteColor,
        foregroundColor: AppColor().blackColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor().colorPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 20),
            _buildJobOverviewSection(),
            const SizedBox(height: 20),
            _buildSalaryShiftSection(),
            const SizedBox(height: 20),
            _buildRequirementsBenefitsSection(),
            const SizedBox(height: 20),
            _buildLocationSection(),
            const SizedBox(height: 20),
            _buildJobDescriptionSection(),
            const SizedBox(height: 20),
            _buildContactApplySection(controller),
          ],
        ),
      ),
    );
  }

  // ✅ Header Section
  Widget _buildHeaderSection() {
    /* same as your code */
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.medical_services,
                color: Colors.blue, size: 30),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.jobHeading ?? 'Registered Nurse',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  job.jobPostedBy ?? 'MediCare Hospital',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobOverviewSection() {
    /* same as your code */
    return _buildSection(
      title: 'Job Overview',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewItem(Icons.business_center, 'Job Type',
                    job.jobType ?? 'Full Time'),
                _buildOverviewItem(Icons.category, 'Category',
                    job.category?.name ?? ""),
                _buildOverviewItem(
                    Icons.work, 'Work Type', job.workType ?? 'On-site'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewItem(Icons.work_history, 'Experience',
                    '${job.minExperience ?? 0} - ${job.maxExperience ?? 0} years'),
                _buildOverviewItem(Icons.person, 'Gender', job.gender ?? 'Any'),
                _buildOverviewItem(
                    Icons.house, 'Accommodation', job.accommodation ?? 'Any'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryShiftSection() {
    /* same as yours */
    return _buildSection(
      title: 'Salary & Shift',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Salary',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                Text(
                    job.getFormattedSalaryRange() ??
                        '\$65,000 - \$85,000 / year',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Shift',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Night Shift',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text('9AM–5PM, Rotational',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsBenefitsSection() {
    /* same as yours */
    return _buildSection(
      title: 'Requirements & Benefits',
      child: Column(
        children: [
          _buildBenefitItem(
              'Accommodation provided',
              job.accommodation.toLowerCase() == 'yes' ||
                  job.accommodation.toLowerCase() == 'true'),
          _buildBenefitItem('Insurance & Medical coverage', true),
          _buildBenefitItem('Transport allowance', false),
          _buildBenefitItem('Food provided', false),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text, bool isProvided) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isProvided ? Colors.green[50] : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
              border:
                  Border.all(color: isProvided ? Colors.green : Colors.grey),
            ),
            child: Icon(isProvided ? Icons.check : Icons.close,
                size: 16, color: isProvided ? Colors.green : Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isProvided ? Colors.black87 : Colors.grey,
                decoration: isProvided ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    /* same as yours */
    return _buildSection(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  job.getFullLocation() ??
                      '123 Medical Center Dr, New York, NY',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDescriptionSection() {
    /* same as yours */
    return _buildSection(
      title: 'Job Description',
      child: const Text(
        'Provide exceptional patient care and coordinate with medical professionals for continuous monitoring and medication management.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  // ✅ Updated Apply Section with Controller Logic
  Widget _buildContactApplySection(JobProviderController controller) {
    return Column(
      children: [
        _buildSection(
          title: 'Contact Information',
          child: Column(
            children: [
              if (job.contactNumber != null && job.contactNumber!.isNotEmpty)
                _buildContactItem(Icons.phone, job.contactNumber!),
              if (job.email != null && job.email!.isNotEmpty)
                _buildContactItem(Icons.email, job.email!),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final jobId = job.id!;
              final jobData = job;

              if (controller.appliedJobIds.contains(jobId)) {
                Get.snackbar(
                  "Notice",
                  "You have already applied for this position",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red.shade400,
                  colorText: Colors.white,
                );
              } else {
                Get.dialog(Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "You Apply these job",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Are You Sure You Want To Apply These job"),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: AppColor().whiteColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor().grey_Li),
                            ),
                            ElevatedButton(
                              onPressed: () => {
                                Get.back(),
                                controller.applyJobApi(jobId, job)
                              },
                              child: Text(
                                "Yes, Apply",
                                style: TextStyle(color: AppColor().whiteColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor().colorPrimary),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Apply Now',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
