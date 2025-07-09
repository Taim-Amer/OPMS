// lib/common/widgets/layouts/rounded_section_container.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/utils/constants/colors.dart';

class RoundedSectionContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// `radius` and `padding` should be provided using screenutil, e.g. `16.r`, `16.w`
  const RoundedSectionContainer({
    super.key,
    required this.child,
    this.radius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Padding(
      // now padding is used directly
      padding: padding,
      child: TRoundedContainer(
        backgroundColor:
            dark ? TColors.dark : const Color.fromARGB(255, 233, 230, 230),
        radius: radius.r,               // make it responsive
        padding: EdgeInsets.all(16.w),  // inner padding for content
        child: child,
      ),
    );
  }
}
