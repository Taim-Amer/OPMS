// lib/features/manger/manager_home/model/manager_active_activities_model.dart

class ManagerActiveActivitiesModel {
  final bool status;
  final List<MaActiveActivity> data;
  final String message;

  ManagerActiveActivitiesModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ManagerActiveActivitiesModel.fromJson(Map<String, dynamic> json) {
    return ManagerActiveActivitiesModel(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => MaActiveActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
    );
  }
}

class MaActiveActivity {
  final int id;
  final int activityId;
  final String yearOfImplementation;
  final int numberOfYearsToImplementation;
  final String projectImplementationStatus;
  final int statusBy;
  final String comment;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ActivityDetail activity;
  final String status;

  MaActiveActivity({
    required this.id,
    required this.activityId,
    required this.yearOfImplementation,
    required this.numberOfYearsToImplementation,
    required this.projectImplementationStatus,
    required this.statusBy,
    required this.comment,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.activity,
    required this.status,
  });

  factory MaActiveActivity.fromJson(Map<String, dynamic> json) {
    return MaActiveActivity(
      id: json['id'] as int,
      activityId: json['activity_id'] as int,
      yearOfImplementation: json['year_of_implementation'] as String,
      numberOfYearsToImplementation:
          json['number_of_years_to_implementation'] as int,
      projectImplementationStatus:
          json['project_implementation_status'] as String,
      statusBy: json['status_by'] as int,
      comment: json['comment'] as String,
      createdBy: json['created_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      activity:
          ActivityDetail.fromJson(json['activity'] as Map<String, dynamic>),
      status: json['status'] as String,
    );
  }
}

class ActivityDetail {
  final int id;
  final int outputId;
  final String name;
  final String code;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityDetail({
    required this.id,
    required this.outputId,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityDetail.fromJson(Map<String, dynamic> json) {
    return ActivityDetail(
      id: json['id'] as int,
      outputId: json['output_id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
