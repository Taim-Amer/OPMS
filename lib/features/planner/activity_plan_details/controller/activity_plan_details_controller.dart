// lib/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart

import 'dart:developer' as developer; // for professional debug logging
import 'package:get/get.dart';
import 'package:opms/features/planner/activity_plan_details/model/admin_four_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/distric_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/governorate_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/sub_distric_model.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/features/planner/activity_plan_details/model/activity_plan_details_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/plan_regions_model.dart';

class ActivityPlanDetailsController extends GetxController {
  final ApiService _api = Get.find();
  late int planActivityId;

  final loadState = RequestState.begin.obs;
  final details = Rxn<ActivityPlanDetailsModel>();

  // New state for plan regions
  final planRegionsLoadState = RequestState.begin.obs;
  final planRegions = Rxn<PlanRegionsModel>();

  // ─────────────────────────────
  // REGIONS PICKER STATES
  // ─────────────────────────────
  // Rx lists for all four levels
  final governorates = <Governorate>[].obs;
  final districts = <District>[].obs;
  final subDistricts = <SubDistrict>[].obs;
  final adminFors = <AdminFor>[].obs;

  // Loading flags
  final governoratesLoading = false.obs;
  final districtsLoading = false.obs;
  final subDistrictsLoading = false.obs;
  final adminForsLoading = false.obs;

  // when we check for a region plan
  final RxBool isPlanEditable = false.obs;

  Future<void> preload(int id) async {
    planActivityId = id;
    await Future.wait([
      _fetchDetails(),
      fetchPlanRegions(), // Fetch plan regions in parallel
    ]);
  }

  Future<void> _fetchDetails() async {
    if (planActivityId == 0) return;
    loadState.value = RequestState.loading;

    try {
      final resp = await _api.getData<ActivityPlanDetailsModel>(
        endPoint: ApiConstants.activities,
        queryParameters: {'plan_activity_id': planActivityId},
        fromJson: (json) => ActivityPlanDetailsModel.fromJson(json),
      );

      if (resp is DataSuccess<ActivityPlanDetailsModel>) {
        details.value = resp.data;
        isPlanEditable.value = resp.data!.data!.isEditable!;
        loadState.value = RequestState.success;
      } else {
        loadState.value = RequestState.error;
      }
    } catch (e, stackTrace) {
      loadState.value = RequestState.error;
      developer.log(
        '[ActivityPlanDetailsController] _fetchDetails error',
        error: e,
        stackTrace: stackTrace,
      );
    }

    update(); // <-- THIS TRIGGERS GetBuilder REBUILD!
  }

  Future<void> fetchPlanRegions() async {
    if (planActivityId == 0) return;

    try {
      planRegionsLoadState.value = RequestState.loading;

      final resp = await _api.getData<PlanRegionsModel>(
        endPoint: ApiConstants.planImplement,
        queryParameters: {
          'plan_activity_id': planActivityId,
          'needRegions': 1,
        },
        fromJson: (json) => PlanRegionsModel.fromJson(json),
      );

      if (resp is DataSuccess<PlanRegionsModel>) {
        planRegions.value = resp.data;
        planRegionsLoadState.value = RequestState.success;
      } else {
        planRegionsLoadState.value = RequestState.error;
      }
    } catch (e, stackTrace) {
      planRegionsLoadState.value = RequestState.error;
      print("error in regiosn $e");
      developer.log(
        '[ActivityPlanDetailsController] fetchPlanRegions error',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> fetchGovernorates() async {
    governoratesLoading.value = true;

    try {
      final resp = await _api.getData<List<Governorate>>(
        endPoint: '/governorates',
        fromJson: (json) =>
            (json['data'] as List).map((e) => Governorate.fromJson(e)).toList(),
      );

      if (resp is DataSuccess<List<Governorate>>) {
        governorates.value = resp.data ?? [];
      } else {
        governorates.clear();
      }
    } catch (e, stackTrace) {
      governorates.clear();
      developer.log(
        '[ActivityPlanDetailsController] fetchGovernorates error',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      governoratesLoading.value = false;
    }
  }

  Future<void> fetchDistricts(int governorateId) async {
    districtsLoading.value = true;

    try {
      final resp = await _api.getData<List<District>>(
        endPoint: '/districts',
        queryParameters: {'governorate_id': governorateId},
        fromJson: (json) =>
            (json['data'] as List).map((e) => District.fromJson(e)).toList(),
      );

      if (resp is DataSuccess<List<District>>) {
        districts.value = resp.data ?? [];
      } else {
        districts.clear();
      }
    } catch (e, stackTrace) {
      districts.clear();
      developer.log(
        '[ActivityPlanDetailsController] fetchDistricts error',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      districtsLoading.value = false;
    }
  }

  Future<void> fetchSubDistricts(int districtId) async {
    subDistrictsLoading.value = true;

    try {
      final resp = await _api.getData<List<SubDistrict>>(
        endPoint: '/sub_districts',
        queryParameters: {'district_id': districtId},
        fromJson: (json) =>
            (json['data'] as List).map((e) => SubDistrict.fromJson(e)).toList(),
      );

      if (resp is DataSuccess<List<SubDistrict>>) {
        subDistricts.value = resp.data ?? [];
      } else {
        subDistricts.clear();
      }
    } catch (e, stackTrace) {
      subDistricts.clear();
      developer.log(
        '[ActivityPlanDetailsController] fetchSubDistricts error',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      subDistrictsLoading.value = false;
    }
  }

  Future<void> fetchAdminFors(int subDistrictId) async {
    adminForsLoading.value = true;

    try {
      final resp = await _api.getData<List<AdminFor>>(
        endPoint: '/admin_fors',
        queryParameters: {'sub_district_id': subDistrictId},
        fromJson: (json) =>
            (json['data'] as List).map((e) => AdminFor.fromJson(e)).toList(),
      );

      if (resp is DataSuccess<List<AdminFor>>) {
        adminFors.value = resp.data ?? [];
      } else {
        adminFors.clear();
      }
    } catch (e, stackTrace) {
      adminFors.clear();
      developer.log(
        '[ActivityPlanDetailsController] fetchAdminFors error',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      adminForsLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    Get.delete<ActivityPlanDetailsController>();
  }
}
