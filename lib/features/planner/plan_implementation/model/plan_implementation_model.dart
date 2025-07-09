// lib/features/planner/plan_implementation/model/plan_implementation_model.dart

import 'package:opms/features/planner/plan_implementation/model/field_visit_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/relief_assistance_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/equipment_model.dart';
import 'package:opms/features/planner/plan_implementation/model/plan_implementation_months_model.dart';
import 'package:opms/features/planner/plan_implementation/model/running_cost_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_model.dart';
import 'package:opms/features/planner/plan_implementation/model/volunteer_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_item_model.dart';  // ← NEW

class PlanImplementationModel {
  final int? id;
  final int? planActivityId;
  final String? regionType;
  final int? regionId;

  final String? targetType;
  final int? targetNum;
  final String? beneficiaryType;
  final int? totalBeneficiaries;

  final List<PlanImplementationMonth> months;
  final List<SalaryItem>? salaries;
  final List<VolunteerItem> volunteers;
  final List<EquipmentItem> equipments;
  final List<ReliefAssistanceItem> reliefAssistanceItems;
  final List<RunningCostItem> runningCosts;
  final List<FieldVisitItem> fieldVisits;
  final List<TrainingItem> trainings;  // ← NEW

  PlanImplementationModel({
    this.id,
    this.planActivityId,
    this.regionType,
    this.regionId,
    this.targetType,
    this.targetNum,
    this.beneficiaryType,
    this.totalBeneficiaries,
    this.months = const [],
    this.salaries,
    this.volunteers = const [],
    this.equipments = const [],
    this.reliefAssistanceItems = const [],
    this.runningCosts = const [],
    this.fieldVisits = const [],
    this.trainings = const [],  // ← NEW
  });

  factory PlanImplementationModel.fromJson(Map<String, dynamic> json) {
    return PlanImplementationModel(
      id: json['id'] as int?,
      planActivityId: json['plan_activity_id'] as int?,
      regionType: (json['region_type'] as String?)?.split("\\").last,
      regionId: json['region_id'] as int?,
      targetType: json['target_type'] as String?,
      targetNum: json['target_num'] as int?,
      beneficiaryType: json['beneficiary_type'] as String?,
      totalBeneficiaries: json['total_beneficiaries'] as int?,
      months: (json['months'] as List<dynamic>?)
              ?.map((m) => PlanImplementationMonth.fromJson(m))
              .toList() ??
          [],
      salaries: (json['salaries'] as List<dynamic>?)
          ?.map((s) => SalaryItem.fromJson(s))
          .toList(),
      volunteers: (json['volunteers'] as List<dynamic>?)
              ?.map((v) => VolunteerItem.fromJson(v))
              .toList() ??
          [],
      equipments: (json['equipments'] as List<dynamic>?)
              ?.map((e) => EquipmentItem.fromJson(e))
              .toList() ??
          [],
      reliefAssistanceItems: (json['relief_assistance_items'] as List<dynamic>?)
              ?.map((r) => ReliefAssistanceItem.fromJson(r))
              .toList() ??
          [],
      runningCosts: (json['running_costs'] as List<dynamic>?)
              ?.map((r) => RunningCostItem.fromJson(r))
              .toList() ??
          [],
      fieldVisits: (json['field_visits'] as List<dynamic>?)
              ?.map((fv) => FieldVisitItem.fromJson(fv))
              .toList() ??
          [],
      trainings: (json['trainings'] as List<dynamic>?)  // ← NEW
              ?.map((t) => TrainingItem.fromJson(t))
              .toList() ??
          [],  // ← NEW
    );
  }

  PlanImplementationModel copyWith({
    int? id,
    int? planActivityId,
    String? regionType,
    int? regionId,
    String? targetType,
    int? targetNum,
    String? beneficiaryType,
    int? totalBeneficiaries,
    List<PlanImplementationMonth>? months,
    List<SalaryItem>? salaries,
    List<VolunteerItem>? volunteers,
    List<EquipmentItem>? equipments,
    List<ReliefAssistanceItem>? reliefAssistanceItems,
    List<RunningCostItem>? runningCosts,
    List<FieldVisitItem>? fieldVisits,
    List<TrainingItem>? trainings,  // ← NEW
  }) {
    return PlanImplementationModel(
      id: id ?? this.id,
      planActivityId: planActivityId ?? this.planActivityId,
      regionType: regionType ?? this.regionType,
      regionId: regionId ?? this.regionId,
      targetType: targetType ?? this.targetType,
      targetNum: targetNum ?? this.targetNum,
      beneficiaryType: beneficiaryType ?? this.beneficiaryType,
      totalBeneficiaries: totalBeneficiaries ?? this.totalBeneficiaries,
      months: months ?? this.months,
      salaries: salaries ?? this.salaries,
      volunteers: volunteers ?? this.volunteers,
      equipments: equipments ?? this.equipments,
      reliefAssistanceItems:
          reliefAssistanceItems ?? this.reliefAssistanceItems,
      runningCosts: runningCosts ?? this.runningCosts,
      fieldVisits: fieldVisits ?? this.fieldVisits,
      trainings: trainings ?? this.trainings,  // ← NEW
    );
  }

  Map<String, dynamic> toDraftJson() => {
        "target_type": targetType,
        "target_num": targetNum,
        "beneficiary_type": beneficiaryType,
        "total_beneficiaries": totalBeneficiaries,
        "months_ids": months.map((m) => m.month.id).toList(),
        "salaries": salaries?.map((s) => s.toDraftJson()).toList() ?? [],
        "volunteers": volunteers.map((v) => v.toDraftJson()).toList(),
        "equipments": equipments.map((e) => e.toDraftJson()).toList(),
        "relief_assistance_items":
            reliefAssistanceItems.map((r) => r.toDraftJson()).toList(),
        'running_costs': runningCosts.map((r) => r.toDraftJson()).toList(),
        'field_visits': fieldVisits.map((fv) => fv.toDraftJson()).toList(),
        'trainings': trainings.map((t) => t.toDraftJson()).toList(),  // ← NEW
      };
}
