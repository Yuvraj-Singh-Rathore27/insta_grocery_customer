import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/vechile_controller.dart';

class RideDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  
  const RideDetailsScreen({super.key, this.vehicle});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  final controller = Get.find<VehicleController>();
  
  late Map<String, dynamic> vehicleData;
  
  @override
  void initState() {
    super.initState();
    // Use passed vehicle data or get from controller
    if (widget.vehicle != null) {
      vehicleData = widget.vehicle!;
    } else if (controller.nearbyVehicles.isNotEmpty) {
      vehicleData = controller.nearbyVehicles.first;
    } else {
      vehicleData = {};
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanNumber.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number not available",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        "Error",
        "Cannot make call",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _openNavigation(double lat, double lng) {
    final url = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Ride Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: vehicleData.isEmpty
          ? const Center(
              child: Text("No vehicle data available"),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Driver Profile Card
                  _buildDriverProfileCard(),
                  const SizedBox(height: 16),
                  
                  // Vehicle Details Card
                  _buildVehicleDetailsCard(),
                  const SizedBox(height: 16),
                  
                  // Pricing Details Card
                  _buildPricingCard(),
                  const SizedBox(height: 16),
                  
                  // Location Details Card
                  _buildLocationCard(),
                  const SizedBox(height: 16),
                  
                  // Documents Card
                  _buildDocumentsCard(),
                  const SizedBox(height: 24),
                  
                  // Action Buttons
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildDriverProfileCard() {
    final driver = vehicleData['driver'] ?? {};
    final driverName = driver['name'] ?? 'Not available';
    final driverContact = driver['contact_number'] ?? '';
    final driverLicense = driver['license_number'] ?? 'Not available';
    final licenseExpiry = driver['license_expiry_date'] ?? 'Not available';
    final hasContact = driverContact.isNotEmpty && driverContact.length >= 10;
    
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "4.8",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "100+ rides",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
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
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _infoRow(
                  icon: Icons.phone,
                  title: "Contact Number",
                  value: driverContact.isEmpty ? "Not available" : driverContact,
                  action: hasContact
                      ? IconButton(
                          onPressed: () => _makePhoneCall(driverContact),
                          icon: const Icon(Icons.call, color: Colors.red, size: 20),
                        )
                      : null,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: Icons.credit_card,
                  title: "License Number",
                  value: driverLicense,
                ),
                const Divider(height: 24),
                _infoRow(
                  icon: Icons.calendar_today,
                  title: "License Expiry",
                  value: licenseExpiry,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsCard() {
    final category = vehicleData['category'] ?? {};
    final subCategory = vehicleData['subcategory'] ?? {};
    
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "Vehicle Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _infoRow(
            icon: Icons.confirmation_number,
            title: "Vehicle Number",
            value: vehicleData['vehicle_number'] ?? 'Not available',
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.build,
            title: "Make & Model",
            value: vehicleData['make_model'] ?? 'Not available',
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.category,
            title: "Category",
            value: category['name'] ?? 'Not available',
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.subdirectory_arrow_right,
            title: "Subcategory",
            value: subCategory['name'] ?? 'Not available',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoRow(
                  icon: Icons.calendar_today,
                  title: "Year",
                  value: vehicleData['year']?.toString() ?? 'Not available',
                ),
              ),
              Expanded(
                child: _infoRow(
                  icon: Icons.color_lens,
                  title: "Color",
                  value: vehicleData['color'] ?? 'Not available',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.people,
            title: "Seating Capacity",
            value: "${vehicleData['seating_capacity'] ?? 2} seats",
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.currency_rupee, color: Colors.red, size: 24),
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
            value: "₹${vehicleData['base_chargers'] ?? vehicleData['base_charges'] ?? 0}",
            isFirst: true,
          ),
          _pricingRow(
            title: "Rate Per Kilometer",
            value: "₹${vehicleData['rate_per_km'] ?? 0}/km",
          ),
          _pricingRow(
            title: "Minimum Fare",
            value: "₹${vehicleData['base_chargers'] ?? vehicleData['base_charges'] ?? 0}",
          ),
          _pricingRow(
            title: "Waiting Charges",
            value: "₹2/min",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    final lat = vehicleData['latitude'] ?? controller.latitude.value;
    final lng = vehicleData['longitude'] ?? controller.longitude.value;
    
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "Location Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _infoRow(
            icon: Icons.my_location,
            title: "Current Location",
            value: "Vehicle is nearby",
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoRow(
                  icon: Icons.map,
                  title: "Latitude",
                  value: lat.toString(),
                ),
              ),
              Expanded(
                child: _infoRow(
                  icon: Icons.map,
                  title: "Longitude",
                  value: lng.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openNavigation(lat.toDouble(), lng.toDouble()),
              icon: const Icon(Icons.navigation, size: 18),
              label: const Text("Open in Google Maps"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                "Documents",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _docRow(
            icon: Icons.car_rental,
            title: "RC Document",
            subtitle: "Registration Certificate",
            isVerified: true,
          ),
          const SizedBox(height: 16),
          _docRow(
            icon: Icons.security,
            title: "Insurance Document",
            subtitle: "Valid until Dec 2025",
            isVerified: true,
          ),
          const SizedBox(height: 16),
          _docRow(
            icon: Icons.health_and_safety,
            title: "Fitness Certificate",
            subtitle: "Verified",
            isVerified: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final driver = vehicleData['driver'] ?? {};
    final driverContact = driver['contact_number'] ?? '';
    final hasContact = driverContact.isNotEmpty && driverContact.length >= 10;
    final lat = vehicleData['latitude'] ?? controller.latitude.value;
    final lng = vehicleData['longitude'] ?? controller.longitude.value;
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _openNavigation(lat.toDouble(), lng.toDouble()),
            icon: const Icon(Icons.navigation, size: 20),
            label: const Text("Navigate"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: hasContact
                ? () => _makePhoneCall(driverContact)
                : null,
            icon: const Icon(Icons.call, size: 20),
            label: Text(
              hasContact ? "Call Driver" : "Contact Unavailable",
              style: const TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    Widget? action,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.red.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (action != null) action,
      ],
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
          padding: EdgeInsets.symmetric(
            vertical: isFirst ? 0 : 12,
            horizontal: 0,
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
        if (isLast) const SizedBox(height: 0),
      ],
    );
  }

  Widget _docRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isVerified,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.red.shade400),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isVerified ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.warning,
                size: 14,
                color: isVerified ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                isVerified ? "Verified" : "Pending",
                style: TextStyle(
                  fontSize: 10,
                  color: isVerified ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}