import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/live_offer/OfferNearbyMapScreen.dart';
import 'package:insta_grocery_customer/screen/side_menu/live_offer/offer_detail_screen.dart';
import '../../../controller/vender_controller.dart';
import '../../../res/AppColor.dart';
import 'package:share_plus/share_plus.dart';

class LiveOfferScreen extends StatelessWidget {
  const LiveOfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PharmacyController controller =
        Get.find<PharmacyController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "All Offers",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "ACTIVE"),
              Tab(text: "EXPIRED"),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Get.to(const NearbyOfferMapScreen());
              },
              icon: const Icon(Icons.map),
            )
          ],
        ),

        /// BODY
        body: Obx(() {
          if (controller.isLoadingOffer.value) {
            return const Center(
                child: CircularProgressIndicator());
          }

          /// Filter by category only (removed subcategory filter)
          final filteredOffers =
              controller.homeOfferList.where((offer) {
            // Category filter only
            if (controller.selectedOfferCategoryId.value != 0 &&
                offer.offerCategoryId !=
                    controller.selectedOfferCategoryId.value) {
              return false;
            }
            return true;
          }).toList();

          final activeOffers = filteredOffers
              .where((o) =>
                  o.isActive == true &&
                  o.isDeleted == false)
              .toList();

          final inactiveOffers = filteredOffers
              .where((o) =>
                  o.isActive == false ||
                  o.isDeleted == true)
              .toList();

          return Column(
            children: [
              /// Tab View
              Expanded(
                child: TabBarView(
                  children: [
                    _offerList(activeOffers),
                    _offerList(inactiveOffers),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Offer List
  Widget _offerList(List offers) {
    if (offers.isEmpty) {
      return const Center(
          child: Text("No offers found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: offers.length,
      itemBuilder: (_, index) {
        return _offerCard(offers[index]);
      },
    );
  }

  /// Offer Card
  Widget _offerCard(offer) {
    final imageUrl = (offer.image != null &&
            offer.image!.isNotEmpty &&
            offer.image!.first.path != null &&
            offer.image!.first.path!
                .trim()
                .isNotEmpty)
        ? offer.image!.first.path!
        : null;

    return GestureDetector(
      onTap: () {
        Get.to(
            OfferDetailScreen(offer: offer));
      },
      child: Container(
        margin:
            const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black
                  .withOpacity(0.08),
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius
                          .vertical(
                          top: Radius.circular(
                              18)),
                  child: imageUrl == null
                      ? _imageErrorWidget()
                      : Image.network(
                          imageUrl,
                          height: 180,
                          width:
                              double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context,
                                  child,
                                  progress) {
                            if (progress ==
                                null) {
                              return child;
                            }
                            return const SizedBox(
                              height: 180,
                              child: Center(
                                child:
                                    CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder:
                              (context,
                                  error,
                                  stackTrace) {
                            return _imageErrorWidget();
                          },
                        ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: _badge(
                    offer.isActive == true
                        ? "LIVE"
                        : "EXPIRED",
                    offer.isActive == true
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),

            Padding(
              padding:
                  const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  Text(
                    offer.store?.name ??
                        '',
                    style: TextStyle(
                      color: AppColor()
                          .colorPrimary,
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(
                      height: 6),

                  Text(
                    offer.name ?? '',
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Row(
                    children: [
                      const Icon(
                          Icons.schedule,
                          size: 16),
                      const SizedBox(
                          width: 6),
                      Text(
                        offer.timeLeft
                                .isNotEmpty
                            ? "Ends in ${offer.timeLeft}"
                            : "Limited period",
                      ),
                    ],
                  ),

                  const SizedBox(
                      height: 14),

                  Row(
                    children: [
                      Expanded(
                        child:
                            ElevatedButton(
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                AppColor()
                                    .colorPrimary,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Claim Offer",
                            style: TextStyle(
                                color:
                                    AppColor()
                                        .whiteColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 10),
                      Expanded(
                        child:
                            OutlinedButton
                                .icon(
                          icon:
                              const Icon(
                                  Icons.share),
                          label:
                              const Text(
                                  "Share"),
                          onPressed:
                              () {
                            Share.share(
                                "Check this offer: ${offer.name}");
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageErrorWidget() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight:
              FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}