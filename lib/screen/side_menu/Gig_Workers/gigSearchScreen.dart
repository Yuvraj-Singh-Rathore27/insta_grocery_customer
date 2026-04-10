import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import '../../../controller/gigs_works_controller.dart';
import './gig_worker_detail_screen.dart';

class GigSearchScreen extends StatefulWidget {
  const GigSearchScreen({super.key});

  @override
  State<GigSearchScreen> createState() => _GigSearchScreenState();
}

class _GigSearchScreenState extends State<GigSearchScreen> {
  final GigsController controller = Get.find<GigsController>();

  int selectedFilter = 0;
  final filters = ["All Workers", "Available Now", "Top Rated"];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    /// Load all gigs
    await controller.loadMyProfile();

    /// Load hired gigs to know which ones are hired by current user
    await controller.getMyHiredGigs();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
        title: const Text("Gig Workers",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [
          Icon(Icons.tune, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 12),
        ],
      ),

      /// BODY
      body: Obx(() {
        /// LOADING
        if (controller.isLoadingProfile.value ||
            controller.isLoadingHiredGigs.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading workers..."),
              ],
            ),
          );
        }

        /// NO DATA
        if (controller.gigsList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text("No workers found", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return Column(
          children: [
            /// SEARCH BOX
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Search skills, services, or workers",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),

            /// FILTERS
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedFilter == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedFilter = index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor().colorPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColor().colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            /// COUNT & SORT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${controller.gigsList.length} workers found",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Row(
                    children: [
                      Text("Sort by "),
                      Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.gigsList.length,
                itemBuilder: (context, index) {
                  final gig = controller.gigsList[index];
                  return workerCard(gig);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  /// WORKER CARD
  Widget workerCard(Map<String, dynamic> gig) {
    /// CHECK IF THIS WORKER IS ALREADY HIRED BY CURRENT USER
    final bool isHired = controller.isWorkerHiredByMe(gig['id'] ?? 0);

    return GestureDetector(
      onTap: (){
         Get.to(() => GigWorkerDetailScreen(gig: gig));
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isHired
            ? Border.all(color: Colors.black.withOpacity(0.1), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW - Avatar + Name + Hired Badge
          Row(
            children: [
              /// Avatar
              CircleAvatar(
                radius: 28,
                backgroundImage: gig['image'] != null && gig['image'].isNotEmpty
                    ? NetworkImage(gig['image'][0]['path'])
                    : null,
                child: (gig['image'] == null || gig['image'].isEmpty)
                    ? const Icon(Icons.person, size: 28)
                    : null,
              ),

              const SizedBox(width: 12),

              /// Name & Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            gig['full_name'] ?? "No Name",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        /// HIRED BADGE (only if hired)
                        if (isHired)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "HIRED",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gig['title'] ?? "",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// WORK PREFERENCE & LOCATION
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gig['work_preference'] == "remote"
                      ? Colors.blue.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  gig['work_preference'] == "remote" ? "Remote" : "On-site",
                  style: TextStyle(
                    color: gig['work_preference'] == "remote"
                        ? Colors.blue
                        : Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                gig['city'] ?? "",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// BIO
          if (gig['bio'] != null && gig['bio'].toString().isNotEmpty)
            Text(
              gig['bio'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),

          const SizedBox(height: 12),

          /// SKILLS
          if (gig['skills'] != null && (gig['skills'] as List).isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (gig['skills'] as List).take(3).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    skill.toString(),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          /// PRICE & BUTTONS
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Starting from",
                    style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  ),
                  Text(
                    "₹ ${gig['price'] ?? 0}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              /// MESSAGE BUTTON
              _buildActionButton(gig, isHired),
            ],
          ),
        ],
      ),
    ),
    );
  }

  /// MESSAGE BUTTON

  /// HIRE BUTTON (Black - Active)
  /// HIRE BUTTON with Description Dialog

  /// Show Hire Dialog with Description
  void _showHireDialog(Map<String, dynamic> gig) {
    final TextEditingController descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text("Hire ${gig['full_name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add a message or description for this hire",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter description (optional)...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog
              Get.back();

              // Show loading
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              // Get description (empty if not provided)
              String description = descriptionController.text.trim();
              if (description.isEmpty) {
                description = "Hired for ${gig['title'] ?? 'gig work'}";
              }

              // Call hire API with description
              bool success = await controller.hireGigWithTracking(
                gig,
                description: description,
              );

              // Close loading
              Get.back();

              if (success) {
                // Show success message
                Get.snackbar(
                  "Success! 🎉",
                  "${gig['full_name']} has been hired",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                // Refresh UI
                setState(() {});
              } else {
                // Show error
                Get.snackbar(
                  "Error ❌",
                  "Failed to hire. Please try again.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Confirm Hire"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// HIRED BUTTON (Green - Disabled style)

  Widget _buildActionButton(Map<String, dynamic> gig, bool isHired) {
    return GestureDetector(
      onTap: () {
        _showMessageDialog(gig, isHired);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isHired ? Colors.green.shade50 : Colors.black,
        ),
        child: Text(
          isHired ? "Edit Message" : "Hire",
          style: TextStyle(
            color: isHired ? Colors.green : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(Map<String, dynamic> gig, bool isHired) {
    final TextEditingController controllerText = TextEditingController();

    /// 🔥 PRE-FILL MESSAGE (important UX)
    if (isHired) {
      final hire = controller.hiredGigsList.firstWhere(
        (e) => e['profile_id'] == gig['id'],
        orElse: () => {},
      );

      controllerText.text = hire['description'] ?? "";
    }

    Get.dialog(
      AlertDialog(
        title: Text(isHired ? "Update Message" : "Hire ${gig['full_name']}"),
        content: TextField(
          controller: controllerText,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter message...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              String description = controllerText.text.trim();
              if (description.isEmpty) {
                description = "Hired for ${gig['title']}";
              }

              bool success;

              if (isHired) {
                /// 🔥 UPDATE FLOW
                final hire = controller.hiredGigsList.firstWhere(
                  (e) => e['profile_id'] == gig['id'],
                );

                int? hireId = hire['hire_id'] ?? hire['id'];

                if (hireId == null) {
                  Get.snackbar("Error", "Hire ID not found");
                  return;
                }

                success = await controller.updateHireMessage(
                  hireId,
                  description,
                );
              } else {
                /// 🔥 CREATE FLOW
                success = await controller.hireGigWithTracking(
                  gig,
                  description: description,
                );
              }

              if (success) {
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor().colorPrimary,
            ),
            child: Text(isHired ? "Update" : "Hire",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
