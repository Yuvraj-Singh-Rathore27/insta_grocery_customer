import 'dart:async';
import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../../controller/vender_controller.dart';
import '../../../toolbar/TopBar.dart';
class VenderMapDirection extends StatefulWidget {
  double latitude;
  double longitude;

  VenderMapDirection({Key? key, required this.latitude,required this.longitude}) : super(key: key);

  @override
  State<VenderMapDirection> createState() => _PharacyMapDirectionState( this.latitude, this.longitude);
}

class _PharacyMapDirectionState extends State<VenderMapDirection> {
  late double latitude;
  late double longitude;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  PharmacyController controller = Get.put(PharmacyController());
  Set<Polygon> _polygon = HashSet<Polygon>();
  Set<Polyline> _polylines = {};


  _PharacyMapDirectionState(double latitude,double longitude) {
    this.latitude = latitude;
    this.longitude = longitude;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBar(
          title: "Google Map Direction",
          menuicon: false,
          menuback: true,
          iconnotifiction: true,
          is_wallaticon: true,
          is_supporticon: false,
          is_whatsappicon: false,
          onPressed: () => {},
          onTitleTapped: () => {}),
      body: GoogleMap(
        onCameraMove: (CameraPosition position) {
          print("Latitude: ${position.target.latitude}; Longitude: ${position.target.longitude}");
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target:
          LatLng(latitude, longitude),
          zoom: 14.4746,
        ),
        compassEnabled: true,
        polygons: _polygon,
        polylines: _polylines,

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },


      ),

    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determinePosition();

    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    if (position != null) {
      print("latitude====> ${position.latitude}");
      print("longitude====> ${position.longitude}");
      // Generate 20 points in a zigzag pattern
      double distanceKm = 0.5;

        controller.getRoute(position.latitude,position.longitude,
            double.parse(latitude.toString()),double.parse(longitude.toString())).then((value) =>
        // print("value==>${value}"),
        drawPolyline(value)
        );

      final GoogleMapController controller1 = await _controller.future;
      await controller1.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(controller.lat.value, controller.lng.value), 14));
    }
    return position;
  }

  Future<void> drawPolyline( List<LatLng> points) async {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: points, // Use your path points here
          color: Colors.red,
          width: 5,
        ),
      );
    });
  }





}
