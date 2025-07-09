import 'package:opms/features/admin/factors/models/factors_model.dart';
import 'package:opms/features/coordinator/districts/model/districts_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RiskModel {
  List<RiskItem>? data;
  bool? status;
  String? message;

  RiskModel({this.status, this.data, this.message});

  RiskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RiskItem>[];
      json['data'].forEach((v) {
        data!.add(RiskItem.fromJson(v));
      });
    }
    message = json['message'];
  }
  
  static RiskModel get skeleton{
    return RiskModel(
      data: List.generate(18, (_) => RiskItem(
        factor: Factor(
          title: BoneMock.name,
        ),
        district: GovernorateArea(
          name: BoneMock.name
        ),
        heavy: 1,
        quarter: 'Q1'
      ))
    );
  }
}

class RiskItem {
  int? id;
  int? year;
  String? quarter;
  int? factorId;
  int? districtId;
  int? heavy;
  String? createdAt;
  String? updatedAt;
  Factor? factor;
  GovernorateArea? district;

  RiskItem(
      {this.id,
        this.year,
        this.quarter,
        this.factorId,
        this.districtId,
        this.heavy,
        this.createdAt,
        this.updatedAt,
        this.factor,
        this.district});

  RiskItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
    quarter = json['quarter'];
    factorId = json['factor_id'];
    districtId = json['district_id'];
    heavy = json['heavy'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    factor =
    json['factor'] != null ? Factor.fromJson(json['factor']) : null;
    district = json['district'] != null
        ? GovernorateArea.fromJson(json['district'])
        : null;
  }
}
