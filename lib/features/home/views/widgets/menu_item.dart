import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/animations/loop_rotation_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/home/controllers/sidebar_controller.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/router/app_router.dart';

class MenuItem extends GetView<SidebarController> {
  MenuItem({super.key, required this.index});

  final int index;

  final List<String> titles = [
    'Home',
    'Departments',
    'Units',
    'Outcomes',
    'Outputs',
    'Indicators',
    'Activities',
    'Users',
  ];

  final List<String> routes = [
    AppRoutes.kHome,
    "1",
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
  ];

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return InkWell(
      onTap: () => controller.changeActiveItem(routes[index]),
      onHover: (hovering) => controller.changeHoverItem(hovering ? routes[index] : '') ,
      child: Obx(() => TRoundedContainer(
        backgroundColor: (controller.isHovering(routes[index]) || controller.isActive(routes[index])) ? TColors.primary : Colors.transparent,
        radius: Sizes.cardRadiusMd,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.md),
              child: controller.isHovering(routes[index]) ?
              const TLoopRotation(child: Icon(Iconsax.status, color: TColors.white)) :
              Icon(Iconsax.status, color: !controller.isActive(routes[index]) ? TColors.darkerGrey : TColors.white,),
            ),
            TextWidget(
              text: titles[index].s14w700,
              color: controller.isActive(routes[index]) || controller.isHovering(routes[index]) ? TColors.white : dark ? TColors.lightGrey : TColors.darkerGrey,
            )
          ],
        ),
      )),
    );
  }
}
