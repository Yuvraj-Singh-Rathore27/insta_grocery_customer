
import '../store_profile_model.dart';

class StoreDetailsResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  StoreProfileModel? data;

  StoreDetailsResponseModel({this.status, this.code, this.error, this.message, this.data});

  StoreDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? StoreProfileModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

