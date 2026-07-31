import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/vechile_controller.dart';
import '../../../utills/weight_units.dart';
import '../../../webservices/WebServicesHelper.dart';

class RideDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  
  const RideDetailsScreen({super.key, this.vehicle});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  final controller = Get.find<VehicleController>();
  final TextEditingController _sosMessageController = TextEditingController();
  final PageController _imagePageController = PageController();
  final RxInt _imageIndex = 0.obs;

  late Map<String, dynamic> vehicleData;

  // Full driver detail (including image) fetched from /drivers/{id}.
  // The vehicle-nearby API only embeds id/name/contact for the driver, so
  // we fetch the complete record separately to show the profile photo.
  Map<String, dynamic>? _driverDetail;

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

    // Facility names may have failed to load at app start (network) —
    // retry so the Facilities chips can show names instead of ids.
    if (controller.facilityNames.isEmpty) {
      controller.loadFacilities();
    }

    _fetchDriverDetail();
  }

  // Fetch the driver's full profile by id so the photo (and other details
  // missing from the vehicle payload) can be shown.
  Future<void> _fetchDriverDetail() async {
    final driver = vehicleData['driver'];
    if (driver is! Map) return;

    final dynamic id = driver['id'];
    if (id == null || id == 0) return;

    final res = await WebServicesHelper().getDriverById(id.toString());
    if (res == null || !mounted) return;

    // The endpoint may return the driver object directly, or wrapped as
    // {data: {...}} or {data: [{...}]} — pull the map out of any shape.
    Map<String, dynamic>? detail;
    final dynamic data = res['data'] ?? res;
    if (data is Map) {
      detail = Map<String, dynamic>.from(data);
    } else if (data is List && data.isNotEmpty && data.first is Map) {
      detail = Map<String, dynamic>.from(data.first);
    }

    if (detail != null) {
      setState(() => _driverDetail = detail);
    }
  }

  @override
  void dispose() {
    _sosMessageController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  // Ambulance is vehicle type 2 (ids come from GET /admin/vehicle-type/).
  // Facilities — ICU, Oxygen Support, Patient Transport… — are only ever
  // configured for ambulances, so everything facility-related hangs off this
  // id and not off the payload happening to carry facility_ids.
  static const int _ambulanceTypeId = 2;

  // The type this particular vehicle belongs to (1 = Cab, 2 = Ambulance,
  // 3 = Local Cabs, …). Read straight off the vehicle when the API sends it —
  // the key is spelled differently across endpoints and is sometimes nested in
  // the expanded type/category object, so every known shape is tried.
  int get _vehicleTypeId {
    final Map category =
        vehicleData['category'] is Map ? vehicleData['category'] as Map : {};

    final List<dynamic> candidates = [
      vehicleData['vechile_type_id'], // backend's spelling
      vehicleData['vehicle_type_id'],
      vehicleData['vechile_type'] is Map
          ? (vehicleData['vechile_type'] as Map)['id']
          : null,
      vehicleData['vehicle_type'] is Map
          ? (vehicleData['vehicle_type'] as Map)['id']
          : null,
      category['vechile_type_id'],
      category['vehicle_type_id'],
    ];

    for (final candidate in candidates) {
      final int? id = candidate is int
          ? candidate
          : int.tryParse(candidate?.toString() ?? '');
      if (id != null && id != 0) return id;
    }

    // Nothing on the payload → fall back to the module the customer opened.
    // The nearby fetch filters by vehicle_type_id, so every vehicle reachable
    // from that screen is of this type anyway.
    return controller.vehicleTypeId.value;
  }

  bool get _isAmbulance => _vehicleTypeId == _ambulanceTypeId;

  // Goods vehicles (type 3) are the ones that carry a payload_capacity. Used
  // only to scope the legacy dirty-data correction in WeightUnits — the row
  // itself shows for any non-ambulance vehicle that actually has a capacity,
  // so a future goods type doesn't silently lose it.
  static const int _goodsTypeId = 3;

  bool get _isGoodsVehicle => _vehicleTypeId == _goodsTypeId;

  // "2 Ton" / "150 kg" for the payload row, or null when this vehicle has no
  // usable capacity — the caller then drops the row instead of printing
  // "Not available". All unit handling lives in WeightUnits so this screen
  // and any future one can't disagree.
  String? get _payloadCapacityText => WeightUnits.format(
        vehicleData['payload_capacity'],
        assumeTonsBelow:
            _isGoodsVehicle ? WeightUnits.goodsDirtyDataTonThreshold : null,
      );

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

  void _showSosConfirmationDialog() {
    _sosMessageController.clear();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Emergency SOS"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Are you sure you want to send an emergency SOS? This will call 100 and immediately notify our support team with your live location.",
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sosMessageController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "What's the emergency? (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back();
              _triggerSos();
            },
            child: const Text("Yes, SOS", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _triggerSos() async {
    final driver = vehicleData['driver'] ?? {};
    final int vehicleIdValue = vehicleData['id'] ?? 0;
    final int driverIdValue = driver['id'] ?? 0;
    final double lat = (vehicleData['latitude'] ?? controller.latitude.value).toDouble();
    final double lng = (vehicleData['longitude'] ?? controller.longitude.value).toDouble();

    final String enteredMessage = _sosMessageController.text.trim();
    final String finalMessage =
        enteredMessage.isEmpty ? VehicleController.defaultSosMessage : enteredMessage;

    // 1. Dial emergency number
    await _makePhoneCall("100");

    // 2. Notify backend so admin can see what happened
    final success = await controller.sendSosAlert(
      vehicleId: vehicleIdValue,
      driverId: driverIdValue,
      latitude: lat,
      longitude: lng,
      message: finalMessage,
    );

    Get.snackbar(
      success ? "SOS Sent" : "SOS Alert Failed",
      success
          ? "Emergency alert sent. Help is on the way."
          : "Could not reach our server, but your call to 100 was placed.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? Colors.red : Colors.orange,
      colorText: Colors.white,
    );
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _showSosConfirmationDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sos, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      "SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
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
    // Start from the driver embedded in the vehicle payload, then overlay
    // the full detail fetched from /drivers/{id} (which carries the image).
    final driver = <String, dynamic>{
      ...?(vehicleData['driver'] as Map?)?.cast<String, dynamic>(),
      ...?_driverDetail,
    };
    final driverName = driver['name'] ?? 'Not available';
    final driverContact = driver['contact_number'] ?? '';
    final driverLicense = driver['license_number'] ?? 'Not available';
    final licenseExpiry = driver['license_expiry_date'] ?? 'Not available';
    final hasContact = driverContact.isNotEmpty && driverContact.length >= 10;
    // Driver photo uploaded by the driver (API sends it as "photo" or "image").
    final driverImageUrl = _filePathOf(driver['photo'] ?? driver['image']);
    
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
                  child: ClipOval(
                    child: driverImageUrl != null && driverImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: driverImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: Icon(Icons.person,
                                  size: 35, color: Colors.red),
                            ),
                            errorWidget: (_, __, ___) => const Center(
                              child: Icon(Icons.person,
                                  size: 35, color: Colors.red),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.red,
                            ),
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
    // Ambulances carry facility_ids instead of a subcategory
    final List<int> facilityIds = (vehicleData['facility_ids'] is List)
        ? (vehicleData['facility_ids'] as List).whereType<int>().toList()
        : <int>[];
    // Goods vehicles carry a payload capacity; null when this vehicle has none.
    final String? payloadCapacity = _payloadCapacityText;
    // Vehicle photos uploaded by the driver (API sends "image" as a list of
    // files; tolerates a single map or plain URL too).
    final List<String> vehicleImages = _filePathsOf(vehicleData['image']);
    
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

          // Vehicle photos uploaded by the driver
          _buildVehicleImage(vehicleImages),
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

          // Facilities are an ambulance-only concept, so the row is gated on
          // the vehicle TYPE — not on the payload carrying facility_ids. A
          // local cab (type 3) with a stray facility id on it must never
          // render a medical facilities row; it gets its subcategory here and
          // its seating capacity below instead.
          if (_isAmbulance) ...[
            if (facilityIds.isNotEmpty) ...[
              _facilitiesRow(facilityIds),
              const SizedBox(height: 16),
            ],
          ] else ...[
            _infoRow(
              icon: Icons.subdirectory_arrow_right,
              title: "Subcategory",
              value: subCategory['name'] ?? 'Not available',
            ),
            const SizedBox(height: 16),
          ],

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

          // Seating capacity is the passenger-vehicle counterpart of the
          // facilities row above: it is what matters when booking a cab, so it
          // shows for every type except ambulances.
          if (!_isAmbulance) ...[
            const SizedBox(height: 16),
            _infoRow(
              icon: Icons.people,
              title: "Seating Capacity",
              value: "${vehicleData['seating_capacity'] ?? 2} seats",
            ),
          ],

          // How much weight this vehicle can carry — the number that actually
          // matters on a goods vehicle (type 3). Shown only when the API sends
          // a usable capacity, so passenger cabs don't get an empty row.
          if (!_isAmbulance && payloadCapacity != null) ...[
            const SizedBox(height: 16),
            _infoRow(
              icon: Icons.scale,
              title: "Payload Capacity",
              value: payloadCapacity,
            ),
          ],
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

  // Single file path (driver photo) from any shape the API sends:
  // a map ({"path": ...}), a list of files, or a plain URL string.
  String? _filePathOf(dynamic file) {
    if (file is Map) return file['path']?.toString();
    if (file is List && file.isNotEmpty && file.first is Map) {
      return (file.first as Map)['path']?.toString();
    }
    if (file is String && file.isNotEmpty) return file;
    return null;
  }

  // The API returns image sometimes as a single map ({"path": ...}),
  // sometimes as a list of files, sometimes a plain URL — read all the
  // paths safely from any shape.
  List<String> _filePathsOf(dynamic file) {
    if (file is List) {
      return file
          .whereType<Map>()
          .map((m) => m['path']?.toString())
          .whereType<String>()
          .where((p) => p.isNotEmpty)
          .toList();
    }
    if (file is Map && file['path'] != null) {
      final p = file['path'].toString();
      return p.isNotEmpty ? [p] : [];
    }
    if (file is String && file.isNotEmpty) return [file];
    return [];
  }

  // Vehicle photos uploaded by the driver: placeholder when none, single
  // image for one, swipeable carousel with dots for many.
  Widget _buildVehicleImage(List<String> images) {
    const double imageHeight = 180;

    Widget networkImage(String url) => CachedNetworkImage(
          imageUrl: url,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => _vehicleImagePlaceholder(),
          errorWidget: (_, __, ___) => _vehicleImagePlaceholder(),
        );

    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _vehicleImagePlaceholder(),
      );
    }

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: networkImage(images.first),
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: imageHeight,
            child: PageView.builder(
              controller: _imagePageController,
              itemCount: images.length,
              onPageChanged: (index) => _imageIndex.value = index,
              itemBuilder: (_, i) => networkImage(images[i]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final current = _imageIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final isActive = i == current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? Colors.red : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _vehicleImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            "No vehicle image",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Facility chips (Patient Transport, ICU, Oxygen Support...) resolved
  // from facility_ids via the names loaded in the controller.
  Widget _facilitiesRow(List<int> facilityIds) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.medical_services_outlined,
            size: 20, color: Colors.red.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Facilities",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() {
                return Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: facilityIds.map((id) {
                    final name =
                        controller.facilityNames[id] ?? "Facility #$id";
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
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