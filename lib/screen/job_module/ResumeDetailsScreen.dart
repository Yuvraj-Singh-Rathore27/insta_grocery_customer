import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/resume_controller.dart';
import '../../res/AppColor.dart';
import '../../res/AppDimens.dart';
import '../job_module/resume_detail_view.dart';

class ResumeDetailsScreen extends StatefulWidget {
  const ResumeDetailsScreen({super.key});

  @override
  State<ResumeDetailsScreen> createState() => _ResumeDetailsScreenState();
}

class _ResumeDetailsScreenState extends State<ResumeDetailsScreen> {
  final ResumeController controller = Get.put(ResumeController());
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.getResumeDetailsApi();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().whiteColor,
      appBar: AppBar(
        title: const Text('Resume Listing'),
        backgroundColor: AppColor().colorPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Obx(() {
              if (controller.resumeallResumes.isEmpty) {
                return const Center(
                  child: Text(
                    "No Resume Found. Please Create One.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.resumeallResumes.length,
                itemBuilder: (context, index) {
                  final resume = controller.resumeallResumes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: _buildResumeCard(resume),
                  );
                },
              );
            }),
    );
  }

  Widget _buildResumeCard(Map<String, dynamic> resume) {
    // Safe data extraction
    final fullName = resume["full_name"]?.toString() ?? 'No Name';
    final headline = resume["resume_headline"]?.toString() ?? 'No Headline';
    final experience = resume["experience"]?.toString() ?? '0';
    final jobType = resume["job_type"]?.toString() ?? 'Not Specified';
    final city = resume["preferred_city"]?.toString() ?? 'Location Not Set';

    // Handle skills safely with better error handling
    List<String> skills = _parseSkillsSafely(resume["skills"]);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColor().colorPrimary,
              child: Text(
                fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    headline,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$experience years of experience in $jobType",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor().blackColorMoreC,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 15,
                    runSpacing: 3,
                    children: [
                      _infoIcon(Icons.school, "Graduate"),
                      _infoIcon(Icons.work_outline, jobType),
                      _infoIcon(Icons.location_on_outlined, city),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (skills.isNotEmpty)
                    Wrap(
                      spacing: 3,
                      runSpacing: 1,
                      children: skills
                          .take(3)
                          .map((skill) => Chip(
                                backgroundColor:
                                    AppColor().colorPrimary.withOpacity(0.1),
                                label: Text(
                                  skill,
                                  style: TextStyle(
                                    color: AppColor().colorPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => ResumeDetailView(resume: resume));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor().colorPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "View Resume",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Safe skills parsing method
  List<String> _parseSkillsSafely(dynamic skillsData) {
    try {
      if (skillsData == null) return [];

      if (skillsData is List) {
        // Handle case where skills might be nested [[skill1, skill2]]
        if (skillsData.isNotEmpty && skillsData[0] is List) {
          return List<String>.from(
                  skillsData[0].map((item) => item?.toString() ?? ''))
              .where((skill) => skill.isNotEmpty)
              .toList();
        }
        // Handle flat list [skill1, skill2]
        else {
          return List<String>.from(
                  skillsData.map((item) => item?.toString() ?? ''))
              .where((skill) => skill.isNotEmpty)
              .toList();
        }
      }

      // Handle case where skills might be a single string
      if (skillsData is String) {
        return [skillsData];
      }

      return [];
    } catch (e) {
      print("Error parsing skills: $e");
      return [];
    }
  }

  Widget _infoIcon(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
