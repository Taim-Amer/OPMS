// lib/features/planner/plan_implementation/model/equipment_model.dart

import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';

class EquipmentOptionModel {
  final int id;
  final String type;
  final String equipmentDescription;
  final int equipmentCost;
  final String date;

  EquipmentOptionModel({
    required this.id,
    required this.type,
    required this.equipmentDescription,
    required this.equipmentCost,
    required this.date,
  });

  factory EquipmentOptionModel.fromJson(Map<String, dynamic> json) {
    return EquipmentOptionModel(
      id: json['id'],
      type: json['type'],
      equipmentDescription: json['equipment_description'],
      equipmentCost: (double.parse(json['equipment_cost']).round()),
      date: json['date'],
    );
  }
}

class EquipmentItem {
  final int id;
  final int planImplementationId;
  final int equipmentId;
  final int quantity;
  final int facilityTypeId;
  final String facilityNameEn;
  final String facilityNameAr;
  final String? remarks;
  final EquipmentOptionModel equipment;
  final FacilityTypeModel facilityType;

  EquipmentItem({
    required this.id,
    required this.planImplementationId,
    required this.equipmentId,
    required this.quantity,
    required this.facilityTypeId,
    required this.facilityNameEn,
    required this.facilityNameAr,
    this.remarks,
    required this.equipment,
    required this.facilityType,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      id: json['id'],
      planImplementationId: json['plan_implementation_id'],
      equipmentId: json['equipment_id'],
      quantity: json['quantity'],
      facilityTypeId: json['facility_type_id'],
      facilityNameEn: json['Facility Name in English'],
      facilityNameAr: json['Facility Name in Arabic'],
      remarks: json['remarks'] as String?,
      equipment: EquipmentOptionModel.fromJson(
          json['equipment'] as Map<String, dynamic>),
      facilityType: FacilityTypeModel.fromJson(
          json['facility_type'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toDraftJson() => {
        'equipment_id': id,
        'facility_type_id': facilityTypeId,
        'Facility Name in English': facilityNameEn,
        'Facility Name in Arabic': facilityNameAr,
        'quantity': quantity,
        'remarks': remarks,
      };

  EquipmentItem copyWith({
    int? equipmentId,
    int? quantity,
    int? facilityTypeId,
    String? facilityNameEn,
    String? facilityNameAr,
    String? remarks,
    EquipmentOptionModel? equipment,
    FacilityTypeModel? facilityType,
  }) {
    return EquipmentItem(
      id: id,
      planImplementationId: planImplementationId,
      equipmentId: equipmentId ?? this.equipmentId,
      quantity: quantity ?? this.quantity,
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      facilityNameEn: facilityNameEn ?? this.facilityNameEn,
      facilityNameAr: facilityNameAr ?? this.facilityNameAr,
      remarks: remarks ?? this.remarks,
      equipment: equipment ?? this.equipment,
      facilityType: facilityType ?? this.facilityType,
    );
  }
}
