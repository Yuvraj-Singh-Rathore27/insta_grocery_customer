import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../model/autoComplete_prediction.dart';
import '../../../model/place_auto_complete_response.dart';
import '../../../model/responsemodel/place_details_response.dart';
import '../../../webservices/ApiUrl.dart';
import '../../../webservices/WebServicesHelper.dart';
import '../../../webservices/network_utility.dart';

/// Ola/Uber style "enter location" screen — search by typing an address and
/// pick from autocomplete suggestions, or jump straight to current location.
class VehicleLocationSearchScreen extends StatefulWidget {
  const VehicleLocationSearchScreen({super.key});

  @override
  State<VehicleLocationSearchScreen> createState() =>
      _VehicleLocationSearchScreenState();
}

class _VehicleLocationSearchScreenState
    extends State<VehicleLocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AutoCompletePrediction> _predictions = [];
  Timer? _debounce;
  bool _isSearching = false;
  bool _isLocatingMe = false;
  bool _isResolvingPlace = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() {
        _predictions = [];
        _isSearching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchPlaces(value.trim());
    });
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isSearching = true);
    try {
      final uri = Uri.parse(ApiUrl.autoCompleteApi).replace(queryParameters: {
        "input": query,
        "key": ApiUrl.mapApiKey,
      });
      final response = await NetworkUtility.fetchUrl(uri);
      if (response != null && mounted) {
        final parsed =
            PlaceAutoCompleteResponse.fromJson(jsonDecode(response));
        setState(() => _predictions = parsed.predictions ?? []);
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _selectPrediction(AutoCompletePrediction prediction) async {
    if (prediction.placeId == null || _isResolvingPlace) return;
    setState(() => _isResolvingPlace = true);
    try {
      final response =
          await WebServicesHelper().placeDetailsApi(prediction.placeId);
      if (response == null) return;

      final details = PlaceDetails.fromJson(response);
      final lat = details.result?.geometry?.location?.lat;
      final lng = details.result?.geometry?.location?.lng;
      if (lat == null || lng == null) return;

      Get.back(result: {
        "latitude": lat,
        "longitude": lng,
        "address": prediction.structuredFormatting?.mainText ??
            prediction.description ??
            details.result?.formattedAddress ??
            "Selected location",
      });
    } finally {
      if (mounted) setState(() => _isResolvingPlace = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    if (_isLocatingMe) return;
    setState(() => _isLocatingMe = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      String address = "Current Location";
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final parts = [place.locality, place.administrativeArea]
              .where((e) => e != null && e.isNotEmpty)
              .join(", ");
          if (parts.isNotEmpty) address = parts;
        }
      } catch (_) {}

      Get.back(result: {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "address": address,
      });
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          "Error",
          "Unable to fetch current location",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) setState(() => _isLocatingMe = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final showNoResults =
        query.length >= 3 && !_isSearching && _predictions.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onChanged: _onQueryChanged,
                        decoration: InputDecoration(
                          hintText: "Search for a location",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _debounce?.cancel();
                                    setState(() => _predictions = []);
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: _useCurrentLocation,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    _isLocatingMe
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Icon(Icons.my_location,
                            color: Colors.red, size: 22),
                    const SizedBox(width: 16),
                    const Text(
                      "Use current location",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            if (_isSearching)
              const LinearProgressIndicator(color: Colors.red, minHeight: 2),
            if (showNoResults)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "No locations found for \"$query\"",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            Expanded(
              child: ListView.separated(
                itemCount: _predictions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined,
                        color: Colors.grey),
                    title: Text(
                      prediction.structuredFormatting?.mainText ??
                          prediction.description ??
                          "",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle:
                        prediction.structuredFormatting?.secondaryText != null
                            ? Text(
                                prediction.structuredFormatting!.secondaryText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                    onTap: () => _selectPrediction(prediction),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
