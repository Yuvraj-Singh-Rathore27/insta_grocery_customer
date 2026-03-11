import 'package:insta_grocery_customer/model/common_model_new.dart';

import '../common_model.dart';

class CommonResponseModelNew {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<CommonModelNew>? data;

  CommonResponseModelNew({this.status, this.code, this.error, this.message, this.data});

  CommonResponseModelNew.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommonModelNew>[];
      json['data'].forEach((v) {
        data?.add(new CommonModelNew.fromJson(v));
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
