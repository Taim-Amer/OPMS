class EquipmentsModel {
  bool? status;
  List<Data>? data;
  String? message;

  EquipmentsModel({this.status, this.data, this.message});

  EquipmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class Data {
  int? id;
  String? type;
  String? equipmentDescription;
  String? equipmentCost;
  String? date;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.type,
        this.equipmentDescription,
        this.equipmentCost,
        this.date,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    equipmentDescription = json['equipment_description'];
    equipmentCost = json['equipment_cost'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
