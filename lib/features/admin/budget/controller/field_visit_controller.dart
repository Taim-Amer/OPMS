import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/budget/models/field_visit_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class FieldVisitController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getFieldVisit();
    super.onInit();
  }


  RequestState getFieldVisitStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertFieldVisitRequestStatus = RequestState.begin;

  FieldVisitModel fieldVisitModel = FieldVisitModel.skeleton;

  Future<void> getFieldVisit() async {
    getFieldVisitStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getFieldVisit();

    if (response is DataSuccess) {
      getFieldVisitStatus = RequestState.success;
      update();
      fieldVisitModel = response.data!;
    } else {
      getFieldVisitStatus = RequestState.error;
      update();
    }
  }

  final fieldVisitUnitTypeController = TextEditingController();
  final fieldVisitDescriptionController = TextEditingController();
  final fieldVisitUnitPriceController = TextEditingController();
  final fieldVisitDateController = TextEditingController();

  var fieldVisitFormKey = GlobalKey<FormState>();

  Future<void> insertFieldVisit() async {
    if (!fieldVisitFormKey.currentState!.validate()) return;

    insertFieldVisitRequestStatus = RequestState.loading;
    update();

    final dataState = await _globalRepo.insertFieldVisit(
      unitType: fieldVisitUnitTypeController.text.trim(),
      description: fieldVisitDescriptionController.text.trim(),
      unitPrice: fieldVisitUnitPriceController.text.trim(),
      date: fieldVisitDateController.text.trim(),
    );

    if (dataState is DataSuccess) {
      insertFieldVisitRequestStatus = RequestState.success;

      fieldVisitUnitTypeController.clear();
      fieldVisitDescriptionController.clear();
      fieldVisitUnitPriceController.clear();
      fieldVisitDateController.clear();

      showSnackBar(dataState.data!.message, AlertState.success);
      getFieldVisit();
      update();
    } else if (dataState is DataFailed) {
      insertFieldVisitRequestStatus = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  final updateFieldVisitUnitTypeController = TextEditingController();
  final updateFieldVisitDescriptionController = TextEditingController();
  final updateFieldVisitUnitPriceController = TextEditingController();
  final updateFieldVisitDateController = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();
  var updateFieldVisitRequestStatus = RequestState.begin.obs;

  Future<void> updateFieldVisit({required int id}) async {
    if (!updateFormKey.currentState!.validate()) return;

    updateFieldVisitRequestStatus.value = RequestState.loading;

    final response = await _globalRepo.updateFieldVisit(
      id: id,
      unitType: updateFieldVisitUnitTypeController.text.trim(),
      description: updateFieldVisitDescriptionController.text.trim(),
      unitPrice: updateFieldVisitUnitPriceController.text.trim(),
      date: updateFieldVisitDateController.text.trim(),
    );

    if (response is DataSuccess) {
      updateFieldVisitRequestStatus.value = RequestState.success;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      updateFieldVisitUnitTypeController.clear();
      updateFieldVisitDescriptionController.clear();
      updateFieldVisitUnitPriceController.clear();
      updateFieldVisitDateController.clear();
      getFieldVisit();
    } else if (response is DataFailed) {
      updateFieldVisitRequestStatus.value = RequestState.error;
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }

  String searchQuery = '';

  List<FieldVisit> get filteredVisits {
    final original = fieldVisitModel.data ?? [];
    if (searchQuery.isEmpty) return original;

    return HelperFunctions.search<FieldVisit>(
      original,
      searchQuery,
      searchFields: (item) => [
        item.unitType ?? '',
        item.description ?? '',
        item.date ?? '',
      ],
    );
  }

  void updateSearchQuery(String q) {
    searchQuery = q;
    update();
  }
}