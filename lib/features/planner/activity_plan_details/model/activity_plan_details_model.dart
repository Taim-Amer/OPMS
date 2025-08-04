// lib/features/planner/planner_home/model/activity_plan_details_model.dart

class ActivityPlanDetailsModel {
  final bool status;
  final ActivityPlanData? data;
  final String? message;
  final List<dynamic>? meta;

  ActivityPlanDetailsModel({
    required this.status,
    this.data,
    this.message,
    this.meta,
  });

  factory ActivityPlanDetailsModel.fromJson(Map<String, dynamic> json) {
    return ActivityPlanDetailsModel(
      status: json['status'] as bool? ?? false,
      data: json['data'] != null
          ? ActivityPlanData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      meta: (json['meta'] as List<dynamic>?) ?? <dynamic>[],
    );
  }
}

class ActivityPlanData {
  final int id;
  final int activityId;
  final String? yearOfImplementation;
  final int? numberOfYearsToImplementation;
  final String? projectImplementationStatus;
  final String? programUserStatus;
  final String? managerStatus;
  final String? directorStatus;
  final String? statusBy;
  final String? comment;
  final User? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ActivityInfo? activity;
  final String? totalCost;
  final bool? isEditable;

  ActivityPlanData(
      {required this.id,
      required this.activityId,
      this.yearOfImplementation,
      this.numberOfYearsToImplementation,
      this.projectImplementationStatus,
      this.programUserStatus,
      this.managerStatus,
      this.directorStatus,
      this.statusBy,
      this.comment,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.activity,
      this.totalCost,
      this.isEditable});

  factory ActivityPlanData.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return ActivityPlanData(
        id: json['id'] as int? ?? 0,
        activityId: json['activity_id'] as int? ?? 0,
        yearOfImplementation: json['year_of_implementation'] as String?,
        numberOfYearsToImplementation:
            json['number_of_years_to_implementation'] as int?,
        projectImplementationStatus:
            json['project_implementation_status'] as String?,
        programUserStatus: json['program_user_status'] as String?,
        managerStatus: json['manager_status'] as String?,
        directorStatus: json['director_status'] as String?,
        statusBy: json['status_by']?.toString(),
        comment: json['comment'] as String?,
        createdBy: json['created_by'] != null
            ? User.fromJson(json['created_by'] as Map<String, dynamic>)
            : null,
        createdAt: _parseDate(json['created_at'] as String?),
        updatedAt: _parseDate(json['updated_at'] as String?),
        activity: json['activity'] != null
            ? ActivityInfo.fromJson(json['activity'] as Map<String, dynamic>)
            : null,
        totalCost: json['total_cost'] as String?,
        isEditable: json['is_editable'] ?? false);
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? fcmToken;
  final dynamic registeredBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.fcmToken,
    this.registeredBy,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emailVerifiedAt: _parseDate(json['email_verified_at'] as String?),
      fcmToken: json['fcm_token'] as String?,
      registeredBy: json['registered_by'],
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
    );
  }
}

class ActivityInfo {
  final int id;
  final int outputId;
  final String name;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OutputInfo? output;

  ActivityInfo({
    required this.id,
    required this.outputId,
    required this.name,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.output,
  });

  factory ActivityInfo.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return ActivityInfo(
      id: json['id'] as int? ?? 0,
      outputId: json['output_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
      output: json['output'] != null
          ? OutputInfo.fromJson(json['output'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OutputInfo {
  final int id;
  final int outcomeId;
  final String name;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Outcome? outcome;
  final List<Indicator> indicators;

  OutputInfo({
    required this.id,
    required this.outcomeId,
    required this.name,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.outcome,
    required this.indicators,
  });

  factory OutputInfo.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    final rawInd = (json['indicators'] as List<dynamic>?) ?? <dynamic>[];
    final indList = rawInd
        .cast<Map<String, dynamic>>()
        .map((m) => Indicator.fromJson(m))
        .toList();

    return OutputInfo(
      id: json['id'] as int? ?? 0,
      outcomeId: json['outcome_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
      outcome: json['outcome'] != null
          ? Outcome.fromJson(json['outcome'] as Map<String, dynamic>)
          : null,
      indicators: indList,
    );
  }
}

class Outcome {
  final int id;
  final String name;
  final int unitId;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Unit? unit;

  Outcome({
    required this.id,
    required this.name,
    required this.unitId,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.unit,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return Outcome(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      unitId: json['unit_id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
      unit: json['unit'] != null
          ? Unit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Unit {
  final int id;
  final int departmentId;
  final String name;
  final String type;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Department? department;

  Unit({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.type,
    required this.code,
    this.createdAt,
    this.updatedAt,
    this.department,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return Unit(
      id: json['id'] as int? ?? 0,
      departmentId: json['department_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      code: json['code'] as String? ?? '',
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
      department: json['department'] != null
          ? Department.fromJson(json['department'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Department {
  final int id;
  final String name;
  final String code;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return Department(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
    );
  }
}

class Indicator {
  final int id;
  final int outputId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Indicator({
    required this.id,
    required this.outputId,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Indicator.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(String? s) => s == null ? null : DateTime.tryParse(s);

    return Indicator(
      id: json['id'] as int? ?? 0,
      outputId: json['output_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      createdAt: _parseDate(json['created_at'] as String?),
      updatedAt: _parseDate(json['updated_at'] as String?),
    );
  }
}
