import 'package:skeletonizer/skeletonizer.dart';

class IndicatorsModel {
  bool? status;
  List<Data>? data;
  String? message;

  IndicatorsModel({this.status, this.data, this.message});

  IndicatorsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  static IndicatorsModel get skeleton{
    return IndicatorsModel(
      data: List.generate(20, (_) => Data.skeleton)
    );
  }
}

class Data {
  int? id;
  int? outputId;
  String? description;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.outputId,
        this.description,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outputId = json['output_id'];
    description = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  static Data get skeleton{
    return Data(
      description: BoneMock.fullName,
    );
  }
}
