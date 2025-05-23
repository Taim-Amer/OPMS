import 'package:skeletonizer/skeletonizer.dart';

class ReliefAssistanceModel {
  bool? status;
  List<ReliefAssistance>? data;
  String? message;

  ReliefAssistanceModel({this.status, this.data, this.message});

  ReliefAssistanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ReliefAssistance>[];
      json['data'].forEach((v) {
        data!.add(ReliefAssistance.fromJson(v));
      });
    }
    message = json['message'];
  }

  static ReliefAssistanceModel get skeleton{
    return ReliefAssistanceModel(
      data: List.generate(12, (_) => ReliefAssistance(
        description: BoneMock.name,
        type: BoneMock.name,
        date: BoneMock.name,
        unitCost: BoneMock.name,
      ))
    );
  }
}

class ReliefAssistance {
  int? id;
  String? type;
  String? description;
  String? unitCost;
  String? date;
  String? createdAt;
  String? updatedAt;

  ReliefAssistance(
      {this.id,
        this.type,
        this.description,
        this.unitCost,
        this.date,
        this.createdAt,
        this.updatedAt});

  ReliefAssistance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
    unitCost = json['unit_cost'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
