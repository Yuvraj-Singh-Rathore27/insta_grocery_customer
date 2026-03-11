class UserLocationModel {
  double? latitude;
  double? longitude;
  String? address;

  UserLocationModel({this.latitude, this.longitude, this.address});

  UserLocationModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    return data;
  }
}