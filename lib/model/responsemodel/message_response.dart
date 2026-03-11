import 'package:insta_grocery_customer/model/message_model.dart';

class MessageResonse {
  bool? error;
  int? code;
  int? status;
  String? message;
  List<Data>? data;

  MessageResonse({this.error, this.code, this.status, this.message, this.data});

  MessageResonse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? updatedBy;
  String? providerType;
  Content? content;
  bool? providerRead;
  int? id;
  bool? isDeleted;
  String? updatedAt;
  int? createdById;
  int? providerId;
  int? updatedById;
  bool? userRead;
  Null? attachmentPath;
  bool? isActive;
  String? createdAt;
  int? createdBy;

  Data(
      {this.userId,
        this.updatedBy,
        this.providerType,
        this.content,
        this.providerRead,
        this.id,
        this.isDeleted,
        this.updatedAt,
        this.createdById,
        this.providerId,
        this.updatedById,
        this.userRead,
        this.attachmentPath,
        this.isActive,
        this.createdAt,
        this.createdBy});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    updatedBy = json['updated_by'];
    providerType = json['provider_type'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    providerRead = json['provider_read'];
    id = json['id'];
    isDeleted = json['is_deleted'];
    updatedAt = json['updated_at'];
    createdById = json['created_by_id'];
    providerId = json['provider_id'];
    updatedById = json['updated_by_id'];
    userRead = json['user_read'];
    attachmentPath = json['attachment_path'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['updated_by'] = this.updatedBy;
    data['provider_type'] = this.providerType;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    data['provider_read'] = this.providerRead;
    data['id'] = this.id;
    data['is_deleted'] = this.isDeleted;
    data['updated_at'] = this.updatedAt;
    data['created_by_id'] = this.createdById;
    data['provider_id'] = this.providerId;
    data['updated_by_id'] = this.updatedById;
    data['user_read'] = this.userRead;
    data['attachment_path'] = this.attachmentPath;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    return data;
  }
}

class Content {
  List<Message>? messages;

  Content({this.messages});

  Content.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
