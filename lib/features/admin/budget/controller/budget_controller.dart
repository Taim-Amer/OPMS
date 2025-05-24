import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/controller/salary_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/relief_assistance_list.dart';
import 'package:opms/features/admin/budget/views/widgets/running_cost_list.dart';
import 'package:opms/features/admin/budget/views/widgets/salaries_list.dart';

class BudgetController extends GetxController{
  int selectedChip = 0;

  List<String> titles = [
    'Relief Assistance',
    'Salary',
    'Training',
    // 'Training Sub Description',
    'Running Cost',
    'Field Visit',
    'Equipments',
    'Training Description',
    // 'Training Cost',
  ];

  List<Function> onTap = [
    () => Get.find<ReliefAssistanceController>().getReliefAssistance(),
    () => Get.find<SalariesController>().getSalaries(),
    (){},
    (){},
    (){},
    (){},
    (){},
  ];

  List<Widget> itemsList = [
    const ReliefAssistanceList(),
    const SalariesList(),
    const ReliefAssistanceList(),
    const RunningCostList(),
    const ReliefAssistanceList(),
    const ReliefAssistanceList(),
    Container(color: Colors.orange,),
  ];

  void changeSelectedChip({required int value}){
    selectedChip = value;
    update();
  }
}