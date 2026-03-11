class JobTasksModel {
  int? id;
  String? templateId;
  String? elementName;
  String? completionTime;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? templateName;

  JobTasksModel(
      {this.id,
        this.templateId,
        this.elementName,
        this.completionTime,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.templateName});

  JobTasksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    templateId = json['template_id'];
    elementName = json['element_name'];
    completionTime = json['completion_time'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    templateName = json['template_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['template_id'] = this.templateId;
    data['element_name'] = this.elementName;
    data['completion_time'] = this.completionTime;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['template_name'] = this.templateName;
    return data;
  }
}