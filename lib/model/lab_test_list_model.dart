class LabTestModel {
  int? updatedById;
  String? description;
  bool? isActive;
  String? name;
  var charges;
  int? id;
  bool isSelected=false;
  PackageList ? labTest;

  LabTestModel(
      {
        this.description,
        this.isActive,
        this.name,
        this.id,
        this.charges,
        required this.isSelected, this.labTest});

  LabTestModel.fromJson(Map<String, dynamic> json) {
    updatedById = json['updated_by_id'];
    description = json['description'];
    isActive = json['is_active'];
    charges = json['charges'].toString();
    name = json['name'];
    id = json['id'];
    isSelected = json['is_selected']?? false;
    labTest = json['lab_tests'] != null ? PackageList?.fromJson(json['lab_tests']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_by_id'] = this.updatedById;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['id'] = this.id;
    data['is_selected'] = this.isSelected;
    data['charges'] = this.charges;
    data['lab_tests'] = this.labTest;
    return data;
  }
}

class PackageList {
  String? name;

  PackageList({this.name});

  PackageList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}


