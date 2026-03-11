import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_grocery_customer/controller/address_controller.dart';

import 'package:get/get.dart';

import '../../controller/vender_controller.dart';
import 'item/location_list_tile.dart';

class ClientLocationSetOnMap extends StatefulWidget {
  final String type;
  ClientLocationSetOnMap({Key? key, required this.type}) : super(key: key);

  @override
  State<ClientLocationSetOnMap> createState() => _SearchLocationFinderState(type);
}

class _SearchLocationFinderState extends State<ClientLocationSetOnMap> {
  AddressController controller = Get.find<AddressController>();
  PharmacyController pharmacyController = Get.put(PharmacyController());
  var type="";
  _SearchLocationFinderState(this.type);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Search Location'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
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
                contentPadding: const EdgeInsets.only(
                    left: 14.0, bottom: 12.0, top: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Obx(() => Expanded(
            child:  ListView.builder(
                itemCount: controller.predictions.length,
                itemBuilder: (context, index) {
                  var item = controller.predictions[index];
                  return LocationListTile(
                    location: item.description!,
                    press: () {
                      if(type=="pickup"){
                        controller.pickupLocation.value=item;
                        print(item);
                        controller.getPlaceDetails2(controller.pickupLocation.value.placeId,"pickup",pharmacyController);

                      }

                      Get.back();
                      // SnackBarUtils.showSnackBar(msg: item.description!);
                    },
                  );
                }) ,
          ) )

        ],
      ),
    );
  }
}
