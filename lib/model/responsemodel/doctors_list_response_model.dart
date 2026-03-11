

import 'package:insta_grocery_customer/model/DoctorListModel.dart';

class DoctorsResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<DoctorModelList>? data;

  DoctorsResponseModel({
    this.status,
    this.code,
    this.error,
    this.message,
    this.data,
  });

  DoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DoctorModelList>[];
      json['data'].forEach((v) {
        data!.add(DoctorModelList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['code'] = code;
    map['error'] = error;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v?.toJson()).toList();
    }
    return map;
  }
}
