import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../model/storeOfferModel.dart';
import '../../../res/AppColor.dart';

class OfferDetailScreen extends StatelessWidget {
  final StoreOfferModel offer;

  const OfferDetailScreen({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (offer.image != null &&
                offer.image!.isNotEmpty &&
                offer.image!.first.path != null &&
                offer.image!.first.path!.startsWith("http"))
            ? offer.image!.first.path!
            : null;

    return Scaffold(
      body: Column(
        children: [

          /// HEADER IMAGE
          Stack(
            children: [
              imageUrl == null
                  ? Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 60),
                    )
                  : Image.network(
  imageUrl,
  height: 180,
  width: double.infinity,
  fit: BoxFit.cover,

  /// 🔄 Loading Indicator
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;

    return Container(
      height: 180,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  },

  /// ❌ If image fails OR unsupported format
  errorBuilder: (context, error, stackTrace) {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "Image not supported",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  },
),

              Positioned(
                top: 40,
                left: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  Text(
                    offer.offerStatus=="Expired"?"Expired":"Running",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          /// CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// CATEGORY / TYPE
                  Text(
                    offer.durationType ?? "SPECIAL OFFER",
                    style: TextStyle(
                      color: AppColor().colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// TITLE
                  Text(
                    offer.name ?? "",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// DATE CARD
                  _infoCard(
                    icon: Icons.calendar_month,
                    title: "Date & Time",
                    value:
                        "${offer.formattedStartDate}\n${offer.formattedEndDate}",
                  ),

                  const SizedBox(height: 12),

                  /// LOCATION CARD
                  _infoCard(
                    icon: Icons.location_on,
                    title: "Location",
                    value: offer.store?.name ?? "",
                    actionText: "View on Map",
                    onTap: () {
                      // open maps
                    },
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
                    "About Offer",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    offer.description ?? "No description available",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 20),

                  /// STORE NAME
                  const Text(
                    "Store",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    offer.store?.name ?? "",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM BUTTONS
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon:  Icon(Icons.local_offer,color: AppColor().whiteColor,),
                    label:  Text("Claim Offer",style: TextStyle(color: AppColor().whiteColor),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // claim logic
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
  icon: const Icon(Icons.share),
  label: const Text("Share"),
  onPressed: () => shareOffer(offer),
),

                ),
              ],
            ),
          )
        ],
      ),
    );
  }

void shareOffer(StoreOfferModel offer) {
  final storeName = offer.store?.name ?? "Unknown Store";
  final mapLink = offer.store?.googleMapsLink ?? "";

  final shareText = '''
🔥 ${offer.name ?? "Special Offer"}

🏪 Store: $storeName
📍 Location: $mapLink

⏰ Status: ${offer.offerStatus}
🕒 Valid Till: ${offer.formattedEndDate}

Check this offer on Frebbo Connect:
https://play.google.com/store/apps/details?id=com.insta.grocery.customer
''';

  Share.share(shareText);
}

  /// INFO CARD WIDGET
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepPurple.shade100,
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value),
                if (actionText != null)
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      actionText,
                      style: TextStyle(
                          color: AppColor().colorPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
