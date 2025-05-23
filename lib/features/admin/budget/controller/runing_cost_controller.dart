import 'package:get/get.dart';
import 'package:opms/features/admin/budget/models/running_cost_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class RunningCostController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getRunningCost();
    super.onInit();
  }


  RequestState getRunningCostStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  RunningCostModel runningCostModel = RunningCostModel.skeleton;

  Future<void> getRunningCost() async {
    getRunningCostStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getRunningCost();

    if (response is DataSuccess) {
      getRunningCostStatus = RequestState.success;
      update();
      runningCostModel = response.data!;
    } else {
      getRunningCostStatus = RequestState.error;
      update();
    }
  }
}