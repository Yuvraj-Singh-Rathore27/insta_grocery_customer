class HospitalModel {
  String? countryPhoneCode;
  String? whatsappNumber;
  int? createdById;
  String? ceaRegistrationNumber;
  int? id;
  int? cityId;
  String? contactNumber;
  String? name;
  String? nhbHbiRegistrationNumber;
  bool? isActive;
  String? email;
  String? owner;
  int? updatedById;
  // String? fullAddress;
  String? workingDays;
  bool? isDeleted;
  String? description;
  String? pincode;

  String? hospitalLogoPath;
  String? latitude;
  // String? hospitalImagePath;
  // String? location;
  String? longitude;
  String? bedCount;
  int? createdBy;
  String? specialityType;
  int? stateId;
  String? hospitalType;

  HospitalModel(
      {this.countryPhoneCode,
        this.whatsappNumber,
        this.createdById,
        this.ceaRegistrationNumber,
        this.id,
        this.cityId,
        this.contactNumber,
        this.name,
        this.nhbHbiRegistrationNumber,
        this.isActive,
        this.email,
        this.owner,
        this.updatedById,
        // this.fullAddress,
        this.workingDays,
        this.isDeleted,
        this.description,
        this.pincode,
        this.hospitalLogoPath,
        this.latitude,
        // this.hospitalImagePath,
        // this.location,
        this.longitude,
        this.bedCount,
        this.createdBy,
        this.specialityType,
        this.stateId,
        this.hospitalType});

  HospitalModel.fromJson(Map<String, dynamic> json) {
    countryPhoneCode = json['country_phone_code'];
    whatsappNumber = json['whatsapp_number'];
    createdById = json['created_by_id'];
    ceaRegistrationNumber = json['cea_registration_number'];
    id = json['id'];
    cityId = json['city_id'];
    contactNumber = json['contact_number'];
    name = json['name'];
    nhbHbiRegistrationNumber = json['nhb_hbi_registration_number'];
    isActive = json['is_active'];
    email = json['email'];
    owner = json['owner'];
    updatedById = json['updated_by_id'];
    // fullAddress = json['full_address'];
    workingDays = json['working_days'];
    isDeleted = json['is_deleted'];
    description = json['description'];
    pincode = json['pincode'];
    hospitalLogoPath = json['hospital_logo_path'];
    latitude = json['latitude'];
    // hospitalImagePath = json['hospital_image_path'];
    // location = json['location'];
    longitude = json['longitude'];
    bedCount = json['bed_count'];
    createdBy = json['created_by'];
    specialityType = json['speciality_type'];
    stateId = json['state_id'];
    hospitalType = json['hospital_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_phone_code'] = this.countryPhoneCode;
    data['whatsapp_number'] = this.whatsappNumber;
    data['created_by_id'] = this.createdById;
    data['cea_registration_number'] = this.ceaRegistrationNumber;
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    data['contact_number'] = this.contactNumber;
    data['name'] = this.name;
    data['nhb_hbi_registration_number'] = this.nhbHbiRegistrationNumber;
    data['is_active'] = this.isActive;
    data['email'] = this.email;
    data['owner'] = this.owner;
    data['updated_by_id'] = this.updatedById;
    // data['full_address'] = this.fullAddress;
    data['working_days'] = this.workingDays;
    data['is_deleted'] = this.isDeleted;
    data['description'] = this.description;
    data['pincode'] = this.pincode;
    data['hospital_logo_path'] = this.hospitalLogoPath;
    data['latitude'] = this.latitude;
    // data['hospital_image_path'] = this.hospitalImagePath;
    // data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['bed_count'] = this.bedCount;
    data['created_by'] = this.createdBy;
    data['speciality_type'] = this.specialityType;
    data['state_id'] = this.stateId;
    data['hospital_type'] = this.hospitalType;
    return data;
  }
}

