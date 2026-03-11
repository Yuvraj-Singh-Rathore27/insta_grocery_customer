

import '../base/BaseModel.dart';

class JobModel extends BaseModel {
  String? jobID;
  String? jobName;
  String? expectedServiceDate;
  String? jobAddress;
  String? jobCity;
  String? remarks;
  String? status;
  String? completionTime;

  JobModel(
      {this.jobID,
      this.jobName,
      this.expectedServiceDate,
      this.jobAddress,
      this.jobCity,
      this.remarks,
      this.status,
      this.completionTime});

  JobModel.fromJson(Map<String, dynamic> json) {
    jobID = json['job_ID'];
    jobName = json['job_name'];
    expectedServiceDate = json['expected_service_date'];
    jobAddress = json['job_address'];
    jobCity = json['job_city'];
    remarks = json['remarks'];
    status = json['status'];
    completionTime = json['completion_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_ID'] = this.jobID;
    data['job_name'] = this.jobName;
    data['expected_service_date'] = this.expectedServiceDate;
    data['job_address'] = this.jobAddress;
    data['job_city'] = this.jobCity;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    data['completion_time'] = this.completionTime;
    return data;
  }
}
