import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/event_managment/event_detail_screen_all.dart';
import '../../../controller/customer_event_controller.dart';
import '../../../model/customer_event_model.dart';
import 'event_detail_screen.dart';
import '../../../res/AppColor.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import './EventNearbyMapScreen.dart';

class AllEventsScreen extends StatelessWidget {
  AllEventsScreen({super.key});

  final controller = Get.find<CustomerEventController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "All Events",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                indicatorColor: AppColor().colorPrimary,
                indicatorWeight: 3,
                labelColor: AppColor().colorPrimary,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                tabs: const [
                  Tab(text: "ACTIVE"),
                  Tab(text: "COMPLETED"),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                controller.isSearchOpen.toggle();
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              icon: Icon(Icons.map, color: AppColor().colorPrimary),
              onPressed: () {
                Get.to(() => const EventNearbyMapScreen());
              },
            ),
          ],
        ),

        // BODY STARTS HERE
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeEvents = controller.filteredEvents
              .where((e) => e.isActive == true)
              .toList();

          final completedEvents = controller.filteredEvents
              .where((e) => e.isActive == false)
              .toList();

          return Column(
            children: [
              // SEARCH BAR
              Obx(() {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: controller.isSearchOpen.value ? 60 : 0,
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: controller.isSearchOpen.value ? 10 : 0,
                  ),
                  child: controller.isSearchOpen.value
                      ? TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: "Search by title or #hashtag",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.isSearchOpen.value = false;
                                controller.getAllEvents();
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            controller.searchEvents(value);
                          },
                        )
                      : const SizedBox(),
                );
              }),

              // TAB CONTENT (removed subcategory bar)
              Expanded(
                child: TabBarView(
                  children: [
                    _eventList(activeEvents),
                    _eventList(completedEvents),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _eventList(List<CustomerEventModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text("No Events Found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (_, index) {
        return _eventCard(list[index]);
      },
    );
  }

  Widget _eventCard(CustomerEventModel event) {
    final imageUrl = (event.image != null &&
            event.image!.isNotEmpty &&
            event.image!.first.path != null &&
            event.image!.first.path!.startsWith('http'))
        ? event.image!.first.path!
        : null;

    return GestureDetector(
      onTap: () {
        Get.to(EventDetailScreenAll(event: event));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: imageUrl == null
                      ? Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 50),
                        )
                      : Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _badge(
                    event.feeType == "free" ? "FREE" : "PAID",
                    event.feeType == "free" ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.category?.name?.toUpperCase() ?? '',
                    style: TextStyle(
                      color: AppColor().colorPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 16),
                      const SizedBox(width: 6),
                      Text("${event.eventDate}  ${event.eventTime}"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.address ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Buttons Row
                  Row(
                    children: [
                      // Register (only active)
                      if (event.isActive == true)
                        Expanded(
                          child: Obx(() {
                            final isRegistered = controller
                                .registeredEventIds
                                .contains(event.id);

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColor().colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isRegistered
                                  ? null
                                  : () => controller
                                      .registerForEvent(event.id!),
                              child: Text(
                                isRegistered
                                    ? "Registered"
                                    : "Register Now",
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                            );
                          }),
                        ),

                      if (event.isActive == true)
                        const SizedBox(width: 10),

                      // Share (for all)
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text("Share"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: AppColor().colorPrimary),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final shareText = '''
📅 ${event.title}

🗓 Date: ${event.eventDate} ${event.eventTime}
📍 Location: ${event.address}

Check out this event! @ Frebbo Connect
https://play.google.com/store/apps/details?id=com.insta.grocery.customer
''';

                            if (imageUrl != null) {
                              File? imageFile = await controller.downloadImage(imageUrl);

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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}