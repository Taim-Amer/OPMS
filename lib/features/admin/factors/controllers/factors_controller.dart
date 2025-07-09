import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/factors/models/factors_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class FactorsController extends GetxController{
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getFactorsState = RequestState.begin;
  RequestState insertFactorsState = RequestState.begin;
  Rx<RequestState> updateFactorsState = RequestState.begin.obs;
  
  FactorsModel factorsModel = FactorsModel.skeleton;

  final factorTitleController = TextEditingController();
  final updateFactorTitleController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var updateFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    getFactors();
    super.onInit();
  }

  Future<void> getFactors() async{
    getFactorsState = RequestState.loading;
    update();
    final dataState = await _repo.getFactors();
    if (dataState is DataSuccess) {
      factorsModel = dataState.data!;
      factorsModel.data?.isEmpty ?? true ? getFactorsState = RequestState.empty : getFactorsState = RequestState.success;
      update();
    } else if (dataState is DataFailed) {
      getFactorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }
  
  Future<void> insertFactor() async{
    if (!formKey.currentState!.validate()) return;
    insertFactorsState = RequestState.loading;
    update();
    final dataState = await _repo.insertFactor(title: factorTitleController.text.toString());
    if (dataState is DataSuccess) {
      insertFactorsState = RequestState.success;
      factorTitleController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getFactors();
      update();
    } else if (dataState is DataFailed) {
      insertFactorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateFactor({required int factorID}) async{
    if (!updateFormKey.currentState!.validate()) return;
    updateFactorsState.value = RequestState.loading;
    update();
    final dataState = await _repo.updateFactor(
      title: updateFactorTitleController.text.toString(),
      factorID: factorID,
    );
    if (dataState is DataSuccess) {
      updateFactorsState.value = RequestState.success;
      updateFactorTitleController.clear();
      // print('Trying to close dialog...');
      showSnackBar(dataState.data!.message, AlertState.success);
      getFactors();
      update();
    } else if (dataState is DataFailed) {
      updateFactorsState.value = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
    Navigator.pop(Get.context!);
  }

}