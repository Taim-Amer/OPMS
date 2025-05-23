import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/features/admin/activities/models/activities_model.dart';

class ActivitiesController extends GetxController {
  final _globalRepo = GeneralRepoImpl();

  int? outputID;

  @override
  void onInit() {
    outputID = Get.arguments?['outputID'] as int?;
    if(outputID != null) {
      getActivities(outputID: outputID);
    } else{
      getActivities();
    }
    super.onInit();
  }

  final activityName = TextEditingController();
  final activityCode = TextEditingController();
  final newActivityName = TextEditingController();
  final newActivityCode = TextEditingController();
  var formKey = GlobalKey<FormState>();


  RequestState getActivitiesStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  ActivitiesModel activitiesModel = ActivitiesModel.skeleton;

  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;

  Future<void> getActivities({
    int? outputID,
    int? page,
    int? perPageOverride,
    String? search,
  }) async {
    currentPage = page ?? currentPage;
    final usedPerPage = perPageOverride ?? perPage;

    getActivitiesStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getActivities(
      page: currentPage,
      outputID: outputID,
      perPage: usedPerPage,
      paginate: true,
    );

    if (response is DataSuccess) {
      getActivitiesStatus = RequestState.success;
      update();
      activitiesModel = response.data!;
      totalPages = response.data?.meta?.lastPage ?? 1;
    } else {
      getActivitiesStatus = RequestState.error;
      update();
    }
  }

  Future<void> updateActivity({required int activityID}) async {
    updateActivityRequestStatus = RequestState.loading.obs;
    final response = await _globalRepo.updateActivity(
        activityID: activityID,
        name: activityName.text.trim(),
        code: activityCode.text.trim(),
    );

    if (response is DataSuccess) {
      updateActivityRequestStatus = RequestState.success.obs;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      activityName.clear();
      activityCode.clear();
      outputID == null ? getActivities() : getActivities(outputID: outputID);
    } else if (response is DataFailed) {
      updateActivityRequestStatus = RequestState.error.obs;

      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> insertActivity() async {
    insertActivityRequestStatus = RequestState.loading;
    update();
    final response = await _globalRepo.insertActivity(
      outputID: outputID!,
      name: newActivityName.text.trim(),
      code: newActivityCode.text.trim(),
    );

    if (response is DataSuccess) {
      insertActivityRequestStatus = RequestState.success;
      update();
      showSnackBar(response.data!.message, AlertState.success);
      activityName.clear();
      activityCode.clear();
      outputID == null ? getActivities() : getActivities(outputID: outputID);
    } else if (response is DataFailed) {
      insertActivityRequestStatus = RequestState.error;
      update();
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }
}
