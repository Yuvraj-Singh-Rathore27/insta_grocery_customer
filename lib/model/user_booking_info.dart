class BookingUserInfo {
  String? countryPhoneCode;
  String? email;
  String? contactNumber;
  int? id;
  List<UserProfile>? userProfile;

  BookingUserInfo(
      {this.countryPhoneCode,
        this.email,
        this.contactNumber,
        this.id,
        this.userProfile});

  BookingUserInfo.fromJson(Map<String, dynamic> json) {
    countryPhoneCode = json['country_phone_code'];
    email = json['email'];
    contactNumber = json['contact_number'];
    id = json['id'];
    if (json['user_profile'] != null && json['user_profile'] is List) {
      userProfile = <UserProfile>[];
      json['user_profile'].forEach((v) {
        userProfile!.add( UserProfile.fromJson(v));
      });
    }else if(json['user_profile'] != null){
      userProfile = <UserProfile>[];
      userProfile!.add(UserProfile.fromJson(json['user_profile']));
    }else{
      userProfile = <UserProfile>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_phone_code'] = this.countryPhoneCode;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['id'] = this.id;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserProfile {
  int? userId;
  String? firstName;
  String? lastName;
  String? whatsappNumber;
  int? id;
  Null? photoFilePath;
  int? updatedBy;

  UserProfile(
      {this.userId,
        this.firstName,
        this.lastName,
        this.whatsappNumber,
        this.id,
        this.photoFilePath,
        this.updatedBy});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    whatsappNumber = json['whatsapp_number'];
    id = json['id'];
    photoFilePath = json['photo_file_path'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['whatsapp_number'] = this.whatsappNumber;
    data['id'] = this.id;
    data['photo_file_path'] = this.photoFilePath;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}