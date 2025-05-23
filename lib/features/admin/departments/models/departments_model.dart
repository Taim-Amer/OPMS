import 'package:skeletonizer/skeletonizer.dart';

class DepartmentsModel {
  bool? status;
  List<Department>? departments;
  String? message;

  DepartmentsModel({this.status, this.departments, this.message});

  DepartmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      departments = <Department>[];
      json['data'].forEach((v) {
        departments!.add(Department.fromJson(v));
      });
    }
    message = json['message'];
  }

  static DepartmentsModel get skeleton{
    return DepartmentsModel(
      departments: List.generate(20, (_) => Department(
        code: BoneMock.name,
        name: BoneMock.name
      ))
    );
  }
}

class Department {
  int? id;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  Department({this.id, this.name, this.code, this.createdAt, this.updatedAt});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
