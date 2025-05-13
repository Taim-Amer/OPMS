class ProjectsModel {
  bool? status;
  List<Project>? data;
  String? message;

  ProjectsModel({this.status, this.data, this.message});

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Project>[];
      json['data'].forEach((v) {
        data!.add(Project.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class Project {
  int? id;
  int? departmentId;
  String? name;
  String? type;
  String? code;
  String? createdAt;
  String? updatedAt;
  int? departementID;

  Project(
      {this.id,
      this.departmentId,
      this.name,
      this.type,
      this.code,
      this.createdAt,
      this.updatedAt,
      this.departementID});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentId = json['department_id'];
    name = json['name'];
    type = json['type'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    departementID = json['department_id'];
  }
}
