import 'package:get/get.dart';
import 'package:opms/features/admin/budget/models/relief_assistance_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class ReliefAssistanceController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getReliefAssistance();
    super.onInit();
  }


  RequestState getReliefAssistanceStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  ReliefAssistanceModel reliefAssistanceModel = ReliefAssistanceModel.skeleton;

  Future<void> getReliefAssistance() async {
    getReliefAssistanceStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getReliefAssistance();

    if (response is DataSuccess) {
      getReliefAssistanceStatus = RequestState.success;
      update();
      reliefAssistanceModel = response.data!;
      // totalPages = response.data?.meta?.lastPage ?? 1;
    } else {
      getReliefAssistanceStatus = RequestState.error;
      update();
    }
  }
}