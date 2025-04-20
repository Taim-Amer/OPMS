import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/sidebar/controllers/sidebar_controller.dart';

class SidebarMenu extends GetView<SidebarController> {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => TSiteTemplate(
      tablet: controller.screens[controller.activeItem.value],
      desktop: controller.screens[controller.activeItem.value],
      mobile: controller.screens[controller.activeItem.value],
    ));
  }
}
