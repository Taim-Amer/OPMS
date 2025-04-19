class ActivitiesModel {
  bool? status;
  List<Data>? data;
  String? message;

  ActivitiesModel({this.status, this.data, this.message});

  ActivitiesModel.fromJson(Map<String, dynamic> json) {
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
  int? outputId;
  String? name;
  String? code;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.outputId,
        this.name,
        this.code,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outputId = json['output_id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
