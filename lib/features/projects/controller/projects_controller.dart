import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/projects/models/all_projects_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/logger_service.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class ProjectsController extends GetxController {
  static ProjectsController get instance => Get.find();

  final globalRepo = GeneralRepoImpl();

  Rx<RequestState> getProjectsRequestStatus = RequestState.begin.obs;
  Rx<RequestState> insertProjectRequestStatus = RequestState.begin.obs;
  Rx<RequestState> updateProjectRequestStatus = RequestState.begin.obs;

  Rx<ProjectsModel> projectssModel = ProjectsModel().obs;

  final TextEditingController projectName = TextEditingController();
  final TextEditingController projectCode = TextEditingController();
  final TextEditingController projectType = TextEditingController();

  void checkProjectsData() async {
    if (projectssModel.value.data == null) {
      await getProjects();
    }
  }

  Future<void> getProjects({int? departmentID}) async {
    LoggerService().logDebug("getting projects");
    try {
      getProjectsRequestStatus.value = RequestState.loading;
      final response = await globalRepo.getUnits(departmentID: departmentID);

      if (response is DataSuccess) {
        getProjectsRequestStatus.value = RequestState.success;
        projectssModel.value = response.data!;
      } else {
        getProjectsRequestStatus.value = RequestState.error;
      }
    } catch (e) {
      getProjectsRequestStatus.value = RequestState.error;
    }
  }

  Future<void> insertProject({required int departmentID}) async {
    LoggerService().logDebug("inserting departemtns");
    try {
      insertProjectRequestStatus.value = RequestState.loading;
      final response = await globalRepo.insertUnit(
          type: projectType.text.trim(),
          name: projectName.text.trim(),
          code: projectCode.text.trim(),
          departmentID: departmentID);

      if (response is DataSuccess) {
        insertProjectRequestStatus.value = RequestState.success;
        Get.back();
        showSnackBar(response.data!.message, AlertState.success);

        projectName.clear();
        projectCode.clear();
        getProjects();
      } else if (response is DataFailed) {
        insertProjectRequestStatus.value = RequestState.error;

        showSnackBar(response.error!.data.toString(), AlertState.error);
      }
    } catch (e) {
      LoggerService().logError("catch error in inser department $e");
      insertProjectRequestStatus.value = RequestState.error;

      showSnackBar("some thing went wrong".tr, AlertState.error);
    }
  }

  Future<void> updateProject(
      {required int unitID, required int projectID}) async {
    LoggerService().logDebug("updating updateProjectRequestStatus.value");
    try {
      updateProjectRequestStatus.value = RequestState.loading;
      final response = await globalRepo.updateUnit(
          departmentID: projectID,
          name: projectName.text.trim(),
          code: projectCode.text.trim(),
          unitID: unitID);

      if (response is DataSuccess) {
        updateProjectRequestStatus.value = RequestState.success;
        Get.back();
        showSnackBar(response.data!.message, AlertState.success);

        projectName.clear();
        projectCode.clear();
        projectType.clear();
        getProjects();
      } else if (response is DataFailed) {
        updateProjectRequestStatus.value = RequestState.error;

        showSnackBar(response.error!.data.toString(), AlertState.error);
      }
    } catch (e) {
      LoggerService()
          .logError("catch error in inser updateProjectRequestStatus.value $e");
      updateProjectRequestStatus.value = RequestState.error;

      showSnackBar("some thing went wrong".tr, AlertState.error);
    }
  }
}
