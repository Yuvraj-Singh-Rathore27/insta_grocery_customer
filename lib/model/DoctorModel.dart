import 'doctor_eduction_model.dart';

class DoctorModel {
  String? userName;
  String? fullName;
  String? email;
  bool? isEmailVerified;
  String? countryPhoneCode;
  String? contactNumber;
  bool? isContactVerified;
  String? accessToken;
  int? platformType;
  int? id;
  String? deviceToken;
  String? deviceType;
  String? timezone;
  List<DoctorEductionModel>? doctorEducation;


  DoctorModel(
      {this.userName,
        this.email,
        this.isEmailVerified,
        this.countryPhoneCode,
        this.contactNumber,
        this.isContactVerified,
        this.accessToken,
        this.platformType,
        this.deviceToken,
        this.deviceType,
        this.timezone,
        this.id,
        this.doctorEducation,
        this.fullName,
      });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    email = json['email'];
    fullName = json['full_name']??'';
    isEmailVerified = json['is_email_verified'];
    countryPhoneCode = json['country_phone_code'];
    contactNumber = json['contact_number'];
    id = json['id'];
    isContactVerified = json['is_contact_verified'];
    accessToken = json['access_token'];
    platformType = json['platform_type'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    timezone = json['timezone'];
    if (json['doctor_profile'] != null) {
      doctorEducation = <DoctorEductionModel>[];
      json['doctor_education'].forEach((v) {
        doctorEducation!.add(DoctorEductionModel.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['is_email_verified'] = this.isEmailVerified;
    data['country_phone_code'] = this.countryPhoneCode;
    data['contact_number'] = this.contactNumber;
    data['id'] = this.id;
    data['is_contact_verified'] = this.isContactVerified;
    data['access_token'] = this.accessToken;
    data['platform_type'] = this.platformType;
    data['device_token'] = this.deviceToken;
    data['device_type'] = this.deviceType;
    data['timezone'] = this.timezone;
    return data;
  }
}