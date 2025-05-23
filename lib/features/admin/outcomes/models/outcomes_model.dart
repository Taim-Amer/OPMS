import 'package:skeletonizer/skeletonizer.dart';

class OutcomesModel {
  bool? status;
  List<Data>? data;
  String? message;

  OutcomesModel({this.status, this.data, this.message});

  OutcomesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  static OutcomesModel get skeleton{
    return OutcomesModel(
      data: List.generate(20, (_) => Data.skeleton)
    );
  }
}

class Data {
  int? id;
  String? name;
  int? unitId;
  String? code;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.name,
        this.unitId,
        this.code,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitId = json['unit_id'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static Data get skeleton{
    return Data(
      name: BoneMock.fullName,
      code: BoneMock.fullName,
    );
  }
}
