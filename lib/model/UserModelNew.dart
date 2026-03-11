class UserModelNew {
  int? id;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNumber;
  bool? isEmailVerified;
  bool? isContactVerified;
  String? countryPhoneCode;
  String? timezone;
  String? accessToken;
  String? deviceToken;
  String? deviceType;
  UserProfile? userProfile;


  UserModelNew(
      {this.id,
        this.userName,
        this.firstName,
        this.lastName,
        this.email,
        this.contactNumber,
        this.isEmailVerified,
        this.isContactVerified,
        this.countryPhoneCode,
        this.timezone,
        this.accessToken,
        this.deviceToken,
        this.userProfile,
        this.deviceType});

  UserModelNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    isEmailVerified = json['is_email_verified'];
    isContactVerified = json['is_contact_verified'];
    countryPhoneCode = json['country_phone_code'];
    timezone = json['timezone'];
    accessToken = json['access_token'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_contact_verified'] = this.isContactVerified;
    data['country_phone_code'] = this.countryPhoneCode;
    data['timezone'] = this.timezone;
    data['access_token'] = this.accessToken;
    data['device_token'] = this.deviceToken;
    data['device_type'] = this.deviceType;
    return data;
  }


}


class UserProfile {
  String? whatsappNumber;
  Null? photoFilePath;
  var countryId;
  var stateId;
  var addressLine1;
  var maritalStatus;
  int? id;
  var addressLine2;
  String? uhid;
  bool? isActive;
  var pincode;
  Null? height;
  bool? isDeleted;
  String? firstName;
  int? userId;
  Null? weight;
  String? createdAt;
  var lastName;
  int? bloodGroupId;
  var emergencyContact;
  String? birthDate;
  var  cityId;
  var gender;

  UserProfile(
      {this.whatsappNumber,
        this.photoFilePath,
        this.countryId,
        this.stateId,
        this.addressLine1,
        this.maritalStatus,
        this.id,
        this.addressLine2,
        this.uhid,
        this.isActive,
        this.pincode,
        this.height,
        this.isDeleted,
        this.firstName,
        this.userId,
        this.weight,
        this.createdAt,
        this.lastName,
        this.bloodGroupId,
        this.emergencyContact,
        this.birthDate,
        this.cityId,
        this.gender});

  UserProfile.fromJson(Map<String, dynamic> json) {
    whatsappNumber = json['whatsapp_number'];
    photoFilePath = json['photo_file_path'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    addressLine1 = json['address_line_1'];

    maritalStatus = json['marital_status'];
    id = json['id'];
    addressLine2 = json['address_line_2'];
    uhid = json['uhid'];
    isActive = json['is_active'];
    pincode = json['pincode'];
    height = json['height'];
    isDeleted = json['is_deleted'];
    firstName = json['first_name'];
    userId = json['user_id'];
    weight = json['weight'];
    createdAt = json['created_at'];
    lastName = json['last_name'];
    bloodGroupId = json['blood_group_id'];
    emergencyContact = json['emergency_contact'];
    birthDate = json['birth_date'];
    cityId = json['city_id'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsapp_number'] = this.whatsappNumber;
    data['photo_file_path'] = this.photoFilePath;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['address_line_1'] = this.addressLine1;
    data['marital_status'] = this.maritalStatus;
    data['id'] = this.id;
    data['address_line_2'] = this.addressLine2;
    data['uhid'] = this.uhid;
    data['is_active'] = this.isActive;
    data['pincode'] = this.pincode;
    data['height'] = this.height;
    data['is_deleted'] = this.isDeleted;
    data['first_name'] = this.firstName;
    data['user_id'] = this.userId;
    data['weight'] = this.weight;
    data['created_at'] = this.createdAt;
    data['last_name'] = this.lastName;
    data['blood_group_id'] = this.bloodGroupId;
    data['emergency_contact'] = this.emergencyContact;
    data['birth_date'] = this.birthDate;
    data['city_id'] = this.cityId;
    data['gender'] = this.gender;
    return data;
  }

}