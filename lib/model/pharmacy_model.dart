class PharmayModel {
  String? endTime;
  String? accessToken;
  String? latitude;
  String? ownerMobileNumber;
  bool? isActive;
  int? id;
  List<Photos>? photos;
  String? profile_photo = "";
  List<Photos>? pharmaRegistrationCertificate;
  List<Photos>? pharmacistRegistrationCertificate;
  int? updatedById;
  String? longitude;
  String? pharmacistName;
  String? name;
  bool? homeDelivery;

  String? countryPhoneCode;
  String? pharmacyMobileNumber;
  bool? cashOnDelivery;
  String? drugLicenseRegistrationNumber;

  String? contactNumber;
  String? pharmacyWhatsappNumber;
  String? updatedAt;
  String? gstNumber;
  String? description;
  String? openTime;
  String? closeTime;
  int? stateId;
  String? email;
  String? pharmacistRegistrationNumber;
  int? cityId;
  String? startTime;
  String? owner;
  String? pincode;
  String? provider;
  String? hospitalId;
  String? button_name;
  int? countryId;
  FullAddress? fullAddress;
  double? distance;

  PharmayModel({
    this.endTime,
    this.accessToken,
    this.latitude,
    this.ownerMobileNumber,
    this.isActive,
    this.id,
    this.photos,
    this.button_name,
    this.profile_photo,
    this.updatedById,
    this.longitude,
    this.pharmacistName,
    this.name,
    this.homeDelivery,
    this.pharmaRegistrationCertificate,
    this.countryPhoneCode,
    this.pharmacyMobileNumber,
    this.cashOnDelivery,
    this.drugLicenseRegistrationNumber,
    this.pharmacistRegistrationCertificate,
    this.contactNumber,
    this.pharmacyWhatsappNumber,
    this.updatedAt,
    this.gstNumber,
    this.description,
    this.stateId,
    this.email,
    this.pharmacistRegistrationNumber,
    this.cityId,
    this.startTime,
    this.owner,
    this.pincode,
    this.provider,
    this.hospitalId,
    this.countryId,
    this.closeTime,
    this.openTime,
    this.fullAddress,
    this.distance,
  });

  PharmayModel.fromJson(Map<String, dynamic> json) {
    endTime = json['end_time'] ?? "21:00:00";
    accessToken = json['access_token'];
    latitude = json['latitude'];
    ownerMobileNumber = json['owner_mobile_number'];
    isActive = json['is_active'];
    id = json['id'];
    button_name = json['button_name'];
    profile_photo = json['profile_photo'] ?? '';
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    updatedById = json['updated_by_id'];
    longitude = json['longitude'];
    pharmacistName = json['pharmacist_name'];
    name = json['name'];
    homeDelivery = json['home_delivery'];
    if (json['pharma_registration_certificate'] != null) {
      pharmaRegistrationCertificate = <Photos>[];
      json['pharma_registration_certificate'].forEach((v) {
        pharmaRegistrationCertificate!.add(new Photos.fromJson(v));
      });
    } else {
      pharmaRegistrationCertificate = <Photos>[];
    }
    if (json['pharmacist_registration_certificate'] != null) {
      pharmacistRegistrationCertificate = <Photos>[];
      json['pharmacist_registration_certificate'].forEach((v) {
        pharmacistRegistrationCertificate!.add(new Photos.fromJson(v));
      });
    }

    fullAddress = json['full_address'] != null
        ? new FullAddress.fromJson(json['full_address'])
        : null;
    countryPhoneCode = json['country_phone_code'];
    pharmacyMobileNumber = json['pharmacy_mobile_number'];
    cashOnDelivery = json['cash_on_delivery'];
    drugLicenseRegistrationNumber = json['drug_license_registration_number'];

    contactNumber = json['contact_number'];
    pharmacyWhatsappNumber = json['pharmacy_whatsapp_number'] ?? '';
    updatedAt = json['updated_at'];
    gstNumber = json['gst_number'] ?? '';
    description = json['description'] ?? '';
    closeTime = json['close_time'] ?? '';
    openTime = json['open_time'] ?? '';
    stateId = json['state_id'];
    email = json['email'];
    pharmacistRegistrationNumber = json['pharmacist_registration_number'];
    cityId = json['city_id'];
    startTime = json['start_time'] ?? "08:00:00";
    owner = json['owner'];
    pincode = json['pincode'];
    provider = json['provider'];
    hospitalId = json['hospital_id'];
    countryId = json['country_id'];
  }

  get rating => null;

 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_time'] = this.endTime;
    data['access_token'] = this.accessToken;
    data['latitude'] = this.latitude;
    data['owner_mobile_number'] = this.ownerMobileNumber;
    data['is_active'] = this.isActive;
    data['id'] = this.id;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['updated_by_id'] = this.updatedById;
    data['longitude'] = this.longitude;
    data['pharmacist_name'] = this.pharmacistName;
    data['name'] = this.name;
    data['home_delivery'] = this.homeDelivery;
    if (this.pharmaRegistrationCertificate != null) {
      data['pharma_registration_certificate'] =
          this.pharmaRegistrationCertificate!.map((v) => v.toJson()).toList();
    }
    if (this.pharmacistRegistrationCertificate != null) {
      data['pharmacist_registration_certificate'] = this
          .pharmacistRegistrationCertificate!
          .map((v) => v.toJson())
          .toList();
    }

    data['country_phone_code'] = this.countryPhoneCode;
    data['pharmacy_mobile_number'] = this.pharmacyMobileNumber;
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['drug_license_registration_number'] =
        this.drugLicenseRegistrationNumber;
    data['contact_number'] = this.contactNumber;
    data['pharmacy_whatsapp_number'] = this.pharmacyWhatsappNumber;
    data['updated_at'] = this.updatedAt;
    data['gst_number'] = this.gstNumber;
    data['description'] = this.description;
    data['state_id'] = this.stateId;
    data['email'] = this.email;
    data['pharmacist_registration_number'] = this.pharmacistRegistrationNumber;
    data['button_name'] = this.button_name;

    data['city_id'] = this.cityId;
    data['start_time'] = this.startTime;
    data['owner'] = this.owner;
    data['pincode'] = this.pincode;
    data['provider'] = this.provider;
    data['hospital_id'] = this.hospitalId;
    data['country_id'] = this.countryId;
    return data;
  }
}

class FullAddress {
  String? address;
  var latitude;
  var longitude;

  FullAddress({this.address, this.latitude, this.longitude});

  FullAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'] ?? '';
    latitude = json['latitude'] ?? "0.0";
    longitude = json['longitude'] ?? "0.0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Photos {
  String? path;

  Photos({this.path});

  Photos.fromJson(Map<String, dynamic> json) {
    path = json['path'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
