// lib/features/manger/manager_home/model/manager_user.dart

class ManagerUser {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? fcmToken;
  final int? registeredBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ManagerUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.fcmToken,
    this.registeredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ManagerUser.fromJson(Map<String, dynamic> json) {
    DateTime? tryParse(String? s) => s == null ? null : DateTime.parse(s);

    return ManagerUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: tryParse(json['email_verified_at'] as String?),
      fcmToken: json['fcm_token'] as String?,
      registeredBy: json['registered_by'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'email_verified_at': emailVerifiedAt?.toIso8601String(),
        'fcm_token': fcmToken,
        'registered_by': registeredBy,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
