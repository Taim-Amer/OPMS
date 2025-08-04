// lib/features/planner/planner_home/models/activities_model.dart

class PlannerActivitiesModel {
  // Common
  final int id;
  final String code;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Reserved-only
  final int? activityId;
  final String? yearOfImplementation;
  final int? numberOfYearsToImplementation;
  final String? projectImplementationStatus;
  final String? statusBy;
  final String? comment;
  final int? createdBy;
  final String? status;

  // Unreserved-only
  final int? outputId;

  /// True if fetched with `is_reserved=1`
  final bool isReserved;

  PlannerActivitiesModel({
    required this.id,
    required this.code,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.activityId,
    this.yearOfImplementation,
    this.numberOfYearsToImplementation,
    this.projectImplementationStatus,
    this.statusBy,
    this.comment,
    this.createdBy,
    this.status,
    this.outputId,
    required this.isReserved,
  });

  /// Parses either the “reserved” or “unreserved” JSON into a single model.
  factory PlannerActivitiesModel.fromJson(
    Map<String, dynamic> json, {
    required bool reserved,
  }) {
    DateTime? _tryParse(String? s) {
      if (s == null) return null;
      try {
        return DateTime.tryParse(s);
      } catch (_) {
        return null;
      }
    }

    if (reserved) {
      final act = json['activity'] as Map<String, dynamic>? ?? {};
      return PlannerActivitiesModel(
        isReserved: true,
        id: json['id'] as int? ?? 0,
        activityId: json['activity_id'] as int? ?? 0,
        yearOfImplementation: json['year_of_implementation'] as String?,
        numberOfYearsToImplementation:
            json['number_of_years_to_implementation'] as int?,
        projectImplementationStatus:
            json['project_implementation_status'] as String?,
        statusBy:
            json['status_by']?.toString(),
        comment: json['comment'] as String? ?? '',
        createdBy: json['created_by'] as int?,
        createdAt: _tryParse(json['created_at'] as String?),
        updatedAt: _tryParse(json['updated_at'] as String?),
        // from nested "activity"
        code: act['code'] as String? ?? '',
        name: act['name'] as String? ?? '',
        outputId: act['output_id'] as int?,
        // nested timestamps
        // (we ignore nested created_at/updated_at here since top-level is more relevant)
        status: json['status'] as String? ?? '',
      );
    } else {
      // unreserved
      return PlannerActivitiesModel(
        isReserved: false,
        id: json['id'] as int? ?? 0,
        outputId: json['output_id'] as int?,
        name: json['name'] as String? ?? '',
        code: json['code'] as String? ?? '',
        createdAt: _tryParse(json['created_at'] as String?),
        updatedAt: _tryParse(json['updated_at'] as String?),
        // reserved-only get null
        activityId: null,
        yearOfImplementation: null,
        numberOfYearsToImplementation: null,
        projectImplementationStatus: null,
        statusBy: null,
        comment: null,
        createdBy: null,
        status: 'available',
      );
    }
  }
}
