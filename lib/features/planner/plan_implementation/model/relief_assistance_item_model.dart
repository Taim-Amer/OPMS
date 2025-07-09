import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';

/// The “option” coming from GET /relief_assistance_item
class ReliefAssistanceOptionModel {
  final int id;
  final String type;
  final String description;
  final int unitCost;
  final String date;

  ReliefAssistanceOptionModel({
    required this.id,
    required this.type,
    required this.description,
    required this.unitCost,
    required this.date,
  });

  factory ReliefAssistanceOptionModel.fromJson(Map<String, dynamic> json) {
    return ReliefAssistanceOptionModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      unitCost: (double.parse(json['unit_cost']).round()),
      date: json['date'],
    );
  }
}

/// The row in your plan_implementation → relief_assistance_items
class ReliefAssistanceItem {
  final int id;
  final int reliefId;
  final int planImplementationId;
  final int facilityTypeId;
  final String facilityNameEn;
  final String facilityNameAr;
  final int quantity;
  final String? remarks;
  final ReliefAssistanceOptionModel reliefItem;
  final FacilityTypeModel facilityType;

  ReliefAssistanceItem({
    required this.id,
    required this.reliefId,
    required this.planImplementationId,
    required this.facilityTypeId,
    required this.facilityNameEn,
    required this.facilityNameAr,
    required this.quantity,
    this.remarks,
    required this.reliefItem,
    required this.facilityType,
  });

  factory ReliefAssistanceItem.fromJson(Map<String, dynamic> json) {
    return ReliefAssistanceItem(
      id: json['id'],
      reliefId: json['relief_id'],
      planImplementationId: json['plan_implementation_id'],
      facilityTypeId: json['facility_type_id'],
      facilityNameEn: json['Facility Name in English'],
      facilityNameAr: json['Facility Name in Arabic'],
      quantity: json['quantity'],
      remarks: json['remarks'] as String?,
      reliefItem: ReliefAssistanceOptionModel.fromJson(
          json['relief_item'] as Map<String, dynamic>),
      facilityType: FacilityTypeModel.fromJson(
          json['facility_type'] as Map<String, dynamic>),
    );
  }

  /// Shape expected by saveDraft()
  Map<String, dynamic> toDraftJson() => {
        'relief_id': id,
        'facility_type_id': facilityTypeId,
        'Facility Name in English': facilityNameEn,
        'Facility Name in Arabic': facilityNameAr,
        'quantity': quantity,
        'remarks': remarks,
      };

  ReliefAssistanceItem copyWith({
    int? reliefId,
    int? facilityTypeId,
    String? facilityNameEn,
    String? facilityNameAr,
    int? quantity,
    String? remarks,
    ReliefAssistanceOptionModel? reliefItem,
    FacilityTypeModel? facilityType,
  }) {
    return ReliefAssistanceItem(
      id: id,
      reliefId: reliefId ?? this.reliefId,
      planImplementationId: planImplementationId,
      facilityTypeId: facilityTypeId ?? this.facilityTypeId,
      facilityNameEn: facilityNameEn ?? this.facilityNameEn,
      facilityNameAr: facilityNameAr ?? this.facilityNameAr,
      quantity: quantity ?? this.quantity,
      remarks: remarks ?? this.remarks,
      reliefItem: reliefItem ?? this.reliefItem,
      facilityType: facilityType ?? this.facilityType,
    );
  }
}
