import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../../controller/vender_controller.dart';

class VenderListingGoogleMap extends StatefulWidget {
  VenderListingGoogleMap({Key? key}) : super(key: key);

  @override
  State<VenderListingGoogleMap> createState() =>
      _PhamrcyListingGoogleMapState();
}

class _PhamrcyListingGoogleMapState extends State<VenderListingGoogleMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  PharmacyController pharmacyController = Get.find<PharmacyController>();
  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  Set<Polygon> _polygon = HashSet<Polygon>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Listing'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(() => GoogleMap(
                onCameraMove: (CameraPosition position) {},
                markers: pharmacyController.markers.values.toSet(),
                mapType: MapType.normal,
                // on below line we have enabled location
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(pharmacyController.lat.value,
                      pharmacyController.lng.value),
                  // initialLocation,
                  zoom: 14.4746,
                ),
                compassEnabled: true,
                // on below line we have added polygon
                polygons: _polygon,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ))
        ],
      ),

    );
  }

  @override
  void initState() {
    // addCustomIcon();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determinePosition();
      // drawPolyGone();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();

    print("position==> ${position?.latitude ?? 0.0}");
    if (position != null) {
      // controller.startLat.value = position!.latitude;
      // controller.startEnd.value = position!.longitude;
      // final GoogleMapController controller1 = await _controller.future;
      // await controller1.animateCamera(CameraUpdate.newLatLngZoom(LatLng(controller.startLat.value, controller.startEnd.value), 14));

      // controller.getAddressFromLatLng( controller.lat.value,controller.lng.value);

      // goToCurrentLocation(lat.value,lng.value);
    } else {
      // Handle the case where the position is null
      // controller.startLat.value = 0.0;
      // controller.startEnd.value = 0.0;
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> drawPolyGone() async {
    _polygon.add(Polygon(
      // given polygonId
      polygonId: PolygonId('1'),
      // initialize the list of points to display polygon
      points: pharmacyController.points.value,
      // given color to polygon
      fillColor: Colors.green.withOpacity(0.3),
      // given border color to polygon
      strokeColor: Colors.green,
      geodesic: true,
      // given width of border
      strokeWidth: 4,
    ));
  }
}
