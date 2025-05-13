import 'package:get/get.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';

class ProjectsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectsController());
  }
}
