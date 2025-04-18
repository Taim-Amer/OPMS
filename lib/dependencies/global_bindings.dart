import 'package:get/get.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/api/global_repo.dart';
import 'package:opms/utils/constants/api_constants.dart';

class GlobalBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(baseUrl: TApiConstants.baseUrl), fenix: true);
    Get.lazyPut<GlobalRepository>(() => GlobalRepository(Get.find<ApiService>()), fenix: true);
  }
}