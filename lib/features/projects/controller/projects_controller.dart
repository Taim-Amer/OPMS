import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/projects/models/all_projects_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class ProjectsController extends GetxController {
  static ProjectsController get instance => Get.find();

  final globalRepo = GeneralRepoImpl();

  final Rx<ProjectsModel> allProjectsModel = ProjectsModel.skeleton.obs;
  final Rx<ProjectsModel> filteredProjectsModel = ProjectsModel.skeleton.obs;

  final Rx<RequestState> getAllProjectsRequestStatus = RequestState.begin.obs;
  final Rx<RequestState> getFilteredProjectsRequestStatus = RequestState.begin.obs;

  // final RxBool isFilteringByDepartment = false.obs;

  Rx<RequestState> insertProjectRequestStatus = RequestState.begin.obs;
  Rx<RequestState> updateProjectRequestStatus = RequestState.begin.obs;

  // Rx<ProjectsModel> projectssModel = ProjectsModel.skeleton.obs;

  final projectName = TextEditingController();
  final projectCode = TextEditingController();
  final projectType = TextEditingController();

  @override
  void onInit() {
    getProjects();
    super.onInit();
  }

  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final perPage = 10.obs;

  Future<void> getProjects({
    int? departmentID,
    int? page,
    int? perPageOverride,
    String? search,
  }) async {
    currentPage.value = page ?? currentPage.value;
    final usedPerPage = perPageOverride ?? perPage.value;

    if (departmentID != null) {
      getFilteredProjectsRequestStatus.value = RequestState.loading;
      final response = await globalRepo.getUnits(
        departmentID: departmentID,
        page: currentPage.value,
        perPage: usedPerPage,
        paginate: false,
        search: search,
      );

      if (response is DataSuccess) {
        getFilteredProjectsRequestStatus.value = RequestState.success;
        filteredProjectsModel.value = response.data!;
        totalPages.value = response.data?.meta?.lastPage ?? 1;
      } else {
        getFilteredProjectsRequestStatus.value = RequestState.error;
      }
    } else {
      getAllProjectsRequestStatus.value = RequestState.loading;
      final response = await globalRepo.getUnits(
        page: currentPage.value,
        paginate: true,
        perPage: usedPerPage,
        search: search,
      );

      if (response is DataSuccess) {
        getAllProjectsRequestStatus.value = RequestState.success;
        allProjectsModel.value = response.data!;
        totalPages.value = response.data?.meta?.lastPage ?? 1;
      } else {
        getAllProjectsRequestStatus.value = RequestState.error;
      }
    }
  }

  Future<void> insertProject({required int departmentID}) async {
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
  }

  Future<void> updateProject(
      {required int unitID, required int projectID}) async {
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
      getProjects(departmentID: projectID);
      getProjects();
    } else if (response is DataFailed) {
      updateProjectRequestStatus.value = RequestState.error;

      showSnackBar(response.error!.data.toString(), AlertState.error);
    }
  }
}
