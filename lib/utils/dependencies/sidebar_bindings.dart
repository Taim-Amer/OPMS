import 'package:get/get.dart';
import 'package:opms/features/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/features/outputs/controller/outputs_controller.dart';
import 'package:opms/features/roles/controllers/roles_controller.dart';

class SidebarBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<RolesController>(RolesController());
    Get.put<OutcomesController>(OutcomesController());
    Get.put<OutputsController>(OutputsController());
  }
}