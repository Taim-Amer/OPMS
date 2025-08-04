import 'package:get/get.dart';
import 'package:opms/features/director/director_home/controller/director_controller.dart';
import 'package:opms/utils/dependencies/bread_crumb_controler.dart';

class DirectorBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectorController>(
      () => DirectorController(),
      fenix: true,
    );
    Get.lazyPut<BreadcrumbController>(
      () => BreadcrumbController(),
      fenix: true,
    );
  }
}
