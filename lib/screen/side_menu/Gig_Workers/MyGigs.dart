import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/gigs_works_controller.dart';

class MyGigsScreen extends StatefulWidget {
  const MyGigsScreen({super.key});

  @override
  State<MyGigsScreen> createState() => _MyGigsScreenState();
}

class _MyGigsScreenState extends State<MyGigsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GigsController controller = Get.find<GigsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.getMyHiredGigs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
        title: const Text(
          "My Gigs",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingHiredGigs.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading your gigs..."),
              ],
            ),
          );
        }

        if (controller.hiredGigsList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No gigs found",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "When someone hires you, it will appear here",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: "Active"),
                  Tab(text: "All"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveGigsList(),
                  _buildAllGigsList(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActiveGigsList() {
    final activeHires = controller.hiredGigsList
        .where((hire) => hire['is_active'] == true)
        .toList();

    if (activeHires.isEmpty) {
      return const Center(
        child: Text("No active gigs"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeHires.length,
      itemBuilder: (context, index) {
        return _buildHireCard(activeHires[index]);
      },
    );
  }

  Widget _buildAllGigsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.hiredGigsList.length,
      itemBuilder: (context, index) {
        return _buildHireCard(controller.hiredGigsList[index]);
      },
    );
  }

  Widget _buildHireCard(Map<String, dynamic> hire) {
    final profile = hire['profile'] ?? {};
    final user = hire['user'] ?? {};

    final String workerName = profile['full_name'] ?? "Unknown Worker";
    final String clientName = user['first_name'] != null
        ? "${user['first_name']} ${user['last_name'] ?? ''}".trim()
        : "Unknown Client";
    final String description = hire['description'] ?? "No description provided";
    final String hiredDate = _formatDate(hire['created_at']);
    final bool isActive = hire['is_active'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isActive
            ? Border.all(color: Colors.green.shade200, width: 1)
            : Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row with Status Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  workerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.shade50 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? "Active" : "Completed",
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Client Info
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Hired by: $clientName",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Description
          if (description.isNotEmpty)
            Text(
              description,
              style: const TextStyle(fontSize: 13, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 12),

          /// Date
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Hired on: $hiredDate",
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return "Unknown date";

    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return dateTimeString;
    }
  }
}