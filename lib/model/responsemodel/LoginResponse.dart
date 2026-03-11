import '../UserModel.dart';

class LoginRespone {
  int? status;
  bool ? error;
  String? message;
  String? tokenType;
  int? expiresIn;
  UserModel? user;
  String? baseUrl;

  LoginRespone(
      {this.status,
      this.error,
      this.message,
      this.tokenType,
      this.expiresIn,
      this.user,
      this.baseUrl});

  LoginRespone.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? UserModel.fromMap(json['user']) : null;
    baseUrl = json['base_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['base_url'] = this.baseUrl;
    return data;
  }
}

