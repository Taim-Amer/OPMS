import 'package:get/get.dart';
import 'package:opms/features/indicators/controllers/indicators_controller.dart';
import 'package:opms/features/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/features/outputs/controller/outputs_controller.dart';
import 'package:opms/features/roles/controllers/roles_controller.dart';

class SidebarBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<RolesController>(RolesController());
    // Get.create(() => OutcomesController());
    // Get.create(() => OutputsController());
    // Get.create(() => IndicatorsController());
    Get.lazyPut(() => OutcomesController(), fenix: true);
    Get.lazyPut(() => OutputsController(), fenix: true);
    Get.lazyPut(() => IndicatorsController(), fenix: true);
    // Get.put<OutcomesController>(OutcomesController());
    // Get.put<OutputsController>(OutputsController());
    // Get.put<IndicatorsController>(IndicatorsController());
  }
}