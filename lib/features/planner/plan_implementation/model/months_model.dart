class MonthModel {
  final int id;
  final String name;

  MonthModel({required this.id, required this.name});

  factory MonthModel.fromJson(Map<String, dynamic> json) => MonthModel(
        id: json['id'],
        name: json['name'] ?? '',
      );
}

class MonthsModel {
  final List<MonthModel> months;

  MonthsModel({required this.months});

  factory MonthsModel.fromJson(Map<String, dynamic> json) => MonthsModel(
        months: (json['data'] as List<dynamic>?)
                ?.map((e) => MonthModel.fromJson(e))
                .toList() ??
            [],
      );
}
