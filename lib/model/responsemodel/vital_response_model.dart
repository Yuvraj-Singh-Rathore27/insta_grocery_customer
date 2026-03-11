import 'package:insta_grocery_customer/model/daily_vital_model.dart';
import 'package:insta_grocery_customer/model/lab_report_model.dart';

class VitalResponseModel {
  int? status;
  int? code;
  bool? error;
  String? message;
  Data? data;

  VitalResponseModel(
      {this.status, this.code, this.error, this.message, this.data});

  VitalResponseModel.fromJson(Map<String, dynamic> json) {
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
  bool? isActive;
  var  height;
  var bmi;
  var weight;
  String? bmiStatus;
  Vitals? vitals;
  LabReports? labReports;

  Data(
      {this.isActive,
        this.height,
        this.bmi,
        this.weight,
        this.bmiStatus,
        this.vitals,
        this.labReports});

  Data.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    height = json['height']==null??'';
    bmi = json['bmi']==null??'';
    weight = json['weight']==null??'';
    bmiStatus = json['bmi_status'];
    vitals =
    json['vitals'] != null ? new Vitals.fromJson(json['vitals']) : null;
    labReports = json['lab_reports'] != null
        ? new LabReports.fromJson(json['lab_reports'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active'] = this.isActive;
    data['height'] = this.height;
    data['bmi'] = this.bmi;
    data['weight'] = this.weight;
    data['bmi_status'] = this.bmiStatus;
    if (this.vitals != null) {
      data['vitals'] = this.vitals!.toJson();
    }
    if (this.labReports != null) {
      data['lab_reports'] = this.labReports!.toJson();
    }
    return data;
  }
}

class Vitals {
  List<DailyVitals>? dailyVitals;

  Vitals({this.dailyVitals});

  Vitals.fromJson(Map<String, dynamic> json) {
    if (json['daily_vitals'] != null) {
      dailyVitals = <DailyVitals>[];
      json['daily_vitals'].forEach((v) {
        dailyVitals!.add(new DailyVitals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dailyVitals != null) {
      data['daily_vitals'] = this.dailyVitals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class LabReports {
  List<LabReportDetails>? labReportDetails;

  LabReports({this.labReportDetails});

  LabReports.fromJson(Map<String, dynamic> json) {
    if (json['lab_report_details'] != null) {
      labReportDetails = <LabReportDetails>[];
      json['lab_report_details'].forEach((v) {
        labReportDetails!.add(new LabReportDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.labReportDetails != null) {
      data['lab_report_details'] =
          this.labReportDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

