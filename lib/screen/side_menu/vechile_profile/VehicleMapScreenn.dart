import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/vechile_controller.dart';
import './RideDetailScreen.dart';
class VehicleMapScreen extends StatefulWidget {
  const VehicleMapScreen({super.key});

  @override
  State<VehicleMapScreen> createState() => _VehicleMapScreenState();
}

class _VehicleMapScreenState extends State<VehicleMapScreen> {
  final controller = Get.find<VehicleController>();
  GoogleMapController? mapController;
  Rx<Map<String, dynamic>?> selectedVehicle = Rx<Map<String, dynamic>?>(null);
  BitmapDescriptor? carIcon;
  BitmapDescriptor? selectedCarIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNearbyVehicles();
    });
  }

  Future<void> _loadCustomIcons() async {
    try {
      // Try to load custom icons, fallback to default if not found
      carIcon = await BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
      selectedCarIcon = await BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    } catch (e) {
      // Fallback to default markers
      carIcon = BitmapDescriptor.defaultMarker;
      selectedCarIcon = BitmapDescriptor.defaultMarker;
    }
    setState(() {});
  }

  Set<Marker> _buildMarkers() {
  final vehicles = controller.nearbyVehicles;

  return vehicles.map((vehicle) {
    final vehicleId = vehicle['id']?.toString() ?? "";

    // 🔥 safe selection check
    final isSelected =
        selectedVehicle.value?['id']?.toString() == vehicleId;

    // 🔥 safe coordinates
    final lat = (vehicle['latitude'] ?? 0.0).toDouble();
    final lng = (vehicle['longitude'] ?? 0.0).toDouble();

    // ❌ skip invalid coordinates (VERY IMPORTANT)
    if (lat == 0.0 || lng == 0.0) return null;

    return Marker(
      markerId: MarkerId(vehicleId),

      // 🔥 important for smooth updates
      position: LatLng(lat, lng),

      // 🔥 stable icon (avoid flicker)
      icon: isSelected
          ? (selectedCarIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed))
          : (carIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue)),

      infoWindow: InfoWindow(
        title: vehicle['make_model'] ?? 'Vehicle',
        snippet:
            "₹${vehicle['base_charges'] ?? 0} | ₹${vehicle['rate_per_km'] ?? 0}/km",
      ),

      onTap: () {
        selectedVehicle.value = vehicle;
        _animateToVehicle(lat, lng);
      },
    );
  }).whereType<Marker>().toSet(); // 🔥 REMOVE NULL MARKERS
}


  void _animateToVehicle(double lat, double lng) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(lat, lng),
        16,
      ),
    );
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
        duration: const Duration(seconds: 2),
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
        duration: const Duration(seconds: 2),
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
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return _buildLoadingState();
        }

        if (controller.nearbyVehicles.isEmpty) {
          return _buildEmptyState();
        }

        final markers = _buildMarkers();
        
        // Get initial position from first vehicle or use default
        LatLng initialPosition;
        if (controller.nearbyVehicles.isNotEmpty) {
          final firstVehicle = controller.nearbyVehicles.first;
          initialPosition = LatLng(
            (firstVehicle['latitude'] ?? 0.0).toDouble(),
            (firstVehicle['longitude'] ?? 0.0).toDouble(),
          );
        } else if (controller.latitude.value != 0.0) {
          initialPosition = LatLng(controller.latitude.value, controller.longitude.value);
        } else {
          initialPosition = const LatLng(28.6139, 77.2090); // Default: Delhi
        }

        return Stack(
          children: [
            // Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14,
              ),
markers: Set<Marker>.from(markers),        
      myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              onMapCreated: (c) => mapController = c,
onTap: (LatLng position) => selectedVehicle.value = null,            ),

            // Top Bar
            _buildTopBar(),

            // Bottom Sheet (Selected Vehicle)
            if (selectedVehicle.value != null)
              _buildBottomSheet(selectedVehicle.value!),

            // Close Button
            if (selectedVehicle.value != null)
              _buildCloseButton(),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Finding nearby vehicles...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Searching for available cabs near you",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.car_crash_outlined,
                size: 64,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No vehicles available",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No cabs found in your area right now",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try changing your location or try again later",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.fetchNearbyVehicles(),
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Back Button
            _buildMapButton(
              onTap: () => Get.back(),
              icon: Icons.arrow_back,
              color: Colors.black87,
            ),
            const SizedBox(width: 12),
            
            // Location Info
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Your Location",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Obx(() => Text(
                            controller.selectedSubCategory.value?.name ?? 
                            controller.selectedCategory.value?.name ??
                            "Nearby Vehicles",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // My Location Button
            _buildMapButton(
              onTap: () async {
                await controller.getCurrentLocation();
                if (controller.latitude.value != 0.0) {
                  mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(controller.latitude.value, controller.longitude.value),
                        zoom: 15,
                      ),
                    ),
                  );
                }
              },
              icon: Icons.my_location,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(Map<String, dynamic> vehicle) {
    final driver = vehicle['driver'] ?? {};
    final driverName = driver['name'] ?? 'Driver';
    final driverContact = driver['contact_number'] ?? '';
    final vehicleNumber = vehicle['vehicle_number'] ?? 'Not available';
    final hasContact = driverContact.isNotEmpty && driverContact.length >= 10;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: GestureDetector(
          onTap: () {
  Get.to(() => RideDetailsScreen(vehicle: selectedVehicle.value));
},
          child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Vehicle Info Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    vehicle['make_model'] ?? 'Vehicle',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    vehicle['subcategory']?['name'] ?? 'Economy',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Available now",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.access_time,
                                    size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  "2 min away",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Pricing
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "₹${vehicle['base_charges'] ?? 0}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "₹${vehicle['rate_per_km'] ?? 0}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                TextSpan(
                                  text: "/km",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade100, height: 1),
                  const SizedBox(height: 16),

                  // Driver Info
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.person,
                              color: Colors.white, size: 28),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  "4.8",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "•",
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    vehicleNumber,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Call Button
                      GestureDetector(
                        onTap: hasContact
                            ? () => _makePhoneCall(driverContact)
                            : null,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: hasContact
                                ? Colors.red.shade50
                                : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.phone,
                            size: 22,
                            color: hasContact
                                ? Colors.red
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openNavigation(
                            (vehicle['latitude'] ?? 0.0).toDouble(),
                            (vehicle['longitude'] ?? 0.0).toDouble(),
                          ),
                          icon: const Icon(Icons.navigation, size: 18),
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
                          icon: const Icon(Icons.call, size: 18,color: Colors.white,),
                          label: Text(
                            hasContact ? "Call Driver" : "Contact Unavailable",style: TextStyle(color: AppColor().whiteColor
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
        )
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      bottom: 320,
      right: 16,
      child: _buildMapButton(
        onTap: () => selectedVehicle.value = null,
        icon: Icons.close,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildMapButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  Future<void> animateMarkerMovement(
    String vehicleId,
    LatLng start,
    LatLng end,
  ) async {
  const int duration = 1000; // 1 second
  const int steps = 30;

  final double latStep = (end.latitude - start.latitude) / steps;
  final double lngStep = (end.longitude - start.longitude) / steps;

  for (int i = 0; i < steps; i++) {
    await Future.delayed(Duration(milliseconds: duration ~/ steps));

    final newLat = start.latitude + (latStep * i);
    final newLng = start.longitude + (lngStep * i);

    int index = controller.nearbyVehicles.indexWhere(
      (v) => v['id'].toString() == vehicleId,
    );

    if (index != -1) {
      controller.nearbyVehicles[index]['latitude'] = newLat;
      controller.nearbyVehicles[index]['longitude'] = newLng;

      controller.nearbyVehicles.refresh();
    }
  }
}
}