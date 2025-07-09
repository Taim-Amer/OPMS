import 'package:skeletonizer/skeletonizer.dart';

class GovernorateModel {
  bool? status;
  List<Governorate>? data;
  String? message;

  GovernorateModel({this.status, this.data, this.message});

  GovernorateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Governorate>[];
      json['data'].forEach((v) {
        data!.add(Governorate.fromJson(v));
      });
    }
    message = json['message'];
  }

  static GovernorateModel get skeleton{
    return GovernorateModel(
      data: List.generate(12, (_) => Governorate.skeleton)
    );
  }
}

class Governorate {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Governorate({this.id, this.name, this.createdAt, this.updatedAt});

  Governorate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static Governorate get skeleton{
    return Governorate(
      name: BoneMock.name,
      id: 0
    );
  }
}
