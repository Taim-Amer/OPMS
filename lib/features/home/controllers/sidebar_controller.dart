import 'package:get/get.dart';
import 'package:opms/utils/helpers/device_utility.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/app_router.dart';

class SidebarController extends GetxController{
  final activeItem = AppRoutes.kHome.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value = route;
  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void changeHoverItem(String route){
    if(!isActive(route)) hoverItem.value = route;
  }

  void menuOnTap(String route){
    if(!isActive(route)){
      changeActiveItem(route);
      if(HelperFunctions.isMobileScreen(Get.context!)) Get.back();
      Get.toNamed(route);
    }
  }
}