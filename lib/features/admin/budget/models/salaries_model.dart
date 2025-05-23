import 'package:skeletonizer/skeletonizer.dart';

class SalariesModel {
  bool? status;
  List<Salary>? data;
  String? message;

  SalariesModel({this.status, this.data, this.message});

  SalariesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Salary>[];
      json['data'].forEach((v) {
        data!.add(Salary.fromJson(v));
      });
    }
    message = json['message'];
  }

  static SalariesModel get skeleton{
    return SalariesModel(
      data: List.generate(12, (_) => Salary(
        date: BoneMock.name,
        type: BoneMock.name,
        costOfLivingAllowance: 0,
        positions: BoneMock.name,
        salary: 0,
      ))
    );
  }
}

class Salary {
  int? id;
  String? type;
  String? positions;
  int? salary;
  int? costOfLivingAllowance;
  String? date;
  String? createdAt;
  String? updatedAt;

  Salary(
      {this.id,
        this.type,
        this.positions,
        this.salary,
        this.costOfLivingAllowance,
        this.date,
        this.createdAt,
        this.updatedAt});

  Salary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    positions = json['positions'];
    salary = json['salary'];
    costOfLivingAllowance = json['cost_of_living_allowance'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
