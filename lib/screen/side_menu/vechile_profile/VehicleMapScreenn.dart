import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_grocery_customer/res/AppColor.dart';
import 'package:insta_grocery_customer/res/ImageRes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../controller/vechile_controller.dart';
import '../../../model/vechile_model.dart';
import '../../../webservices/WebServicesHelper.dart';
import './RideDetailScreen.dart';
import './VehicleLocationSearchScreen.dart';

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class VehicleMapScreen extends StatefulWidget {
  /// 1 = Cab, 2 = Ambulance (ids from GET /admin/vehicle-type/).
  /// Categories and nearby vehicles are loaded for this type only.
  final int vehicleTypeId;

  const VehicleMapScreen({super.key, this.vehicleTypeId = 1});

  @override
  State<VehicleMapScreen> createState() => _VehicleMapScreenState();
}

class _VehicleMapScreenState extends State<VehicleMapScreen> {
  late VehicleController
      controller; // Changed to late for better initialization
  GoogleMapController? mapController;
  Rx<Map<String, dynamic>?> selectedVehicle = Rx<Map<String, dynamic>?>(null);
  // Full driver details (with image) fetched from /drivers/{id}, keyed by
  // driver id. The vehicle-nearby API only embeds id/name/contact, so we
  // fetch the complete record once per driver to show the profile photo.
  final RxMap<String, Map<String, dynamic>> _driverDetails =
      <String, Map<String, dynamic>>{}.obs;
  // Null = using device's current location. Set once the customer picks a
  // location from VehicleLocationSearchScreen; shown in the top bar and used
  // to tailor the "no vehicles" message to that place.
  Rx<String?> selectedLocationLabel = Rx<String?>(null);
  // Reverse-geocoded address for the device's current location, shown in the
  // top bar in place of the generic "Nearby Vehicles" label.
  Rx<String?> currentAddress = Rx<String?>(null);
  // Current page of the vehicle image carousel on the bottom sheet
  final RxInt _imageIndex = 0.obs;
  BitmapDescriptor? movingCarIcon;
  BitmapDescriptor? staticCarIcon;
  BitmapDescriptor? selectedCarIcon;
  BitmapDescriptor? onlineCarIcon;
  BitmapDescriptor? offlineCarIcon;

  // Marker drawn at the customer's own pickup/current location.
  //
  // This deliberately does NOT use the selected category's image. Drawing the
  // customer's position as an auto/cab makes it indistinguishable from a real
  // vehicle marker: it gets tapped as one, and because there is no vehicle
  // behind it the tap appears to do nothing. It is a location badge instead,
  // so it is always readable as "you are here" regardless of category.
  BitmapDescriptor? pickupIcon;

  // Nearby-vehicle markers drawn from the SELECTED category's image, tinted by
  // state through a coloured ring (orange = moving, green = standing, red =
  // selected). When the category has a usable image, every vehicle on the map
  // shows that picture instead of the generic car icon. Null when the category
  // has no image / the download failed → markers fall back to the car icons.
  BitmapDescriptor? categoryMovingIcon; // 🟠 moving
  BitmapDescriptor? categoryStandingIcon; // 🟢 standing
  BitmapDescriptor? categorySelectedVehicleIcon; // 🔴 selected
  // The image URL the category vehicle icons were last built from, so we don't
  // re-download and re-render the same picture on every category change.
  String? _categoryVehicleIconUrl;

  // Auto-fit the camera to all vehicles only once per map instance, so live
  // vehicle updates never yank the camera away from the user's own zoom/pan.
  bool _hasAutoFitted = false;

  // True once the map has been shown at least once. From then on it is never
  // removed from the widget tree again — see build() for why.
  bool _mapEverShown = false;

  // Last-resort guard on the loading screen. The controller already bounds the
  // GPS call and always marks the fetch done, but if anything else stalls
  // (a hung platform channel, a plugin that never answers) the customer would
  // be left staring at "Finding nearby vehicles..." with no way out. After
  // this long we show the recovery screen instead, which offers a retry and a
  // manual location picker.
  Timer? _loadingWatchdog;
  bool _loadingTimedOut = false;
  static const Duration _loadingWatchdogDuration = Duration(seconds: 30);

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
      // Reload categories + vehicles if the screen was opened for a
      // different module (Cab vs Ambulance) than last time.
      controller.setVehicleType(widget.vehicleTypeId);
    } else {
      controller = Get.put(
        VehicleController(vehicleTypeId: widget.vehicleTypeId),
        permanent: true,
      );
    }

    _loadCustomIcons();

    // The pickup badge is category-independent, so it is built once here. The
    // nearby-vehicle icons are rebuilt on every category change so each vehicle
    // shows the chosen category's picture (e.g. the auto image for "Passenger
    // Auto").
    _loadPickupIcon();
    _loadCategoryVehicleIcons();
    ever(controller.selectedCategory, (_) {
      // A category switch loads a different set of vehicles, so allow one fresh
      // auto-fit for them. This used to ride on the map being recreated by its
      // ValueKey; the map is reused now, so reset it here instead.
      _hasAutoFitted = false;
      selectedVehicle.value = null;
      _loadCategoryVehicleIcons();
    });

    // ✅ Performance: Debounced rebuild listener
    ever(controller.nearbyVehicles, (_) {
      _debounceMarkersUpdate();
    });

    // Selecting a vehicle changes which marker is drawn red, but the marker set
    // is only rebuilt when the vehicle list changes — so without this the
    // highlight never appeared. Rebuild immediately (no auto-fit, which would
    // fight the camera animation onto the picked vehicle).
    ever(selectedVehicle, (_) {
      if (!mounted) return;
      _cachedMarkers = _buildMarkers();
      setState(() {});
    });

    if (controller.isLocationReady.value) {
      _resolveCurrentAddress();
    }
    ever(controller.isLocationReady, (bool ready) {
      if (ready) _resolveCurrentAddress();
    });

    _startLoadingWatchdog();
  }

  // (Re)arms the loading-screen guard. Called on entry and on every retry, so
  // a retry that also stalls still lands back on the recovery screen.
  void _startLoadingWatchdog() {
    _loadingWatchdog?.cancel();
    _loadingTimedOut = false;
    _loadingWatchdog = Timer(_loadingWatchdogDuration, () {
      if (!mounted || _mapEverShown) return;
      setState(() => _loadingTimedOut = true);
    });
  }

  Future<void> _resolveCurrentAddress() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        controller.latitude.value,
        controller.longitude.value,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [place.locality, place.administrativeArea]
            .where((e) => e != null && e.isNotEmpty)
            .join(", ");
        if (parts.isNotEmpty && mounted) {
          currentAddress.value = parts;
        }
      }
    } catch (e) {
      debugPrint("❌ Reverse geocode error => $e");
    }
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
    // Only auto-fit while the camera hasn't been fitted for this map yet;
    // afterwards live position updates must not move the user's camera.
    if (!_hasAutoFitted) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _fitAllMarkers();
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _loadingWatchdog?.cancel();
    super.dispose();
  }

  void _refreshMapMarkers() {
    if (mapController != null && mounted) {
      setState(() {});
    }
  }

  Future<void> _loadCustomIcons() async {
    try {
      // 🚑 Ambulance module shows a medical icon instead of a car
      final IconData markerIcon = widget.vehicleTypeId == 2
          ? FontAwesomeIcons.truckMedical
          : FontAwesomeIcons.carSide;

      // ✅ ONLINE VEHICLE = ORANGE
      onlineCarIcon = await _createCustomMarker(
        icon: markerIcon,
        color: Colors.orange,
        size: 90,
      );

      // ✅ OFFLINE VEHICLE = GREEN
      offlineCarIcon = await _createCustomMarker(
        icon: markerIcon,
        color: Colors.green,
        size: 90,
      );

      // ✅ SELECTED VEHICLE = RED
      selectedCarIcon = await _createCustomMarker(
        icon: markerIcon,
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

  // Builds the badge shown at the customer's own pickup/current location.
  // Independent of the selected category, so it is built once and reused.
  Future<void> _loadPickupIcon() async {
    if (pickupIcon != null) return;

    final BitmapDescriptor icon = await _createPickupMarker(size: 110);

    if (!mounted) return;
    pickupIcon = icon;
    // Bypass the marker cache so the pickup badge is drawn right away.
    _lastCacheKey = '';
    _cachedMarkers = _buildMarkers();
    setState(() {});
  }

  // Draws the "you are here" badge: a white disc with a blue ring and a
  // location glyph. Kept visually distinct from every vehicle marker on
  // purpose — a car picture at the customer's own position cannot be told
  // apart from a real vehicle, so it gets tapped as one and the tap appears
  // to do nothing because there is no vehicle behind it.
  Future<BitmapDescriptor> _createPickupMarker({double size = 110}) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Offset center = Offset(size / 2, size / 2);

    canvas.drawCircle(center, size / 2, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      size / 2 - size * 0.03,
      Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.06,
    );

    const IconData glyph = Icons.person_pin_circle;
    final TextPainter painter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(glyph.codePoint),
        style: TextStyle(
          fontSize: size * 0.55,
          fontFamily: glyph.fontFamily,
          package: glyph.fontPackage,
          color: Colors.blueAccent,
        ),
      )
      ..layout();

    painter.paint(
      canvas,
      Offset((size - painter.width) / 2, (size - painter.height) / 2),
    );

    final ui.Image image =
        await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  // Builds the nearby-vehicle marker icons from the SELECTED category's image,
  // one tinted variant per state (orange = moving, green = standing, red =
  // selected). Called on init and every time the customer taps a different
  // category chip, so all vehicles on the map show the chosen category's
  // picture (e.g. the auto image for "Passenger Auto"). The image is
  // downloaded once and rendered three times. When the category has no usable
  // image, or the download fails, the icons are cleared so _buildMarkers falls
  // back to the coloured car icons.
  Future<void> _loadCategoryVehicleIcons() async {
    final Category? category = controller.selectedCategory.value;

    // First usable image URL sent by the category API.
    String? imageUrl;
    for (final img in category?.image ?? const <CategoryImage>[]) {
      final path = img.path;
      if (path != null && path.isNotEmpty) {
        imageUrl = path;
        break;
      }
    }

    // Same category image already rendered → nothing to do.
    if (imageUrl == _categoryVehicleIconUrl && categoryStandingIcon != null) {
      return;
    }

    // No category image → clear so markers fall back to the car icons.
    if (imageUrl == null) {
      if (!mounted) return;
      categoryMovingIcon = null;
      categoryStandingIcon = null;
      categorySelectedVehicleIcon = null;
      _categoryVehicleIconUrl = null;
      _lastCacheKey = '';
      _cachedMarkers = _buildMarkers();
      setState(() {});
      return;
    }

    // Download once, render a variant per state.
    final Uint8List? bytes = await _downloadImageBytes(imageUrl);
    final moving = bytes == null
        ? null
        : await _renderImageMarker(bytes, size: 100, ringColor: Colors.orange);
    final standing = bytes == null
        ? null
        : await _renderImageMarker(bytes, size: 100, ringColor: Colors.green);
    final selected = bytes == null
        ? null
        : await _renderImageMarker(bytes, size: 110, ringColor: Colors.red);

    if (!mounted) return;
    categoryMovingIcon = moving;
    categoryStandingIcon = standing;
    categorySelectedVehicleIcon = selected;
    // On success remember the URL; on failure clear it so the next selection
    // retries the download.
    _categoryVehicleIconUrl = standing != null ? imageUrl : null;
    // Bypass the marker cache so the new vehicle icons are drawn right away.
    _lastCacheKey = '';
    _cachedMarkers = _buildMarkers();
    setState(() {});
  }

  // Fetches image bytes with browser-like headers (some hosts reject bare
  // requests with 403) and a timeout so we can fall back instead of hanging.
  Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: const {
          "User-Agent": "Mozilla/5.0 (Android) FrebboApp",
          "Accept": "image/*,*/*",
        },
      ).timeout(const Duration(seconds: 15));

      debugPrint(
          "🖼️ Marker image => $url | status ${response.statusCode} | ${response.bodyBytes.length} bytes");

      if (response.statusCode != 200 || response.bodyBytes.isEmpty) return null;
      return response.bodyBytes;
    } catch (e) {
      debugPrint("❌ Marker image download error => $e");
      return null;
    }
  }

  // Renders already-downloaded image bytes into a circular map marker with a
  // white fill and a coloured ring. Returns null on any decode/render failure.
  Future<BitmapDescriptor?> _renderImageMarker(Uint8List bytes,
      {double size = 130, Color ringColor = Colors.red}) async {
    try {
      final double imgSize = size * 0.70;
      // Decode at native resolution (no forced square target — that could
      // distort or fail on some images); we crop to a square while drawing.
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Offset center = Offset(size / 2, size / 2);

      // White circular badge with a coloured ring.
      canvas.drawCircle(center, size / 2, Paint()..color = Colors.white);
      canvas.drawCircle(
        center,
        size / 2 - size * 0.03,
        Paint()
          ..color = ringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = size * 0.06,
      );

      // Category image clipped to a circle in the centre of the badge.
      final Rect imgRect =
          Rect.fromCenter(center: center, width: imgSize, height: imgSize);
      canvas.save();
      canvas.clipPath(Path()..addOval(imgRect));
      // Center-crop the source to a square (BoxFit.cover) so non-square images
      // aren't stretched.
      final double srcSide = image.width < image.height
          ? image.width.toDouble()
          : image.height.toDouble();
      final Rect srcRect = Rect.fromCenter(
        center: Offset(image.width / 2, image.height / 2),
        width: srcSide,
        height: srcSide,
      );
      canvas.drawImageRect(
        image,
        srcRect,
        imgRect,
        Paint()..filterQuality = FilterQuality.high,
      );
      canvas.restore();

      final ui.Image finalImage =
          await recorder.endRecording().toImage(size.toInt(), size.toInt());
      final data = await finalImage.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return null;

      return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
    } catch (e) {
      debugPrint("❌ Image marker render error => $e");
      return null;
    }
  }

  // ✅ Performance: Cached marker building with cache key
  Set<Marker> _buildMarkers() {
    final vehicles = controller.nearbyVehicles;

    // ✅ Cache check
    final cacheKey = _getCacheKey(vehicles);

    if (cacheKey == _lastCacheKey && _cachedMarkers.isNotEmpty) {
      return _cachedMarkers;
    }

    _lastCacheKey = cacheKey;

    final markers = <Marker>[];

    // 📍 Pickup / current-location marker showing the selected category image.
    // Sits at the customer's location as a "you are here" badge, visually
    // distinct from every vehicle marker so it is never mistaken for one.
    final double pickupLat = controller.latitude.value;
    final double pickupLng = controller.longitude.value;
    if (pickupLat != 0.0 && pickupLng != 0.0 && pickupIcon != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup_location'),
          position: LatLng(pickupLat, pickupLng),
          icon: pickupIcon!,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          // Sit BELOW the vehicle markers: when a vehicle is at/near the
          // customer's location it must stay visible and, crucially, tappable.
          // A higher-zIndex pickup badge would hide the vehicle and swallow its
          // taps (Google Maps delivers a tap to the top-most marker only).
          zIndex: 0,
          // zIndex is not enough on its own: the badge is drawn larger than the
          // vehicle icons, so a tap aimed at a vehicle parked on top of the
          // customer's own location can still land here. Without a handler that
          // tap would simply die and the vehicle card would never open, so
          // forward it to the closest vehicle instead.
          consumeTapEvents: true,
          onTap: () => _selectVehicleNearestOnScreen(pickupLat, pickupLng),
        ),
      );
    }

    for (var vehicle in vehicles) {
      final vehicleId = vehicle['id']?.toString() ?? "";

      if (vehicleId.isEmpty) continue;

      final lat = (vehicle['latitude'] ?? 0.0).toDouble();

      final lng = (vehicle['longitude'] ?? 0.0).toDouble();

      if (lat == 0.0 || lng == 0.0) continue;

      // =========================
      // ✅ MOVING CHECK
      // =========================

      final bool isMoving =
          controller.movingVehicles[int.tryParse(vehicleId) ?? 0] ?? false;

      final isSelected = selectedVehicle.value?['id']?.toString() == vehicleId;

      BitmapDescriptor icon;

      // =========================
      // ✅ ICON LOGIC
      // =========================

      // Prefer the SELECTED category's image (so every vehicle shows e.g. the
      // auto picture for "Passenger Auto"); fall back to the coloured car icon
      // when the category has no image or its download failed.
      if (isSelected) {
        // 🔴 SELECTED
        icon = categorySelectedVehicleIcon ??
            selectedCarIcon ??
            BitmapDescriptor.defaultMarker;
      } else if (isMoving) {
        // 🟠 MOVING = ORANGE
        icon = categoryMovingIcon ??
            onlineCarIcon ??
            BitmapDescriptor.defaultMarker;
      } else {
        // 🟢 STANDING = GREEN
        icon = categoryStandingIcon ??
            offlineCarIcon ??
            BitmapDescriptor.defaultMarker;
      }

      markers.add(
        Marker(
          markerId: MarkerId(vehicleId),
          position: controller.vehiclePositions[int.tryParse(vehicleId) ?? 0] ??
              LatLng(lat, lng),
          icon: icon,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          alpha: 1.0,
          // Keep vehicles above the pickup badge (zIndex 1) so overlapping
          // vehicles stay visible and clickable; the selected one sits highest.
          zIndex: isSelected ? 3 : 2,
          // Handle the tap ourselves instead of letting Google Maps run its
          // default marker behaviour (info window + camera recentre), which
          // otherwise competes with the card animation.
          consumeTapEvents: true,
          onTap: () => _selectVehicle(vehicle),
        ),
      );
    }

    return markers.toSet();
  }

  // Opens the vehicle card for [vehicle] and centres the map on it. Single
  // entry point for every way a vehicle can be picked (marker tap, pickup-badge
  // tap) so the card, the driver fetch and the red marker stay in sync.
  void _selectVehicle(Map<String, dynamic> vehicle) {
    final lat = (vehicle['latitude'] ?? 0.0).toDouble();
    final lng = (vehicle['longitude'] ?? 0.0).toDouble();

    _imageIndex.value = 0;
    selectedVehicle.value = vehicle;
    _fetchDriverDetail(vehicle);

    if (lat != 0.0 && lng != 0.0) {
      _animateToVehicle(lat, lng);
    }
  }

  // Picks the vehicle hidden underneath the customer's pickup badge — a tap
  // that lands on the badge almost always means the vehicle drawn beneath it.
  //
  // The test has to be in SCREEN space, not geographic distance: the badge is a
  // fixed-size bitmap, so how much map it covers depends entirely on the zoom.
  // Zoomed out to a whole district it hides vehicles that are kilometres away,
  // which a metre-based radius rejects — the tap then did nothing at all.
  Future<void> _selectVehicleNearestOnScreen(double lat, double lng) async {
    final GoogleMapController? map = mapController;

    if (map != null) {
      try {
        // Screen coordinates come back in device pixels, the same units the
        // marker bitmaps are sized in (badge 110px → 55px radius), so the two
        // are directly comparable without any devicePixelRatio conversion.
        final ScreenCoordinate origin =
            await map.getScreenCoordinate(LatLng(lat, lng));

        Map<String, dynamic>? nearest;
        double nearestPx = double.infinity;

        for (final vehicle in controller.nearbyVehicles) {
          if (vehicle is! Map) continue;
          final vLat = (vehicle['latitude'] ?? 0.0).toDouble();
          final vLng = (vehicle['longitude'] ?? 0.0).toDouble();
          if (vLat == 0.0 || vLng == 0.0) continue;

          final ScreenCoordinate sc =
              await map.getScreenCoordinate(LatLng(vLat, vLng));
          final double dx = (sc.x - origin.x).toDouble();
          final double dy = (sc.y - origin.y).toDouble();
          final double px = math.sqrt(dx * dx + dy * dy);

          if (px < nearestPx) {
            nearestPx = px;
            nearest = Map<String, dynamic>.from(vehicle);
          }
        }

        // Within the badge's own radius (55px) plus a little slack → it was
        // covering that vehicle, so the tap was meant for it.
        if (nearest != null && nearestPx <= 65) {
          _selectVehicle(nearest);
          return;
        }
      } catch (e) {
        debugPrint("❌ Pickup tap hit-test error => $e");
      }
    }

    // Nothing was hidden under the badge: behave like a plain tap on the map.
    selectedVehicle.value = null;
  }

  // ✅ Performance: Quick cache key generation
  String _getCacheKey(List<dynamic> vehicles) {
    final buffer = StringBuffer();
    buffer.write(controller.vehicleTypeId.value);
    buffer.write('|');
    buffer.write(selectedVehicle.value?['id'] ?? 'none');
    buffer.write('|');
    buffer.write(controller.selectedCategory.value?.id ?? 'all');
    buffer.write('|');
    // The pickup badge is part of the marker set, so its position has to be
    // part of the key — otherwise picking a new location left the old badge on
    // the map (and its tap handler pointing at the old spot).
    buffer.write('${controller.latitude.value}:${controller.longitude.value}');
    for (var vehicle in vehicles.take(20)) {
      buffer.write(
          '${vehicle['id']}:${vehicle['latitude']}:${vehicle['longitude']}|');
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
    final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
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
      body: Obx(() {
        final bool ready = controller.hasInitialFetchDone.value &&
            controller.isLocationReady.value;
        // Latch: once the map has been built it stays in the tree for good.
        // Dropping it out of the Stack destroys the underlying platform view,
        // which silently kills mapController and every marker tap handler —
        // that is why vehicles stopped responding after the my-location button
        // (getCurrentLocation flips isLocationReady false) or a type switch.
        // Later loading states are drawn as an overlay on top instead.
        if (ready) {
          _mapEverShown = true;
          _loadingWatchdog?.cancel();
        }

        // Either the controller told us why it couldn't locate the customer,
        // or nothing resolved at all within the watchdog window. Both mean the
        // spinner is going nowhere, so show the recovery screen.
        final bool locationFailed = !_mapEverShown &&
            (controller.locationError.value != null || _loadingTimedOut);

        return Stack(
          children: [
            if (_mapEverShown) _buildMap(),
            if (!_mapEverShown && locationFailed) _buildLocationErrorState(),
            if (!_mapEverShown && !locationFailed) _buildLoadingState(),
            if (ready && controller.nearbyVehicles.isEmpty) _buildEmptyState(),
            _buildTopBar(),
            _buildSubCategoryFilter(),
            _buildCategoryFilter(),
            if (selectedVehicle.value != null)
              _buildBottomSheet(selectedVehicle.value!),
          ],
        );
      }),
    );
  }

  Widget _buildMap() {
    LatLng initialPosition;

    if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
      initialPosition =
          LatLng(controller.latitude.value, controller.longitude.value);
    } else {
      initialPosition = const LatLng(28.6139, 77.2090);
    }

    return GoogleMap(
      // No ValueKey here on purpose. Keying the map by category tore down and
      // recreated the whole platform view on every category tap, which left the
      // marker set bound to the destroyed map — the markers were still painted
      // but no longer delivered taps, so the vehicle card refused to open.
      // The map is reused now and only its markers change.
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      markers: _cachedMarkers, // ✅ Using cached markers for better performance
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      onMapCreated: (c) {
        mapController = c;
        // A new map instance is created when the category changes (ValueKey),
        // so allow one fresh auto-fit for it.
        _hasAutoFitted = false;
        Future.delayed(const Duration(milliseconds: 300), () {
          _fitAllMarkers();
        });
      },
      onTap: (LatLng position) {
        selectedVehicle.value = null;
      },
    );
  }

  // Subcategory chips, shown in a row just below the location bar at the TOP of
  // the screen once a category is picked (the category chips stay at the
  // bottom). Tapping one narrows the nearby vehicles to that subcategory (the
  // controller adds subcategory_id to the fetch); the leading "All" chip — and
  // re-tapping the active chip — clears the filter so every vehicle in the
  // category shows again. Hidden entirely while no category is selected or the
  // selected category has no subcategories.
  Widget _buildSubCategoryFilter() {
    // Subcategory filtering is a Cab-only feature (vehicleTypeId 1). The
    // Ambulance module (2) has no subcategory row, so bail out with no space.
    if (widget.vehicleTypeId != 1) return const SizedBox.shrink();

    // Sit below the top location bar (SafeArea + 16 padding + ~56 bar height)
    // rather than a fixed offset that floats into the notch on some devices.
    final double topInset = MediaQuery.viewPaddingOf(context).top;

    return Positioned(
      top: topInset + 84,
      left: 0,
      right: 0,
      child: Obx(() {
        final subs = controller.subCategoryList;
        // Nothing to filter by → take up no space.
        if (controller.selectedCategory.value == null || subs.isEmpty) {
          return const SizedBox.shrink();
        }

        final bool isAllSelected = controller.selectedSubCategory.value == null;

        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            // +1 for the leading "All" chip.
            itemCount: subs.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSubCategoryChip(
                  label: "All",
                  isSelected: isAllSelected,
                  onTap: () => controller.onSubCategorySelected(null),
                );
              }
              final sub = subs[index - 1];
              final isSelected =
                  controller.selectedSubCategory.value?.id == sub.id;
              return _buildSubCategoryChip(
                label: sub.name,
                isSelected: isSelected,
                onTap: () => controller.onSubCategorySelected(sub),
              );
            },
          ),
        );
      }),
    );
  }

  // A single subcategory pill. Kept visually distinct from the category chips
  // (solid red when active vs. the category chips' red outline) so the two
  // filter rows don't read as the same control.
  Widget _buildSubCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    // Sit above the gesture bar / nav bar rather than a fixed offset that
    // floats too high on some devices and clips on others.
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    // Grow the chips with the user's font scale so two-line names never clip.
    final double textScale =
        MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.4);

    return Positioned(
      bottom: 84 + bottomInset,
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
          height: 104 * textScale,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categoryList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = controller.categoryList[index];

              final isSelected =
                  controller.selectedCategory.value?.id == category.id;

              return GestureDetector(
                onTap: () async {
                  await controller.onCategorySelected(category);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 90,
                    maxWidth: 130,
                  ),
                  decoration: BoxDecoration(
                    // Selected chip keeps a white fill and is highlighted with
                    // a red outline instead of a solid red background.
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Category image from the API; icon only as fallback
                      _buildCategoryImage(category, isSelected),

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
                            color: isSelected ? Colors.red : Colors.black87,
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

  // Category chip visual: the image sent by the category API when there is
  // one, otherwise the old hardcoded icon as fallback.
  Widget _buildCategoryImage(Category category, bool isSelected) {
    String? imageUrl;
    for (final img in category.image ?? const <CategoryImage>[]) {
      final path = img.path;
      if (path != null && path.isNotEmpty) {
        imageUrl = path;
        break;
      }
    }

    final Widget fallbackIcon = Icon(
      _getCategoryIcon(category.name),
      size: 24,
      color: isSelected ? Colors.red : Colors.black87,
    );

    if (imageUrl == null) return fallbackIcon;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 46,
        height: 46,
        fit: BoxFit.cover,
        placeholder: (_, __) => fallbackIcon,
        errorWidget: (_, __, ___) => fallbackIcon,
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('ambulance') || name.contains('icu')) {
      return Icons.local_hospital;
    }
    switch (name) {
      case 'cabs':
        return Icons.local_taxi;
      case 'auto':
        return Icons.electric_rickshaw;
      case 'vans':
        return Icons.local_shipping;
      default:
        return widget.vehicleTypeId == 2
            ? Icons.local_hospital
            : Icons.directions_car;
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

  // Shown instead of the endless spinner when we couldn't locate the customer
  // — location services off, permission denied/denied forever, or no fix
  // arrived in time. Gives a real way out (enable/grant, open settings, retry,
  // or pick the pickup point by hand) instead of staring at "Finding nearby
  // vehicles..." forever.
  Widget _buildLocationErrorState() {
    // No reason from the controller means the watchdog fired: something
    // upstream never answered, which reads to the customer as a timeout.
    final String reason = controller.locationError.value ?? 'timeout';

    final bool deniedForever = reason == 'permission_denied_forever';
    final bool timedOut = reason == 'timeout' || reason == 'unknown';
    final String title = reason == 'service_disabled'
        ? "Location is turned off"
        : timedOut
            ? "Couldn't get your location"
            : "Location permission needed";
    final String message = reason == 'service_disabled'
        ? "Please turn on location services to find vehicles near you."
        : deniedForever
            ? "Location permission was denied. Please enable it from app settings to find vehicles near you."
            : timedOut
                ? "We couldn't find where you are. Check that GPS is on and try again, or set your pickup location manually."
                : "Please allow location access to find vehicles near you.";

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
                  Icons.location_off_outlined,
                  size: 64,
                  color: Colors.red.shade300,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  // Back to the loading screen, watchdog re-armed — a retry
                  // that stalls too must land here again rather than hang.
                  setState(_startLoadingWatchdog);

                  if (deniedForever) {
                    await Geolocator.openAppSettings();
                  } else if (reason == 'service_disabled') {
                    await Geolocator.openLocationSettings();
                  }
                  await controller.retryInitialLoad();
                },
                icon: Icon(
                  timedOut ? Icons.refresh : Icons.my_location,
                  color: Colors.white,
                ),
                label: Text(
                  deniedForever || reason == 'service_disabled'
                      ? "Open Settings"
                      : timedOut
                          ? "Try Again"
                          : "Allow Location",
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Always available: the customer may simply not want to share
              // their location, or GPS may never come back. Picking a place by
              // hand is a complete substitute — updateLocation() clears the
              // error and unblocks the map exactly like a real fix.
              TextButton.icon(
                onPressed: _onSelectLocationTap,
                icon: const Icon(Icons.search, color: Colors.black54, size: 20),
                label: const Text(
                  "Set location manually",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fitAllMarkers() async {
    if (mapController == null) return;
    if (_hasAutoFitted) return;
    if (controller.nearbyVehicles.isEmpty) return;

    _hasAutoFitted = true;

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
    final String vehicleWord =
        widget.vehicleTypeId == 2 ? "ambulances" : "cabs";

    if (locationLabel != null) {
      return categoryName != null
          ? "No $categoryName available near \"$locationLabel\".\nPlease choose another category."
          : "No $vehicleWord available near \"$locationLabel\"";
    }

    return categoryName != null
        ? "No $categoryName available in your area.\nPlease choose another category."
        : "No $vehicleWord found in your area right now";
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
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: const Text(
                "Try Again",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      const Icon(Icons.location_on,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(() {
                          // Always shows the picked/current location, no
                          // matter which ride category is selected below —
                          // the category name only lives in the chip row.
                          final locationLabel = selectedLocationLabel.value;
                          final address = currentAddress.value;

                          final String smallLabel = locationLabel != null
                              ? "Pickup Location"
                              : "Your Location";
                          final String value =
                              locationLabel ?? address ?? "Nearby Vehicles";

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                smallLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }),
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
                if (controller.latitude.value != 0.0 &&
                    controller.locationError.value == null) {
                  selectedLocationLabel.value = null;
                  currentAddress.value = null;
                  _resolveCurrentAddress();
                  mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(controller.latitude.value,
                            controller.longitude.value),
                        zoom: 15,
                      ),
                    ),
                  );
                  await controller.forceRefresh();
                } else {
                  // The map is already on screen here, so there is no error
                  // state to fall back to — say it out loud instead of letting
                  // the button look like it did nothing.
                  Get.snackbar(
                    "Location unavailable",
                    "Couldn't get your current location. Tap the search bar to set it manually.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
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

  // The API returns image/photo sometimes as a single map
  // ({"path": ...}), sometimes as a list of files — read the path safely
  // from any shape instead of crashing with "String is not a subtype of int".
  String? _filePathOf(dynamic file) {
    if (file is Map) return file['path']?.toString();
    if (file is List && file.isNotEmpty && file.first is Map) {
      return (file.first as Map)['path']?.toString();
    }
    if (file is String && file.isNotEmpty) return file;
    return null;
  }

  // All image paths of a vehicle — the API sends "image" as a list of
  // files; also tolerates a single map or a plain URL string.
  List<String> _filePathsOf(dynamic file) {
    if (file is List) {
      return file
          .whereType<Map>()
          .map((m) => m['path']?.toString())
          .whereType<String>()
          .where((p) => p.isNotEmpty)
          .toList();
    }
    final single = _filePathOf(file);
    return single != null ? [single] : [];
  }

  // Business / company the vehicle runs under. The API spells this
  // differently across endpoints and sometimes nests it in an expanded object
  // (or hangs it off the driver), so every known shape is tried.
  //
  // Returns null when the vehicle genuinely has no business name — the card
  // then shows its own "not provided" placeholder, so blank/whitespace/"null"
  // values from the API can never reach the UI as an empty-looking line.
  String? _businessNameOf(Map<String, dynamic> vehicle) {
    final Map driver = vehicle['driver'] is Map ? vehicle['driver'] as Map : {};

    String? nameOf(dynamic value) {
      if (value is Map) return value['name']?.toString();
      if (value is String) return value;
      return null;
    }

    final List<String?> candidates = [
      vehicle['business_name']?.toString(),
      vehicle['company_name']?.toString(),
      vehicle['firm_name']?.toString(),
      nameOf(vehicle['business']),
      nameOf(vehicle['company']),
      nameOf(vehicle['vendor']),
      driver['business_name']?.toString(),
      driver['company_name']?.toString(),
      nameOf(driver['business']),
    ];

    for (final candidate in candidates) {
      final String value = (candidate ?? '').trim();
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }

    return null;
  }

  // Distance shown on the vehicle card → "850 m away" / "12.4 km away".
  // Uses "distance_km" from the API (number or string); when the API
  // doesn't send it, falls back to computing it from the customer's
  // location so the distance always shows for both cabs and ambulances.
  String? _distanceTextFor(Map<String, dynamic> vehicle) {
    final dynamic raw = vehicle['distance_km'];

    double? km;
    if (raw is num) {
      km = raw.toDouble();
    } else if (raw is String) {
      km = double.tryParse(raw);
    }

    if (km == null || km <= 0) {
      final double lat = (vehicle['latitude'] ?? 0.0).toDouble();
      final double lng = (vehicle['longitude'] ?? 0.0).toDouble();
      if (lat != 0.0 &&
          lng != 0.0 &&
          controller.latitude.value != 0.0 &&
          controller.longitude.value != 0.0) {
        km = Geolocator.distanceBetween(
              controller.latitude.value,
              controller.longitude.value,
              lat,
              lng,
            ) /
            1000;
      }
    }

    if (km == null || km <= 0) return null;
    if (km < 1) return "${(km * 1000).round()} m away";
    return "${km.toStringAsFixed(1)} km away";
  }

  // Fetch the selected driver's full profile (with image) by id and cache it
  // so the bottom sheet — which lives inside an Obx — rebuilds with the photo.
  Future<void> _fetchDriverDetail(Map<String, dynamic> vehicle) async {
    final driver = vehicle['driver'];
    if (driver is! Map) return;

    final dynamic id = driver['id'];
    if (id == null || id == 0) return;

    final String key = id.toString();
    if (_driverDetails.containsKey(key)) return; // already fetched

    final res = await WebServicesHelper().getDriverById(key);
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
      _driverDetails[key] = detail;
    }
  }

  Widget _buildBottomSheet(Map<String, dynamic> vehicle) {
    final embeddedDriver =
        vehicle['driver'] is Map ? vehicle['driver'] as Map : {};
    // Overlay the fetched full detail (image, license, etc.) over the embedded
    // driver from the vehicle payload.
    final String driverKey = (embeddedDriver['id'] ?? '').toString();
    final driver = <String, dynamic>{
      ...embeddedDriver.cast<String, dynamic>(),
      ...?_driverDetails[driverKey],
    };
    final driverName = driver['name'] ?? 'Driver';
    final String driverContact = (driver['contact_number'] ?? '').toString();
    final vehicleNumber = vehicle['vehicle_number'] ?? 'Not available';
    final hasContact = driverContact.isNotEmpty && driverContact.length >= 10;
    final List<String> vehicleImages = _filePathsOf(vehicle['image']);
    final driverImageUrl = _filePathOf(driver['photo'] ?? driver['image']);
    final bool isActive =
        vehicle['is_active'] == true || vehicle['is_active'] == 1;
    final String? distanceText = _distanceTextFor(vehicle);
    // Null for the usual case of an individual driver with no business.
    final String? businessName = _businessNameOf(vehicle);

    final Size screen = MediaQuery.sizeOf(context);
    // The card must never eat the whole map: cap it at ~68% of the screen on
    // phones and let the content scroll inside instead of overflowing.
    final double maxSheetHeight = screen.height * 0.68;
    // Tablet/landscape: cap the width so the card stays readable instead of
    // stretching edge to edge; on phones it still spans the full width.
    final double sheetWidth = screen.width > 600 ? 460 : screen.width;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Share/close ride above the card so they follow its real height
            // instead of a hardcoded offset that breaks on short screens.
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildShareButton(vehicle),
                  const SizedBox(width: 12),
                  _buildCloseButton(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(
                  () => RideDetailsScreen(vehicle: selectedVehicle.value)),
              child: Container(
                width: sheetWidth,
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
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
                  child: SingleChildScrollView(
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

                        // ── Vehicle model (make & model) + ACTIVE badge ──
                        // The model doubles as the vehicle's company/brand, so
                        // it stays the card title; the business name sits under
                        // it as the operator line.
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
                                color: isActive
                                    ? Colors.green.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.green.shade300
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                isActive ? "ACTIVE" : "INACTIVE",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.green.shade700
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // ── Business / company name. Shown on EVERY vehicle:
                        // when there is no name the card says so outright
                        // instead of leaving a gap, so "this driver has no
                        // business behind them" can't be mistaken for a row
                        // that failed to load. Sits under the vehicle title
                        // so it reads as "who operates this".
                        Row(
                          children: [
                            Icon(Icons.storefront_outlined,
                                size: 16, color: Colors.grey.shade500),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                businessName ?? "Business name not provided",
                                style: TextStyle(
                                  fontSize: 20,
                                  // The placeholder is deliberately lighter and
                                  // less bold than a real name, so it never
                                  // reads as the business actually being called
                                  // that.
                                  fontWeight: businessName != null
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: businessName != null
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // ── Availability status ──
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isActive ? "Available now" : "Unavailable",
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            // ── Distance from customer (from "distance_km") ──
                            if (distanceText != null) ...[
                              const SizedBox(width: 6),
                              Text("·",
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14)),
                              const SizedBox(width: 6),
                              Icon(Icons.near_me,
                                  size: 12, color: Colors.red.shade400),
                              const SizedBox(width: 3),
                              Text(
                                distanceText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── Vehicle images (carousel when multiple) ──
                        _buildVehicleImageCarousel(
                            vehicleImages, vehicle['id']),
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
          ],
        ),
      ),
    );
  }

  // Image section of the vehicle card: placeholder when there are no
  // images, plain image for one, swipeable carousel with dots for many.
  // Works the same for commercial vehicles and ambulances.
  Widget _buildVehicleImageCarousel(List<String> images, dynamic vehicleId) {
    final double imageHeight = _cardImageHeight();

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
        borderRadius: BorderRadius.circular(14),
        child: _vehicleImagePlaceholder(),
      );
    }

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: networkImage(images.first),
      );
    }

    return Column(
      children: [
        CarouselSlider(
          // New carousel per vehicle so it always starts at the first image
          key: ValueKey('vehicle_images_$vehicleId'),
          options: CarouselOptions(
            height: imageHeight,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, _) => _imageIndex.value = index,
          ),
          items: images
              .map((url) => ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: double.infinity,
                      child: networkImage(url),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // ── Dots indicator ──
        Obx(() {
          final current = _imageIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) {
              final bool isCurrent = i == current;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isCurrent ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.red : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  // Vehicle photo height scales with the screen so the card stays balanced
  // on small phones and tall devices alike. The card is capped at 68% of the
  // screen and scrolls internally, so a taller photo can't push the buttons
  // off — but keep the bump modest: this sits over the map and the driver row
  // and action buttons below it still need to be reachable without scrolling.
  double _cardImageHeight() =>
      (MediaQuery.sizeOf(context).height * 0.20).clamp(132.0, 195.0);

  Widget _vehicleImagePlaceholder() {
    return Container(
      height: _cardImageHeight(),
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
    return _buildMapButton(
      onTap: () => selectedVehicle.value = null,
      icon: Icons.close,
      color: Colors.black87,
    );
  }

  Widget _buildShareButton(Map<String, dynamic> vehicle) {
    return _buildMapButton(
      onTap: () => _shareVehicleDetails(vehicle),
      icon: Icons.share,
      color: Colors.red,
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
