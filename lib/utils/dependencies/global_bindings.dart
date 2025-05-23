import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:opms/features/admin/sidebar/controllers/sidebar_controller.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class GlobalBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio(), fenix: true);
    Get.lazyPut<ApiService>(() => ApiService(Get.find<Dio>()), fenix: true);
    Get.lazyPut<GeneralRepo>(() => GeneralRepoImpl(), fenix: true);
    // Get.put<SidebarController>(SidebarController());
    Get.lazyPut<SidebarController>(() => SidebarController(), fenix: true);
  }
}