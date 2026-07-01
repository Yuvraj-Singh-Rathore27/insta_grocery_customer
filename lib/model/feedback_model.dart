class FeedbackTypeModel {
  int? id;
  String? name;
  String? description;
  bool? isActive;

  FeedbackTypeModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
  });

  FeedbackTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    return data;
  }
}

class FeedbackModel {
  int? id;
  int? feedbackTypeId;
  int? userId;
  String? title;
  String? description;
  int? rating;
  int? createdBy;
  int? createdById;
  int? updatedBy;
  int? updatedById;
  String? createdAt;

  FeedbackModel({
    this.id,
    this.feedbackTypeId,
    this.userId,
    this.title,
    this.description,
    this.rating,
    this.createdBy,
    this.createdById,
    this.updatedBy,
    this.updatedById,
    this.createdAt,
  });

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedbackTypeId = json['feedback_type_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    rating = json['rating'];
    createdBy = json['created_by'];
    createdById = json['created_by_id'];
    updatedBy = json['updated_by'];
    updatedById = json['updated_by_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedback_type_id'] = this.feedbackTypeId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['created_by'] = this.createdBy;
    data['created_by_id'] = this.createdById;
    data['updated_by'] = this.updatedBy;
    data['updated_by_id'] = this.updatedById;
    return data;
  }
}
