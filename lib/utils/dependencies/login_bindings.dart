import 'package:get/get.dart';
import 'package:opms/features/admin/auth/controller/login_controller.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}