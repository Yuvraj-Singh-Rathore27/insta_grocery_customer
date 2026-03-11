import '../AddressModel.dart';

class AddressResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  Data? data;

  AddressResponseModel(
      {this.status, this.code, this.error, this.message, this.data});

  AddressResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Data {
  List<AddressModel>? deliveryAddress;
  int? userId;
  int? id;

  Data({this.deliveryAddress, this.userId, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['delivery_address'] != null) {
      deliveryAddress = <AddressModel>[];
      json['delivery_address'].forEach((v) {
        deliveryAddress!.add(new AddressModel.fromJson(v));
      });
    }
    userId = json['user_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deliveryAddress != null) {
      data['delivery_address'] =
          this.deliveryAddress!.map((v) => v.toJson()).toList();
    }
    data['user_id'] = this.userId;
    data['id'] = this.id;
    return data;
  }
}

