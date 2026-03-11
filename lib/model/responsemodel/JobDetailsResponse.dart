
import '../JobTasksModel.dart';

class JobDetailsResponse {
  int? status;
  List<JobTasksModel>? jobTasks;
  String? message;
  String? baseUrl;

  JobDetailsResponse({this.status, this.jobTasks, this.message, this.baseUrl});

  JobDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['job_tasks'] != null) {
      jobTasks = <JobTasksModel>[];
      json['job_tasks'].forEach((v) {
        jobTasks!.add(new JobTasksModel.fromJson(v));
      });
    }
    message = json['message'];
    baseUrl = json['base_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.jobTasks != null) {
      data['job_tasks'] = this.jobTasks!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['base_url'] = this.baseUrl;
    return data;
  }

}