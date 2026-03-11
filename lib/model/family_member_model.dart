import 'common_model.dart';

class FamilyMemberModel {
  int? relationshipId;
  String? lastName;
  int? updatedBy;
  int? id;
  String? birthDate;
  int? updatedById;
  bool? isActive;
  String? firstName;
  String? relationShipName;
  String? gender;
  bool? isDeleted;
  Null? photoFilePath;
  int? userId;
  int? bloodGroupId;
  CommonModel ? relationship;

  FamilyMemberModel(
      {this.relationshipId,
        this.lastName,
        this.updatedBy,
        this.id,
        this.birthDate,
        this.updatedById,
        this.isActive,
        this.firstName,
        this.relationShipName,
        this.gender,
        this.isDeleted,
        this.photoFilePath,
        this.userId,
        this.bloodGroupId,
        this.relationship,

      });

  FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    relationshipId = json['relationship_id'];
    lastName = json['last_name'];
    updatedBy = json['updated_by'];
    id = json['id'];
    birthDate = json['birth_date'];
    updatedById = json['updated_by_id'];
    isActive = json['is_active'];
    firstName = json['first_name'];
    relationShipName = json['relationShipName'] ?? '';
    gender = json['gender'];
    isDeleted = json['is_deleted'];
    photoFilePath = json['photo_file_path'];
    userId = json['user_id'];
    bloodGroupId = json['blood_group_id'];
    relationship = json['relationship'] != null ? CommonModel.fromJson(json['relationship']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relationship_id'] = this.relationshipId;
    data['last_name'] = this.lastName;
    data['updated_by'] = this.updatedBy;
    data['id'] = this.id;
    data['birth_date'] = this.birthDate;
    data['updated_by_id'] = this.updatedById;
    data['is_active'] = this.isActive;
    data['first_name'] = this.firstName;
    data['gender'] = this.gender;
    data['is_deleted'] = this.isDeleted;
    data['photo_file_path'] = this.photoFilePath;
    data['user_id'] = this.userId;
    data['blood_group_id'] = this.bloodGroupId;
    data['relationship'] = this.relationship;
    return data;
  }
}