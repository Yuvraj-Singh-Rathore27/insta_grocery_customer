
import 'package:insta_grocery_customer/model/pharmacy_booking_info.dart';
import 'package:insta_grocery_customer/model/product_order_model.dart';

import 'delivery_boy_booking_model.dart';
import 'lab_booking_lab_info_model.dart';
import 'user_booking_info.dart';

class LabBookingModel {
  int? id;
  String? prescription;
  int? updatedById;
  bool? isActive;
  var invoice;
  String? createdAt;
  bool? isDeleted;
  bool? homeDelivery;
  bool? cashOnDelivery;
  int? updatedBy;
  var paymentMode;
  var amount;
  int? userId;
  var deliveryStatus;
  int? pharmacyId;
  StatusType? statusType;
  BookingUserInfo? bookingUserInfo;
  BookingPharmacyInfoModel? pharmacyInfo;
  List<ProductOrderModel>? products;
  DeliveryBoyBookingModel ? deliveryBoyBookingModel;
  LabInfoBookingModel ? laboratory;

  LabBookingModel(
      {this.id,
        this.prescription,
        this.updatedById,
        this.isActive,
        this.invoice,
        this.isDeleted,
        this.homeDelivery,
        this.cashOnDelivery,
        this.updatedBy,
        this.paymentMode,
        this.userId,
        this.deliveryStatus,
        this.pharmacyId,
        this.statusType,
        this.bookingUserInfo,
        this.pharmacyInfo,
        this.amount,
        this.deliveryBoyBookingModel,
        this.laboratory,
        this.products,
        this.createdAt,
      });

  LabBookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescription = json['prescription']??'';
    updatedById = json['updated_by_id'];
    isActive = json['is_active'];
    invoice = json['invoice'];
    isDeleted = json['is_deleted'];
    homeDelivery = json['home_delivery'];
    cashOnDelivery = json['cash_on_delivery'];
    updatedBy = json['updated_by'];
    paymentMode = json['payment_mode'];
    amount = json['amount']??"";
    userId = json['user_id'];
    deliveryStatus = json['delivery_status'];
    pharmacyId = json['pharmacy_id'];
    createdAt = json['created_at'];
    statusType = json['status_type'] != null
        ? new StatusType.fromJson(json['status_type'])
        : null;
    bookingUserInfo = json['users'] != null
        ?  BookingUserInfo.fromJson(json['users'])
        : null;
    pharmacyInfo = json['pharmacy'] != null
        ?  BookingPharmacyInfoModel.fromJson(json['pharmacy'])
        : null;

      if (json['products'] != null) {
        products = <ProductOrderModel>[];
        json['products'].forEach((v) {
          products!.add( ProductOrderModel.fromJson(v));
        });
      }else{
        products = <ProductOrderModel>[];
      }
    deliveryBoyBookingModel= json['delivery'] != null
        ?  DeliveryBoyBookingModel.fromJson(json['delivery'])
        : null;
    laboratory= json['laboratory'] != null
        ?  LabInfoBookingModel.fromJson(json['laboratory'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prescription'] = this.prescription;
    data['updated_by_id'] = this.updatedById;
    data['is_active'] = this.isActive;
    data['invoice'] = this.invoice;
    data['is_deleted'] = this.isDeleted;
    data['home_delivery'] = this.homeDelivery;
    data['cash_on_delivery'] = this.cashOnDelivery;
    data['updated_by'] = this.updatedBy;
    data['payment_mode'] = this.paymentMode;
    data['user_id'] = this.userId;
    data['delivery_status'] = this.deliveryStatus;
    data['pharmacy_id'] = this.pharmacyId;
    if (this.statusType != null) {
      data['status_type'] = this.statusType!.toJson();
    }
    if (this.bookingUserInfo != null) {
      data['users'] = this.bookingUserInfo!.toJson();
    }
    if (this.pharmacyInfo != null) {
      data['pharmacy'] = this.pharmacyInfo!.toJson();
    }


    return data;
  }
}

class StatusType {
  int? id;
  String? name;

  StatusType({this.id, this.name});

  StatusType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  String getStatus(){
    return name??'';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}