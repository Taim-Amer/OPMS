import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/roles/models/roles_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class RolesController extends GetxController{
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getRolesState = RequestState.begin;
  RequestState insertRolesState = RequestState.begin;
  RequestState updateRolesState = RequestState.begin;
  
  RolesModel rolesModel = RolesModel.skeleton;

  final roleNameController = TextEditingController();
  final updateRoleController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var updateFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    getRoles();
    super.onInit();
  }

  Future<void> getRoles() async{
    getRolesState = RequestState.loading;
    update();
    final dataState = await _repo.getRoles();
    if (dataState is DataSuccess) {
      rolesModel = dataState.data!;
      rolesModel.data?.isEmpty ?? true ? getRolesState = RequestState.empty : getRolesState = RequestState.success;
      update();
    } else if (dataState is DataFailed) {
      getRolesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }
  
  Future<void> insertRole() async{
    if (!formKey.currentState!.validate()) return;
    insertRolesState = RequestState.loading;
    update();
    final dataState = await _repo.insertRole(name: roleNameController.text.toString());
    if (dataState is DataSuccess) {
      insertRolesState = RequestState.success;
      roleNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getRoles();
      update();
    } else if (dataState is DataFailed) {
      insertRolesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateRole({required int roleID}) async{
    if (!updateFormKey.currentState!.validate()) return;
    updateRolesState = RequestState.loading;
    update();
    final dataState = await _repo.updateRole(name: updateRoleController.text.toString(), roleID: roleID);
    if (dataState is DataSuccess) {
      updateRolesState = RequestState.success;
      updateRoleController.clear();
      // print('Trying to close dialog...');
      showSnackBar(dataState.data!.message, AlertState.success);
      getRoles();
      update();
    } else if (dataState is DataFailed) {
      updateRolesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
    Navigator.pop(Get.context!);
  }

}