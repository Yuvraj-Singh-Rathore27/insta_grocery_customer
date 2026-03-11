
import '../state_model.dart';

class StateResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<StateModel>? data;

  StateResponseModel({this.status, this.code, this.error, this.message, this.data});

  StateResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StateModel>[];
      json['data'].forEach((v) {
        data?.add(new StateModel.fromJson(v));
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
