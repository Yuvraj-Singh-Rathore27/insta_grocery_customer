import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/screen/side_menu/live_offer/offer_detail_screen.dart';
import '../../../controller/vender_controller.dart';

class NearbyOfferMapScreen extends StatefulWidget {
  const NearbyOfferMapScreen({Key? key}) : super(key: key);

  @override
  State<NearbyOfferMapScreen> createState() =>
      _NearbyOfferMapScreenState();
}

class _NearbyOfferMapScreenState extends State<NearbyOfferMapScreen> {
  final controller = Get.find<PharmacyController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getOfferCategoriesApi();
      await controller.getStoreOfferApi();
      controller.filterNearbyOffersByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Offers")),
      body: Column(
        children: [

          /// CATEGORY BAR
          _categoryBar(),

          /// MAP
          SizedBox(
            height: 500,
            child: Obx(() => GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      controller.lat.value,
                      controller.lng.value,
                    ),
                    zoom: 14,
                  ),
                  markers: controller.offerMarkers.values.toSet(),
                )),
          ),

          /// LIST
          Expanded(child: _nearbyOffersList()),
        ],
      ),
    );
  }

  // CATEGORY BAR
  Widget _categoryBar() {
    return Obx(() => Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.offerSubCategories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _chip("All", 0);
              }

              final cat = controller.offerSubCategories[index - 1];
              return _chip(cat.name ?? '', cat.id ?? 0);
            },
          ),
        ));
  }

  // CHIP
  Widget _chip(String title, int id) {
    return Obx(() {
      final isSelected =
          controller.selectedOfferCategoryId.value == id;

      return GestureDetector(
        onTap: () {
          controller.selectedOfferCategoryId.value = id;
          controller.filterNearbyOffersByCategory();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColor().colorPrimary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor().blackColor),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColor().blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  // OFFER LIST
  Widget _nearbyOffersList() {
    return Obx(() {
      if (controller.nearbyOfferList.isEmpty) {
        return const Center(child: Text("No nearby offers"));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              "Nearby Offers",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.nearbyOfferList.length,
              itemBuilder: (context, index) {
                final offer = controller.nearbyOfferList[index];
                return _offerCard(offer);
              },
            ),
          )
        ],
      );
    });
  }

  // OFFER CARD
 Widget _offerCard(offer) {

  final imageUrl = (offer.image != null &&
          offer.image!.isNotEmpty &&
          offer.image!.first.path != null &&
          offer.image!.first.path!.trim().isNotEmpty)
      ? offer.image!.first.path!
      : null;

  return GestureDetector(
    onTap: () {
      Get.to(() => OfferDetailScreen(offer: offer));
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 60,
                        width: 60,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.local_offer),
                      );
                    },
                  )
                : Container(
                    height: 60,
                    width: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.local_offer),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(offer.store?.name ?? ""),
                const SizedBox(height: 4),
                Text("Ends in ${offer.timeLeft}"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
