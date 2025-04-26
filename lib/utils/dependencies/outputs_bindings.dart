import 'package:get/get.dart';
import 'package:opms/features/outputs/controller/outputs_controller.dart';

class OutputsBindings extends Bindings{
  @override
  void dependencies() {
    Get.create<OutputsController>(() => OutputsController());
    // Get.put<OutputsController>(OutputsController());
  }
}