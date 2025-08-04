class SalaryItem {
  final int id;
  final int planImplementationId;
  final int salaryId;
  final int frequencyOfMonth;
  final int numberOfStaff;
  final int facilityTypeId;
  final String facilityNameEn;
  final String facilityNameAr;
  final String remarks;
  final Salary salary;
  final FacilityType facilityType;

  SalaryItem({
    required this.id,
    required this.planImplementationId,
    required this.salaryId,
    required this.frequencyOfMonth,
    required this.numberOfStaff,
    required this.facilityTypeId,
    required this.facilityNameEn,
    required this.facilityNameAr,
    this.remarks = '',
    required this.salary,
    required this.facilityType,
  });

  factory SalaryItem.fromJson(Map<String, dynamic> json) {
    return SalaryItem(
      id: json['id'],
      planImplementationId: json['plan_implementation_id'],
      salaryId: json['salary_id'],
      frequencyOfMonth: json['frequency_of_month'],
      numberOfStaff: json['number_of_staff'],
      facilityTypeId: json['facility_type_id'],
      facilityNameEn: json['Facility Name in English'],
      facilityNameAr: json['Facility Name in Arabic'],
      remarks: (json['remarks'] as String?) ?? '',
      salary: Salary.fromJson(json['salary']),
      facilityType: FacilityType.fromJson(json['facility_type']),
    );
  }

  Map<String, dynamic> toDraftJson() => {
        "salary_id": salaryId,
        "facility_type_id": facilityTypeId,
        "Facility Name in English": facilityNameEn,
        "Facility Name in Arabic": facilityNameAr,
        "number_of_staff": numberOfStaff,
        'remarks': remarks,
      };

  SalaryItem copyWith({
    int? numberOfStaff,
    String? facilityNameEn,
    String? facilityNameAr,
    String? remarks,
    int? salaryId,
    int? facilityTypeId,
    Salary? salary,
    FacilityType? facilityType,
    int? frequencyOfMonth,
  }) {
    return SalaryItem(
      id: id,
      planImplementationId: planImplementationId,
      salaryId: salaryId ?? this.salaryId,
      frequencyOfMonth: frequencyOfMonth ?? this.frequencyOfMonth,
      numberOfStaff: numberOfStaff ?? this.numberOfStaff,
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      facilityNameEn: facilityNameEn ?? this.facilityNameEn,
      facilityNameAr: facilityNameAr ?? this.facilityNameAr,
      remarks: remarks ?? this.remarks,
      salary: salary ?? this.salary,
      facilityType: facilityType ?? this.facilityType,
    );
  }
}

class Salary {
  final int id;
  final String type;
  final String positions;
  final int salary;
  final int costOfLivingAllowance;
  final String date;

  Salary({
    required this.id,
    required this.type,
    required this.positions,
    required this.salary,
    required this.costOfLivingAllowance,
    required this.date,
  });

  factory Salary.fromJson(Map<String, dynamic> json) => Salary(
        id: json['id'],
        type: json['type'],
        positions: json['positions'],
        salary: json['salary'],
        costOfLivingAllowance: json['cost_of_living_allowance'],
        date: json['date'],
      );
}

class FacilityType {
  final int id;
  final String name;

  FacilityType({
    required this.id,
    required this.name,
  });

  factory FacilityType.fromJson(Map<String, dynamic> json) => FacilityType(
        id: json['id'],
        name: json['name'],
      );
}
