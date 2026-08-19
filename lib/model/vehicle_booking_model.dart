// Models for the customer-side vehicle booking APIs:
//
//   POST /bookings/                            → create a booking
//   GET  /bookings/?customer_id=&page=&size=   → customer's bookings
//   GET  /bookings/{booking_id}                → one booking + driver/vehicle
//   POST /bookings/{booking_id}/cancel         → customer cancels
//
// These endpoints have no auth on the backend yet, so the customer is
// identified by `customer_id` in the body/query — which on this app is the
// logged-in user id (UserPreferences.user_id).

/// Booking workflow states. The driver side drives the transitions:
/// accept → ACCEPTED, arriving → ARRIVING, start → IN_PROGRESS,
/// complete → COMPLETED, reject → REJECTED; the customer can cancel until
/// the trip is COMPLETED.
class VehicleBookingStatus {
  static const String pending = 'PENDING';
  static const String accepted = 'ACCEPTED';
  static const String arriving = 'ARRIVING';
  static const String inProgress = 'IN_PROGRESS';
  static const String completed = 'COMPLETED';
  static const String cancelled = 'CANCELLED';
  static const String rejected = 'REJECTED';

  /// Uppercases and normalises separators so 'in progress', 'in-progress'
  /// and 'IN_PROGRESS' all compare equal — the backend isn't consistent
  /// about which spelling it returns.
  static String normalize(String? raw) {
    if (raw == null) return '';
    return raw.trim().toUpperCase().replaceAll(RegExp(r'[\s-]+'), '_');
  }

  /// The booking is still running: it can be tracked and cancelled.
  static bool isLive(String? raw) {
    final String status = normalize(raw);
    if (status.isEmpty) return false;
    return !isFinished(status);
  }

  /// Terminal states — nothing more will happen to this booking.
  static bool isFinished(String? raw) {
    switch (normalize(raw)) {
      case completed:
      case cancelled:
      case rejected:
        return true;
      default:
        return false;
    }
  }

  /// Cancel is refused by the backend once the trip is COMPLETED, and is
  /// pointless on the other terminal states.
  static bool canCancel(String? raw) => isLive(raw);

  /// Short label for the status chip.
  static String label(String? raw) {
    switch (normalize(raw)) {
      case pending:
        return 'Requested';
      case accepted:
        return 'Accepted';
      case arriving:
        return 'Arriving';
      case inProgress:
      case 'STARTED':
      case 'ONGOING':
        return 'On trip';
      case completed:
        return 'Completed';
      case cancelled:
        return 'Cancelled';
      case rejected:
        return 'Rejected';
      case '':
        return 'Booking';
      default:
        // Unknown status from the backend — show it readably rather than
        // hiding it, e.g. "NO_SHOW" → "No show".
        final String status = normalize(raw).replaceAll('_', ' ').toLowerCase();
        return status[0].toUpperCase() + status.substring(1);
    }
  }

  /// One-line explanation shown under the label while the ride is live.
  static String message(String? raw) {
    switch (normalize(raw)) {
      case pending:
        return 'Waiting for the driver to accept your request';
      case accepted:
        return 'Driver accepted your booking';
      case arriving:
        return 'Driver is on the way to your pickup point';
      case inProgress:
      case 'STARTED':
      case 'ONGOING':
        return 'Your trip is in progress';
      case completed:
        return 'Trip completed';
      case cancelled:
        return 'Booking cancelled';
      case rejected:
        return 'Driver rejected this booking';
      default:
        return 'Booking updated';
    }
  }
}

/// Request body for POST /bookings/ (schema: BookingCreate).
/// Only the pickup coordinates are required; drop is optional.
class VehicleBookingCreateModel {
  final int customerId;
  final int driverId;
  final int vehicleId;
  final double pickupLatitude;
  final double pickupLongitude;
  final double? dropLatitude;
  final double? dropLongitude;

  VehicleBookingCreateModel({
    required this.customerId,
    required this.driverId,
    required this.vehicleId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    this.dropLatitude,
    this.dropLongitude,
  });

  /// True when every id is set and the pickup point is a real coordinate —
  /// the backend rejects 0/0 and out-of-range values with a 422.
  bool get isValid =>
      customerId > 0 &&
      driverId > 0 &&
      vehicleId > 0 &&
      pickupLatitude.abs() <= 90 &&
      pickupLongitude.abs() <= 180 &&
      !(pickupLatitude == 0 && pickupLongitude == 0);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'customer_id': customerId,
      'driver_id': driverId,
      'vehicle_id': vehicleId,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
    };

    // Drop is optional — sending nulls makes the API's range validation fail.
    if (dropLatitude != null && dropLongitude != null) {
      data['drop_latitude'] = dropLatitude;
      data['drop_longitude'] = dropLongitude;
    }

    return data;
  }
}

/// One booking record as returned by GET /bookings/ and GET /bookings/{id}.
///
/// Keys are read defensively: the list and detail endpoints don't always
/// expand the same objects, and ids arrive either flat (`driver_id`) or
/// nested inside the expanded record (`driver: {id: ...}`).
class VehicleBookingModel {
  int? id;
  int? customerId;
  int? driverId;
  int? vehicleId;
  double? pickupLatitude;
  double? pickupLongitude;
  double? dropLatitude;
  double? dropLongitude;
  String? status;
  String? createdAt;
  String? updatedAt;

  /// Expanded records when the endpoint sends them (detail call does).
  Map<String, dynamic>? customer;
  Map<String, dynamic>? driver;
  Map<String, dynamic>? vehicle;

  VehicleBookingModel({
    this.id,
    this.customerId,
    this.driverId,
    this.vehicleId,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropLatitude,
    this.dropLongitude,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.driver,
    this.vehicle,
  });

  VehicleBookingModel.fromJson(Map<String, dynamic> json) {
    customer = _asMap(json['customer']);
    driver = _asMap(json['driver']);
    vehicle = _asMap(json['vehicle']);

    id = _asInt(json['id'] ?? json['booking_id']);
    customerId = _asInt(json['customer_id'] ?? json['user_id']) ??
        _asInt(customer?['id']);
    driverId = _asInt(json['driver_id']) ?? _asInt(driver?['id']);
    vehicleId = _asInt(json['vehicle_id'] ?? json['vechile_id']) ??
        _asInt(vehicle?['id']);

    pickupLatitude = _asDouble(json['pickup_latitude']);
    pickupLongitude = _asDouble(json['pickup_longitude']);
    dropLatitude = _asDouble(json['drop_latitude']);
    dropLongitude = _asDouble(json['drop_longitude']);

    status = json['status']?.toString() ?? json['booking_status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'driver_id': driverId,
        'vehicle_id': vehicleId,
        'pickup_latitude': pickupLatitude,
        'pickup_longitude': pickupLongitude,
        'drop_latitude': dropLatitude,
        'drop_longitude': dropLongitude,
        'status': status,
        'created_at': createdAt,
      };

  String get statusLabel => VehicleBookingStatus.label(status);
  String get statusMessage => VehicleBookingStatus.message(status);
  bool get isLive => VehicleBookingStatus.isLive(status);
  bool get isFinished => VehicleBookingStatus.isFinished(status);
  bool get canCancel => VehicleBookingStatus.canCancel(status);

  String get driverName => (driver?['name'] ?? '').toString();
  String get driverContact => (driver?['contact_number'] ?? '').toString();
  String get vehicleNumber => (vehicle?['vehicle_number'] ?? '').toString();

  static Map<String, dynamic>? _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

/// Paged envelope returned by GET /bookings/
/// ({error, code, status, message, data: [...], total, page, size, pages}).
class VehicleBookingListResponse {
  bool error;
  int? status;
  String? message;
  List<VehicleBookingModel> data;
  int total;
  int page;
  int size;
  int pages;

  VehicleBookingListResponse({
    this.error = false,
    this.status,
    this.message,
    List<VehicleBookingModel>? data,
    this.total = 0,
    this.page = 1,
    this.size = 10,
    this.pages = 0,
  }) : data = data ?? <VehicleBookingModel>[];

  VehicleBookingListResponse.fromJson(Map<String, dynamic> json)
      : error = json['error'] == true,
        status = VehicleBookingModel._asInt(json['status']),
        message = json['message']?.toString(),
        data = (json['data'] is List)
            ? (json['data'] as List)
                .whereType<Map>()
                .map((e) =>
                    VehicleBookingModel.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : <VehicleBookingModel>[],
        total = VehicleBookingModel._asInt(json['total']) ?? 0,
        page = VehicleBookingModel._asInt(json['page']) ?? 1,
        size = VehicleBookingModel._asInt(json['size']) ?? 10,
        pages = VehicleBookingModel._asInt(json['pages']) ?? 0;
}
