class ForgetOtpRespone {

  int? status;
  int? otp;
  String? message;
  bool ?error ;

  ForgetOtpRespone({this.status, this.otp, this.message, this.error});

  ForgetOtpRespone.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otp = json['otp'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}