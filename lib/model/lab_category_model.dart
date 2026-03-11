class LabCatgoryModel {
  bool? isActive;
  String? name;
  String? categoryType;
  int? id;
  String? description;

  LabCatgoryModel(
      {this.isActive, this.name, this.categoryType, this.id, this.description});

  LabCatgoryModel.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    name = json['name'];
    categoryType = json['category_type'];
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['category_type'] = this.categoryType;
    data['id'] = this.id;
    data['description'] = this.description;
    return data;
  }
}