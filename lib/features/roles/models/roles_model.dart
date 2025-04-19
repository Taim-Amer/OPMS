class RolesModel {
  bool? status;
  List<Data>? data;
  String? message;

  RolesModel({this.status, this.data, this.message});

  RolesModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.name, this.guardName, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
