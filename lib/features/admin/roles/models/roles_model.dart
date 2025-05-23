import 'package:skeletonizer/skeletonizer.dart';

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
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  static RolesModel get skeleton{
    return RolesModel(
      data: List.generate(20, (_) => Data.skeleton)
    );
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

  static Data get skeleton {
    return Data(
      name: BoneMock.fullName,
      guardName: BoneMock.fullName
    );
  }
}
