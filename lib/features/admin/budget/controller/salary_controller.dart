import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/budget/models/salaries_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class SalariesController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getSalaries();
    super.onInit();
  }


  RequestState getSalariesStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertSalaryRequestStatus = RequestState.begin;

  SalariesModel salariesModel = SalariesModel.skeleton;

  Future<void> getSalaries() async {
    getSalariesStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getSalaries();

    if (response is DataSuccess) {
      getSalariesStatus = RequestState.success;
      update();
      salariesModel = response.data!;
    } else {
      getSalariesStatus = RequestState.error;
      update();
    }
  }

  final typeController = TextEditingController();
  final positionsController = TextEditingController();
  final salaryController = TextEditingController();
  final costOfLivingController = TextEditingController();
  final dateController = TextEditingController();

  var salaryFormKey = GlobalKey<FormState>();

  Future<void> insertSalary() async {
    if (!salaryFormKey.currentState!.validate()) return;
    insertSalaryRequestStatus = RequestState.loading;
    update();

    final dataState = await _globalRepo.insertSalary(
      type: typeController.text.trim(),
      positions: positionsController.text.trim(),
      salary: salaryController.text.trim(),
      costOfLivingAllowance: costOfLivingController.text.trim(),
      date: dateController.text.trim(),
    );

    if (dataState is DataSuccess) {
      insertSalaryRequestStatus = RequestState.success;

      typeController.clear();
      positionsController.clear();
      salaryController.clear();
      costOfLivingController.clear();
      dateController.clear();

      showSnackBar(dataState.data!.message, AlertState.success);
      getSalaries();
      update();
    } else if (dataState is DataFailed) {
      insertSalaryRequestStatus = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  final updateTypeController = TextEditingController();
  final updatePositionsController = TextEditingController();
  final updateSalaryController = TextEditingController();
  final updateCostOfLivingController = TextEditingController();
  final updateDateController = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();
  var updateSalaryRequestStatus = RequestState.begin.obs;

  Future<void> updateSalary({required int id}) async {
    if (!updateFormKey.currentState!.validate()) return;

    updateSalaryRequestStatus.value = RequestState.loading;

    final response = await _globalRepo.updateSalary(
      id: id,
      type: updateTypeController.text.trim(),
      positions: updatePositionsController.text.trim(),
      salary: updateSalaryController.text.trim(),
      costOfLivingAllowance: updateCostOfLivingController.text.trim(),
      date: updateDateController.text.trim(),
    );

    if (response is DataSuccess) {
      updateSalaryRequestStatus.value = RequestState.success;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      // Clear fields
      updateTypeController.clear();
      updatePositionsController.clear();
      updateSalaryController.clear();
      updateCostOfLivingController.clear();
      updateDateController.clear();
      getSalaries();
    } else if (response is DataFailed) {
      updateSalaryRequestStatus.value = RequestState.error;
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }


  String searchQuery = '';
  List<Salary> get filteredSalaries {
    final original = salariesModel.data ?? [];
    if (searchQuery.isEmpty) return original;

    return HelperFunctions.search<Salary>(
      original,
      searchQuery,
      searchFields: (item) => [
        item.type ?? '',
        item.positions ?? '',
        item.date ?? '',
      ],
    );
  }

  void updateSearchQuery(String q) {
    searchQuery = q;
    update();
  }
}