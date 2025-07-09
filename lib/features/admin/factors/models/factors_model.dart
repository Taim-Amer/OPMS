import 'package:skeletonizer/skeletonizer.dart';

class FactorsModel {
  bool? status;
  List<Factor>? data;
  String? message;

  FactorsModel({this.status, this.data, this.message});

  FactorsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Factor>[];
      json['data'].forEach((v) {
        data!.add(Factor.fromJson(v));
      });
    }
    message = json['message'];
  }

  static FactorsModel get skeleton{
    return FactorsModel(
      data: List.generate(12, (_) => Factor(
        title: BoneMock.fullName,
      ))
    );
  }
}

class Factor {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;

  Factor({this.id, this.title, this.createdAt, this.updatedAt});

  Factor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
