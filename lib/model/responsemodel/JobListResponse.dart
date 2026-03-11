import '../JobModel.dart';

class JobListResponse {
  int? status;
  List<JobModel>? job;
  String? message;
  String? baseUrl;

  JobListResponse({this.status, this.job, this.message, this.baseUrl});

  JobListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['job'] != null) {
      job = <JobModel>[];
      json['job'].forEach((v) {
        job!.add(new JobModel.fromJson(v));
      });
    }
    message = json['message'];
    baseUrl = json['base_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.job != null) {
      data['job'] = this.job!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['base_url'] = this.baseUrl;
    return data;
  }
}
