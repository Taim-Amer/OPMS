import 'package:get/get.dart';
import 'package:opms/features/planner/planner_home/controller/planner_bread_crumb_controler.dart';
import '../planner_controller.dart';

class PlannerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlannerController>(
      () => PlannerController(),
      fenix: true,
    );
    Get.lazyPut<PlannerBreadcrumbController>(
      () => PlannerBreadcrumbController(),
      fenix: true,
    );

  }
}
