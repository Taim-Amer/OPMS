import 'package:get/get.dart';
import 'package:opms/features/activities/controller/activities_controller.dart';

class ActivitiesBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<ActivitiesController>(ActivitiesController());
  }
}