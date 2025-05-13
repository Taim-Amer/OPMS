import 'package:get/get.dart';
import 'package:opms/features/activities/controller/activites_controler.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';
import 'package:opms/features/sidebar/controllers/sidebar_controller.dart';

class SideBarBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SidebarController());
    Get.lazyPut(() => DepartmentsController());
    Get.lazyPut(() => ProjectsController());
    Get.lazyPut(() => ActivitiesController());
  }
}
