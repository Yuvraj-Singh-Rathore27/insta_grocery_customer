import '../common_model.dart';

class CommonResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<CommonModel>? data;

  CommonResponseModel({this.status, this.code, this.error, this.message, this.data});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommonModel>[];
      json['data'].forEach((v) {
        data?.add(new CommonModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
