class DoctorEductionModel {
  int? id;
  int? doctorId;
  int? educationId;
  Education? education;

  DoctorEductionModel(
      {this.id, this.doctorId, this.educationId, this.education});

  DoctorEductionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    educationId = json['education_id'];
    education = json['education'] != null
        ? new Education.fromJson(json['education'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['education_id'] = this.educationId;
    if (this.education != null) {
      data['education'] = this.education!.toJson();
    }
    return data;
  }
}

class Education {
  String? name;
  int? id;
  String? description;

  Education({this.name, this.id, this.description});

  Education.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}
