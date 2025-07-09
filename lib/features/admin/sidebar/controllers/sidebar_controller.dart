import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/admin/activities/view/layout/activities_layout.dart';
import 'package:opms/features/admin/app/controllers/breadcrumb_controller.dart';
import 'package:opms/features/admin/budget/views/layouts/budget_layout.dart';
import 'package:opms/features/admin/departments/views/layouts/department_layout.dart';
import 'package:opms/features/admin/factors/views/layouts/factors_layout.dart';
import 'package:opms/features/admin/indicators/views/layouts/indicators_layout.dart';
import 'package:opms/features/admin/outcomes/views/layouts/outcome_layout.dart';
import 'package:opms/features/admin/outputs/views/layouts/outputs_layout.dart';
import 'package:opms/features/admin/projects/controller/projects_controller.dart';
import 'package:opms/features/admin/projects/view/layouts/projects_layout.dart';
import 'package:opms/features/admin/roles/views/layouts/roles_layout.dart';
import 'package:opms/features/admin/users/views/layouts/users_layout.dart';
import 'package:opms/features/coordinator/districts/views/layouts/districts_layout.dart';
import 'package:opms/features/coordinator/governorates/views/layouts/governorates_layout.dart';
import 'package:opms/features/coordinator/home/views/layout/home_layout.dart';
import 'package:opms/features/coordinator/risk_assessments/views/layouts/risks_layout.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/utils/router/app_router.dart';

class SidebarController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  /// indices for active / hover
  RxInt activeItem = 0.obs;
  RxInt hoverItem = (-1).obs;

  /// these will be filled per-role in onInit()
  late final List<String> titles;
  late final List<Widget> screens;
  late final List<VoidCallback> onTap;

  @override
  void onInit() {
    super.onInit();

    final role = CacheHelper.getData(key: Keys.role) as String? ?? '';

    if (role == 'admin') {
      titles = [
        'Departments',
        'Projects & Units',
        'Outcomes',
        'Outputs',
        'Indicators',
        'Activities',
        'Roles',
        'Users',
        'Factors',
        'Budget',
      ];
      screens = [
        const DepartmentLayout(),
        const ProjectsLayout(),
        const OutcomeLayout(),
        const OutputsLayout(),
        const IndicatorLayout(),
        const ActivitiesLayout(),
        const RolesLayout(),
        const UsersLayout(),
        const FactorsLayout(),
        const BudgetLayout(),
      ];
      onTap = [
            () {},
            () => Get.find<ProjectsController>().getProjects(),
            () {},
            () {},
            () {},
            () {},
            () {},
            () {},
            () {},
            () {},
      ];
    }
    else if (role == 'risk_coordinator') {
      titles = [
        'Home',
        'Governorates',
        'Districts',
        'Risks',
      ];
      screens = [
        const HomeLayout(fromAnother: false),
        const GovernoratesLayout(),
        const DistrictsLayout(fromAnother: false),
        const RisksLayout(),
      ];
      onTap = [
        () {},
        () {},
        () {},
        () {},
      ];
    }
    else {
      // fallback/default
      titles = ['Home'];
      screens = [const DepartmentLayout()];
      onTap = [() {}];
    }
  }

  int get menuItemCount => titles.length;
  void changeActiveItem(int index) => activeItem.value = index;
  void changeHoverItem(int index) {
    if (activeItem.value != index) hoverItem.value = index;
  }
  bool isActive(int i)   => activeItem.value == i;
  bool isHovering(int i) => hoverItem.value  == i;

  Rx<RequestState> logoutState = RequestState.begin.obs;
  Future<void> logout() async {
    logoutState.value = RequestState.loading;
    await _repo.logout();
    CacheHelper.removeData(key: Keys.token);
    CacheHelper.removeData(key: Keys.role);
    Get.find<BreadcrumbController>().resetTitles();
    Get.offAllNamed(AppRoutes.kLogin);
    logoutState.value = RequestState.begin;
  }
}
