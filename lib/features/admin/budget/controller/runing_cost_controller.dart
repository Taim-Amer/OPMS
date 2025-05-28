import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/budget/models/running_cost_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
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
  RequestState insertRunningCostRequestStatus = RequestState.begin;

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

  final expenseTypeController = TextEditingController();
  final unitTypeController = TextEditingController();
  final unitCostController = TextEditingController();
  final dateController = TextEditingController();

  var runningCostFormKey = GlobalKey<FormState>();

  Future<void> insertRunningCost() async {
    if (!runningCostFormKey.currentState!.validate()) return;

    insertRunningCostRequestStatus = RequestState.loading;
    update();

    final dataState = await _globalRepo.insertRunningCost(
      expenseType: expenseTypeController.text.trim(),
      unitType: unitTypeController.text.trim(),
      unitCost: unitCostController.text.trim(),
      date: dateController.text.trim(),
    );

    if (dataState is DataSuccess) {
      insertRunningCostRequestStatus = RequestState.success;

      expenseTypeController.clear();
      unitTypeController.clear();
      unitCostController.clear();
      dateController.clear();

      showSnackBar(dataState.data!.message, AlertState.success);
      getRunningCost();
      update();
    } else if (dataState is DataFailed) {
      insertRunningCostRequestStatus = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  final updateExpenseTypeController = TextEditingController();
  final updateUnitTypeController = TextEditingController();
  final updateUnitCostController = TextEditingController();
  final updateDateController = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();
  var updateRunningCostRequestStatus = RequestState.begin.obs;

  Future<void> updateRunningCost({required int id}) async {
    if (!updateFormKey.currentState!.validate()) return;

    updateRunningCostRequestStatus.value = RequestState.loading;

    final response = await _globalRepo.updateRunningCost(
      id: id,
      expenseType: updateExpenseTypeController.text.trim(),
      unitType: updateUnitTypeController.text.trim(),
      unitCost: updateUnitCostController.text.trim(),
      date: updateDateController.text.trim(),
    );

    if (response is DataSuccess) {
      updateRunningCostRequestStatus.value = RequestState.success;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      // Clear fields
      updateExpenseTypeController.clear();
      updateUnitTypeController.clear();
      updateUnitCostController.clear();
      updateDateController.clear();
      getRunningCost();
    } else if (response is DataFailed) {
      updateRunningCostRequestStatus.value = RequestState.error;
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }

  String searchQuery = '';

  List<RunningCost> get filteredRunningCosts {
    final original = runningCostModel.data ?? [];
    if (searchQuery.isEmpty) return original;

    return HelperFunctions.search<RunningCost>(
      original,
      searchQuery,
      searchFields: (item) => [
        item.expenseType ?? '',
        item.unitType ?? '',
        item.date ?? '',
      ],
    );
  }

  void updateSearchQuery(String q) {
    searchQuery = q;
    update();
  }

}