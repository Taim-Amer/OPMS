import 'package:get/get.dart';
import 'package:opms/features/admin/budget/controller/budget_controller.dart';
import 'package:opms/features/admin/budget/controller/equipments_controller.dart';
import 'package:opms/features/admin/budget/controller/field_visit_controller.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/controller/runing_cost_controller.dart';
import 'package:opms/features/admin/budget/controller/salary_controller.dart';
import 'package:opms/features/admin/budget/controller/training_description_controller.dart';
import 'package:opms/features/admin/indicators/controllers/indicators_controller.dart';
import 'package:opms/features/admin/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/features/admin/outputs/controller/outputs_controller.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/features/admin/activities/controller/activities_controller.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/projects/controller/projects_controller.dart';

class SidebarBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<RolesController>(() => RolesController(), fenix: true);
    Get.lazyPut<OutcomesController>(() => OutcomesController(), fenix: true);
    Get.lazyPut<OutputsController>(() => OutputsController(), fenix: true);
    Get.lazyPut<IndicatorsController>(() => IndicatorsController(), fenix: true);
    Get.lazyPut<DepartmentsController>(() => DepartmentsController(), fenix: true);
    Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
    Get.lazyPut<ActivitiesController>(() => ActivitiesController(), fenix: true);

    //Budget
    Get.lazyPut<BudgetController>(() => BudgetController(), fenix: true);
    Get.lazyPut<ReliefAssistanceController>(() => ReliefAssistanceController(), fenix: true);
    Get.lazyPut<SalariesController>(() => SalariesController(), fenix: true);
    Get.lazyPut<RunningCostController>(() => RunningCostController(), fenix: true);
    Get.lazyPut<TrainingDescriptionController>(() => TrainingDescriptionController(), fenix: true);
    Get.lazyPut<EquipmentsController>(() => EquipmentsController(), fenix: true);
    Get.lazyPut<FieldVisitController>(() => FieldVisitController(), fenix: true);
  }
}