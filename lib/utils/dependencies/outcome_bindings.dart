import 'package:get/get.dart';
import 'package:opms/features/admin/outcomes/controllers/outcomes_controller.dart';

class OutcomeBindings extends Bindings{
  @override
  void dependencies() {
    Get.create<OutcomesController>(() => OutcomesController());
    // Get.put<OutcomesController>(OutcomesController());
  }
}