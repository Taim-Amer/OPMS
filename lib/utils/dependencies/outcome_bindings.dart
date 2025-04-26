import 'package:get/get.dart';
import 'package:opms/features/outcomes/controllers/outcomes_controller.dart';

class OutcomeBindings extends Bindings{
  @override
  void dependencies() {
    Get.create<OutcomesController>(() => OutcomesController());
  }
}