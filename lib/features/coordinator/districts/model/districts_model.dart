import 'package:opms/features/admin/activities/models/activities_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DistrictsModel {
  final bool? status;
  final List<GovernorateArea>? data;
  final String? message;
  Meta? meta;

  DistrictsModel({
    this.status,
    this.data,
    this.meta,
    this.message,
  });

  factory DistrictsModel.fromJson(Map<String, dynamic> json) {
    return DistrictsModel(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => GovernorateArea.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (status != null) 'status': status,
      if (data != null) 'data': data!.map((area) => area.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }

  static DistrictsModel get skeleton {
    return DistrictsModel(
      status: null,
      message: null,
      data: List<GovernorateArea>.generate(
        18,
            (_) => GovernorateArea(
          id: null,
          governorateId: null,
          name: BoneMock.name,
          boundary: Boundary(
            // type: BoneMock.word,
            // generate a simple empty multipolygon
            coordinates: [],
          ),
          createdAt: null,
          updatedAt: null,
        ),
      ),
    );
  }
}

class GovernorateArea {
  final int? id;
  final int? governorateId;
  final String? name;
  final Boundary? boundary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GovernorateArea({
    this.id,
    this.governorateId,
    this.name,
    this.boundary,
    this.createdAt,
    this.updatedAt,
  });

  factory GovernorateArea.fromJson(Map<String, dynamic> json) {
    return GovernorateArea(
      id: json['id'] as int?,
      governorateId: json['governorate_id'] as int?,
      name: json['name'] as String?,
      boundary: json['boundary'] != null
          ? Boundary.fromJson(json['boundary'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (governorateId != null) 'governorate_id': governorateId,
      if (name != null) 'name': name,
      if (boundary != null) 'boundary': boundary!.toJson(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

class Boundary {
  final String? type;
  // MultiPolygon: List of polygons, each polygon is List of rings, each ring is List of points, each point is List<double>[lng, lat]
  final List<List<List<List<double>>>>? coordinates;

  Boundary({
    this.type,
    this.coordinates,
  });

  factory Boundary.fromJson(Map<String, dynamic> json) {
    return Boundary(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map<List<List<List<double>>>>((polygons) => (polygons as List<dynamic>)
          .map<List<List<double>>>((rings) => (rings as List<dynamic>)
          .map<List<double>>((points) => (points as List<dynamic>)
          .map<double>((coord) => (coord as num).toDouble())
          .toList())
          .toList())
          .toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (coordinates != null) 'coordinates': coordinates,
    };
  }
}