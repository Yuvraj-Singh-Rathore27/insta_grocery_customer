class JobTypeModel {
  int? id;
  String? name;
  String? type;
  int? categoryId;

  JobTypeModel({
    this.id,
    this.name,
    this.type,
    this.categoryId,
  });

  JobTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type']; // may be null
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'category_id': categoryId,
    };
  }
}