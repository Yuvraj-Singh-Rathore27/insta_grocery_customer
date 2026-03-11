

import 'package:insta_grocery_customer/model/slider_image_model.dart';

class SliderResponseModel {
  bool? error;
  int? code;
  int? status;
  String? message;
  List<Data>? data;

  SliderResponseModel(
      {this.error, this.code, this.status, this.message, this.data});

  SliderResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<SliderImageModel>? bannerPath;

  Data({this.bannerPath});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banner_path'] != null) {
      bannerPath = <SliderImageModel>[];
      json['banner_path'].forEach((v) {
        bannerPath!.add(new SliderImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerPath != null) {
      data['banner_path'] = this.bannerPath!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
