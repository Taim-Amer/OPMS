import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/handlers/wraper_widget.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/common/widgets/loaders/custom_loading_widget.dart';
import 'package:opms/features/admin/sidebar/controllers/sidebar_controller.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';

class SidebarMenu extends GetView<SidebarController> {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => WrapperWidget(
      condition: controller.logoutState.value == RequestState.loading,
      widget: (child) => CustomLoadingWidget(
        height: 1.sh,
        color: TColors.primary.withOpacity(0.1),
        child: child,
      ),
      fallBack: (child) => child,
      child: TSiteTemplate(
        tablet: controller.screens[controller.activeItem.value],
        desktop: controller.screens[controller.activeItem.value],
        mobile: controller.screens[controller.activeItem.value],
      ),
    ));
  }
}
