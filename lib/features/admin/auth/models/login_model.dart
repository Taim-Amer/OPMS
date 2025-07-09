// lib/features/auth/models/login_model.dart
class LoginModel {
  final bool status;
  final _Data data;
  final String message;

  LoginModel({required this.status, required this.data, required this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status : json['status']  as bool,
      data   : _Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}

/// Internal data object carries token, expiry *and* role.
class _Data {
  final String accessToken;
  final int? expiresIn;
  final String roleName;

  _Data({
    required this.accessToken,
    this.expiresIn,
    required this.roleName,
  });

  factory _Data.fromJson(Map<String, dynamic> json) {
    return _Data(
      accessToken: json['access_token'] as String,
      expiresIn  : json['expires_in']   as int?,
      roleName   : json['role_name']    as String, // ← parse role
    );
  }
}
