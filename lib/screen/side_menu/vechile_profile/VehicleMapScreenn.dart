import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/res/ImageRes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controller/vechile_controller.dart';
import './RideDetailScreen.dart';
import './VehicleLocationSearchScreen.dart';

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class VehicleMapScreen extends StatefulWidget {
  const VehicleMapScreen({super.key});

  @override
  State<VehicleMapScreen> createState() => _VehicleMapScreenState();
}

class _VehicleMapScreenState extends State<VehicleMapScreen> {
  late VehicleController controller; // Changed to late for better initialization
  GoogleMapController? mapController;
  Rx<Map<String, dynamic>?> selectedVehicle = Rx<Map<String, dynamic>?>(null);
  // Null = using device's current location. Set once the customer picks a
  // location from VehicleLocationSearchScreen; shown in the top bar and used
  // to tailor the "no vehicles" message to that place.
  Rx<String?> selectedLocationLabel = Rx<String?>(null);
  BitmapDescriptor? movingCarIcon;
  BitmapDescriptor? staticCarIcon;
  BitmapDescriptor? selectedCarIcon;
  BitmapDescriptor? onlineCarIcon;
BitmapDescriptor? offlineCarIcon;

  
  bool isInitialCameraSet = false;
  
  // ✅ Performance: Add caching
  Set<Marker> _cachedMarkers = {};
  Timer? _debounceTimer;
  String _lastCacheKey = '';

  @override
  void initState() {
    super.initState();
    
    // ✅ Safe controller initialization
    if (Get.isRegistered<VehicleController>()) {
      controller = Get.find<VehicleController>();
    } else {
      controller = Get.put(VehicleController(), permanent: true);
    }
    
    _loadCustomIcons();
    
    // ✅ Performance: Debounced rebuild listener
    ever(controller.nearbyVehicles, (_) {
      _debounceMarkersUpdate();
    });
  }
  
  // ✅ Performance: Debounce to prevent multiple rapid rebuilds
  void _debounceMarkersUpdate() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        _updateMarkersAndFit();
      }
    });
  }
  
  void _updateMarkersAndFit() {
    _cachedMarkers = _buildMarkers();
    if (mounted) {
      setState(() {});
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      _fitAllMarkers();
    });
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
  
  void _refreshMapMarkers() {
    if (mapController != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _loadCustomIcons() async {
  try {

    // ✅ ONLINE VEHICLE = ORANGE
    onlineCarIcon = await _createCustomMarker(
      icon: FontAwesomeIcons.carSide,
      color: Colors.orange,
      size: 90,
    );

    // ✅ OFFLINE VEHICLE = GREEN
    offlineCarIcon = await _createCustomMarker(
      icon: FontAwesomeIcons.carSide,
      color: Colors.green,
      size: 90,
    );

    // ✅ SELECTED VEHICLE = RED
    selectedCarIcon = await _createCustomMarker(
      icon: FontAwesomeIcons.carSide,
      color: Colors.red,
      size: 100,
    );

  } catch (e) {

    debugPrint("❌ Marker Error => $e");

    onlineCarIcon = BitmapDescriptor.defaultMarker;
    offlineCarIcon = BitmapDescriptor.defaultMarker;
    selectedCarIcon = BitmapDescriptor.defaultMarker;
  }

  if (mounted) {
    setState(() {});
  }
}

  // ✅ Performance: Cached marker building with cache key
  Set<Marker> _buildMarkers() {

  final vehicles = controller.nearbyVehicles;

  if (vehicles.isEmpty) return {};

  // ✅ Cache check
  final cacheKey = _getCacheKey(vehicles);

  if (cacheKey == _lastCacheKey &&
      _cachedMarkers.isNotEmpty) {
    return _cachedMarkers;
  }

  _lastCacheKey = cacheKey;

  final markers = <Marker>[];

  for (var vehicle in vehicles) {

    final vehicleId =
        vehicle['id']?.toString() ?? "";

    if (vehicleId.isEmpty) continue;

    final lat =
        (vehicle['latitude'] ?? 0.0).toDouble();

    final lng =
        (vehicle['longitude'] ?? 0.0).toDouble();

    if (lat == 0.0 || lng == 0.0) continue;

    // =========================
    // ✅ MOVING CHECK
    // =========================

    final bool isMoving =
        controller.movingVehicles[
                int.tryParse(vehicleId) ?? 0] ??
            false;

    final isSelected =
        selectedVehicle.value?['id']
                ?.toString() ==
            vehicleId;

    BitmapDescriptor icon;

    // =========================
    // ✅ ICON LOGIC
    // =========================

    if (isSelected) {

      // 🔴 SELECTED
      icon =
          selectedCarIcon ??
              BitmapDescriptor.defaultMarker;

    } else if (isMoving) {

      // 🟠 MOVING = ORANGE
      icon =
          onlineCarIcon ??
              BitmapDescriptor.defaultMarker;

    } else {

      // 🟢 STANDING = GREEN
      icon =
          offlineCarIcon ??
              BitmapDescriptor.defaultMarker;
    }

    markers.add(
      Marker(
        markerId: MarkerId(vehicleId),

        position:
            controller.vehiclePositions[
                    int.tryParse(vehicleId) ??
                        0] ??
                LatLng(lat, lng),

        icon: icon,

        anchor: const Offset(0.5, 0.5),

        flat: true,

        alpha: 1.0,

        onTap: () {

          selectedVehicle.value = vehicle;

          _animateToVehicle(lat, lng);
        },
      ),
    );
  }

  return markers.toSet();
}
  // ✅ Performance: Quick cache key generation
  String _getCacheKey(List<dynamic> vehicles) {
    final buffer = StringBuffer();
    buffer.write(selectedVehicle.value?['id'] ?? 'none');
    buffer.write('|');
    buffer.write(controller.selectedCategory.value?.id ?? 'all');
    for (var vehicle in vehicles.take(20)) {
      buffer.write('${vehicle['id']}:${vehicle['latitude']}:${vehicle['longitude']}|');
    }
    return buffer.toString();
  }

  void _animateToVehicle(double lat, double lng) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
    );
  }

  Future<void> _onSelectLocationTap() async {
    final dynamic result =
        await Get.to(() => const VehicleLocationSearchScreen());

    if (result == null || result is! Map) return;

    final double? newLat = (result['latitude'] as num?)?.toDouble();
    final double? newLng = (result['longitude'] as num?)?.toDouble();
    if (newLat == null || newLng == null) return;

    selectedVehicle.value = null;
    selectedLocationLabel.value = result['address'] as String?;
    controller.updateLocation(newLat, newLng);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(newLat, newLng), zoom: 15),
      ),
    );

    await controller.forceRefresh();
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

  void _shareVehicleDetails(Map<String, dynamic> vehicle) {
    final driver = vehicle['driver'] ?? {};
    final driverName = driver['name'] ?? 'Driver';
    final driverContact = (driver['contact_number'] ?? '').toString();
    final vehicleNumber = vehicle['vehicle_number'] ?? 'Not available';
    final makeModel = (vehicle['make_model'] ?? 'Vehicle').toString();
    final lat = (vehicle['latitude'] ?? 0.0).toDouble();
    final lng = (vehicle['longitude'] ?? 0.0).toDouble();

    final shareText = '''
🚖 Vehicle Details

🚗 Vehicle: $makeModel
🔖 Number: $vehicleNumber
👤 Driver: $driverName${driverContact.isNotEmpty ? '\n📞 Contact: $driverContact' : ''}

💰 Base Fare: ₹${vehicle['base_charges'] ?? 0}
📏 Per KM: ₹${vehicle['rate_per_km'] ?? 0}
${lat != 0.0 && lng != 0.0 ? '\n📍 Live Location: https://www.google.com/maps/dir/?api=1&destination=$lat,$lng\n' : ''}
Shared via Frebbo Connect
https://play.google.com/store/apps/details?id=com.insta.grocery.customer
''';

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          if (controller.hasInitialFetchDone.value && controller.isLocationReady.value)
            _buildMap(),
          if (!controller.hasInitialFetchDone.value || !controller.isLocationReady.value)
            _buildLoadingState(),
          if (controller.hasInitialFetchDone.value && 
              controller.isLocationReady.value && 
              controller.nearbyVehicles.isEmpty)
            _buildEmptyState(),
          _buildTopBar(),
          _buildCategoryFilter(),
          if (selectedVehicle.value != null)
            _buildBottomSheet(selectedVehicle.value!),
          if (selectedVehicle.value != null)
            _buildShareButton(selectedVehicle.value!),
          if (selectedVehicle.value != null)
            _buildCloseButton(),
        ],
      )),
    );
  }

  Widget _buildMap() {
    LatLng initialPosition;
    
    if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
      initialPosition = LatLng(controller.latitude.value, controller.longitude.value);
    } else {
      initialPosition = const LatLng(28.6139, 77.2090);
    }

    return GoogleMap(
      key: ValueKey(controller.selectedCategory.value?.id ?? 'all'),
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      markers: _cachedMarkers, // ✅ Using cached markers for better performance
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      onMapCreated: (c) {
        mapController = c;
        if (!isInitialCameraSet) {
          isInitialCameraSet = true;
          Future.delayed(const Duration(milliseconds: 300), () {
            _fitAllMarkers();
          });
        }
      },
      onTap: (LatLng position) {
        selectedVehicle.value = null;
      },
    );
  }

  Widget _buildCategoryFilter() {
  return Positioned(
    bottom: 100,
    left: 0,
    right: 0,
    child: Obx(() {
      if (controller.isLoadingVehiclesByCategory.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      }

      return SizedBox(
        height: 90,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categoryList.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = controller.categoryList[index];

            final isSelected =
                controller.selectedCategory.value?.id ==
                    category.id;

            return GestureDetector(
              onTap: () async {
                await controller.onCategorySelected(category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                constraints: const BoxConstraints(
                  minWidth: 90,
                  maxWidth: 130,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(
                        category.name ?? "",
                      ),
                      size: 24,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),

                    const SizedBox(height: 6),

                    Flexible(
                      child: Text(
                        category.name ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }),
  );
}
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'cabs':
        return Icons.local_taxi;
      case 'auto':
        return Icons.electric_rickshaw;
      case 'vans':
        return Icons.local_shipping;
      default:
        return Icons.directions_car;
    }
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              "Finding nearby vehicles...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Searching for available cabs near you",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fitAllMarkers() async {
    if (mapController == null) return;
    if (controller.nearbyVehicles.isEmpty) return;

    double minLat = controller.latitude.value;
    double maxLat = controller.latitude.value;
    double minLng = controller.longitude.value;
    double maxLng = controller.longitude.value;

    for (var vehicle in controller.nearbyVehicles) {
      final lat = (vehicle['latitude'] ?? 0.0).toDouble();
      final lng = (vehicle['longitude'] ?? 0.0).toDouble();

      if (lat == 0.0 || lng == 0.0) continue;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;

      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  String _emptyStateMessage() {
    final categoryName = controller.selectedCategory.value?.name;
    final locationLabel = selectedLocationLabel.value;

    if (locationLabel != null) {
      return categoryName != null
          ? "No $categoryName available near \"$locationLabel\""
          : "No vehicles available near \"$locationLabel\"";
    }

    return categoryName != null
        ? "No $categoryName available in your area"
        : "No cabs found in your area right now";
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
              _emptyStateMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.forceRefresh(),
              icon: const Icon(Icons.refresh,color: Colors.white,),
              label: const Text("Try Again",style: TextStyle(color: Colors.white),),
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
            _buildMapButton(
              onTap: () => Get.back(),
              icon: Icons.arrow_back,
              color: Colors.black87,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: GestureDetector(
                onTap: _onSelectLocationTap,
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
                            Obx(() => Text(
                                  selectedLocationLabel.value == null
                                      ? "Your Location"
                                      : "Pickup Location",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Obx(() => Text(
                                  selectedLocationLabel.value ??
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
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey.shade500, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            _buildMapButton(
              onTap: () async {
                await controller.getCurrentLocation();
                if (controller.latitude.value != 0.0) {
                  selectedLocationLabel.value = null;
                  mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(controller.latitude.value, controller.longitude.value),
                        zoom: 15,
                      ),
                    ),
                  );
                  await controller.forceRefresh();
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
    final vehicleImageUrl = vehicle['image']?['path'] as String?;
    final driverImageUrl = driver['photo']?['path'] as String?;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 60 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: GestureDetector(
          onTap: () =>
              Get.to(() => RideDetailsScreen(vehicle: selectedVehicle.value)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Handle bar ──
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Vehicle name + ACTIVE badge ──
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (vehicle['make_model'] ?? 'Vehicle')
                                .toString()
                                .split(' ')
                                .map((w) => w.isEmpty
                                    ? w
                                    : w[0].toUpperCase() +
                                        w.substring(1).toLowerCase())
                                .join(' '),
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
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Text(
                            "ACTIVE",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // ── Available now status ──
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Available now",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text("·",
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14)),
                        const SizedBox(width: 6),
                        const Icon(Icons.access_time,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          "2 min away",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Vehicle image ──
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: vehicleImageUrl != null &&
                              vehicleImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: vehicleImageUrl,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  _vehicleImagePlaceholder(),
                              errorWidget: (_, __, ___) =>
                                  _vehicleImagePlaceholder(),
                            )
                          : _vehicleImagePlaceholder(),
                    ),
                    const SizedBox(height: 14),

                    // ── BASE / PER KM pricing row ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BASE",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.local_offer_outlined,
                                        size: 14,
                                        color: Colors.red.shade400),
                                    const SizedBox(width: 4),
                                    Text(
                                      "₹${vehicle['base_charges'] ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Fixed fare",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 1,
                              height: 48,
                              color: Colors.grey.shade300),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PER KM",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.route_outlined,
                                        size: 14,
                                        color: Colors.orange.shade400),
                                    const SizedBox(width: 4),
                                    Text(
                                      "₹${vehicle['rate_per_km'] ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Per kilometer",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Driver row ──
                    Row(
                      children: [
                        ClipOval(
                          child: driverImageUrl != null &&
                                  driverImageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: driverImageUrl,
                                  width: 46,
                                  height: 46,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      _driverAvatar(),
                                )
                              : _driverAvatar(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driverName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 13, color: Colors.amber),
                                  const SizedBox(width: 3),
                                  Text(
                                    "4.8",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text("·",
                                      style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 14)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      vehicleNumber,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: hasContact
                              ? () => _makePhoneCall(driverContact)
                              : null,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: hasContact
                                  ? Colors.red.shade50
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.phone,
                                size: 20,
                                color: hasContact
                                    ? Colors.red
                                    : Colors.grey.shade400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ── Action buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openNavigation(
                              (vehicle['latitude'] ?? 0.0).toDouble(),
                              (vehicle['longitude'] ?? 0.0).toDouble(),
                            ),
                            icon: const Icon(Icons.navigation_outlined,
                                size: 17),
                            label: const Text("Navigate"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: hasContact
                                ? () => _makePhoneCall(driverContact)
                                : null,
                            icon: const Icon(Icons.call,
                                size: 17, color: Colors.white),
                            label: Text(
                              hasContact ? "Call Driver" : "Unavailable",
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              disabledBackgroundColor: Colors.grey.shade300,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
        ),
      ),
    );
  }

  Widget _vehicleImagePlaceholder() {
    return Container(
      height: 130,
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Icon(Icons.directions_car, size: 60, color: Colors.grey.shade300),
    );
  }

  Widget _driverAvatar() {
    return Container(
      width: 46,
      height: 46,
      color: Colors.red,
      child: const Icon(Icons.person, color: Colors.white, size: 26),
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

  Widget _buildShareButton(Map<String, dynamic> vehicle) {
    return Positioned(
      bottom: 320,
      right: 76,
      child: _buildMapButton(
        onTap: () => _shareVehicleDetails(vehicle),
        icon: Icons.share,
        color: Colors.red,
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

  Future<BitmapDescriptor> _createCustomMarker({
    required IconData icon,
    required Color color,
    double size = 80,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final ui.Canvas canvas = Canvas(pictureRecorder);

    final Paint circlePaint = Paint()..color = Colors.black;

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      circlePaint,
    );

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.5,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color,
      ),
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final img = await pictureRecorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );

    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}