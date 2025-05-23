import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/departments/models/departments_model.dart';
import 'package:opms/features/admin/projects/controller/projects_controller.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class DepartmentsController extends GetxController {
  static DepartmentsController get instance => Get.find<DepartmentsController>();
  final globalRepo = GeneralRepoImpl();
  final projectsController = ProjectsController.instance;

  Rx<bool> showProjects = false.obs;

  @override
  void onInit() {
    getDepartments();
    super.onInit();
  }

  Rx<RequestState> getDepartmentsRequestStatus = RequestState.begin.obs;
  Rx<RequestState> insertDepartmentsRequestStatus = RequestState.begin.obs;
  Rx<RequestState> updateDepartmentsRequestStatus = RequestState.begin.obs;

  Rx<DepartmentsModel> departmentsModel = DepartmentsModel.skeleton.obs;

  final departmentName = TextEditingController();
  final departemntCode = TextEditingController();

  Rx<int?> selectedDepartmentID = Rx<int?>(null);

  void toggleShowProjects({required int departmentID}) async {
    projectsController.getProjects(departmentID: departmentID);
    if (selectedDepartmentID.value == departmentID) {
      selectedDepartmentID.value = null;
      showProjects.value = false;
    } else {
      selectedDepartmentID.value = departmentID;
      showProjects.value = true;
    }
  }


  Future<void> getDepartments() async {
    getDepartmentsRequestStatus.value = RequestState.loading;
    final response = await globalRepo.getDepartments();

    if (response is DataSuccess) {
      departmentsModel.value = response.data!;
      getDepartmentsRequestStatus.value = RequestState.success;
    } else {
      getDepartmentsRequestStatus.value = RequestState.error;
    }
  }

  Future<void> insertDepartment() async {
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
  }

  Future<void> updateDepartment({required int departemtnID}) async {
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
  }
}
