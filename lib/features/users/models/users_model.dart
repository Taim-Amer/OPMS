class UsersModel {
  bool? status;
  List<Data>? data;
  String? message;

  UsersModel({this.status, this.data, this.message});

  UsersModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? email;
  String? emailVerifiedAt;
  RegisteredBy? registeredBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.registeredBy,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    registeredBy = json['registered_by'] != null
        ? RegisteredBy.fromJson(json['registered_by'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class RegisteredBy {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? registeredBy;
  String? createdAt;
  String? updatedAt;

  RegisteredBy(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.registeredBy,
        this.createdAt,
        this.updatedAt});

  RegisteredBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    registeredBy = json['registered_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
