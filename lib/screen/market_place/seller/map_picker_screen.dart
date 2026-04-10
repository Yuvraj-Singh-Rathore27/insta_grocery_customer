import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../../../controller/mp_add_product_controller.dart';
import '../../../model/common_model.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final controller = Get.find<MpAddProductController>();

  LatLng? selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(26.9124, 75.7873), // Jaipur default
              zoom: 14,
            ),
            onTap: (LatLng position) async {
              selectedPosition = position;

              // 🔥 SAVE LAT LNG
              controller.latitudeController.text =
                  position.latitude.toString();
              controller.longitudeController.text =
                  position.longitude.toString();

              // 🔥 GET CITY + STATE
              List<Placemark> placemarks =
                  await placemarkFromCoordinates(
                      position.latitude, position.longitude);

              if (placemarks.isNotEmpty) {
                Placemark place = placemarks.first;

                String city =
                    place.locality ?? place.subAdministrativeArea ?? "";
                String state = place.administrativeArea ?? "";

                controller.selectedCity.value = CommonModel(name: city);
                controller.selectedState.value = CommonModel(name: state);

                controller.cityNameController.text = city;
                controller.stateNameController.text = state;
              }

              controller.update();

              // ✅ CLOSE MAP
              Get.back();
            },

            markers: selectedPosition != null
                ? {
                    Marker(
                      markerId: MarkerId("selected"),
                      position: selectedPosition!,
                    )
                  }
                : {},
          ),

          // 📍 CURRENT LOCATION BUTTON
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                await controller.fetchCurrentLocation();
                Get.back();
              },
              child: Icon(Icons.my_location),
            ),
          )
        ],
      ),
    );
  }
}