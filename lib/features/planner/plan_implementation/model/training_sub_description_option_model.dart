class TrainingSubDescriptionOptionModel {
  final int id;
  final int trainingDescriptionId;
  final String name;
  final String unitName;
  final bool isPriceByPlanner;
  final String? currency;
  final int? price;

  TrainingSubDescriptionOptionModel({
    required this.id,
    required this.trainingDescriptionId,
    required this.name,
    required this.unitName,
    required this.isPriceByPlanner,
    this.currency,
    this.price,
  });

  factory TrainingSubDescriptionOptionModel.fromJson(Map<String, dynamic> json) {
    return TrainingSubDescriptionOptionModel(
      id: json['id'] as int,
      trainingDescriptionId: json['training_description_id'] as int,
      name: json['name'] as String,
      unitName: json['unit_name'] as String,
      isPriceByPlanner: (json['is_price_by_planner'] as int) == 1,
      currency: json['currency'] as String?,
      price: json['price'] == null ? null : (double.parse(json['price'] as String)).round(),
    );
  }
}
