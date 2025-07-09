import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/users/models/users_model.dart';
import 'package:opms/features/admin/users/models/users_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/logger.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class UsersController extends GetxController{
  final GeneralRepo _repo = GeneralRepoImpl();

    RequestState getUsersState = RequestState.begin;
  RequestState insertUsersState = RequestState.begin;
  RequestState addRoleForUserStats = RequestState.begin;
  Rx<RequestState> updateUsersState = RequestState.begin.obs;

  UsersModel usersModel = UsersModel.skeleton;

  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userPasswordConfirmController = TextEditingController();


  final updateUserNameController = TextEditingController();
  final updateUserEmailController = TextEditingController();
  final updateUserPasswordController = TextEditingController();
  final updateUserPasswordConfirmController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var updateFormKey = GlobalKey<FormState>();

  int? roleID;
  // int? userID;
  List<int> departmentsIDs = [];
  List<int> unitsIDs = [];

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }

  Future<void> getUsers() async{
    getUsersState = RequestState.loading;
    update();
    final dataState = await _repo.getUsers();
    if (dataState is DataSuccess) {
      usersModel = dataState.data!;
      usersModel.data?.isEmpty ?? true ? getUsersState = RequestState.empty : getUsersState = RequestState.success;
      update();
    } else if (dataState is DataFailed) {
      getUsersState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> insertUser() async{
    if (!formKey.currentState!.validate()) return;
    insertUsersState = RequestState.loading;
    update();
    final dataState = await _repo.insertUser(
        name: userNameController.text.toString(),
      email: userEmailController.text,
      password: userPasswordController.text,
      passwordConfirm: userPasswordConfirmController.text,
    );
    if (dataState is DataSuccess) {
      insertUsersState = RequestState.success;
      userNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getUsers();
      update();
    } else if (dataState is DataFailed) {
      insertUsersState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateUser({required int userID}) async{
    // if (!updateFormKey.currentState!.validate()) return;
    updateUsersState.value = RequestState.loading;
    update();
    final dataState = await _repo.updateUser(
      userID: userID,
      name: updateUserNameController.text,
      email: updateUserEmailController.text,
      password: updateUserPasswordController.text,
      passwordConfirm: updateUserPasswordConfirmController.text,
      // method: 'PUT',
    );
    if (dataState is DataSuccess) {
      updateUsersState.value = RequestState.success;
      updateUserNameController.clear();
      updateUserPasswordConfirmController.clear();
      updateUserPasswordController.clear();
      updateUserEmailController.clear();
      // print('Trying to close dialog...');
      showSnackBar(dataState.data!.message, AlertState.success);
      getUsers();
      update();
    } else if (dataState is DataFailed) {
      LoggerHelper.error(dataState.data?.message ?? '');
      updateUsersState.value = RequestState.error;
      updateUserNameController.clear();
      updateUserPasswordConfirmController.clear();
      updateUserPasswordController.clear();
      updateUserEmailController.clear();
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
    Navigator.pop(Get.context!);
  }

  void setRoleID({required int id}){
    roleID = id;
    update();
  }

  Future<void> addRoleForUser({required int userID}) async{
    print(userID);
    print(roleID);
    print(departmentsIDs);
    print(unitsIDs);
    addRoleForUserStats = RequestState.loading;
    update();
    final dataState = await _repo.addRoleToUser(
      roleID: roleID ?? 0,
      userID: userID,
      departmentIDs: departmentsIDs,
      unitsIDs: unitsIDs,
    );
    if (dataState is DataSuccess) {
      update();
      showSnackBar(dataState.data?.message ?? '', AlertState.success);
      departmentsIDs.clear();
      unitsIDs.clear();
      // Get.back();
    } else if (dataState is DataFailed) {
      addRoleForUserStats = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
      departmentsIDs.clear();
      unitsIDs.clear();
      // Get.back();
    }
  }
}