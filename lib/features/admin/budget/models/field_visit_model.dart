import 'package:skeletonizer/skeletonizer.dart';

class FieldVisitModel {
  bool? status;
  List<FieldVisit>? data;
  String? message;

  FieldVisitModel({this.status, this.data, this.message});

  FieldVisitModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FieldVisit>[];
      json['data'].forEach((v) {
        data!.add(FieldVisit.fromJson(v));
      });
    }
    message = json['message'];
  }

  static FieldVisitModel get skeleton{
    return FieldVisitModel(
      data: List.generate(20, (_) => FieldVisit(
        date: BoneMock.name,
        description: BoneMock.name,
      ))
    );
  }
}

class FieldVisit {
  int? id;
  String? unitType;
  String? description;
  String? unitPrice;
  String? date;
  String? createdAt;
  String? updatedAt;

  FieldVisit(
      {this.id,
        this.unitType,
        this.description,
        this.unitPrice,
        this.date,
        this.createdAt,
        this.updatedAt});

  FieldVisit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitType = json['unit_type'];
    description = json['description'];
    unitPrice = json['unit_price'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
