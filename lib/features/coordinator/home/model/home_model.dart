import 'package:opms/features/admin/activities/models/activities_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeModel {
  bool? status;
  List<HomeItem>? data;
  String? message;
  Meta? meta;

  HomeModel({this.status, this.data, this.message, this.meta});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    status: json['status'] as bool?,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => HomeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    message: json['message'] as String?,
    meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
  );

  static HomeModel get skeleton{
    return HomeModel(
      data: List.generate(18, (_) => HomeItem(
        name: BoneMock.fullName,
        averageHeavy: 1,
      ))
    );
}
}

class HomeItem {
  int? id;
  String? name;
  Boundary? boundary;
  int? averageHeavy;

  HomeItem({this.id, this.name, this.boundary, this.averageHeavy});

  factory HomeItem.fromJson(Map<String, dynamic> json) => HomeItem(
    id: json['id'] as int?,
    name: json['name'] as String?,
    boundary: json['boundary'] != null
        ? Boundary.fromJson(json['boundary'] as Map<String, dynamic>)
        : null,
    averageHeavy: json['average_heavy'] as int?,
  );
}

class Boundary {
  String? type;
  List<List<List<List<double>>>>? coordinates;

  Boundary({this.type, this.coordinates});

  factory Boundary.fromJson(Map<String, dynamic> json) {
    var rawCoords = json['coordinates'] as List<dynamic>?;
    List<List<List<List<double>>>>? coords;
    if (rawCoords != null) {
      coords = rawCoords
          .map((polygon) => (polygon as List<dynamic>).map((ring) {
        return (ring as List<dynamic>).map((pos) {
          var p = pos as List<dynamic>;
          // افتراض: قيم double جاهزة
          return p.map((n) => (n as num).toDouble()).toList();
        }).toList();
      }).toList())
          .toList();
    }
    return Boundary(
      type: json['type'] as String?,
      coordinates: coords,
    );
  }
}
