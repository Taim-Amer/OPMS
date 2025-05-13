import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/activities/controller/activites_controler.dart';
import 'package:opms/features/activities/view/layout/activites_layout.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/departments/views/layouts/department_layout.dart';
import 'package:opms/features/home/views/layouts/home_layout.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class SidebarController extends GetxController {
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
    Container(
      color: Colors.black,
    ),
    Container(
      color: Colors.redAccent,
    ),
    Container(
      color: Colors.greenAccent,
    ),
    Container(
      color: Colors.purple,
    ),
    const ActivitesLayout(),
    Container(
      color: Colors.yellow,
    ),
  ];

  void changeActiveItem(int index) => activeItem.value = index;

  bool isActive(int index) => activeItem == index;

  bool isHovering(int index) => hoverItem == index;

  void changeHoverItem(int index) {
    if (!isActive(index)) hoverItem.value = index;
  }

  void menuOnTap(int index) {
    if (!isActive(index)) {
      sideBarSwitch(index);

      changeActiveItem(index);
      if (HelperFunctions.isMobileScreen(Get.context!)) Get.back();
      // Get.toNamed(index);
    }
  }

  void sideBarSwitch(int index) {
    // 3) Per‑tab logic
    switch (index) {
      case 0:
        // Home tab logic
        // e.g. Get.toNamed('/home');
        break;

      case 1:
        DepartmentsController.instance.checkDepartmentData();

        break;

      case 2:
        // Units tab logic
        // e.g. fetchUnits();
        break;

      case 3:
        // Outcomes tab logic
        // e.g. loadOutcomes();
        break;

      case 4:
        // Outputs tab logic
        // e.g. loadOutputs();
        break;

      case 5:
        // Indicators tab logic
        // e.g. loadIndicators();
        break;

      case 6:
        ActivitiesController.instance.checkDepartmentData();
        // Activities tab logic
        // e.g. loadActivities();
        break;

      case 7:
        // Users tab logic
        // e.g. loadUsers();
        break;

      default:
        // Optional: handle unexpected indices
        break;
    }
  }
}
