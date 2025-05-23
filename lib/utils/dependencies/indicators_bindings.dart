import 'package:get/get.dart';
import 'package:opms/features/admin/indicators/controllers/indicators_controller.dart';

class IndicatorsBindings extends Bindings{
  @override
  void dependencies() {
    Get.create<IndicatorsController>(() => IndicatorsController());
  }
}