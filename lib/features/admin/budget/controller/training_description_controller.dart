import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/budget/models/training_description_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class TrainingDescriptionController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getTrainingDescription();
    super.onInit();
  }


  RequestState getTrainingDescriptionStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertTrainingDescriptionRequestStatus = RequestState.begin;

  TrainingDescriptionModel trainingDescriptionModel = TrainingDescriptionModel.skeleton;

  Future<void> getTrainingDescription() async {
    getTrainingDescriptionStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getTrainingDescription();

    if (response is DataSuccess) {
      getTrainingDescriptionStatus = RequestState.success;
      update();
      trainingDescriptionModel = response.data!;
    } else {
      getTrainingDescriptionStatus = RequestState.error;
      update();
    }
  }

  final trainingNameController = TextEditingController();
  var trainingFormKey = GlobalKey<FormState>();

  Future<void> insertTrainingDescription() async {
    if (!trainingFormKey.currentState!.validate()) return;

    insertTrainingDescriptionRequestStatus = RequestState.loading;
    update();

    final dataState = await _globalRepo.insertTrainingDescription(
      name: trainingNameController.text.trim(),
    );

    if (dataState is DataSuccess) {
      insertTrainingDescriptionRequestStatus = RequestState.success;

      trainingNameController.clear();

      showSnackBar(dataState.data!.message, AlertState.success);
      getTrainingDescription(); // دالة لجلب البيانات المحدّثة
      update();
    } else if (dataState is DataFailed) {
      insertTrainingDescriptionRequestStatus = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  final updateTrainingNameController = TextEditingController();
  final updateFormKey = GlobalKey<FormState>();
  var updateTrainingDescriptionRequestStatus = RequestState.begin.obs;

  Future<void> updateTrainingDescription({required int id}) async {
    if (!updateFormKey.currentState!.validate()) return;

    updateTrainingDescriptionRequestStatus.value = RequestState.loading;

    final response = await _globalRepo.updateTrainingDescription(
      id: id,
      name: updateTrainingNameController.text.trim(),
    );

    if (response is DataSuccess) {
      updateTrainingDescriptionRequestStatus.value = RequestState.success;
      Get.back();
      showSnackBar(response.data!.message, AlertState.success);

      // Clear field
      updateTrainingNameController.clear();
      getTrainingDescription();
    } else if (response is DataFailed) {
      updateTrainingDescriptionRequestStatus.value = RequestState.error;
      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }

  String searchQuery = '';

  List<TrainingDescription> get filteredDescriptions {
    final original = trainingDescriptionModel.data ?? [];
    if (searchQuery.isEmpty) return original;

    return HelperFunctions.search<TrainingDescription>(
      original,
      searchQuery,
      searchFields: (item) => [
        item.name ?? '',
      ],
    );
  }

  void updateSearchQuery(String q) {
    searchQuery = q;
    update();
  }

}