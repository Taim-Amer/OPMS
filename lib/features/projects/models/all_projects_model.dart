import 'package:skeletonizer/skeletonizer.dart';

class ProjectsModel {
  bool? status;
  List<Project>? data;
  String? message;
  Meta? meta;

  ProjectsModel({this.status, this.data, this.message, this.meta});

  ProjectsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Project>[];
      json['data'].forEach((v) {
        data!.add(Project.fromJson(v));
      });
    }
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  
  static ProjectsModel get skeleton {
    return ProjectsModel(
      meta: Meta(
        currentPage: 0,
        lastPage: 0,
        perPage: 0,
        total: 0,
      ),
      data: List.generate(20, (_) => Project(
        name: BoneMock.fullName,
        code: BoneMock.fullName
      ))
    );
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

class Meta {
  int? currentPage;
  int? lastPage;
  int? total;
  int? perPage;

  Meta({this.currentPage, this.lastPage, this.total, this.perPage});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
    perPage = json['per_page'];
  }
}
