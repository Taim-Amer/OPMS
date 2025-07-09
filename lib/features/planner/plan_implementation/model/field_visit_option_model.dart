class FieldVisitOptionModel {
  final int id;
  final String unitType;
  final String description;
  final int unitPrice;
  final String date;

  FieldVisitOptionModel({
    required this.id,
    required this.unitType,
    required this.description,
    required this.unitPrice,
    required this.date,
  });

  factory FieldVisitOptionModel.fromJson(Map<String, dynamic> json) {
    return FieldVisitOptionModel(
      id: json['id'] as int,
      unitType: json['unit_type'] as String,
      description: json['description'] as String,
      unitPrice: (double.parse(json['unit_price'] as String)).round(),
      date: json['date'] as String,
    );
  }
}
