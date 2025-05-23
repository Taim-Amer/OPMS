import 'package:skeletonizer/skeletonizer.dart';

class RunningCostModel {
  bool? status;
  List<RunningCost>? data;
  String? message;

  RunningCostModel({this.status, this.data, this.message});

  RunningCostModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RunningCost>[];
      json['data'].forEach((v) {
        data!.add(RunningCost.fromJson(v));
      });
    }
    message = json['message'];
  }

  static RunningCostModel get skeleton{
    return RunningCostModel(
      data: List.generate(12, (_) => RunningCost(
        date: BoneMock.name,
        unitCost: BoneMock.name,
        expenseType: BoneMock.name,
        unitType: BoneMock.name,
      ))
    );
  }
}

class RunningCost {
  int? id;
  String? expenseType;
  String? unitType;
  String? unitCost;
  String? date;
  String? createdAt;
  String? updatedAt;

  RunningCost(
      {this.id,
        this.expenseType,
        this.unitType,
        this.unitCost,
        this.date,
        this.createdAt,
        this.updatedAt});

  RunningCost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expenseType = json['expense_type'];
    unitType = json['unit_type'];
    unitCost = json['unit_cost'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
