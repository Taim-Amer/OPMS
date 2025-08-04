import 'package:get/get.dart';
import 'package:opms/features/manger/manager_home/controller/manager_controller.dart';
import 'package:opms/utils/dependencies/bread_crumb_controler.dart';

class ManagerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerController>(
      () => ManagerController(),
      fenix: true,
    );
    Get.lazyPut<BreadcrumbController>(
      () => BreadcrumbController(),
      fenix: true,
    );
  }
}
