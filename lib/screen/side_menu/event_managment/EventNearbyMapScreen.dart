import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';

import '../../../controller/customer_event_controller.dart';
import '../../../model/customer_event_model.dart';
import './event_detail_screen_all.dart';

class EventNearbyMapScreen extends StatefulWidget {
  const EventNearbyMapScreen({Key? key}) : super(key: key);

  @override
  State<EventNearbyMapScreen> createState() => _EventNearbyMapScreenState();
}

class _EventNearbyMapScreenState extends State<EventNearbyMapScreen> {
  final controller = Get.find<CustomerEventController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getAllEvents();
await controller.loadNearbyEventsOnMapByCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Events Map")),
      body: Column(
        children: [
          // _categoryBar(),
          _subCategoryBar(),
          // 🗺 Map on top
      SizedBox(
        height: 500,
        child: Obx(() => GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.6139, 77.2090),
                zoom: 14,
              ),
              markers: controller.eventMarkers.values.toSet(),
            )),
      ),

      // 📋 Vertical Nearby Events list
      Expanded(
        child: _nearbyEventsList(),
      ),

        ],
      ),
    );
  }


  Widget _categoryBar() {
  return Obx(() => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _chip("All", 0);
            }

            final cat = controller.categories[index - 1];
            return _chip(cat.name ?? '', cat.id ?? 0);
          },
        ),
      ));
}

Widget _chip(String title, int id) {
  return Obx(() {
    final isSelected = controller.selectedCategoryId.value == id;

    return GestureDetector(
     onTap: () async {
  controller.selectedCategoryId.value = id;

  // load subcategories for this category
  if (id != 0) {
    await controller.getCustomerEventSubCategory(id);
  } else {
    controller.subCategories.clear();
  }

  await controller.loadNearbyEventsOnMapByCategory();
},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColor().colorPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor().colorPrimary),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColor().colorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  });
}


Widget _subCategoryBar() {
  return Obx(() {
    if (controller.subCategories.isEmpty) {
      return const SizedBox(); // hide if none
    }

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.subCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _subChip("All", 0);
          }

          final sub = controller.subCategories[index - 1];
          print("sub lengthh is these  ${sub}");
          return _subChip(sub.name ?? '', sub.id ?? 0);
        },
      ),
    );
  });
}

Widget _subChip(String title, int id) {
  return Obx(() {
    final isSelected =
        controller.selectedSubCategoryId.value == id;

    return GestureDetector(
      onTap: () async {
        controller.selectedSubCategoryId.value = id;

        await controller.loadNearbyEventsOnMapByCategory();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor().colorPrimary
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor().colorPrimary),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppColor().colorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  });
}


Widget _nearbyEventsList() {
  return Obx(() {
    if (controller.nearbyEvents.isEmpty) {
      return const Center(child: Text("No nearby events"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding( padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text("Nearby Events",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
        


        Expanded(child:  ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: controller.nearbyEvents.length,
      itemBuilder: (context, index) {
        final event = controller.nearbyEvents[index];
        return _eventCard(event);
      },
    ))
      ],

    );
  });
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
      Get.to(() => EventDetailScreenAll(event: event));
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
            borderRadius: BorderRadius.circular(12),
            child: imageUrl == null
                ? Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  )
                : Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "${event.category?.name ?? ''} • ${event.address ?? ''}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),
                Text(
                  event.feeType == "free" ? "FREE" : "PAID",
                  style: TextStyle(
                    color: event.feeType == "free"
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}


}

