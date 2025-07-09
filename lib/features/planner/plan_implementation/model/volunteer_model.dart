// lib/features/planner/plan_implementation/model/volunteer_model.dart

import 'package:opms/features/planner/plan_implementation/model/salary_model.dart';
import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';

class VolunteerItem {
  final int id;
  final int planImplementationId;
  final int salaryId;
  final int numberOfVolunteers;
  final int numberOfShifts;
  final int frequencyNumberOfMonths;
  final int facilityTypeId;
  final String facilityNameEn;
  final String facilityNameAr;
  final String? remarks;
  final Salary salary;
  final FacilityTypeModel facilityType;

  VolunteerItem({
    required this.id,
    required this.planImplementationId,
    required this.salaryId,
    required this.numberOfVolunteers,
    required this.numberOfShifts,
    required this.frequencyNumberOfMonths,
    required this.facilityTypeId,
    required this.facilityNameEn,
    required this.facilityNameAr,
    this.remarks,
    required this.salary,
    required this.facilityType,
  });

  factory VolunteerItem.fromJson(Map<String, dynamic> json) {
    return VolunteerItem(
      id: json['id'],
      planImplementationId: json['plan_implementation_id'],
      salaryId: json['salary_id'],
      numberOfVolunteers: json['number_of_volunteers'],
      numberOfShifts: json['number_of_shifts'],
      frequencyNumberOfMonths: json['frequency_number_of_months'],
      facilityTypeId: json['facility_type_id'],
      facilityNameEn: json['Facility Name in English'],
      facilityNameAr: json['Facility Name in Arabic'],
      remarks: json['remarks'] as String?,
      salary: Salary.fromJson(json['salary']),
      facilityType: FacilityTypeModel.fromJson(json['facility_type']),
    );
  }

  /// This is the shape the backend expects on `saveDraft()`
  Map<String, dynamic> toDraftJson() => {
        "salary_id": id,
        "facility_type_id": facilityTypeId,
        "Facility Name in English": facilityNameEn,
        "Facility Name in Arabic": facilityNameAr,
        "number_of_volunteers": numberOfVolunteers,
        "number_of_shifts": numberOfShifts,
        "remarks": remarks,
      };

  VolunteerItem copyWith({
    int? salaryId,
    int? numberOfVolunteers,
    int? numberOfShifts,
    String? facilityNameEn,
    String? facilityNameAr,
    String? remarks,
    int? facilityTypeId,
    Salary? salary,
    FacilityTypeModel? facilityType,
  }) {
    return VolunteerItem(
      id: id,
      planImplementationId: planImplementationId,
      salaryId: salaryId ?? this.salaryId,
      numberOfVolunteers: numberOfVolunteers ?? this.numberOfVolunteers,
      numberOfShifts: numberOfShifts ?? this.numberOfShifts,
      frequencyNumberOfMonths:
          frequencyNumberOfMonths, // readonly
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      facilityNameEn: facilityNameEn ?? this.facilityNameEn,
      facilityNameAr: facilityNameAr ?? this.facilityNameAr,
      remarks: remarks ?? this.remarks,
      salary: salary ?? this.salary,
      facilityType: facilityType ?? this.facilityType,
    );
  }
}
