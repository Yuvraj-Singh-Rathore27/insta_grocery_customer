class VehicleSosModel {
  int? id;
  int? vehicleId;
  int? driverId;
  int? userId;
  double? latitude;
  double? longitude;
  String? message;
  String? status;
  String? createdAt;

  VehicleSosModel({
    this.id,
    this.vehicleId,
    this.driverId,
    this.userId,
    this.latitude,
    this.longitude,
    this.message,
    this.status,
    this.createdAt,
  });

  VehicleSosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    latitude = (json['latitude'] ?? 0).toDouble();
    longitude = (json['longitude'] ?? 0).toDouble();
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['driver_id'] = this.driverId;
    data['user_id'] = this.userId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['message'] = this.message;
    return data;
  }
}
