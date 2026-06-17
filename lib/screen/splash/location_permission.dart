import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controller/vender_controller.dart';
import '../../res/AppColor.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/UserPreferences.dart';
import '../daskboard/DashBord.dart';
import '../login/login_screen.dart';
import 'package:get_storage/get_storage.dart';

class LocationPerMissionScreeen extends StatefulWidget {
  @override
  _LocationPerMissionScreeen createState() => _LocationPerMissionScreeen();
}

class _LocationPerMissionScreeen extends State<LocationPerMissionScreeen> {
  bool locationEnabled = false;
  bool isLoading = false;
  bool notificationsEnabled = false;
  bool cameraEnabled = true; // Default enabled as per your design
  PharmacyController controller = Get.put(PharmacyController());
  Future<void> _requestLocation() async {
  try {
    // STEP 1: Check location service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      // Recheck after user returns
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar(
          "Location Disabled",
          "Please enable location services",
        );
        return;
      }
    }

    // STEP 2: Check permission
    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // STEP 3: Handle denied
    if (permission == LocationPermission.denied) {
      Get.snackbar(
        "Permission Denied",
        "Location permission is required",
      );
      return;
    }

    // STEP 4: Permanently denied
    if (permission == LocationPermission.deniedForever) {
      _showPermissionSettingsDialog('location');
      return;
    }

    // STEP 5: Permission granted
    setState(() {
      locationEnabled = true;
    });

    // STEP 6: Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    controller.lat.value = position.latitude;
    controller.lng.value = position.longitude;

    await controller.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    // STEP 7: Navigate immediately
    _navigateToNextScreen();

  } catch (e) {
    print("Location Error: $e");

    Get.snackbar(
      "Error",
      "Failed to get location",
    );
  }
}
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      setState(() {
        notificationsEnabled = result.isGranted;
      });
    } else if (status.isGranted) {
      setState(() {
        notificationsEnabled = true;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final result = await Permission.camera.request();
      setState(() {
        cameraEnabled = result.isGranted;
      });
    } else if (status.isGranted) {
      setState(() {
        cameraEnabled = true;
      });
    } else if (status.isPermanentlyDenied) {
      _showPermissionSettingsDialog('camera');
    }
  }

  void _showPermissionSettingsDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Permission Required',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
              '$permissionType permission is permanently denied. Please enable it in app settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: Text(
                'Open Settings',
                style: TextStyle(
                  color: AppColor().colorPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToNextScreen() async {
    final store = GetStorage();
    var userId = store.read(UserPreferences.user_id);
    print("user_id==> $userId");
    if (userId != null && userId != "null") {
      Get.offAll(() => DashBord(0, ""));
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  Future<void> _continueWithSelectedPermissions() async {
  if (isLoading) return;

  setState(() {
    isLoading = true;
  });

  await _requestLocation();

  setState(() {
    isLoading = false;
  });
}

  void _skipForNow() {
    _navigateToNextScreen();
  }

  @override
  void initState() {
    super.initState();
    _checkExistingPermissions();
  }

  Future<void> _checkExistingPermissions() async {
    // Check location permission
    final locationPermission = await Geolocator.checkPermission();
    setState(() {
      locationEnabled = locationPermission == LocationPermission.whileInUse ||
          locationPermission == LocationPermission.always;
    });

    // Check notification permission
    final notificationStatus = await Permission.notification.status;
    setState(() {
      notificationsEnabled = notificationStatus.isGranted;
    });

    // Check camera permission
    final cameraStatus = await Permission.camera.status;
    setState(() {
      cameraEnabled = cameraStatus.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section with Icon
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColor().colorPrimary, // Red background
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor().colorPrimary, // Red border color
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColor().colorPrimary, // Red background
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // White dashed border
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Icon(
                    Icons.question_mark,
                    size: 40,
                    color: Colors.white, // White icon color
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Enable Permissions",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Help us provide you with the best experience",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 80),

              // Permissions List
              _buildPermissionItem(
                title: "Location Access",
                subtitle: "Find nearby businesses and services",
                value: locationEnabled,
                onChanged: (value) {
                  if (value) {
                    _requestLocation();
                  } else {
                    setState(() {
                      locationEnabled = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),


              const SizedBox(height: 24),
              const Divider(height: 1),

              const Spacer(),

              // Continue Button - Always enabled
             SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor().colorPrimary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: _continueWithSelectedPermissions,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: const Text(
        "Continue with Selected Permissions",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ),
),
              const SizedBox(height: 16),

              // Skip Button
              // SizedBox(
              //   width: double.infinity,
              //   child: TextButton(
              //     onPressed: _skipForNow,
              //     child: Text(
              //       "Skip for now",
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: AppColor().colorPrimary, // Red color from AppColor
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Toggle Switch
        Transform.scale(
          scale: 1.0,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColor().colorPrimary,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
