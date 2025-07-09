import 'package:skeletonizer/skeletonizer.dart';

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

  static UsersModel get skeleton{
    return UsersModel(
        data: List.generate(12, (_) => Data(
          name: BoneMock.fullName,
          email: BoneMock.fullName,
        ))
    );
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? fcmToken;
  int? registeredBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.fcmToken,
        this.registeredBy,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    fcmToken = json['fcm_token'];
    registeredBy = json['registered_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
