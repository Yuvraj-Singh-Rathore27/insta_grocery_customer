

import 'package:insta_grocery_customer/model/user_location_model.dart';

import 'file_model.dart';

class StoreProfileModel {
  int? id;
  String? pincode;
  String? endTime;
  String? owner;
  List<FileModel>? photos;
  List<FileModel>? pharmaRegistrationCertificate;
  bool? isActive;
  int? countryId;
  var discount;
  String? ownerMobileNumber;

  int? updatedBy;
  bool? isDeleted;
  String? latitude;
  bool? homeDelivery;
  bool? displayOnlyActive;
  String? pharmacistName;
  Null? pharmacistRegistrationCertificate;
  int? updatedById;
  String? name;
  String? longitude;
  bool? cashOnDelivery;
  String? pharmacyMobileNumber;
  int? stateId;
  String? drugLicenseRegistrationNumber;
  String? countryPhoneCode;
  String? description;
  String? pharmacyWhatsappNumber;
  int? cityId;
  String? gstNumber;
  String? contactNumber;
  String? pharmacistRegistrationNumber;
  var hospitalId;
  String? email;
  String? provider;
  String? startTime;
  UserLocationModel? fullAddress;
  List<StoreTypeModel>? storeType;

  StoreProfileModel({this.id, this.pincode, this.endTime, this.owner, this.photos,
    this.isActive, this.countryId, this.discount, this.ownerMobileNumber,
    this.pharmaRegistrationCertificate, this.updatedBy, this.isDeleted, this.latitude,
    this.homeDelivery, this.pharmacistName, this.pharmacistRegistrationCertificate,
    this.updatedById, this.name, this.longitude, this.cashOnDelivery,
    this.pharmacyMobileNumber, this.stateId, this.drugLicenseRegistrationNumber,
    this.countryPhoneCode, this.description, this.pharmacyWhatsappNumber, this.cityId, this.gstNumber,
    this.contactNumber, this.pharmacistRegistrationNumber, this.hospitalId, this.email,
    this.provider, this.startTime, this.fullAddress,this.displayOnlyActive});

  StoreProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pincode = json['pincode'];
    endTime = json['end_time'] ?? "";
    owner = json['owner'];
    if (json['photos'] != null) {
      photos = <FileModel>[];
      json['photos'].forEach((v) { photos!.add(new FileModel.fromJson(v)); });
    }
    if (json['store_type_association'] != null) {
      storeType = <StoreTypeModel>[];
      json['store_type_association'].forEach((v) { storeType!.add(new StoreTypeModel.fromJson(v)); });
    }


    isActive = json['is_active'];
    countryId = json['country_id'];
    discount = json['discount'];
    ownerMobileNumber = json['owner_mobile_number'];
    fullAddress= json['full_address'] != null
        ?  UserLocationModel.fromJson(json['full_address'])
        : null;
    if (json['pharma_registration_certificate'] != null) {
      pharmaRegistrationCertificate = <FileModel>[];
      json['pharma_registration_certificate'].forEach((v) { pharmaRegistrationCertificate!.add(new FileModel.fromJson(v)); });
    }

    updatedBy = json['updated_by'];
    isDeleted = json['is_deleted'];
    latitude = json['latitude'];
    homeDelivery = json['home_delivery'];
    pharmacistName = json['pharmacist_name'];
    pharmacistRegistrationCertificate = json['pharmacist_registration_certificate'];
    updatedById = json['updated_by_id'];
    name = json['name'];
    longitude = json['longitude'];
    cashOnDelivery = json['cash_on_delivery'];
    pharmacyMobileNumber = json['pharmacy_mobile_number'];
    stateId = json['state_id'];
    drugLicenseRegistrationNumber = json['drug_license_registration_number'];
    countryPhoneCode = json['country_phone_code'];
    description = json['description'];
    pharmacyWhatsappNumber = json['pharmacy_whatsapp_number'];
    cityId = json['city_id'];
    gstNumber = json['gst_number'];
    contactNumber = json['contact_number'];
    // googleAddress = json['google_address'];
    pharmacistRegistrationNumber = json['pharmacist_registration_number'];
    hospitalId = json['hospital_id'];
    email = json['email'];
    provider = json['provider'];
    startTime = json['start_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pincode'] = this.pincode;
    data['end_time'] = this.endTime;
    data['owner'] = this.owner;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    if (this.storeType != null) {
      data['storeType'] = this.storeType!.map((v) => v.toJson()).toList();
    }


    data['is_active'] = this.isActive;
    data['country_id'] = this.countryId;
    data['discount'] = this.discount;
    data['owner_mobile_number'] = this.ownerMobileNumber;
    data['pharma_registration_certificate'] = this.pharmaRegistrationCertificate;
    data['updated_by'] = this.updatedBy;
    data['is_deleted'] = this.isDeleted;
    data['latitude'] = this.latitude;
    data['home_delivery'] = this.homeDelivery;
    data['pharmacist_name'] = this.pharmacistName;
    data['pharmacist_registration_certificate'] = this.pharmacistRegistrationCertificate;
    data['updated_by_id'] = this.updatedById;
    data['name'] = this.name;
    data['longitude'] = this.longitude;
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['pharmacy_mobile_number'] = this.pharmacyMobileNumber;
    data['state_id'] = this.stateId;
    data['drug_license_registration_number'] = this.drugLicenseRegistrationNumber;
    data['country_phone_code'] = this.countryPhoneCode;
    data['description'] = this.description;
    data['pharmacy_whatsapp_number'] = this.pharmacyWhatsappNumber;
    data['city_id'] = this.cityId;
    data['gst_number'] = this.gstNumber;
    data['contact_number'] = this.contactNumber;
    // data['google_address'] = this.googleAddress;
    data['pharmacist_registration_number'] = this.pharmacistRegistrationNumber;
    data['hospital_id'] = this.hospitalId;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['start_time'] = this.startTime;
    return data;
  }
}

class Photos {
  String? path;

  Photos({this.path});

  Photos.fromJson(Map<String, dynamic> json) {
    path = json['path'];
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

class StoreTypeModel {
  int ? id;
  int ? store_type_id;
  StoreType? storeType;

  StoreTypeModel({this.storeType});

  StoreTypeModel.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    store_type_id=json['store_type_id'];
    storeType = json['store_type'] != null
        ? new StoreType.fromJson(json['store_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.storeType != null) {
      data['store_type'] = this.storeType!.toJson();
    }
    data['id']=this.id;
    data['store_type_id']=this.store_type_id;
    return data;
  }
}

class StoreType {
  int? id;
  String? updatedAt;
  bool? isActive;
  String? name;

  StoreType({this.updatedAt, this.isActive, this.name,this.id});

  StoreType.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

