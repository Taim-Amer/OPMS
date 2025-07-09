import 'package:get/get.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/projects/controller/projects_controller.dart';

class DepartmentsBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<DepartmentsController>(DepartmentsController());
    Get.put<ProjectsController>(ProjectsController());
  }

}