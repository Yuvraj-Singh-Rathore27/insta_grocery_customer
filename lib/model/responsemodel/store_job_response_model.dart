import '../store_job_model.dart';

class JobListResponse {
  int? status;
  String? message;
  String? baseUrl;

  List<JobListingModel>? jobListing;

  JobListResponse({
    this.status,
    this.message,
    this.baseUrl,
    this.jobListing,
  });

  JobListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    baseUrl = json['base_url'];

    if (json['data'] != null) {
      jobListing = <JobListingModel>[];
      for (var v in json['data']) {
        jobListing!.add(JobListingModel.fromJson(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    data['base_url'] = baseUrl;

    if (jobListing != null) {
      data['data'] = jobListing!.map((e) => e.toJson()).toList();
    }

    return data;
  }
}
