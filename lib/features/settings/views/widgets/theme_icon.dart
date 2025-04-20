import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/circular_motion_animation.dart';
import 'package:opms/common/animations/rotate_animation.dart';
import 'package:opms/common/widgets/icons/circular_icon.dart';
import 'package:opms/features/settings/controllers/theme_controller.dart';
import 'package:opms/utils/constants/colors.dart';

class ThemeIcon extends StatelessWidget {
  const ThemeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    final dark = context.isDarkMode;
    return TRotateAnimation(
      duration: const Duration(seconds: 1),
      child: TCircularMotionAnimation(
        child: TCircularIcon(
          icon: dark ? Icons.sunny : Icons.nightlight_outlined,
          // size: TConsts.iconLg,
          color: dark ? Colors.yellowAccent : Colors.blue,
          backgroundColor: dark ? Colors.black : TColors.white,
          // width: 28.w,
          // height: 28.h,
          radius: 100.r,
          onPressed: () => controller.updateThemeMode(dark ? ThemeMode.light : ThemeMode.dark),
        ),
      ),
    );
  }
}
