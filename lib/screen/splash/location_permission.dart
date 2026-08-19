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
import '../../res/AppDimens.dart';
import '../../res/ImageRes.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/session_manager.dart';
import '../daskboard/DashBord.dart';
import '../login/login_screen.dart';

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
    // The session gate. SessionManager treats null, "" and the literal
    // string "null" (written by older builds via `null.toString()`) as
    // logged out, so a half-written session can't send the customer to a
    // dashboard it has no user id for.
    print("session user_id==> ${SessionManager.userId}");
    if (SessionManager.isLoggedIn) {
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

  // ===========================================================
  //                            UI
  // ===========================================================

  Color get _primary => AppColor().colorPrimary;

  /// Type sizes come from [AppDimens] and are scaled against a 390pt reference
  /// width, clamped so a small phone stays readable and a tablet doesn't
  /// balloon.
  double get _scale =>
      (MediaQuery.of(context).size.width / 390).clamp(0.85, 1.2);

  double get _gutter => (24 * _scale).clamp(16.0, 32.0);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);

    // Cap the system font scale so the card rows can't blow past their box.
    final double textScale = media.textScaler.scale(1).clamp(1.0, 1.15);

    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        backgroundColor: AppColor().whiteColor,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  // Scrolls, so no screen size can overflow this page.
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(_gutter, 8, _gutter, 8),
                      child: Column(
                        children: [
                          _buildHero(),
                          SizedBox(height: 18 * _scale),
                          _buildHeading(),
                          SizedBox(height: 22 * _scale),
                          _buildHighlights(),
                          SizedBox(height: 22 * _scale),
                          _buildLocationCard(),
                          SizedBox(height: 14 * _scale),
                          _buildPrivacyNote(),
                        ],
                      ),
                    ),
                  ),

                  // CTA stays pinned below the scroll area.
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      _gutter,
                      8,
                      _gutter,
                      16 * _scale,
                    ),
                    child: _buildContinueButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                       HERO ILLUSTRATION
  // -----------------------------------------------------------
  Widget _buildHero() {
    final double height =
        (MediaQuery.of(context).size.height * 0.26).clamp(140.0, 260.0);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        ImageRes().locationImage1,
        fit: BoxFit.contain,
        // A missing/renamed asset must not leave a blank screen.
        errorBuilder: (_, __, ___) => Icon(
          Icons.location_on_rounded,
          size: height * 0.5,
          color: _primary,
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                      TITLE + SUBTITLE
  // -----------------------------------------------------------
  Widget _buildHeading() {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Enable Location Access",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimens().front_largest * 1.3 * _scale,
              fontWeight: FontWeight.w800,
              fontFamily: "Inter",
              color: AppColor().blackColor,
            ),
          ),
        ),
        SizedBox(height: 8 * _scale),
        Text(
          "Allow access to your location to provide\nyou with the best experience.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimens().front_regular * _scale,
            height: 1.5,
            color: AppColor().blackColorMore,
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  //                     THREE HIGHLIGHTS
  // -----------------------------------------------------------
  Widget _buildHighlights() {
    final List<(IconData, String)> items = [
      (Icons.gps_fixed_rounded, "Accurate\nPickups"),
      (Icons.route_rounded, "Real-time\nTracking"),
      (Icons.verified_user_rounded, "Enhanced\nSafety"),
    ];

    final double circle = (56 * _scale).clamp(44.0, 66.0);

    return Row(
      children: [
        for (final (IconData icon, String label) in items)
          // Equal thirds so the longest label can't shift the others.
          Expanded(
            child: Column(
              children: [
                Container(
                  height: circle,
                  width: circle,
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: _primary, size: circle * 0.45),
                ),
                SizedBox(height: 8 * _scale),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppDimens().front_regular * _scale,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                    color: AppColor().blackColor,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // -----------------------------------------------------------
  //                  LOCATION TOGGLE CARD
  // -----------------------------------------------------------
  Widget _buildLocationCard() {
    final double tile = (48 * _scale).clamp(40.0, 58.0);

    return Container(
      padding: EdgeInsets.all(14 * _scale),
      decoration: BoxDecoration(
        color: AppColor().whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor().colorGrayLess),
      ),
      child: Row(
        children: [
          Container(
            height: tile,
            width: tile,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: _primary,
              size: tile * 0.5,
            ),
          ),
          SizedBox(width: 12 * _scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location Access",
                  style: TextStyle(
                    fontSize: AppDimens().front_medium * _scale,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter",
                    color: AppColor().blackColor,
                  ),
                ),
                SizedBox(height: 3 * _scale),
                Text(
                  "Let us help you find nearby services and exact locations.",
                  style: TextStyle(
                    fontSize: AppDimens().front_12 * _scale,
                    height: 1.4,
                    color: AppColor().blackColorMore,
                  ),
                ),
              ],
            ),
          ),
          // Same behaviour as before: switching on runs the permission flow,
          // switching off only clears the local flag.
          Switch(
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
            activeColor: AppColor().whiteColor,
            activeTrackColor: _primary,
            inactiveThumbColor: AppColor().whiteColor,
            inactiveTrackColor: AppColor().colorGray,
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  //                        PRIVACY NOTE
  // -----------------------------------------------------------
  Widget _buildPrivacyNote() {
    return Container(
      padding: EdgeInsets.all(14 * _scale),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: _primary,
            size: 22 * _scale,
          ),
          SizedBox(width: 12 * _scale),
          Expanded(
            child: Text(
              "We respect your privacy. Your location is used only while using the app.",
              style: TextStyle(
                fontSize: AppDimens().front_12 * _scale,
                height: 1.45,
                color: AppColor().blackColorMore,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  //                       CONTINUE BUTTON
  // -----------------------------------------------------------
  Widget _buildContinueButton() {
    final double height = (54 * _scale).clamp(46.0, 62.0);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: AppColor().whiteColor,
          disabledBackgroundColor: _primary.withOpacity(0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : _continueWithSelectedPermissions,
        child: isLoading
            ? SizedBox(
                height: height * 0.42,
                width: height * 0.42,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColor().whiteColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.near_me_rounded, size: 20 * _scale),
                  SizedBox(width: 10 * _scale),
                  Flexible(
                    child: Text(
                      "Continue with Location Access",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppDimens().front_medium * _scale,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
