import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/vechile_controller.dart';
import './VechileRegisterScreen.dart';

class VehicleProfileScreen extends StatelessWidget {
  VehicleProfileScreen({super.key});

  final controller = Get.find<VehicleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Vehicle Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.redAccent],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              onPressed: () {
                Get.to(() => VehiclePostScreen());
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ================= VEHICLE STATUS CARD =================
              _buildStatusCard(),
              const SizedBox(height: 20),
              
              // ================= VEHICLE INFO CARD =================
              _buildVehicleInfoCard(),
              const SizedBox(height: 20),
              
              // ================= PRICING CARD =================
              _buildPricingCard(),
              const SizedBox(height: 20),
              
              // ================= QUICK STATS CARD =================
              _buildStatsCard(),
              const SizedBox(height: 20),
              
              // ================= DOCUMENTS CARD =================
              _buildDocumentsCard(),
              const SizedBox(height: 20),
              
              // ================= ACTION BUTTONS =================
             
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard() {
  final width = MediaQuery.of(Get.context!).size.width;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: controller.isVehicleActive.value
            ? [Colors.green.shade400, Colors.green.shade600]
            : [Colors.grey.shade400, Colors.grey.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: (controller.isVehicleActive.value
                  ? Colors.green
                  : Colors.grey)
              .withOpacity(0.3),
          blurRadius: 15,
          spreadRadius: 2,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(width * 0.04), // 🔥 responsive padding
      child: Row(
        children: [
          // LEFT SIDE
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.025),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    controller.isVehicleActive.value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: Colors.white,
                    size: width * 0.06, // 🔥 responsive icon
                  ),
                ),

                SizedBox(width: width * 0.03),

                // TEXT PART
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Vehicle Status",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.035,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Text(
                        controller.isVehicleActive.value
                            ? "Online • Accepting rides"
                            : "Offline • Not accepting rides",
                        maxLines: 2, // 🔥 prevent overflow
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE SWITCH
          Transform.scale(
            scale: width < 350 ? 0.8 : 0.9, // 🔥 small screen adjust
            child: Switch(
              value: controller.isVehicleActive.value,
              onChanged: (val) {
                controller.toggleStatus();
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green.shade300,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildVehicleInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.directions_car, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.modelController.text.isNotEmpty
                          ? controller.modelController.text
                          : "No vehicle added",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.selectedSubCategory.value?.name ?? "No category",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          controller.yearController.text.isNotEmpty
                              ? controller.yearController.text
                              : "Year not set",
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getColorFromString(controller.colorController.text),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.colorController.text.isNotEmpty
                              ? controller.colorController.text
                              : "No color",
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  icon: Icons.confirmation_number,
                  title: "License Plate",
                  value: controller.vehicleNumberController.text.isNotEmpty
                      ? controller.vehicleNumberController.text.toUpperCase()
                      : "Not set",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoBox(
                  icon: Icons.people,
                  title: "Seating",
                  value: "${controller.selectedSeat.value} seats",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  icon: Icons.category,
                  title: "Category",
                  value: controller.selectedCategory.value?.name ?? "Not set",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoBox(
                  icon: Icons.subdirectory_arrow_right,
                  title: "Sub Category",
                  value: controller.selectedSubCategory.value?.name ?? "Not set",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.red.shade400),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.currency_rupee, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Pricing Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _pricingRow(
            title: "Base Charges",
            value: "₹${controller.baseController.text.isNotEmpty ? controller.baseController.text : "0"}",
            isFirst: true,
          ),
          _pricingRow(
            title: "Rate Per KM",
            value: "₹${controller.rateController.text.isNotEmpty ? controller.rateController.text : "0"}",
          ),
          _pricingRow(
            title: "Minimum Fare",
            value: "₹${controller.baseController.text.isNotEmpty ? controller.baseController.text : "0"}",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _pricingRow({
    required String title,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        if (!isFirst) const Divider(color: Colors.grey, height: 1),
        Padding(
          padding: EdgeInsets.only(
            top: isFirst ? 0 : 12,
            bottom: isLast ? 0 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("0", "Total Rides", Icons.trending_up),
          Container(
            width: 1,
            height: 40,
            color: Colors.red.shade200,
          ),
          _statItem("0.0", "Rating", Icons.star),
          Container(
            width: 1,
            height: 40,
            color: Colors.red.shade200,
          ),
          _statItem("0", "Completed", Icons.check_circle),
        ],
      ),
    );
  }

  Widget _statItem(String value, String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.red.shade400, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.description, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Documents",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage vehicle papers & insurance",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
          ),
        ],
      ),
    );
  }

  
  // Helper method to get color from string
  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey.shade400;
    }
  }
}