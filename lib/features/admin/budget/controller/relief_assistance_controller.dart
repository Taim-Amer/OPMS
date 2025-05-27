import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/budget/models/relief_assistance_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
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

  final unitController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

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

  Future<void> insertReliefAssistance() async{
    if (!formKey.currentState!.validate()) return;
    insertReliefAssistanceRequestStatus = RequestState.loading;
    update();
    final dataState = await _globalRepo.insertReliefAssistance(
      type: typeController.text.toString(),
      description: descriptionController.text.toString(),
      unitCost: unitController.text.toString(),
      date: dateController.text.toString(),
    );
    if (dataState is DataSuccess) {
      insertReliefAssistanceRequestStatus = RequestState.success;
      typeController.clear();
      unitController.clear();
      descriptionController.clear();
      dateController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getReliefAssistance();
      update();
    } else if (dataState is DataFailed) {
      insertReliefAssistanceRequestStatus = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
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

  String searchQuery = '';

  // 2. Getter للقائمة المصفّاة
  List<ReliefAssistance> get filteredReliefAssistance {
    final original = reliefAssistanceModel.data ?? [];
    if (searchQuery.isEmpty) return original;

    return HelperFunctions.search<ReliefAssistance>(
      original,
      searchQuery,
      searchFields: (item) => [
        item.type ?? '',
        item.description ?? '',
        item.date ?? '',
      ],
    );
  }

  void updateSearchQuery(String q) {
    searchQuery = q;
    update(); // يحدث GetBuilder
  }
}