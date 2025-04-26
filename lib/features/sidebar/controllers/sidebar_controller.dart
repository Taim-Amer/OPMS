import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/departments/views/layouts/department_layout.dart';
import 'package:opms/features/home/views/layouts/home_layout.dart';
import 'package:opms/features/indicators/views/layouts/indicators_layout.dart';
import 'package:opms/features/outcomes/views/layouts/outcome_layout.dart';
import 'package:opms/features/outputs/views/layouts/outputs_layout.dart';
import 'package:opms/features/roles/views/layouts/roles_layout.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/utils/router/app_router.dart';

class SidebarController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();
  RxInt activeItem = 0.obs;
  RxInt hoverItem = (-1).obs;

  final List<String> titles = [
    'Home',
    'Departments',
    'Units',
    'Outcomes',
    'Outputs',
    'Indicators',
    'Activities',
    'Users',
  ];
  final List<Widget> screens = [
    const HomeLayout(),
    const DepartmentLayout(),
    Container(color: Colors.black,),
    const OutcomeLayout(),
    const OutputsLayout(),
    const IndicatorLayout(),
    Container(color: Colors.brown,),
    const RolesLayout(),
  ];

  void changeActiveItem(int index) => activeItem.value = index;

  bool isActive(int index) => activeItem == index;

  bool isHovering(int index) => hoverItem == index;

  void changeHoverItem(int index) {
    if (!isActive(index)) hoverItem.value = index;
  }

  void menuOnTap(int index) {
    if (!isActive(index)) {
      changeActiveItem(index);
      if (HelperFunctions.isMobileScreen(Get.context!)) Get.back();
      // Get.toNamed(index);
    }
  }

  Rx<RequestState> logoutState = RequestState.begin.obs;
  Future<void> logout() async {
    logoutState.value = RequestState.loading;
    await _repo.logout();
    CacheHelper.removeData(key: Keys.token);
    Get.offAllNamed(AppRoutes.kLogin);
    logoutState.value = RequestState.begin;
  }
}
