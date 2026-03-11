
import '../common_model.dart';

class SubCategoryResponse {
  bool? error;
  int? code;
  int? status;
  String? message;
  List<CommonModel>? data;

  SubCategoryResponse(
      {this.error, this.code, this.status, this.message, this.data});

  SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommonModel>[];
      json['data'].forEach((v) {
        data!.add(new CommonModel.fromJson(v));
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

