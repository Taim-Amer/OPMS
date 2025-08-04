class TrainingSubDescriptionOptionModel {
  final int id;
  final int trainingDescriptionId;
  final String name;
  final String unitName;
  final bool isPriceByPlanner;
  final String currency;
  final int? price;

  TrainingSubDescriptionOptionModel({
    required this.id,
    required this.trainingDescriptionId,
    required this.name,
    required this.unitName,
    required this.isPriceByPlanner,
    required this.currency,
    this.price,
  });

  factory TrainingSubDescriptionOptionModel.fromJson(
      Map<String, dynamic> json) {
    // Extract raw currency, which might be String, int, or null
    final dynamic rawCurrency = json['currency'];

    // Normalize to non-nullable String; use empty if null
    final String currencyStr = rawCurrency == null
        ? ''
        : rawCurrency.toString();

    // Parse price as before
    final dynamic rawPrice = json['price'];
    final int? parsedPrice = rawPrice == null
        ? null
        : (double.parse(rawPrice as String)).round();

    return TrainingSubDescriptionOptionModel(
      id: json['id'] as int,
      trainingDescriptionId: json['training_description_id'] as int,
      name: json['name'] as String,
      unitName: json['unit_name'] as String,
      isPriceByPlanner: (json['is_price_by_planner'] as int) == 1,
      currency: currencyStr,
      price: parsedPrice,
    );
  }
}
