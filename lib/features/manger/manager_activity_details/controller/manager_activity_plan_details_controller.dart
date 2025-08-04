// lib/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart

// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as developer; // for professional debug logging
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/manger/manager_activity_details/model/manager_history.dart';
import 'package:opms/features/manger/manager_activity_details/model/manager_plan_activity_details_model.dart';
import 'package:opms/features/planner/activity_plan_details/model/plan_regions_model.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/models/message_model.dart';

class ManagerActivityPlanDetailsController extends GetxController {
  final ApiService _api = Get.find();
  late int planActivityId;

  final loadState = RequestState.begin.obs;
  final details = Rxn<ManagerActivityPlanDetailsModel>();

  // New state for plan regions
  final planRegionsLoadState = RequestState.begin.obs;
  final planRegions = Rxn<PlanRegionsModel>();

    final historyLoadState = RequestState.begin.obs;
  final histories = <HistoryItem>[].obs;

  // ─────────────────────────────
  // REGIONS PICKER STATES
  // ─────────────────────────────

  // when we check for a region plan
  final RxBool isPlanEditable = false.obs;

  
  // two separate loading flags:
  final isApproving = false.obs;
  final isRequestingEdits = false.obs;

  Future<bool> updateplan({
    required int isMovedToNext,
    String? comment,
    required BuildContext context,
  }) async {
    // pick the right flag
    final loadingFlag = (isMovedToNext == 1) ? isApproving : isRequestingEdits;
    loadingFlag.value = true;
    update();

    try {
      final resp = await _api.putData<MessageModel>(
        endPoint: 'plan_activities/$planActivityId'
            '?is_moved_to_next=$isMovedToNext'
            '${comment != null ? '&comment=${Uri.encodeComponent(comment)}' : ''}',
        fromJson: MessageModel.fromJson,
      );

      final success = resp is DataSuccess<MessageModel> && resp.data!.status == true;
      return success;
    } catch (e, st) {
      developer.log(
        '[ManagerActivityPlanDetailsController] updateplan error',
        error: e,
        stackTrace: st,
      );
      return false;
    } finally {
      loadingFlag.value = false;
      update();
    }
  }

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
      final resp = await _api.getData<ManagerActivityPlanDetailsModel>(
        endPoint: ApiConstants.activities,
        queryParameters: {'plan_activity_id': planActivityId},
        fromJson: (json) => ManagerActivityPlanDetailsModel.fromJson(json),
      );

      if (resp is DataSuccess<ManagerActivityPlanDetailsModel>) {
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

    Future<void> fetchHistory() async {
    historyLoadState.value = RequestState.loading;
    update();
    try {
      final resp = await _api.getData<ManagerHistoryModel>(
        endPoint: "plan_status_histories",
        queryParameters: {
          'plan_activity_id': planActivityId.toString(),
          'with': 'user',
        },
        fromJson: (json) => ManagerHistoryModel.fromJson(json),
      );
      if (resp is DataSuccess<ManagerHistoryModel>) {
        histories.assignAll(resp.data!.data);
        historyLoadState.value = RequestState.success;
      } else {
        historyLoadState.value = RequestState.error;
      }
    } catch (e, st) {
      historyLoadState.value = RequestState.error;
      developer.log('[ManagerActivityPlanDetailsController] fetchHistory error',
          error: e, stackTrace: st);
    }
    update();
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

  @override
  void onClose() {
    super.onClose();
    Get.delete<ManagerActivityPlanDetailsController>();
  }
}
