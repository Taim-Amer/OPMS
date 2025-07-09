class LoginModel {
  bool? status;
  Data? data;
  String? message;

  LoginModel({this.status, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
}

class Data {
  String? accessToken;
  int? expiresIn;
  String? roleName;

  Data({this.accessToken, this.expiresIn, this.roleName});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    roleName = json['role_name'];
    expiresIn = json['expires_in'];
  }
}
