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
