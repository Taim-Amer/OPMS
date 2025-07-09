class FacilityTypeModel {
  final int id;
  final String name;

  FacilityTypeModel({required this.id, required this.name});

  factory FacilityTypeModel.fromJson(Map<String, dynamic> json) =>
      FacilityTypeModel(id: json['id'], name: json['name']);
}
