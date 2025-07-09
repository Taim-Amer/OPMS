// lib/features/planner/activity_plan_details/model/plan_regions_model.dart

class PlanRegionsModel {
  final bool? status;
  final List<PlanRegionData>? data;
  final String? message;

  PlanRegionsModel({
    this.status,
    this.data,
    this.message,
  });

  factory PlanRegionsModel.fromJson(Map<String, dynamic> json) {
    return PlanRegionsModel(
      status: json['status'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PlanRegionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );
  }
}

class PlanRegionData {
  final int? id;
  final int? planActivityId;
  final String? regionType;
  final RegionDetails? region;

  PlanRegionData({
    this.id,
    this.planActivityId,
    this.regionType,
    this.region,
  });

  factory PlanRegionData.fromJson(Map<String, dynamic> json) {
    return PlanRegionData(
      id: json['id'] as int?,
      planActivityId: json['plan_activity_id'] as int?,
      regionType: json['region_type'] as String?,
      region: json['region'] != null
          ? RegionDetails.fromJson(json['region'])
          : null,
    );
  }
}

class RegionDetails {
  final int? id;
  final int? governorateId;
  final int? districtId;
  final int? subDistrictId;
  final String? name;
  final dynamic boundary;

  RegionDetails({
    this.id,
    this.governorateId,
    this.districtId,
    this.subDistrictId,
    this.name,
    this.boundary,
  });

  factory RegionDetails.fromJson(Map<String, dynamic> json) {
    return RegionDetails(
      id: json['id'] as int?,
      governorateId: json['governorate_id'] as int?,
      districtId: json['district_id'] as int?,
      subDistrictId: json['sub_district_id'] as int?,
      name: json['name'] as String?,
      boundary: json['boundary'],
    );
  }
}
