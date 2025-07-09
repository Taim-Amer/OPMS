// lib/features/planner/activity_plan_details/view/layouts/activity_plan_details_desktop.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/features/planner/activity_plan_details/view/widgets/remain_details_section.dart';
import 'package:opms/features/planner/activity_plan_details/view/widgets/summary_cards_section.dart';
import 'package:opms/features/planner/activity_plan_details/view/widgets/plan_regions_panel.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/features/planner/activity_plan_details/model/activity_plan_details_model.dart';

class ActivityPlanDetailsDesktop extends StatelessWidget {
  final ActivityPlanData data;
  final int activityID;
  const ActivityPlanDetailsDesktop(
      {super.key, required this.data, required this.activityID});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? TColors.dark : const Color.fromARGB(255, 233, 230, 230),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 24.h, left: 14.w, right: 14.w, bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_rounded,
                      size: 38.w, color: TColors.cresePrimarySwatch),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.activity?.name ?? '—',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? TColors.white : TColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            data.activity?.code ?? '—',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? TColors.darkGrey
                                  : TColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? TColors.creseDark : TColors.crese50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              "Plan Activity Details",
                              style: TextStyle(
                                color:
                                    isDark ? TColors.white : TColors.crese500,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (data.createdBy != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15.w,
                          backgroundColor: TColors.cresePrimarySwatch,
                          child: Text(
                            (data.createdBy?.name ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColors.white),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "By ${data.createdBy?.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? TColors.darkGrey
                                : TColors.textSecondary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Divider(
              height: 26.h,
              thickness: 1,
              color: isDark ? TColors.darkContainer2 : TColors.borderPrimary,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SummaryCardsSection(data: data),
                      SizedBox(height: 18.h),
                      PlanDetailsSection(data: data),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  flex: 2,
                  child: PlanRegionsPanel(
                    planActivityId: activityID,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
