class TrainingCostItem {
  final int id;
  final int trainingId;
  final int subDescriptionId;
  final int descriptionId;
  final String descriptionName;
  final String subDescriptionName;
  final String unitName;
  final bool isPriceByPlanner;
  final String? currency;
  final int? price;
  final int numberOfUnits;
  final int numberOfDays;
  final String? remarks;

  TrainingCostItem({
    required this.id,
    required this.trainingId,
    required this.descriptionId,
    required this.subDescriptionId,
    required this.descriptionName,
    required this.subDescriptionName,
    required this.unitName,
    required this.isPriceByPlanner,
    this.currency,
    this.price,
    required this.numberOfUnits,
    required this.numberOfDays,
    this.remarks,
  });

  factory TrainingCostItem.fromJson(Map<String, dynamic> j) {
    return TrainingCostItem(
      id: j['id'] as int,
      trainingId: j['training_id'] as int,
      subDescriptionId: j['training_sub_description_id'] as int,
      descriptionName: j['Description'] as String,
      descriptionId: j['training_description_id'] as int,
      subDescriptionName: j['Sub Description'] as String,
      unitName: j['Unit Name'] as String,
      isPriceByPlanner: (j['is_price_by_planner'] as int) == 1,
      currency: j['currency'] as String?,
      price: j['price'] == null
          ? null
          : (double.parse(j['price'] as String)).round(),
      numberOfUnits: j['number_of_units'] as int,
      numberOfDays: j['number_of_days'] as int,
      remarks: j['remarks'] as String?,
    );
  }
  Map<String, dynamic> toDraftJson() => {
        'training_description_id': descriptionId,
        'training_sub_description_id': subDescriptionId,
        'number_of_units': numberOfUnits,
        // always send currency_id and price, defaulting to empty/zero
        'currency_id': 1,
        'price': price ?? 0,
        'number_of_days': numberOfDays,
        'remarks': remarks,
      };

  /// Now accepts descriptionName, subDescriptionName, unitName, etc.
  TrainingCostItem copyWith({
    int? descriptionId,
    int? subDescriptionId,
    String? descriptionName,
    String? subDescriptionName,
    String? unitName,
    bool? isPriceByPlanner,
    String? currency,
    int? price,
    int? numberOfUnits,
    int? numberOfDays,
    String? remarks,
  }) {
    return TrainingCostItem(
      id: id,
      trainingId: trainingId,
      descriptionId: descriptionId ?? this.descriptionId,
      subDescriptionId: subDescriptionId ?? this.subDescriptionId,
      descriptionName: descriptionName ?? this.descriptionName,
      subDescriptionName: subDescriptionName ?? this.subDescriptionName,
      unitName: unitName ?? this.unitName,
      isPriceByPlanner: isPriceByPlanner ?? this.isPriceByPlanner,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      numberOfUnits: numberOfUnits ?? this.numberOfUnits,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      remarks: remarks ?? this.remarks,
    );
  }
}
