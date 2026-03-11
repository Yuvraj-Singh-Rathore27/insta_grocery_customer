class BaseResponse {
  int? status;
  int? code;
  bool? error;
  String? message;

  BaseResponse({this.status, this.code, this.error, this.message});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}

