import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/event_managment/event_detail_screen.dart';

import '../../../controller/customer_event_controller.dart';
import '../../../model/customer_event_model.dart';
import '../../../res/AppColor.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:io';





class CustomerEventScreen extends StatelessWidget {
  CustomerEventScreen({super.key});

  final controller = Get.put(CustomerEventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Events",style: TextStyle(fontWeight: FontWeight.bold),),
      actions: [
  IconButton(
    icon: const Icon(Icons.search),
    onPressed: () {
      controller.isSearchOpen.toggle();
    },
  ),

  IconButton(
    icon: const Icon(Icons.tune),
    onPressed: () {
      controller.isFilterOpen1.toggle();
    },
  ),
],  centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 
        10,bottom: 10),
        child: Column(
          children: [
        Obx(() {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: controller.isSearchOpen.value ? 60 : 0,
    margin: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: controller.isSearchOpen.value ? 10 : 0),
    child: controller.isSearchOpen.value
        ? TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: "Search by title or #hashtag",
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.searchController.clear();
                  controller.isSearchOpen.value = false;
                  controller.getMyEvents(); // restore list
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
              controller.searchEvents(value, isMyEvents: true);
            },
          )
        : const SizedBox(),
  );
}),

            
Obx(() {
  return AnimatedSize(
    duration: const Duration(milliseconds: 300),
    child: controller.isFilterOpen1.value
        ? _buildFilterDropdowns()
        : const SizedBox(),
  );
}),            
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }

Widget _buildFilterDropdowns() {
  return Obx(() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Events",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// CLOSE BUTTON
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.isFilterOpen1.value = false;
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// CATEGORY DROPDOWN
          DropdownButtonFormField<int>(
            value: controller.selectedCategoryId.value == 0
                ? null
                : controller.selectedCategoryId.value,
            items: controller.categories
                .map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name ?? ''),
                    ))
                .toList(),
            onChanged: (v) {
              controller.filterByCategory(v ?? 0);
            },
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              labelText: "Category",
              prefixIcon: const Icon(Icons.category_outlined),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// SUBCATEGORY DROPDOWN
          DropdownButtonFormField<int>(
            value: controller.selectedSubCategoryId.value == 0
                ? null
                : controller.selectedSubCategoryId.value,
            items: controller.subCategories
                .map((e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name ?? ''),
                    ))
                .toList(),
            onChanged: (v) {
              if (controller.selectedCategoryId.value == 0) {
                Get.snackbar(
                  "Select Category",
                  "Please select category first",
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              controller.filterBySubCategory(v ?? 0);
            },
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              labelText: controller.selectedCategoryId.value == 0
                  ? "Select category first"
                  : "Subcategory",
              prefixIcon: const Icon(Icons.list_alt_outlined),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// CLEAR FILTER
              TextButton.icon(
                onPressed: () {
                  controller.clearFilter();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Clear"),
              ),

              /// APPLY BUTTON (optional)
              ElevatedButton.icon(
                onPressed: () {
                  controller.isFilterOpen1.value = false;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
}
  Widget _buildEventList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.myEvents.length,
        itemBuilder: (context, index) {
          final event = controller.myEvents[index];
          return _eventCard(event);
        },
      );
    });
  }

  // ================= EVENT CARD =================
  Widget _eventCard(CustomerEventModel event) {
     final imageUrl = (event.image != null &&
        event.image!.isNotEmpty &&
        event.image!.first.path != null &&
        event.image!.first.path!.startsWith('http'))
    ? event.image!.first.path!
    : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
            

GestureDetector(
  onTap: ()=>{
    Get.to(EventDetailScreen(event: event))
  },
  child: Container(
  height: 180,
  width: double.infinity,
  color: Colors.grey.shade200,
  child: imageUrl == null
      ? const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey,
          ),
        )
      : Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
),

),
                // FREE / PAID TAG
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: event.feeType == "free"
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.feeType?.toUpperCase() ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.category?.name ?? '',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600,
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
                    const Icon(Icons.calendar_month, size: 18),
                    const SizedBox(width: 6),
                    Text("${event.eventDate} | ${event.eventTime}"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(event.address ?? '')),
                  ],
                ),

                const SizedBox(height: 14),

         Obx(() {
  final isRegistered =
      controller.registeredEventIds.contains(event.id);

  return Row(
    children: [
      // ✅ Register Button
     

      // ✅ Share Button
      Expanded(
        child: OutlinedButton.icon(
          icon: const Icon(Icons.share),
          label: const Text("Share"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: AppColor().colorPrimary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
  );
})

              ],
            ),
          ),
        ],
      ),
    );
  }
}


