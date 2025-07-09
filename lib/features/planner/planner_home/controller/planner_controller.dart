// lib/features/planner/planner_home/controller/planner_controller.dart

import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/planner/planner_home/model/planner_activities_model.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/models/message_model.dart';
import 'package:opms/utils/router/app_router.dart';

class PlannerController extends GetxController {
  static PlannerController get instance => Get.find();
  final ApiService _api = Get.find();

  /// 0 = Active (reserved), 1 = Available (unreserved)
  final selectedIndex = 0.obs;

  /// Reserved & Available activities
  final activities = <PlannerActivitiesModel>[].obs;
  final availableActivities = <PlannerActivitiesModel>[].obs;

  /// IDs of the user-selected available activities
  final selectedAvailableIds = <int>[].obs;

  /// Loading states
  final loadState = RequestState.begin.obs;
  final availLoadState = RequestState.begin.obs;

  final reserveState = RequestState.begin.obs;
  final archivedActivities = <PlannerActivitiesModel>[].obs;

  final archivedLoadState = RequestState.begin.obs;

  /// Search query for available activities
  final searchQuery = ''.obs;

  Future<void> fetchReserved() => _fetchReserved();
  Future<void> fetchAvailable() => _fetchAvailable();
  Future<void> fetchArchived() => _fetchArchived();

  /// Filtered list for display
  List<PlannerActivitiesModel> get filteredAvailable {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return availableActivities;
    return availableActivities.where((a) {
      return a.name.toLowerCase().startsWith(q) ||
          a.code.toLowerCase().startsWith(q);
    }).toList();
  }

  /// Toggle select/unselect
  void toggleAvailableSelection(int id) {
    if (selectedAvailableIds.contains(id)) {
      selectedAvailableIds.remove(id);
    } else {
      selectedAvailableIds.add(id);
    }
  }

  /// Logout state
  final logoutState = RequestState.begin.obs;

 



  Future<void> _fetchArchived() async {
    archivedLoadState.value = RequestState.loading;
    final resp = await _api.getData<List<PlannerActivitiesModel>>(
      endPoint: ApiConstants.activities,
      queryParameters: {'is_archive': 1},
      fromJson: (json) {
        final raw = (json['data'] as List<dynamic>?) ?? [];
        return raw
            .cast<Map<String, dynamic>>()
            .map((m) => PlannerActivitiesModel.fromJson(m, reserved: true))
            .toList();
      },
    );

    if (resp is DataSuccess<List<PlannerActivitiesModel>>) {
      archivedActivities.assignAll(resp.data!);
      archivedLoadState.value = RequestState.success;
    } else {
      archivedLoadState.value = RequestState.error;
      // showSnackBar(
      //   (resp as DataFailed).error?.data?.toString() ??
      //       'Failed to load archived activities',
      //   AlertState.error,
      // );
    }
  }

  Future<void> _fetchReserved() async {
    loadState.value = RequestState.loading;
    final resp = await _api.getData<List<PlannerActivitiesModel>>(
      endPoint: ApiConstants.activities,
      queryParameters: {'is_reserved': 1},
      fromJson: (json) {
        final raw = (json['data'] as List<dynamic>?) ?? [];
        return raw
            .cast<Map<String, dynamic>>()
            .map((m) => PlannerActivitiesModel.fromJson(m, reserved: true))
            .toList();
      },
    );
    if (resp is DataSuccess<List<PlannerActivitiesModel>>) {
      activities.assignAll(resp.data!);
      loadState.value = RequestState.success;
    } else {
      loadState.value = RequestState.error;
      // showSnackBar(
      //   (resp as DataFailed).error?.data?.toString() ??
      //       'Failed to load activities',
      //   AlertState.error,
      // );
    }
  }

  Future<void> _fetchAvailable() async {
    availLoadState.value = RequestState.loading;
    final resp = await _api.getData<List<PlannerActivitiesModel>>(
      endPoint: ApiConstants.activities,
      queryParameters: {'is_reserved': 0},
      fromJson: (json) {
        final raw = (json['data'] as List<dynamic>?) ?? [];
        return raw
            .cast<Map<String, dynamic>>()
            .map((m) => PlannerActivitiesModel.fromJson(m, reserved: false))
            .toList();
      },
    );
    if (resp is DataSuccess<List<PlannerActivitiesModel>>) {
      availableActivities.assignAll(resp.data!);
      availLoadState.value = RequestState.success;
    } else {
      availLoadState.value = RequestState.error;
      // showSnackBar(
      //   (resp as DataFailed).error?.data?.toString() ??
      //       'Failed to load available activities',
      //   AlertState.error,
      // );
    }
  }

  Future<void> reserveSelected() async {
    final ids = selectedAvailableIds.toList();
    if (ids.isEmpty) return;
    searchQuery.value = "";

    // start loading
    reserveState.value = RequestState.loading;

    final resp = await _api.postData<MessageModel>(
      endPoint: ApiConstants.reservedActivities,
      data: {'activities_ids': ids},
      fromJson: (json) => MessageModel.fromJson(json),
    );

    if (resp is DataSuccess<MessageModel>) {
      // showSnackBar(resp.data!.message, AlertState.success);
      selectedAvailableIds.clear();
      // re-fetch both lists
      await Future.wait([
        _fetchAvailable(),
        _fetchReserved(),
      ]);
    } else {
      // showSnackBar(
      //   (resp as DataFailed).error?.data?.toString() ??
      //       'Failed to reserve activities',
      //   AlertState.error,
      // );
    }

    // stop loading
    reserveState.value = RequestState.begin;
  }

  Future<void> logout() async {
    logoutState.value = RequestState.loading;
    try {
      final result = await _api.getData<MessageModel>(
        endPoint: ApiConstants.logout,
        fromJson: MessageModel.fromJson,
      );
      if (result is DataFailed) {
        // showSnackBar(
        //   result.error?.data?.toString() ?? 'Logout failed',
        //   AlertState.warning,
        // );
      }
    } catch (err) {
      // showSnackBar('Logout error: ${err}', AlertState.error);
    } finally {
      CacheHelper.removeData(key: Keys.token);
      Get.offAllNamed(AppRoutes.kLogin);
      logoutState.value = RequestState.begin;
    }
  }
}
