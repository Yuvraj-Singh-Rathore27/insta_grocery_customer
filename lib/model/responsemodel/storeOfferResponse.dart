import '../storeOfferModel.dart';

class StoreOfferResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  List<StoreOfferModel>? data;

  StoreOfferResponseModel({
    this.status,
    this.code,
    this.error,
    this.message,
    this.data,
  });

  StoreOfferResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];

    // ✅ SAME LOGIC AS YOUR STATE RESPONSE
    if (json['data'] is List) {
      data = <StoreOfferModel>[];
      json['data'].forEach((v) {
        data?.add(StoreOfferModel.fromJson(v));
      });
    } else if (json['data'] is Map) {
      data = [StoreOfferModel.fromJson(json['data'])];
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
