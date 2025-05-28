import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/features/admin/budget/views/widgets/equipments_list.dart';
import 'package:opms/features/admin/budget/views/widgets/field_visit_list.dart';
import 'package:opms/features/admin/budget/views/widgets/insert_equipments_container.dart';
import 'package:opms/features/admin/budget/views/widgets/insert_field_visit_container.dart';
import 'package:opms/features/admin/budget/views/widgets/insert_relief_container.dart';
import 'package:opms/features/admin/budget/views/widgets/insert_running_cost_container.dart';
import 'package:opms/features/admin/budget/views/widgets/insert_salary_container.dart';
import 'package:opms/features/admin/budget/views/widgets/insert_training_description_container.dart';
import 'package:opms/features/admin/budget/views/widgets/relief_assistance_list.dart';
import 'package:opms/features/admin/budget/views/widgets/running_cost_list.dart';
import 'package:opms/features/admin/budget/views/widgets/salaries_list.dart';
import 'package:opms/features/admin/budget/views/widgets/training_description_list.dart';

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

  List<Widget> insertContainer = [
    const InsertReliefContainer(),
    const InsertSalaryContainer(),
    const InsertTrainingDescriptionContainer(),
    // 'Training Sub Description',
    const InsertRunningCostContainer(),
    const InsertFieldVisitContainer(),
    const InsertEquipmentContainer(),
    const InsertTrainingDescriptionContainer(),
    // 'Training Cost',
  ];

  // List<Function> onTap = [
  //   () => Get.find<ReliefAssistanceController>().getReliefAssistance(),
  //   () => Get.find<SalariesController>().getSalaries(),
  //   (){},
  //   (){},
  //   (){},
  //   (){},
  //   (){},
  // ];

  List<Widget> itemsList = [
    const ReliefAssistanceList(),
    const SalariesList(),
    const ReliefAssistanceList(),
    const RunningCostList(),
    const FieldVisitList(),
    const EquipmentsList(),
    const TrainingDescriptionList(),
  ];

  void changeSelectedChip({required int value}){
    selectedChip = value;
    update();
  }
}