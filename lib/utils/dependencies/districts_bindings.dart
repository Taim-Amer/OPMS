import 'package:get/get.dart';
import 'package:opms/features/admin/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/features/coordinator/districts/controller/districts_controller.dart';

class DistrictsBindings extends Bindings{
  @override
  void dependencies() {
    Get.create<DistrictsController>(() => DistrictsController());
    // Get.put<OutcomesController>(OutcomesController());
  }
}