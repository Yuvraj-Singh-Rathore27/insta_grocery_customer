class BookingPharmacyInfoModel {
  String? name;
  String? contactNumber;
  Null? googleAddress;
  String? email;
  int? id;

  BookingPharmacyInfoModel(
      {this.name, this.contactNumber, this.googleAddress, this.email, this.id});

  BookingPharmacyInfoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNumber = json['contact_number'];
    googleAddress = json['google_address'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['google_address'] = this.googleAddress;
    data['email'] = this.email;
    data['id'] = this.id;
    return data;
  }
}