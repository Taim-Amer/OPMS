import 'package:opms/features/planner/plan_implementation/model/field_visit_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_options_model.dart';

class FieldVisitItem {
  final int id;
  final int planImplementationId;
  final String
      typeType; // "\\App\\Models\\FieldVisit" or "\\App\\Models\\Salary"
  final int typeId;
  final int numOfUnitsPerYear;
  final int specificUnitDay;
  final int numberOfUnitsPerTravel;
  final String? remarks;
  final dynamic type; // either FieldVisitOptionModel or SalaryOptionModel

  FieldVisitItem({
    required this.id,
    required this.planImplementationId,
    required this.typeType,
    required this.typeId,
    required this.numOfUnitsPerYear,
    required this.specificUnitDay,
    required this.numberOfUnitsPerTravel,
    this.remarks,
    required this.type,
  });

  factory FieldVisitItem.fromJson(Map<String, dynamic> json) {
    final tType = json['type_type'] as String;
    final dynType = tType.endsWith('FieldVisit')
        ? FieldVisitOptionModel.fromJson(json['type'] as Map<String, dynamic>)
        : SalaryOptionModel.fromJson(json['type'] as Map<String, dynamic>);
    return FieldVisitItem(
      id: json['id'] as int,
      planImplementationId: json['plan_implementation_id'] as int,
      typeType: tType,
      typeId: json['type_id'] as int,
      numOfUnitsPerYear: json['num_of_units_per_year'] as int,
      specificUnitDay: json['specific_unit_day'] as int,
      numberOfUnitsPerTravel: json['number_of_units_per_travel'] as int,
      remarks: json['remarks'] as String?,
      type: dynType,
    );
  }

  Map<String, dynamic> toDraftJson() => {
        'type_type': typeType,
        'type_id': typeId,
        'num_of_units_per_year': numOfUnitsPerYear,
        'specific_unit_day': specificUnitDay,
        'number_of_units_per_travel': numberOfUnitsPerTravel,
        'remarks': remarks,
      };

  FieldVisitItem copyWith({
    int? typeId,
    int? numOfUnitsPerYear,
    int? specificUnitDay,
    int? numberOfUnitsPerTravel,
    String? remarks,
    dynamic type,
  }) {
    return FieldVisitItem(
      id: id,
      planImplementationId: planImplementationId,
      typeType: typeType,
      typeId: typeId ?? this.typeId,
      numOfUnitsPerYear: numOfUnitsPerYear ?? this.numOfUnitsPerYear,
      specificUnitDay: specificUnitDay ?? this.specificUnitDay,
      numberOfUnitsPerTravel:
          numberOfUnitsPerTravel ?? this.numberOfUnitsPerTravel,
      remarks: remarks ?? this.remarks,
      type: type ?? this.type,
    );
  }

  /// Convenience getters for UI:
  String get description => type is FieldVisitOptionModel
      ? (type as FieldVisitOptionModel).description
      : (type as SalaryOptionModel).positions;

  String get unitType => type is FieldVisitOptionModel
      ? (type as FieldVisitOptionModel).unitType
      : (type as SalaryOptionModel).type;

  int get unitPrice => type is FieldVisitOptionModel
      ? (type as FieldVisitOptionModel).unitPrice
      : (type as SalaryOptionModel).salary;
}
