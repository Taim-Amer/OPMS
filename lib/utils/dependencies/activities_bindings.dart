import 'package:get/get.dart';
import 'package:opms/features/admin/activities/controller/activities_controller.dart';

class ActivitiesBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<ActivitiesController>(ActivitiesController());
  }
}