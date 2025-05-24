import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
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
  Rx<RequestState> updateReliefAssistanceRequestStatus = RequestState.begin.obs;
  RequestState insertReliefAssistanceRequestStatus = RequestState.begin;

  final updateUnitController = TextEditingController();
  final updateTypeController = TextEditingController();
  final updateDateController = TextEditingController();
  final updateDescriptionController = TextEditingController();

  ReliefAssistanceModel reliefAssistanceModel = ReliefAssistanceModel.skeleton;

  Future<void> getReliefAssistance() async {
    getReliefAssistanceStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getReliefAssistance();

    if (response is DataSuccess) {
      getReliefAssistanceStatus = RequestState.success;
      update();
      reliefAssistanceModel = response.data!;
    } else {
      getReliefAssistanceStatus = RequestState.error;
      update();
    }
  }

  Future<void> updateReliefAssistance({required int id}) async {
    updateReliefAssistanceRequestStatus = RequestState.loading.obs;
    final response = await _globalRepo.updateReliefAssistance(
      id: id,
      unitCost: updateUnitController.text.toString(),
      date: updateDateController.text.toString(),
      type: updateTypeController.text.toString(),
      description: updateDescriptionController.text.toString(),
    );

    if (response is DataSuccess) {
      updateReliefAssistanceRequestStatus = RequestState.success.obs;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      //Clear
      updateDateController.clear();
      updateTypeController.clear();
      updateUnitController.clear();
      updateDescriptionController.clear();
    } else if (response is DataFailed) {
      updateReliefAssistanceRequestStatus = RequestState.error.obs;
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }
}