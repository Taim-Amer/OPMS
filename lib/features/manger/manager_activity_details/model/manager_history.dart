// lib/features/manger/manager_home/model/manager_history_model.dart

class ManagerHistoryModel {
  final bool status;
  final List<HistoryItem> data;
  final String message;

  ManagerHistoryModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ManagerHistoryModel.fromJson(Map<String, dynamic> json) {
    return ManagerHistoryModel(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.map((item) => item.toJson()).toList(),
        'message': message,
      };
}

class HistoryItem {
  final int id;
  final int planActivityId;
  final int userId;
  final String action;
  final String comment;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final HistoryUser user;

  HistoryItem({
    required this.id,
    required this.planActivityId,
    required this.userId,
    required this.action,
    required this.comment,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as int,
      planActivityId: json['plan_activity_id'] as int,
      userId: json['user_id'] as int,
      action: json['action'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: HistoryUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plan_activity_id': planActivityId,
        'user_id': userId,
        'action': action,
        'comment': comment,
        'date': date.toIso8601String().split('T').first,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'user': user.toJson(),
      };
}

class HistoryUser {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? fcmToken;
  final int? registeredBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  HistoryUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.fcmToken,
    this.registeredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HistoryUser.fromJson(Map<String, dynamic> json) {
    return HistoryUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] as String?,
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
        'email_verified_at': emailVerifiedAt,
        'fcm_token': fcmToken,
        'registered_by': registeredBy,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
