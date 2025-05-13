// file: features/activities/controller/activities_controller.dart

// ignore_for_file: unnecessary_null_comparison, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/features/activities/models/activities_model.dart';

class ActivitiesController extends GetxController {
  static ActivitiesController get instance => Get.find();
  final globalRepo = GeneralRepoImpl();

  void checkDepartmentData() async {
    if (activities.value == null) {
      await getActivitiesStatus();
    }
  }

  // state & data
  Rx<RequestState> getActivitiesStatus = RequestState.begin.obs;
  RxList<Activity> activities = <Activity>[].obs;

  // pagination & search
  RxInt currentPage = 1.obs;
  RxInt perPage = 20.obs;
  RxInt lastPage = 1.obs;
  RxString searchQuery = ''.obs;

  /// Fetch activities from API (single call, paginated & searchable)
  Future<void> fetchActivities({int? page, int? perPageOverride}) async {
    final p = page ?? currentPage.value;
    final pp = perPageOverride ?? perPage.value;
    try {
      getActivitiesStatus.value = RequestState.loading;
      final response = await globalRepo.getActivities(
        paginate: true,
        pp: pp,
        p: p,
        searchQuery: searchQuery.value,
      );
      if (response is DataSuccess) {
        activities.assignAll(response.data!.data);
        currentPage.value = response.data!.meta.currentPage;
        lastPage.value = response.data!.meta.lastPage;
        perPage.value = response.data!.meta.perPage;
        getActivitiesStatus.value = RequestState.success;
      } else {
        getActivitiesStatus.value = RequestState.error;
      }
    } catch (_) {
      getActivitiesStatus.value = RequestState.error;
    }
  }
}
