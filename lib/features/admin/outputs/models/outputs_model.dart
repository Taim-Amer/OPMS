import 'package:skeletonizer/skeletonizer.dart';

class OutputsModel {
  bool? status;
  List<Data>? data;
  String? message;

  OutputsModel({this.status, this.data, this.message});

  OutputsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  static OutputsModel get skeleton {
    return OutputsModel(data: List.generate(20, (_) => Data.skeleton));
  }
}

class Data {
  int? id;
  int? outcomeId;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.outcomeId,
      this.name,
      this.code,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outcomeId = json['outcome_id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static Data get skeleton {
    return Data(code: BoneMock.fullName, name: BoneMock.fullName);
  }
}
