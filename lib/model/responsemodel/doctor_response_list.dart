import '../DoctorModel.dart';

class DoctorResponseModelList {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<DoctorModel>? data;

  DoctorResponseModelList(
      {this.status, this.code, this.error, this.message, this.data});

  DoctorResponseModelList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DoctorModel>[];
      json['data'].forEach((v) {
        data!.add(DoctorModel.fromJson(v));
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

