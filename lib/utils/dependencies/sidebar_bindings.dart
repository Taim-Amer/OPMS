import 'package:get/get.dart';
import 'package:opms/features/indicators/controllers/indicators_controller.dart';
import 'package:opms/features/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/features/outputs/controller/outputs_controller.dart';
import 'package:opms/features/roles/controllers/roles_controller.dart';
import 'package:opms/features/activities/controller/activities_controller.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';

class SidebarBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<RolesController>(RolesController());
    Get.lazyPut<OutcomesController>(() => OutcomesController(), fenix: true);
    Get.lazyPut<OutputsController>(() => OutputsController(), fenix: true);
    Get.lazyPut<IndicatorsController>(() => IndicatorsController(), fenix: true);
    Get.lazyPut<DepartmentsController>(() => DepartmentsController(), fenix: true);
    Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
    Get.lazyPut<ActivitiesController>(() => ActivitiesController(), fenix: true);
  }
}