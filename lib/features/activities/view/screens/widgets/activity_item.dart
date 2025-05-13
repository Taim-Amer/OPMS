// file: features/activities/views/widgets/activity_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/activities/models/activities_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;
  const ActivityItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.defaultSpace / 2),
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
            offset: const Offset(2, 2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // name & code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: activity.name!.s16w700,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 8.h),
                TextWidget(
                  text: 'Code: ${activity.code!}'.s14w400,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          // timestamp or id
          TextWidget(
            text: activity.id.toString().s14w400,
            color: dark ? TColors.lightGrey : TColors.darkGrey,
          ),
        ],
      ),
    );
  }
}
