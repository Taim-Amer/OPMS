import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/layouts/rounded_section_container.dart';
import 'package:opms/features/manger/manager_activity_details/model/manager_plan_activity_details_model.dart';

import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class ManagerPlanDetailsSection extends StatelessWidget {
  final ActivityPlanData data;
  const ManagerPlanDetailsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final indicators = data.activity?.output?.indicators ?? [];
    final userName = data.createdBy?.name ?? '—';

    return RoundedSectionContainer(
      padding: EdgeInsetsGeometry.only(left: 0.w),
      radius: 20,
      // color: isDark ? TColors.darkContainer : TColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined,
                  color: TColors.crese500, size: 17.sp),
              SizedBox(width: 7.w),
              Text(
                'Indicators',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.textPrimary,
                ),
              ),
              SizedBox(width: 7.w),
              Tooltip(
                message: "All associated project indicators.",
                child: Icon(Icons.info_outline_rounded,
                    size: 15.sp, color: TColors.crese500),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: indicators.isNotEmpty
                ? indicators.map((indicator) {
                    return Tooltip(
                      message: indicator.name,
                      child: Chip(
                        label: Text(
                          indicator.name,
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                            color: HelperFunctions.isDarkMode(context)
                                ? TColors.white
                                : TColors.crese500,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 3.h),
                        backgroundColor: isDark
                            ? TColors.darkGrey.withOpacity(0.13)
                            : TColors.crese50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                          side: BorderSide(color: TColors.crese200, width: 1),
                        ),
                      ),
                    );
                  }).toList()
                : [
                    Text(
                      '—',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? TColors.white : TColors.textPrimary,
                      ),
                    ),
                  ],
            ),
            SizedBox(height: 20.h),
            Divider(
              height: 26.h,
              thickness: 1,
              color: isDark ? TColors.darkContainer : TColors.borderPrimary,
            ),
          if (data.createdBy != null)
            Row(
              children: [
                CircleAvatar(
                  radius: 15.w,
                  backgroundColor: TColors.cresePrimarySwatch,
                  child: Text(
                    (data.createdBy?.name ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: TColors.white),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "By ${data.createdBy?.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? TColors.darkGrey : TColors.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
