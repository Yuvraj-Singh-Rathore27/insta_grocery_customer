import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import '../../../toolbar/TopBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/ProductModel.dart';
class MProductDetails extends StatelessWidget {
  final dynamic product;
  final BuyerController buyerController = Get.put(BuyerController());

  MProductDetails({super.key, required this.product});

  // -----------------------------------------------------------
  //                     MESSAGE POPUP
  // -----------------------------------------------------------
  void _openMessagePopup(BuildContext context) {
    final TextEditingController msgCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Top Drag Handle
                Container(
                  height: 4,
                  width: 40,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // 🔹 Title
                Row(
                  children: [
                    Icon(Icons.message, color: AppColor().colorPrimary),
                    SizedBox(width: 8),
                    Text(
                      "Send Message",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                // 🔹 Text Field
                TextField(
                  controller: msgCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // 🔹 Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (msgCtrl.text.trim().isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Message cannot be empty!",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          Navigator.pop(context);

                          await buyerController.markProductAsMessage(
                            product.id,
                            product.userId,
                            int.parse(buyerController.userId),
                            msgCtrl.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Send",
                          style: TextStyle(color: AppColor().whiteColor),
                        ),
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

  @override
  Widget build(BuildContext context) {
    // ---------------- SELECT BEST IMAGE AVAILABLE ----------------
    String img = "";
    if (product.image_url != null && product.image_url!.isNotEmpty) {
      img = product.image_url!.first;
    } else if (product.images != null && product.images!.isNotEmpty) {
      img = product.images ?? "";
    } else if (product.logo != null && product.logo!.isNotEmpty) {
      img = product.logo ?? "";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(
        title: product.title ?? product.name ?? "",
        menuicon: false,
        menuback: true,
        iconnotifiction: true,
        is_wallaticon: true,
        is_supporticon: false,
        is_whatsappicon: false,
        onPressed: () {},
        onTitleTapped: () {},
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          // ---------------- PRODUCT IMAGE ----------------
          buildNetworkImage(img, h: 260),

          const SizedBox(height: 20),

          // ---------------- BASIC TITLE + PRICE ----------------
          Text(
            capitalizeFirstLetter(product.title) ??
                product.name ??
                "Untitled Product",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            "₹ ${product.price ?? 0}",
            style: const TextStyle(fontSize: 22, color: Colors.black87),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.grey),
              Text(" ${product.cityName ?? "Unknown"}"),
              const SizedBox(width: 10),
              Text("• ${timeAgo(product.createdAt)}"),
            ],
          ),

          const SizedBox(height: 20),

          // ---------------- DESCRIPTION ----------------
          const Text("Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            product.description?.isEmpty ?? true
                ? "No description available."
                : product.description!,
            style: TextStyle(fontSize: 16),
          ),

          SizedBox(height: 25),

          // ---------------- PRODUCT DETAILS ----------------
          const Text("Product Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          detailRow("State", product.stateName),
          detailRow("City", product.cityName),

          detailRow("Posted At", timeAgo(product.createdAt)),

      const    SizedBox(height: 25),

         
            buildSellerSection(product),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              _openMessagePopup(context);
            },
            icon: const Icon(Icons.message, color: Colors.white),
            label: Text(
              "Message Seller",
              style: TextStyle(color: AppColor().whiteColor),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor().colorPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- SAFE IMAGE WIDGET ----------------
  Widget buildNetworkImage(String? url,
      {double h = 180, double w = double.infinity, double radius = 12}) {
    if (url == null || url.isEmpty) {
      return Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        height: h,
        width: w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: h,
          width: w,
          color: Colors.grey.shade300,
          child: Icon(Icons.image_not_supported, size: 40),
        ),
      ),
    );
  }

  // --------------- TIME AGO -----------------
  String timeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Unknown";

    try {
      DateTime created = DateTime.parse(dateString);
      Duration diff = DateTime.now().difference(created);

      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hrs ago";
      if (diff.inDays < 7) return "${diff.inDays} days ago";

      return "${created.day}/${created.month}/${created.year}";
    } catch (_) {
      return dateString;
    }
  }

  Widget buildSellerSection(ProductModel product) {
  final user = product.user;

  // Safe values
  final name = user?.userName?.isNotEmpty == true
      ? user!.userName!
      : "Unknown Seller";

  final phone = user?.contactNumber?.isNotEmpty == true
      ? user!.contactNumber!
      : null;

  return Container(
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            "https://randomuser.me/api/portraits/men/22.jpg",
          ),
        ),

        SizedBox(width: 15),

        // 👤 Seller Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4),

              Text(
                phone ?? "No Contact Available",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),

        // 📞 Call Button
        if (phone != null)
  if (phone != null)
  IconButton(
    icon: Icon(Icons.call, color: Colors.green),
    onPressed: () async {
      final cleanedPhone = buyerController.cleanPhoneNumber(phone);

      print("📞 Original: $phone");
      print("✅ Cleaned: $cleanedPhone");

      final Uri callUri = Uri.parse("tel:$cleanedPhone");

      await launchUrl(callUri);
    },
  ),
  
      ],
    ),
  );
}

  // --------------- REUSABLE DETAIL ROW -----------------
  Widget detailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title:", style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value?.toString().isEmpty ?? true ? "N/A" : value.toString(),
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
  

  // First Letter Capital
  String capitalizeFirstLetter(String? name) {
    if (name == null || name.isEmpty) return "";
    return name[0].toUpperCase() + name.substring(1);
  }
}
