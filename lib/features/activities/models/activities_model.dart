class ActivitiesModel {
  final bool status;
  final List<Activity> data;
  final String message;
  final Meta meta;

  ActivitiesModel({
    required this.status,
    required this.data,
    required this.message,
    required this.meta,
  });

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) {
    return ActivitiesModel(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'] as String,
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data.map((e) => e.toJson()).toList(),
        'message': message,
        'meta': meta.toJson(),
      };
}

class Activity {
  final int id;
  final int outputId;
  final String name;
  final String code;
  final DateTime createdAt;
  final DateTime updatedAt;

  Activity({
    required this.id,
    required this.outputId,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int,
      outputId: json['output_id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'output_id': outputId,
        'name': name,
        'code': code,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      total: json['total'] as int,
      perPage: json['per_page'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'total': total,
        'per_page': perPage,
      };
}
