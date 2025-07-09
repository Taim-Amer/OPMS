class TrainingDescriptionOptionModel {
  final int id;
  final String name;

  TrainingDescriptionOptionModel({
    required this.id,
    required this.name,
  });

  factory TrainingDescriptionOptionModel.fromJson(Map<String, dynamic> json) {
    return TrainingDescriptionOptionModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
