import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_grocery_customer/screen/side_menu/event_managment/all_event_screen.dart';

import '../../../controller/customer_event_controller.dart';
import './Post_event.dart';
import './my_event_screen.dart';
import '../../../res/AppColor.dart';
import '../../../res/ImageRes.dart';
import './EventNearbyMapScreen.dart';

class EventManagementDashboard extends StatefulWidget {
  const EventManagementDashboard({super.key});

  @override
  State<EventManagementDashboard> createState() =>
      _EventManagementDashboardState();
}

class _EventManagementDashboardState
    extends State<EventManagementDashboard> {

  final controller = Get.put(CustomerEventController());

  int selectedIndex = 1; // Default = Post button selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorBg,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Explore Events",
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: AppColor().colorPrimary),
            onPressed: () {
              Get.to(() => const EventNearbyMapScreen());
            },
          ),
        ],
        centerTitle: true,
      ),
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            const SizedBox(height: 20),
            _categorySection(),
            const SizedBox(height: 20),
            _bannerSection(),
          ],
        ),
      ),

      // Floating Post Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor().colorPrimary,
        onPressed: () {
          setState(() => selectedIndex = 1);
          Get.to(() => PostCustomerEventScreen());
        },
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: _bottomBar(),
    );
  }

  // ================= SEARCH =================
  Widget _searchBar() {
    return TextField(
      controller: controller.searchController,
      onChanged: (value) => controller.searchEvents(value),
      decoration: InputDecoration(
        hintText: "Search events, venues, hosts...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ================= CATEGORY =================
 Widget _categorySection() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFDF2F2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Browse Categories",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Discover amazing events around you",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 16),

        Obx(() {

  if (controller.isLoadingCategory.value) {
    return const Center(child: CircularProgressIndicator());
  }

  final sortedCategories = controller.categories.toList()
    ..sort((a, b) =>
        (a.name ?? '')
            .trim()
            .toLowerCase()
            .compareTo(
                (b.name ?? '').trim().toLowerCase()));

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: sortedCategories.length,

    /// ✅ FIXED 3 COLUMNS
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,       // 3 columns
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.85,  // perfect vertical ratio
    ),

    itemBuilder: (context, index) {

      final category = sortedCategories[index];

      return GestureDetector(
        onTap: () {
          controller.filterByCategory(category.id!);
          Get.to(() => AllEventsScreen());
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// ✅ IMAGE (PERFECT CENTERED)
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor()
                      .colorPrimary
                      .withOpacity(0.08),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: category.image != null &&
                          category.image!.isNotEmpty
                      ? Image.network(
                          category.image!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Icon(
                              Icons.image,
                              size: 28,
                            );
                          },
                        )
                      : const Icon(
                          Icons.image,
                          size: 28,
                        ),
                ),
              ),

              const SizedBox(height: 8),

              /// ✅ NAME
              Text(
                category.name ?? "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}),
      ],
    ),
  );
}
  // ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            // Home
            GestureDetector(
              onTap: () {
                setState(() => selectedIndex = 0);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    color: selectedIndex == 0
                        ? AppColor().colorPrimary
                        : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 12,
                      color: selectedIndex == 0
                          ? AppColor().colorPrimary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 40),

            // My Events
            GestureDetector(
              onTap: () {
                setState(() => selectedIndex = 2);
                Get.to(() => CustomerEventScreen());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: selectedIndex == 2
                        ? AppColor().colorPrimary
                        : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "My Events",
                    style: TextStyle(
                      fontSize: 12,
                      color: selectedIndex == 2
                          ? AppColor().colorPrimary
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BANNER =================
  Widget _bannerSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Image.asset(
          ImageRes().team_member_image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}