class TrainingSubDescriptionModel {
  bool? status;
  List<Data>? data;
  String? message;

  TrainingSubDescriptionModel({this.status, this.data, this.message});

  TrainingSubDescriptionModel.fromJson(Map<String, dynamic> json) {
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
  int? trainingDescriptionId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.trainingDescriptionId,
      this.name,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trainingDescriptionId = json['training_description_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
