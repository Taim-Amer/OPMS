// lib/common/widgets/handlers/info_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const InfoItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    // background capsule
    final bgColor = HelperFunctions.isMobileScreen(context)
        ? dark
            ? TColors.darkBackground.withOpacity(0.2)
            : TColors.primaryBackground.withOpacity(0.1)
        : dark
            ? TColors.primary.withOpacity(0.2)
            : TColors.primary.withOpacity(0.1);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizes.md.w / 2),
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: Sizes.lg.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          // icon circle
          Container(
            width:  HelperFunctions.isMobileScreen(context)
                ?60.w :25.w,
            height:  HelperFunctions.isMobileScreen(context)
                ? 60.w: 25.w,
            decoration: const BoxDecoration(
              color: TColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: HelperFunctions.isMobileScreen(context)
                ?30.w: 12.w),
          ),
          SizedBox(width: Sizes.md.w),
          TextWidget(
            text: label.s14w700(context),
            color: HelperFunctions.isMobileScreen(context)
                ? Colors.white
                : TColors.primary,
          ),
        ],
      ),
    );
  }
}
