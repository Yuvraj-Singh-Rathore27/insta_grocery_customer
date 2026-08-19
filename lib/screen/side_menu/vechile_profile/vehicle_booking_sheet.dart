import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../controller/vechile_controller.dart';
import '../../../model/vehicle_booking_model.dart';
import './VehicleLocationSearchScreen.dart';

// Booking UI shared by the map bottom sheet and the ride detail screen:
//
//  * showVehicleBookingSheet() → confirm pickup/drop, then POST /bookings/
//  * VehicleBookingStatusCard  → live status of the ride + cancel button
//
// Both work off the same VehicleController, so a booking made from the map
// immediately shows its status on the detail screen and the other way round.

/// Colour used for a booking status everywhere in the app.
Color vehicleBookingStatusColor(String? status) {
  switch (VehicleBookingStatus.normalize(status)) {
    case VehicleBookingStatus.pending:
      return Colors.orange.shade700;
    case VehicleBookingStatus.accepted:
      return Colors.blue.shade700;
    case VehicleBookingStatus.arriving:
      return Colors.indigo;
    case VehicleBookingStatus.inProgress:
    case 'STARTED':
    case 'ONGOING':
      return Colors.green.shade700;
    case VehicleBookingStatus.completed:
      return Colors.teal.shade700;
    case VehicleBookingStatus.cancelled:
      return Colors.grey.shade700;
    case VehicleBookingStatus.rejected:
      return Colors.red.shade700;
    default:
      return Colors.blueGrey;
  }
}

IconData _statusIcon(String? status) {
  switch (VehicleBookingStatus.normalize(status)) {
    case VehicleBookingStatus.pending:
      return Icons.hourglass_top_rounded;
    case VehicleBookingStatus.accepted:
      return Icons.check_circle_outline;
    case VehicleBookingStatus.arriving:
      return Icons.directions_car_filled_outlined;
    case VehicleBookingStatus.inProgress:
    case 'STARTED':
    case 'ONGOING':
      return Icons.navigation_rounded;
    case VehicleBookingStatus.completed:
      return Icons.flag_circle_outlined;
    case VehicleBookingStatus.cancelled:
      return Icons.cancel_outlined;
    case VehicleBookingStatus.rejected:
      return Icons.block_outlined;
    default:
      return Icons.local_taxi_outlined;
  }
}

int? _idOf(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '');
}

/// Opens the "confirm your ride" sheet for [vehicle] (a record from
/// /vehicles/nearby). Returns the created booking, or null when the customer
/// backed out or the API refused.
Future<VehicleBookingModel?> showVehicleBookingSheet(
  BuildContext context,
  Map<String, dynamic> vehicle, {
  String? pickupAddress,
}) async {
  final controller = Get.find<VehicleController>();

  final int? vehicleId = _idOf(vehicle['id']);
  final Map driver = vehicle['driver'] is Map ? vehicle['driver'] as Map : {};
  final int? driverId = _idOf(driver['id']);

  if (vehicleId == null || driverId == null || driverId == 0) {
    Get.snackbar(
      "Booking",
      "This vehicle has no driver assigned yet",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return null;
  }

  return showModalBottomSheet<VehicleBookingModel?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _BookingConfirmSheet(
      vehicle: vehicle,
      vehicleId: vehicleId,
      driverId: driverId,
      controller: controller,
      pickupAddress: pickupAddress,
    ),
  );
}

class _BookingConfirmSheet extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final int vehicleId;
  final int driverId;
  final VehicleController controller;
  final String? pickupAddress;

  const _BookingConfirmSheet({
    required this.vehicle,
    required this.vehicleId,
    required this.driverId,
    required this.controller,
    this.pickupAddress,
  });

  @override
  State<_BookingConfirmSheet> createState() => _BookingConfirmSheetState();
}

class _BookingConfirmSheetState extends State<_BookingConfirmSheet> {
  // Pickup defaults to the location the map is centred on (GPS fix or the
  // place the customer picked); they can still move it from here.
  late double _pickupLat = widget.controller.latitude.value;
  late double _pickupLng = widget.controller.longitude.value;
  String? _pickupLabel;

  // Drop is optional — the API only requires the pickup point.
  double? _dropLat;
  double? _dropLng;
  String? _dropLabel;

  @override
  void initState() {
    super.initState();
    _pickupLabel = widget.pickupAddress;
    if (_pickupLabel == null || _pickupLabel!.isEmpty) {
      _resolvePickupAddress();
    }
  }

  Future<void> _resolvePickupAddress() async {
    if (_pickupLat == 0.0 && _pickupLng == 0.0) return;
    try {
      final placemarks = await placemarkFromCoordinates(_pickupLat, _pickupLng);
      if (placemarks.isEmpty || !mounted) return;
      final place = placemarks.first;
      final label = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).join(", ");
      if (label.isNotEmpty) setState(() => _pickupLabel = label);
    } catch (e) {
      debugPrint("❌ [BOOKING] Pickup geocode error: $e");
    }
  }

  Future<void> _pickLocation({required bool isPickup}) async {
    final dynamic result = await Get.to(
      () => const VehicleLocationSearchScreen(),
    );
    if (result is! Map || !mounted) return;

    final double? lat = (result['latitude'] as num?)?.toDouble();
    final double? lng = (result['longitude'] as num?)?.toDouble();
    if (lat == null || lng == null) return;

    setState(() {
      if (isPickup) {
        _pickupLat = lat;
        _pickupLng = lng;
        _pickupLabel = result['address'] as String?;
      } else {
        _dropLat = lat;
        _dropLng = lng;
        _dropLabel = result['address'] as String?;
      }
    });
  }

  /// Distance in km between pickup and drop, null until a drop is chosen.
  double? get _tripKm {
    if (_dropLat == null || _dropLng == null) return null;
    return Geolocator.distanceBetween(
          _pickupLat,
          _pickupLng,
          _dropLat!,
          _dropLng!,
        ) /
        1000;
  }

  double _numOf(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _confirm() async {
    final booking = await widget.controller.createBooking(
      driverId: widget.driverId,
      vehicleId: widget.vehicleId,
      pickupLat: _pickupLat,
      pickupLng: _pickupLng,
      dropLat: _dropLat,
      dropLng: _dropLng,
    );

    if (booking == null || !mounted) return;

    Navigator.of(context).pop(booking);

    Get.snackbar(
      "Booking ${booking.statusLabel}",
      booking.statusMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: vehicleBookingStatusColor(booking.status),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map driver =
        widget.vehicle['driver'] is Map ? widget.vehicle['driver'] as Map : {};
    final String driverName = (driver['name'] ?? 'Driver').toString();
    final String vehicleName =
        (widget.vehicle['make_model'] ?? 'Vehicle').toString();
    final String vehicleNumber =
        (widget.vehicle['vehicle_number'] ?? '').toString();

    final double baseCharges = _numOf(widget.vehicle['base_charges']);
    final double ratePerKm = _numOf(widget.vehicle['rate_per_km']);
    final double? km = _tripKm;
    final double? estimate =
        km == null ? null : baseCharges + (ratePerKm * km);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Confirm your booking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$vehicleName${vehicleNumber.isNotEmpty ? ' · $vehicleNumber' : ''} · $driverName",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 18),

              // ── Pickup ──
              _locationTile(
                icon: Icons.my_location,
                iconColor: Colors.green,
                title: "PICKUP",
                value: _pickupLabel?.isNotEmpty == true
                    ? _pickupLabel!
                    : "${_pickupLat.toStringAsFixed(5)}, ${_pickupLng.toStringAsFixed(5)}",
                onTap: () => _pickLocation(isPickup: true),
              ),
              const SizedBox(height: 10),

              // ── Drop (optional) ──
              _locationTile(
                icon: Icons.location_on_outlined,
                iconColor: Colors.red,
                title: "DROP (OPTIONAL)",
                value: _dropLabel?.isNotEmpty == true
                    ? _dropLabel!
                    : "Tap to add a drop location for a fare estimate",
                muted: _dropLabel == null,
                onTap: () => _pickLocation(isPickup: false),
                onClear: _dropLat == null
                    ? null
                    : () => setState(() {
                          _dropLat = null;
                          _dropLng = null;
                          _dropLabel = null;
                        }),
              ),
              const SizedBox(height: 16),

              // ── Fare ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _fareRow("Base fare", "₹${baseCharges.toStringAsFixed(0)}"),
                    const SizedBox(height: 8),
                    _fareRow("Per km", "₹${ratePerKm.toStringAsFixed(0)}"),
                    if (km != null) ...[
                      const SizedBox(height: 8),
                      _fareRow("Distance", "${km.toStringAsFixed(1)} km"),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                      _fareRow(
                        "Estimated fare",
                        "₹${estimate!.toStringAsFixed(0)}",
                        bold: true,
                      ),
                    ],
                  ],
                ),
              ),
              if (km == null) ...[
                const SizedBox(height: 8),
                Text(
                  "Final fare is calculated by the driver at the end of the trip.",
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
              const SizedBox(height: 18),

              // ── Confirm ──
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.controller.isCreatingBooking.value
                        ? null
                        : _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      disabledBackgroundColor: Colors.red.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: widget.controller.isCreatingBooking.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Confirm Booking",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Pickup / drop row. The whole box is the control: tapping anywhere on it
  /// opens the location search. There are no "Change" / "Add" buttons —
  /// customers went for the text itself, so the text is what responds.
  Widget _locationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
    VoidCallback? onClear,
    bool muted = false,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: muted ? FontWeight.w400 : FontWeight.w600,
                        color: muted ? Colors.grey.shade500 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Clearing the drop is a different action from editing it, so it
              // keeps its own hit target instead of riding on the row tap.
              if (onClear != null)
                IconButton(
                  onPressed: onClear,
                  icon:
                      Icon(Icons.close, size: 16, color: Colors.grey.shade500),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                  tooltip: "Clear",
                ),
              // Affordance only — the tap is handled by the row itself.
              Icon(Icons.chevron_right,
                  size: 20, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fareRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 14 : 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            fontWeight: FontWeight.w700,
            color: bold ? Colors.red : Colors.black87,
          ),
        ),
      ],
    );
  }
}

/// Live status of a booking: the state chip, what it means, and the cancel
/// action while the backend still allows it. Rebuilds itself as the
/// controller polls GET /bookings/{id}.
class VehicleBookingStatusCard extends StatelessWidget {
  final VehicleBookingModel booking;

  const VehicleBookingStatusCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();
    final Color color = vehicleBookingStatusColor(booking.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_statusIcon(booking.status), size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          booking.statusLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        if (booking.id != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            "#${booking.id}",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.statusMessage,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (booking.canCancel && booking.id != null) ...[
            const SizedBox(height: 12),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.isCancellingBooking.value
                      ? null
                      : () => _confirmCancel(context, controller),
                  icon: controller.isCancellingBooking.value
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.close_rounded, size: 17),
                  label: Text(
                    controller.isCancellingBooking.value
                        ? "Cancelling..."
                        : "Cancel Booking",
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    VehicleController controller,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cancel booking?"),
        content: const Text(
          "Your ride request will be cancelled and the driver will be notified.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text("Keep it"),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Yes, cancel"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final bool ok = await controller.cancelBooking(booking.id!);
    if (!ok) return;

    Get.snackbar(
      "Booking cancelled",
      "Your booking #${booking.id} has been cancelled",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade800,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
