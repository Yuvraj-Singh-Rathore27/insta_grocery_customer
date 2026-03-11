import '../customer_event_model.dart';

class CustomerEventResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<CustomerEventModel>? data;

  CustomerEventResponseModel({
    this.status,
    this.code,
    this.error,
    this.message,
    this.data,
  });

  CustomerEventResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];

    // SAME LOGIC LIKE YOUR StoreOfferResponseModel
    if (json['data'] is List) {
      data = <CustomerEventModel>[];
      json['data'].forEach((v) {
        data?.add(CustomerEventModel.fromJson(v));
      });
    } else if (json['data'] is Map) {
      data = [CustomerEventModel.fromJson(json['data'])];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['code'] = code;
    json['error'] = error;
    json['message'] = message;

    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}
