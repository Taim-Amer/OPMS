import 'package:skeletonizer/skeletonizer.dart';

class TrainingDescriptionModel {
  bool? status;
  List<TrainingDescription>? data;
  String? message;

  TrainingDescriptionModel({this.status, this.data, this.message});

  TrainingDescriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TrainingDescription>[];
      json['data'].forEach((v) {
        data!.add(TrainingDescription.fromJson(v));
      });
    }
    message = json['message'];
  }

  static TrainingDescriptionModel get skeleton{
    return TrainingDescriptionModel(
      data: List.generate(20, (_) => TrainingDescription(
        name: BoneMock.fullName,
      ))
    );
  }
}

class TrainingDescription {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  TrainingDescription({this.id, this.name, this.createdAt, this.updatedAt});

  TrainingDescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null;
    updatedAt = json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null;
  }
}
