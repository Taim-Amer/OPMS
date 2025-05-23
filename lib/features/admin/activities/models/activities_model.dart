import 'package:skeletonizer/skeletonizer.dart';

class ActivitiesModel {
  final bool? status;
  final List<Activity>? data;
  final String? message;
  final Meta? meta;

  ActivitiesModel({
    this.status,
    this.data,
    this.message,
    this.meta,
  });

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) {
    return ActivitiesModel(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  static ActivitiesModel get skeleton {
    return ActivitiesModel(
      data: List.generate(12, (index) => Activity(
        code: BoneMock.name,
        name: BoneMock.fullName,
      )),
      meta: Meta(
        total: 0,
        currentPage: 0,
        lastPage: 0,
        perPage: 0
      )
    );
  }
}

class Activity {
  final int? id;
  final int? outputId;
  final String? name;
  final String? code;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Activity({
    this.id,
    this.outputId,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      outputId: json['output_id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}

class Meta {
  final int? currentPage;
  final int? lastPage;
  final int? total;
  final int? perPage;

  Meta({
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      total: json['total'] as int?,
      perPage: json['per_page'] as int?,
    );
  }
}
