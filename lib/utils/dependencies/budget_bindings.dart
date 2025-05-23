import 'package:get/get.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';

class BudgetBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ReliefAssistanceController>(() => ReliefAssistanceController(), fenix: true);
  }
}