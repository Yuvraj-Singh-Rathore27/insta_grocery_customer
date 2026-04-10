import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/gigs_works_controller.dart';

class GigWorkerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> gig;

  const GigWorkerDetailScreen({super.key, required this.gig});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        leading: _circleIcon(Icons.arrow_back, () => Get.back()),
        actions: [
          _circleIcon(Icons.share, () {
            // add share here
          })
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// TOP PROFILE HEADER
            _profileHeader(),

            /// ABOUT
            _section(
              "About",
              Text(gig['bio'] ?? "No bio available"),
            ),

            /// SKILLS
            if (gig['skills'] != null)
              _section(
                "Skills",
                Wrap(
                  spacing: 8,
                  children: (gig['skills'] as List).map((skill) {
                    return Chip(
                      label: Text(skill.toString()),
                      backgroundColor: Colors.red.shade50,
                    );
                  }).toList(),
                ),
              ),

            /// EXPERIENCE (STATIC DEMO)
            // _section(
            //   "Experience",
            //   Column(
            //     children: const [
            //       _ExpItem("Senior Developer", "2023 - Present"),
            //       _ExpItem("Frontend Developer", "2021 - 2023"),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showMessageDialog(Map<String, dynamic> gig) {
  final TextEditingController messageController = TextEditingController();

  Get.dialog(
    AlertDialog(
      title: Text("Message ${gig['full_name']}"),
      content: TextField(
        controller: messageController,
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

            String message = messageController.text.trim();

            if (message.isEmpty) {
              message = "Hello, I want to hire you";
            }

            /// 🔥 CALL SAME CONTROLLER FUNCTION
            bool success = await Get.find<GigsController>()
                .hireGigWithTracking(
              gig,
              description: message,
            );

            if (success) {
              Get.snackbar("Success", "Message sent & hired");
            } else {
              Get.snackbar("Error", "Something went wrong");
            }
          },
          child: const Text("Send"),
        ),
      ],
    ),
  );
}

  

  /// PROFILE HEADER
  Widget _profileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [

          /// IMAGE
          _buildProfileImage(),
          const SizedBox(height: 10),

          /// NAME
          Text(
            gig['full_name'] ?? "No Name",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),

          /// TITLE
          Text(
            gig['title'] ?? "",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          /// LOCATION
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.red),
              Text(gig['city'] ?? ""),
            ],
          ),

          const SizedBox(height: 15),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                     _showMessageDialog(gig);
                  },
                  child: const Text("Message"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    makeCall();
                  },
                  child:  Text("Call",style: TextStyle(color: AppColor().whiteColor),),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
              _StatBox("156", "Projects"),
              _StatBox("98%", "Success"),
           _StatBox(
  gig['price'] != null ? "₹ ${gig['price']}" : "₹ 0",
  "Per Hour",
),
            ],
          ),
        ],
      ),
    );
  }

  /// SECTION UI
  Widget _section(String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
  final imageData = gig['image'];

  String? imageUrl;

  /// SAFE CHECK
  if (imageData != null &&
      imageData is List &&
      imageData.isNotEmpty &&
      imageData[0] != null &&
      imageData[0]['path'] != null) {
    imageUrl = imageData[0]['path'];
  }

  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _defaultImage(),
              )
            : _defaultImage(),
      ),

      /// ONLINE / VERIFIED DOT
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      )
    ],
  );
}


Widget _defaultImage() {
  String name = gig['full_name'] ?? "U";

  return Container(
    width: 110,
    height: 110,
    decoration: BoxDecoration(
      color: Colors.red.shade100,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "U",
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    ),
  );
}


Future<void> makeCall() async {
  String phone = gig['phone_number']?.toString() ?? "";

  if (phone.isEmpty) {
    Get.snackbar("Error", "Phone number not available");
    return;
  }

  final Uri url = Uri.parse("tel:$phone");

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    Get.snackbar("Error", "Cannot open dialer");
  }
}

  /// ICON BUTTON
  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.red),
        ),
      ),
    );
  }
}

/// EXPERIENCE ITEM
class _ExpItem extends StatelessWidget {
  final String title;
  final String year;

  const _ExpItem(this.title, this.year);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 2, height: 40, color: Colors.red),
      title: Text(title),
      subtitle: Text(year),
    );
  }
}

/// STAT BOX
class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

