import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';

/// “Option” coming from GET /running_costs
class RunningCostOptionModel {
  final int id;
  final String expenseType;
  final String unitType;
  final int unitCost;
  final String date;

  RunningCostOptionModel({
    required this.id,
    required this.expenseType,
    required this.unitType,
    required this.unitCost,
    required this.date,
  });

  factory RunningCostOptionModel.fromJson(Map<String, dynamic> json) {
    return RunningCostOptionModel(
      id: json['id'] as int,
      expenseType: json['expense_type'] as String,
      unitType: json['unit_type'] as String,
      unitCost: (double.parse(json['unit_cost'] as String).round()),
      date: json['date'] as String,
    );
  }
}

/// One row in “running_costs”
class RunningCostItem {
  final int id;
  final int planImplementationId;
  final int runningCostId;
  final int facilityTypeId;
  final String facilityNameEn;
  final String facilityNameAr;
  final String description; // free‐text override
  final int numberOfUnitsEveryMonth;
  final int frequencyNumberOfMonths; // read‐only
  final String? remarks;

  final RunningCostOptionModel runningCost;
  final FacilityTypeModel facilityType;

  RunningCostItem({
    required this.id,
    required this.planImplementationId,
    required this.runningCostId,
    required this.facilityTypeId,
    required this.facilityNameEn,
    required this.facilityNameAr,
    required this.description,
    required this.numberOfUnitsEveryMonth,
    required this.frequencyNumberOfMonths,
    this.remarks,
    required this.runningCost,
    required this.facilityType,
  });

  factory RunningCostItem.fromJson(Map<String, dynamic> json) {
    return RunningCostItem(
      id: json['id'] as int,
      planImplementationId: json['plan_implementation_id'] as int,
      runningCostId: json['running_cost_id'] as int,
      facilityTypeId: json['facility_type_id'] as int,
      facilityNameEn: json['Facility Name in English'] as String,
      facilityNameAr: json['Facility Name in Arabic'] as String,
      description: json['description'] as String,
      numberOfUnitsEveryMonth: json['number_of_units_every_month'] as int,
      frequencyNumberOfMonths: json['frequency_number_of_months'] as int,
      remarks: json['remarks'] as String?,
      runningCost: RunningCostOptionModel.fromJson(
        json['running_cost'] as Map<String, dynamic>,
      ),
      facilityType: FacilityTypeModel.fromJson(
        json['facility_type'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toDraftJson() => {
        'running_cost_id': runningCostId,
        'facility_type_id': facilityTypeId,
        'Facility Name in English': facilityNameEn,
        'Facility Name in Arabic': facilityNameAr,
        'description': description,
        'number_of_units_every_month': numberOfUnitsEveryMonth,
        'remarks': remarks,
      };

  RunningCostItem copyWith({
    int? runningCostId,
    int? facilityTypeId,
    String? facilityNameEn,
    String? facilityNameAr,
    String? description,
    int? numberOfUnitsEveryMonth,
    String? remarks,
    RunningCostOptionModel? runningCost,
    FacilityTypeModel? facilityType,
  }) {
    return RunningCostItem(
      id: id,
      planImplementationId: planImplementationId,
      runningCostId: runningCostId ?? this.runningCostId,
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      facilityNameEn: facilityNameEn ?? this.facilityNameEn,
      facilityNameAr: facilityNameAr ?? this.facilityNameAr,
      description: description ?? this.description,
      numberOfUnitsEveryMonth:
          numberOfUnitsEveryMonth ?? this.numberOfUnitsEveryMonth,
      frequencyNumberOfMonths: frequencyNumberOfMonths,
      remarks: remarks ?? this.remarks,
      runningCost: runningCost ?? this.runningCost,
      facilityType: facilityType ?? this.facilityType,
    );
  }
}
