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
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
