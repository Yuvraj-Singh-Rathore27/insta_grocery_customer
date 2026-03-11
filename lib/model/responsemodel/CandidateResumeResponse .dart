import '../candidate_resume_model.dart';
class CandidateResumeResponse {
  bool? error;
  int? code;
  int? status;
  String? message;
  List<CandidateData>? data;

  int? total;
  int? page;
  int? size;
  int? pages;
  dynamic nextPage;
  dynamic previousPage;

  CandidateResumeResponse({
    this.error,
    this.code,
    this.status,
    this.message,
    this.data,
    this.total,
    this.page,
    this.size,
    this.pages,
    this.nextPage,
    this.previousPage,
  });

  CandidateResumeResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    code = json['code'];
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      data = <CandidateData>[];
      json['data'].forEach((v) {
        data!.add(CandidateData.fromJson(v));
      });
    }

    total = json['total'];
    page = json['page'];
    size = json['size'];
    pages = json['pages'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }
}
