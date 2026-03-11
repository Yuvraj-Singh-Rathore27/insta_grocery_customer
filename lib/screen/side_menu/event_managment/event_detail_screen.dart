import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/customer_event_controller.dart';
import '../../../model/customer_event_model.dart';
import '../../../res/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';



class EventDetailScreen extends StatelessWidget {
  final CustomerEventModel event;

  EventDetailScreen({super.key, required this.event});
final controller = Get.put(CustomerEventController());


  @override
  Widget build(BuildContext context) {
    controller.getRegisteredUsersByEvent(event.id!);
    final imageUrl = (event.image != null &&
            event.image!.isNotEmpty &&
            event.image!.first.path != null &&
            event.image!.first.path!.startsWith('http'))
        ? event.image!.first.path!
        : null;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          _headerImage(imageUrl),
          Expanded(child: _detailsSection()),
          _bottomButtons(imageUrl),
        ],
      ),
    );
  }

  // ================= HEADER IMAGE =================
  Widget _headerImage(String? imageUrl) {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: imageUrl == null
              ? Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 60),
                )
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 60),
                ),
        ),

        Positioned(
          top: 45,
          left: 15,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
        ),

        Positioned(
          top: 45,
          right: 15,
          child: _badge(event.feeType == "free" ? "FREE" : "PAID",
              event.feeType == "free" ? Colors.green : Colors.orange),
        ),

        // Positioned(
        //   top: 45,
        //   left: 80,
        //   child: _badge("TODAY", Colors.deepPurple),
        // ),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= DETAILS =================
  Widget _detailsSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.category?.name?.toUpperCase() ?? '',
            style: TextStyle(
              color: AppColor().colorPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.title ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _infoCard(
            icon: Icons.calendar_month,
            title: "Date & Time",
            subtitle:
                "${event.eventDate}\n${event.eventTime}",
          ),

          const SizedBox(height: 16),

          _infoCard(
            icon: Icons.location_on,
            title: "Location",
            subtitle: event.address ?? '',
            extra: GestureDetector(
              onTap: _openMap,
              child: const Text(
                "View on Map",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "About Event",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            event.description ?? '',
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),

          const SizedBox(height: 20),

          const Text(
            "Organizer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(event.organizerName ?? ''),
        ],
      ),
    );
  }

  Widget _infoCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      Widget? extra}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle),
                if (extra != null) ...[
                  const SizedBox(height: 6),
                  extra,
                ]
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= BOTTOM BUTTONS =================
  Widget _bottomButtons(String? imageUrl){
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Obx(() {
          final isRegistered =
              controller.registeredEventIds.contains(event.id);

          return Row(
            children: [
              // ✅ Register Button
             

              const SizedBox(width: 10),

              // ✅ Share Button
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color:
                            AppColor().colorPrimary),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () async {
  final shareText = '''
📅 ${event.title}

🗓 Date: ${event.eventDate} ${event.eventTime}
📍 Location: ${event.address}

Check out this event!
''';

  if (imageUrl != null) {
    File? imageFile =
        await controller.downloadImage(imageUrl);

    if (imageFile != null) {
      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: shareText,
      );
      return;
    }
  }

  // fallback if image not available
  Share.share(shareText);
},

                ),
              ),
            ],
          );
        }),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.list),
            onPressed: () {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Obx(() {
        final users = controller.usersForEvent(event.id!);

        if (users.isEmpty) {
          return const Center(child: Text("No registrations yet"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) {
            final u = users[i];
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(u.name ?? ''),
              subtitle: Text(u.mobile ?? ''),
               trailing: IconButton(
    icon: const Icon(Icons.phone, color: Colors.green),
    onPressed: () {
      if (u.mobile != null && u.mobile!.isNotEmpty) {
       controller.makePhoneCall(u.mobile!);
      } else {
        Get.snackbar("No Number", "User has no mobile number");
      }
    },
  ),
            );
          },
        );
      }),
    ),
  );
},

            label: const Text("View Registrations"),
          ),
        ),
      ],
    ),
  );
}


  void _openMap() async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=${event.latitude},${event.longitude}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
