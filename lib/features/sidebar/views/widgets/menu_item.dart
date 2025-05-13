import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/animations/loop_rotation_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/sidebar/controllers/sidebar_controller.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class MenuItem extends GetView<SidebarController> {
  const MenuItem({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return InkWell(
      onTap: () => controller.changeActiveItem(index),
      onHover: (hovering) => controller.changeHoverItem(hovering ? index : -1),
      child: Obx(() => TRoundedContainer(
            backgroundColor:
                (controller.isHovering(index) || controller.isActive(index))
                    ? TColors.primary
                    : Colors.transparent,
            radius: Sizes.cardRadiusMd,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: controller.isHovering(index)
                      ? const TLoopRotation(
                          child: Icon(Iconsax.status, color: TColors.white))
                      : Icon(
                          Iconsax.status,
                          color: !controller.isActive(index)
                              ? TColors.darkerGrey
                              : TColors.white,
                        ),
                ),
                TextWidget(
                  text: controller.titles[index].s14w700,
                  color:
                      controller.isActive(index) || controller.isHovering(index)
                          ? TColors.white
                          : dark
                              ? TColors.lightGrey
                              : TColors.darkerGrey,
                )
              ],
            ),
          )),
    );
  }
}
