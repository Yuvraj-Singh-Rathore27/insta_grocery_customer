class DeliveryBoyBookingModel {
  int? id;
  String? name;
  String? contactNumber;

  DeliveryBoyBookingModel({this.id, this.name, this.contactNumber});

  DeliveryBoyBookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contactNumber = json['contact_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    return data;
  }
}