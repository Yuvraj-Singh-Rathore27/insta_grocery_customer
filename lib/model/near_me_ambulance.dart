class NearByAmbulanceModel {
  double? distance;
  AmbulanceDetails? ambulanceDetails;

  NearByAmbulanceModel({this.distance, this.ambulanceDetails});

  NearByAmbulanceModel.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    ambulanceDetails = json['ambulance_details'] != null
        ? new AmbulanceDetails.fromJson(json['ambulance_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    if (this.ambulanceDetails != null) {
      data['ambulance_details'] = this.ambulanceDetails!.toJson();
    }
    return data;
  }
}

class AmbulanceDetails {
  var yearOfManufacturing;
  var waitingTimeCharge;

  String? pincode;
  int? cityId;
  var chassisNumber;
  bool? isAvailable;
  Null? createdById;
  int? id;
  String? countryPhoneCode;
  Null? updatedBy;
  Null? photos;
  bool? isActive;
  String? contactNumber;
  Null? updatedById;
  String? name;
  Null? ambulanceRegistrationCertificate;
  bool? isDeleted;
  String? email;
  Null? gpsTrackingDevice;
  String? registrationNumber;
  int? countryId;
  String? createdAt;
  String? latitude;
  int? ownerId;
  var vehicleModelName;
  var tripCharge;
  String? updatedAt;
  String? longitude;
  int? typeId;
  int? stateId;

  AmbulanceDetails(
      {this.yearOfManufacturing,
        this.waitingTimeCharge,
        this.pincode,
        this.cityId,
        this.chassisNumber,
        this.isAvailable,
        this.createdById,
        this.id,
        this.countryPhoneCode,
        this.updatedBy,
        this.photos,
        this.isActive,
        this.contactNumber,
        this.updatedById,
        this.name,
        this.ambulanceRegistrationCertificate,
        this.isDeleted,
        this.email,
        this.gpsTrackingDevice,
        this.registrationNumber,
        this.countryId,
        this.createdAt,
        this.latitude,
        this.ownerId,
        this.vehicleModelName,
        this.tripCharge,
        this.updatedAt,
        this.longitude,
        this.typeId,
        this.stateId});

  AmbulanceDetails.fromJson(Map<String, dynamic> json) {
    yearOfManufacturing = json['year_of_manufacturing'];
    waitingTimeCharge = json['waiting_time_charge'];

    pincode = json['pincode'];
    cityId = json['city_id'];
    chassisNumber = json['chassis_number'];
    isAvailable = json['is_available'];
    createdById = json['created_by_id'];
    id = json['id'];
    countryPhoneCode = json['country_phone_code'];
    updatedBy = json['updated_by'];
    photos = json['photos'];
    isActive = json['is_active'];
    contactNumber = json['contact_number'];
    updatedById = json['updated_by_id'];
    name = json['name'];
    ambulanceRegistrationCertificate =
    json['ambulance_registration_certificate'];
    isDeleted = json['is_deleted'];
    email = json['email'];
    gpsTrackingDevice = json['gps_tracking_device'];
    registrationNumber = json['registration_number'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    latitude = json['latitude'];
    ownerId = json['owner_id'];
    vehicleModelName = json['vehicle_model_name'];
    tripCharge = json['trip_charge'];
    updatedAt = json['updated_at'];
    longitude = json['longitude'];
    typeId = json['type_id'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year_of_manufacturing'] = this.yearOfManufacturing;
    data['waiting_time_charge'] = this.waitingTimeCharge;
    data['pincode'] = this.pincode;
    data['city_id'] = this.cityId;
    data['chassis_number'] = this.chassisNumber;
    data['is_available'] = this.isAvailable;
    data['created_by_id'] = this.createdById;
    data['id'] = this.id;
    data['country_phone_code'] = this.countryPhoneCode;
    data['updated_by'] = this.updatedBy;
    data['photos'] = this.photos;
    data['is_active'] = this.isActive;
    data['contact_number'] = this.contactNumber;
    data['updated_by_id'] = this.updatedById;
    data['name'] = this.name;
    data['ambulance_registration_certificate'] =
        this.ambulanceRegistrationCertificate;
    data['is_deleted'] = this.isDeleted;
    data['email'] = this.email;
    data['gps_tracking_device'] = this.gpsTrackingDevice;
    data['registration_number'] = this.registrationNumber;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['latitude'] = this.latitude;
    data['owner_id'] = this.ownerId;
    data['vehicle_model_name'] = this.vehicleModelName;
    data['trip_charge'] = this.tripCharge;
    data['updated_at'] = this.updatedAt;
    data['longitude'] = this.longitude;
    data['type_id'] = this.typeId;
    data['state_id'] = this.stateId;
    return data;
  }
}