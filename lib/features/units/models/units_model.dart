class UnitsModel {
  bool? status;
  List<Data>? data;
  String? message;

  UnitsModel({this.status, this.data, this.message});

  UnitsModel.fromJson(Map<String, dynamic> json) {
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
  int? departmentId;
  String? name;
  String? type;
  String? code;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.departmentId,
        this.name,
        this.type,
        this.code,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    name = json['name'];
    type = json['type'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
