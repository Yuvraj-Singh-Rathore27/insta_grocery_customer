class LabInfoBookingModel {
  String? name;
  String? contactNumber;
  String? email;
  int? id;

  LabInfoBookingModel(
      {this.name,
        this.contactNumber,
        this.email,
        this.id});

  LabInfoBookingModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNumber = json['contact_number']??'';
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['email'] = this.email;
    data['id'] = this.id;
    return data;
  }
}