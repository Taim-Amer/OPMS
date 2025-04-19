import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:opms/utils/api/api_service.dart';

class GlobalBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio(), fenix: true);
    Get.lazyPut<TApiService>(() => TApiService(Get.find<Dio>()), fenix: true);
  }
}