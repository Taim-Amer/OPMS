import 'package:get/get.dart';
import 'package:opms/utils/dependencies/bread_crumb_controler.dart';
import '../planner_controller.dart';

class PlannerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlannerController>(
      () => PlannerController(),
      fenix: true,
    );
    Get.lazyPut<BreadcrumbController>(
      () => BreadcrumbController(),
      fenix: true,
    );
  }
}
