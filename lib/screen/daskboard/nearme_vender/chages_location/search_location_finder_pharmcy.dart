import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../../../controller/vender_controller.dart';
import '../../../../res/AppColor.dart';
import '../../../../res/AppDimens.dart';
import '../../../../res/ImageRes.dart';
import '../../../address_managment/item/location_list_tile.dart';

class SearchLocationPharmcyFinder extends StatefulWidget {
  final String type;
  SearchLocationPharmcyFinder({Key? key, required this.type}) : super(key: key);

  @override
  State<SearchLocationPharmcyFinder> createState() =>
      _SearchLocationFinderState(type);
}

class _SearchLocationFinderState extends State<SearchLocationPharmcyFinder> {
  PharmacyController controller = Get.find<PharmacyController>();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LatLng initialLocation = const LatLng(37.422131, -122.084801);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  var type = "";
  _SearchLocationFinderState(this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Location'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(() => GoogleMap(
            onCameraMove: (CameraPosition position) {
              controller.lat.value = position.target.latitude;
              controller.lng.value = position.target.longitude;
              controller.getAddressFromLatLng( controller.lat.value,controller.lng.value);
              print("Latitude: ${position.target.latitude}; Longitude: ${position.target.longitude}");
            },
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target:
              LatLng(controller.lat.value, controller.lng.value),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },

          )),
          Obx(() =>     Container(
            height: 250,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: controller.searchInputController,
                    onChanged: (value) {
                      controller.searchCity.value = value;
                      controller.placeAutoComplete();
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.5),
                      hintText: "Search your location",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: Icon(Icons.location_searching),
                      ),
                      suffixIcon: Visibility(
                        visible: controller.searchCity.value.isNotEmpty,
                        maintainAnimation: true,
                        maintainState: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: IconButton(
                            onPressed: () {
                              controller.placeController.clear();
                              controller.predictions.clear();
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Obx(() =>Container(
                  child:  Expanded(
                    child: ListView.builder(
                        itemCount: controller.predictions.length,
                        itemBuilder: (context, index) {
                          var item = controller.predictions[index];
                          return LocationListTile(
                            location: item.description!,
                            press: () {
                              if (type == "pickup") {
                                controller.pickupLocation.value = item;
                                controller.getPlaceDetails(
                                    controller.pickupLocation.value.placeId,
                                    "pickup");
                              }

                              Get.back();
                              // SnackBarUtils.showSnackBar(msg: item.description!);
                            },
                          );
                        }),
                  ),
                )),
              ],
            ),
          )),

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                ImageRes().pinMarker, // Replace with your image path
                width: 50, // Adjust width as needed
                height: 60, // Adjust height as needed
                fit: BoxFit.cover, // Adjust fit as needed
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: ()=>{
                  Get.back(),
                },
                child:Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(

                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: AppColor().whiteColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                    Obx(() => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: AppColor().whiteColor,
                        ),
                        child: Center(
                          child: Text(
                            controller.addresssValue.value == ""
                                ? ""
                                : controller.addresssValue.value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDimens().front_regular,
                                color: AppColor().blackColor),
                          ),
                        )

                    ),),
                          SizedBox(height: 10,),

                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                color: AppColor().red,
                              ),
                              child: Center(
                                child: Text(
                                  'Confirm Location',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: AppColor().whiteColor),
                                ),
                              )

                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  )
                )
              )),

        ],
      ),
    );
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), ImageRes().pinMarker)
        .then(
          (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }
  @override
  void initState() {
    // addCustomIcon();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determinePosition();
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
    Position position=await Geolocator.getCurrentPosition();

    print("position1==> ${position?.latitude ?? 0.0}");
    if (position != null) {
      controller.lat.value = position!.latitude;
      controller.lng.value = position!.longitude;
      final GoogleMapController controller1 = await _controller.future;
      await controller1.animateCamera(CameraUpdate.newLatLngZoom(LatLng(controller.lat.value, controller.lng.value), 14));

      controller.getAddressFromLatLng( controller.lat.value,controller.lng.value);

      // goToCurrentLocation(lat.value,lng.value);
    } else {
      // Handle the case where the position is null
      controller.lat.value = 0.0;
      controller.lng.value = 0.0;
    }
    return await Geolocator.getCurrentPosition();
  }

}
