import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/budget/models/equipments_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class EquipmentsController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getEquipments();
    super.onInit();
  }


  RequestState getEquipmentsStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertEquipmentsRequestStatus = RequestState.begin;

  EquipmentsModel equipmentsModel = EquipmentsModel.skeleton;

  Future<void> getEquipments() async {
    getEquipmentsStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getEquipments();

    if (response is DataSuccess) {
      getEquipmentsStatus = RequestState.success;
      update();
      equipmentsModel = response.data!;
    } else {
      getEquipmentsStatus = RequestState.error;
      update();
    }
  }

  final equipmentTypeController = TextEditingController();
  final equipmentDescriptionController = TextEditingController();
  final equipmentCostController = TextEditingController();
  final equipmentDateController = TextEditingController();

  var equipmentFormKey = GlobalKey<FormState>();

  Future<void> insertEquipments() async {
    if (!equipmentFormKey.currentState!.validate()) return;

    insertEquipmentsRequestStatus = RequestState.loading;
    update();

    final dataState = await _globalRepo.insertEquipments(
      type: equipmentTypeController.text.trim(),
      description: equipmentDescriptionController.text.trim(),
      cost: equipmentCostController.text.trim(),
      date: equipmentDateController.text.trim(),
    );

    if (dataState is DataSuccess) {
      insertEquipmentsRequestStatus = RequestState.success;

      equipmentTypeController.clear();
      equipmentDescriptionController.clear();
      equipmentCostController.clear();
      equipmentDateController.clear();

      showSnackBar(dataState.data!.message, AlertState.success);
      getEquipments(); // دالة تحديث البيانات
      update();
    } else if (dataState is DataFailed) {
      insertEquipmentsRequestStatus = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  final updateEquipmentTypeController = TextEditingController();
  final updateEquipmentDescriptionController = TextEditingController();
  final updateEquipmentCostController = TextEditingController();
  final updateEquipmentDateController = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();
  var updateEquipmentsRequestStatus = RequestState.begin.obs;

  Future<void> updateEquipments({required int id}) async {
    if (!updateFormKey.currentState!.validate()) return;

    updateEquipmentsRequestStatus.value = RequestState.loading;

    final response = await _globalRepo.updateEquipments(
      id: id,
      type: updateEquipmentTypeController.text.trim(),
      description: updateEquipmentDescriptionController.text.trim(),
      cost: updateEquipmentCostController.text.trim(),
      date: updateEquipmentDateController.text.trim(),
    );

    if (response is DataSuccess) {
      updateEquipmentsRequestStatus.value = RequestState.success;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      // Clear fields
      updateEquipmentTypeController.clear();
      updateEquipmentDescriptionController.clear();
      updateEquipmentCostController.clear();
      updateEquipmentDateController.clear();
    } else if (response is DataFailed) {
      updateEquipmentsRequestStatus.value = RequestState.error;
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }


  String searchQuery = '';
  List<Equipment> get filteredEquipments {
    final originalList = equipmentsModel.data ?? [];
    if (searchQuery.isEmpty) return originalList;

    return HelperFunctions.search<Equipment>(
      originalList,
      searchQuery,
      searchFields: (item) => [
        item.type ?? '',
        item.date ?? '',
      ],
    );
  }
  void updateSearchQuery(String query) {
    searchQuery = query;
    update(); // يحدث GetBuilder
  }
}