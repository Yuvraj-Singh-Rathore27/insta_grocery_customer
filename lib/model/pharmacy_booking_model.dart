class PharmacyDetailsBookingModel {
  String? name;
  String? contactNumber;
  String? email;
  int? id;
  var latitude;
  var longitude;

  PharmacyDetailsBookingModel(
      {this.name,
        this.contactNumber,
        this.email,
        this.latitude,
        this.longitude,


        this.id});

  PharmacyDetailsBookingModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNumber = json['contact_number']??'';
    email = json['email'];
    latitude = json['latitude']??0.0;
    longitude = json['longitude']??0.0;
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['email'] = this.email;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['id'] = this.id;
    return data;
  }
}