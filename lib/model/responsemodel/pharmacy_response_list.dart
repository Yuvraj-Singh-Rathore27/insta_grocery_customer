import 'package:insta_grocery_customer/model/pharmacy_model.dart';

import '../DoctorModel.dart';

class PharmacyResponseModelList {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<PharmayModel>? data;

  PharmacyResponseModelList(
      {this.status, this.code, this.error, this.message, this.data});

  PharmacyResponseModelList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PharmayModel>[];
      json['data'].forEach((v) {
        data!.add(PharmayModel.fromJson(v));
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
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

