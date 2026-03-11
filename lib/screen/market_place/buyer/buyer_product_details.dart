import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/controller/buyercontroller.dart';
import '../../../toolbar/TopBar.dart';

class MProductDetails extends StatelessWidget {
  final dynamic product;
  final BuyerController buyerController = Get.put(BuyerController());

  MProductDetails({super.key, required this.product});

  // -----------------------------------------------------------
  //                     MESSAGE POPUP
  // -----------------------------------------------------------
  void _openMessagePopup(BuildContext context) {
    final TextEditingController msgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Send Message"),
          content: TextField(
            controller: msgCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter your message...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Send"),
              onPressed: () async {
                if (msgCtrl.text.trim().isEmpty) {
                  Get.snackbar("Error", "Message cannot be empty!");
                  return;
                }

                Navigator.pop(context); // close popup

                await buyerController.markProductAsMessage(
                  product.id,                        // product_id
                  product.userId,                    // receiver_id
                  int.parse(buyerController.userId), // sender_id (logged user)
                  msgCtrl.text,                      // message
                );
              },
            ),
          ],
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

          SizedBox(height: 20),

          // ---------------- BASIC TITLE + PRICE ----------------
          Text(
            capitalizeFirstLetter(product.title) ?? product.name ?? "Untitled Product",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 6),

          Text(
            "₹ ${product.price ?? 0}",
            style: TextStyle(fontSize: 22, color: Colors.black87),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey),
              Text(" ${product.cityName ?? "Unknown"}"),
              SizedBox(width: 10),
              Text("• ${timeAgo(product.createdAt)}"),
            ],
          ),

          SizedBox(height: 20),

          // ---------------- DESCRIPTION ----------------
          Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(
            product.description?.isEmpty ?? true
                ? "No description available."
                : product.description!,
            style: TextStyle(fontSize: 16),
          ),

          SizedBox(height: 25),

          // ---------------- PRODUCT DETAILS ----------------
          Text("Product Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          detailRow("Company Name", capitalizeFirstLetter(product.companyName)),
          detailRow("State", product.stateName),
          detailRow("City", product.cityName),
          detailRow("Product Code", product.productCode),
          detailRow("Strength", product.strength),
          detailRow("Pack Size", product.packSize),
          detailRow("Barcode", product.barCode),
          detailRow("Self Life", product.selfLife),
          detailRow("Manufacturer", product.manufacturerDetails),
          detailRow("Specification", product.specification),
          detailRow("Sizes", product.sizes),
          detailRow("Composition", product.compositions),
          detailRow("Created At", timeAgo(product.createdAt)),

          SizedBox(height: 25),

          // ---------------- SELLER DETAILS ----------------
          if (product.userId != null)
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/22.jpg",
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Seller ID: ${product.userId}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Verified Seller", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),

          SizedBox(height: 25),

          // ---------------- BUTTONS ----------------
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _openMessagePopup(context);
                  },
                  child: Text("Message"),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.call),
                  label: Text("Call"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---------------- SAFE IMAGE WIDGET ----------------
  Widget buildNetworkImage(String? url, {double h = 180, double w = double.infinity, double radius = 12}) {
    if (url == null || url.isEmpty) {
      return Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(Icons.image_not_supported, size: 40),
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
