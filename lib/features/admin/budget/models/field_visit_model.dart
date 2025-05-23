class FieldVisitModel {
  bool? status;
  List<Data>? data;
  String? message;

  FieldVisitModel({this.status, this.data, this.message});

  FieldVisitModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class Data {
  int? id;
  String? unitType;
  String? description;
  String? unitPrice;
  String? date;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.unitType,
        this.description,
        this.unitPrice,
        this.date,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitType = json['unit_type'];
    description = json['description'];
    unitPrice = json['unit_price'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
