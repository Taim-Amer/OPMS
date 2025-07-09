class SalaryOptionModel {
  final int id;
  final String type;
  final String positions;
  final int salary;
  final int costOfLivingAllowance;
  final String date;

  SalaryOptionModel({
    required this.id,
    required this.type,
    required this.positions,
    required this.salary,
    required this.costOfLivingAllowance,
    required this.date,
  });

  factory SalaryOptionModel.fromJson(Map<String, dynamic> json) =>
      SalaryOptionModel(
        id: json['id'],
        type: json['type'],
        positions: json['positions'],
        salary: json['salary'],
        costOfLivingAllowance: json['cost_of_living_allowance'],
        date: json['date'],
      );
}
