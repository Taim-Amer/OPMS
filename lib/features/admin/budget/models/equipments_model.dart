import 'package:skeletonizer/skeletonizer.dart';

class EquipmentsModel {
  bool? status;
  List<Equipment>? data;
  String? message;

  EquipmentsModel({this.status, this.data, this.message});

  EquipmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Equipment>[];
      json['data'].forEach((v) {
        data!.add(Equipment.fromJson(v));
      });
    }
    message = json['message'];
  }

  static EquipmentsModel get skeleton {
    return EquipmentsModel(
      data: List.generate(20, (_) => Equipment(
      type: BoneMock.name,
      equipmentCost: BoneMock.name,
      equipmentDescription: BoneMock.name,
      date: BoneMock.name,
    )),
    );
  }
}

class Equipment {
  int? id;
  String? type;
  String? equipmentDescription;
  String? equipmentCost;
  String? date;
  String? createdAt;
  String? updatedAt;

  Equipment(
      {this.id,
        this.type,
        this.equipmentDescription,
        this.equipmentCost,
        this.date,
        this.createdAt,
        this.updatedAt});

  Equipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    equipmentDescription = json['equipment_description'];
    equipmentCost = json['equipment_cost'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
