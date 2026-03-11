class AddressModel {
  String? city;
  String? state;
  String? landmark;
  String? latitude;
  String? fullName;
  bool? isActive;
  String? longitude;
  String? addressId;
  bool? isDefault;
  String? postalCode;
  String? addressLine1;
  String? addressLine2;
  String? mobileNumber;

  AddressModel(
      {this.city,
        this.state,
        this.landmark,
        this.latitude,
        this.fullName,
        this.isActive,
        this.longitude,
        this.addressId,
        this.isDefault,
        this.postalCode,
        this.addressLine1,
        this.addressLine2,
        this.mobileNumber});

  AddressModel.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    state = json['state'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    fullName = json['full_name'];
    isActive = json['is_active'];
    longitude = json['longitude'];
    addressId = json['address_id'];
    isDefault = json['is_default'];
    postalCode = json['postal_code'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    mobileNumber = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['state'] = this.state;
    data['landmark'] = this.landmark;
    data['latitude'] = this.latitude;
    data['full_name'] = this.fullName;
    data['is_active'] = this.isActive;
    data['longitude'] = this.longitude;
    data['address_id'] = this.addressId;
    data['is_default'] = this.isDefault;
    data['postal_code'] = this.postalCode;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['mobile_number'] = this.mobileNumber;
    return data;
  }
}