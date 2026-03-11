import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapLocationPickerScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapLocationPickerScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState
    extends State<MapLocationPickerScreen> {

  LatLng? _currentLatLng;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    /// 🔥 IMPORTANT: If lat/lng is 0, use default India location
    if (widget.latitude == 0 || widget.longitude == 0) {
      _currentLatLng = const LatLng(28.6139, 77.2090); // Delhi
    } else {
      _currentLatLng =
          LatLng(widget.latitude, widget.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLatLng == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: Stack(
        children: [

          /// MAP (Same pattern as NearbyOfferMapScreen)
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _currentLatLng!,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              _currentLatLng = position.target;
            },
          ),

          /// Center Marker
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 40,
              color: Colors.red,
            ),
          ),

          /// Confirm Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {

                final placemarks =
                    await placemarkFromCoordinates(
                  _currentLatLng!.latitude,
                  _currentLatLng!.longitude,
                );

                if (placemarks.isNotEmpty) {
                  final place = placemarks.first;

                  Get.back(result: {
                    "city": place.locality ?? '',
                    "state": place.administrativeArea ?? '',
                    "country": place.country ?? '',
                    "latitude": _currentLatLng!.latitude,
                    "longitude": _currentLatLng!.longitude,
                  });
                }
              },
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}