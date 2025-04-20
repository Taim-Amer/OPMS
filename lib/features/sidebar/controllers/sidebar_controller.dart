import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/departments/views/layouts/department_layout.dart';
import 'package:opms/features/home/views/layouts/home_layout.dart';
import 'package:opms/utils/helpers/device_utility.dart';
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
    Container(color: Colors.black,),
    Container(color: Colors.redAccent,),
    Container(color: Colors.greenAccent,),
    Container(color: Colors.purple,),
    Container(color: Colors.brown,),
    Container(color: Colors.yellow,),
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
}
