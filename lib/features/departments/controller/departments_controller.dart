import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/departments/models/departments_model.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/logger_service.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class DepartmentsController extends GetxController {
  static DepartmentsController get instance => Get.find();
  final globalRepo = GeneralRepoImpl();
  final projectsController = ProjectsController.instance;

  Rx<bool> showProjects = false.obs;

  Rx<int> selectedDepartementID = 0.obs;

  Rx<RequestState> getDepartmentsRequestStatus = RequestState.begin.obs;
  Rx<RequestState> insertDepartmentsRequestStatus = RequestState.begin.obs;
  Rx<RequestState> updateDepartmentsRequestStatus = RequestState.begin.obs;

  Rx<DepartmentsModel> departmentsModel = DepartmentsModel().obs;

  final TextEditingController departmentName = TextEditingController();
  final TextEditingController departemntCode = TextEditingController();

  void checkDepartmentData() async {
    if (departmentsModel.value.departments == null) {
      await getDepartments();
    }
  }

  void toggleShowProjects() async {
    if (departmentsModel.value.departments != null) {
      showProjects.value = !showProjects.value;
      if (selectedDepartementID.value == 0) {
        selectedDepartementID.value =
            departmentsModel.value.departments![0].id!;
      }
    }
    projectsController.checkProjectsData();
  }

  Future<void> getDepartments() async {
    LoggerService().logDebug("getting departemtns");
    try {
      getDepartmentsRequestStatus.value = RequestState.loading;
      final response = await globalRepo.getDepartments();

      if (response is DataSuccess) {
        getDepartmentsRequestStatus.value = RequestState.success;
        departmentsModel.value = response.data!;
      } else {
        getDepartmentsRequestStatus.value = RequestState.error;
      }
    } catch (e) {
      getDepartmentsRequestStatus.value = RequestState.error;
    }
  }

  Future<void> insertDepartment() async {
    LoggerService().logDebug("inserting departemtns");
    try {
      insertDepartmentsRequestStatus.value = RequestState.loading;
      final response = await globalRepo.insertDepartment(
          name: departmentName.text.trim(), code: departemntCode.text.trim());

      if (response is DataSuccess) {
        insertDepartmentsRequestStatus.value = RequestState.success;
        Get.back();
        showSnackBar(response.data!.message, AlertState.success);

        departmentName.clear();
        departemntCode.clear();
        getDepartments();
      } else if (response is DataFailed) {
        insertDepartmentsRequestStatus.value = RequestState.error;

        showSnackBar(response.error!.data.toString(), AlertState.error);
      }
    } catch (e) {
      LoggerService().logError("catch error in inser department $e");
      insertDepartmentsRequestStatus.value = RequestState.error;

      showSnackBar("some thing went wrong".tr, AlertState.error);
    }
  }

  Future<void> updateDepartment({required int departemtnID}) async {
    LoggerService().logDebug("updating departemtns");
    try {
      updateDepartmentsRequestStatus.value = RequestState.loading;
      final response = await globalRepo.updateDepartment(
          departmentID: departemtnID,
          name: departmentName.text.trim(),
          code: departemntCode.text.trim());

      if (response is DataSuccess) {
        updateDepartmentsRequestStatus.value = RequestState.success;
        Get.back();
        showSnackBar(response.data!.message, AlertState.success);

        departmentName.clear();
        departemntCode.clear();
        getDepartments();
      } else if (response is DataFailed) {
        updateDepartmentsRequestStatus.value = RequestState.error;

        showSnackBar(response.error!.data.toString(), AlertState.error);
      }
    } catch (e) {
      LoggerService().logError("catch error in inser department $e");
      updateDepartmentsRequestStatus.value = RequestState.error;

      showSnackBar("some thing went wrong".tr, AlertState.error);
    }
  }
}
