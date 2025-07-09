// lib/features/planner/activity_plan_details/view/widgets/activity_plan_details_shimmer.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:opms/utils/constants/colors.dart';

class ActivityPlanDetailsShimmer extends StatelessWidget {
  const ActivityPlanDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 0, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer (activity name + code)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _block(
                width: 210.w,
                height: 36.h,
                isDark: isDark,
              ),
              SizedBox(width: 16.w),
              _block(
                width: 80.w,
                height: 24.h,
                isDark: isDark,
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // Summary & Status Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Expanded(
                child: Wrap(
                  spacing: 24.w,
                  runSpacing: 24.h,
                  children: List.generate(
                    5,
                    (i) => _summaryCardShimmer(isDark: isDark),
                  ),
                ),
              ),
              SizedBox(width: 32.w),
              // PlanRegions (right side)
              _planRegionsShimmer(isDark: isDark),
            ],
          ),
          SizedBox(height: 32.h),
          // Details section shimmer
          _detailsSectionShimmer(isDark: isDark),
        ],
      ),
    );
  }

  /// Shimmer block helper
  static Widget _block({
    required double width,
    required double height,
    required bool isDark,
    EdgeInsets? margin,
  }) {
    final baseColor = isDark ? TColors.darkContainer.withOpacity(0.38) : Colors.grey.shade300;
    final highlightColor = isDark ? TColors.darkGrey.withOpacity(0.16) : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  /// Summary Card shimmer
  static Widget _summaryCardShimmer({required bool isDark}) {
    final baseColor = isDark ? TColors.darkContainer2.withOpacity(0.47) : Colors.grey.shade200;
    final highlightColor = isDark ? TColors.darkGrey.withOpacity(0.18) : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: 280.w,
        height: 118.h,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _block(width: 28.sp, height: 28.sp, isDark: isDark),
                Spacer(),
                _block(width: 20.sp, height: 20.sp, isDark: isDark),
              ],
            ),
            SizedBox(height: 16.h),
            _block(width: 90.w, height: 28.h, isDark: isDark),
            SizedBox(height: 8.h),
            _block(width: 70.w, height: 14.h, isDark: isDark),
          ],
        ),
      ),
    );
  }

  /// PlanRegions (side card) shimmer
  static Widget _planRegionsShimmer({required bool isDark}) {
    // For dark mode: use a deep, subtle gradient.
    final List<Color> gradientColors = isDark
        ? [TColors.darkContainer2.withOpacity(0.93), TColors.darkBackground.withOpacity(0.95)]
        : [TColors.crese200.withOpacity(0.13), TColors.crese600.withOpacity(0.08)];

    final baseColor = isDark
        ? TColors.darkGrey.withOpacity(0.14)
        : TColors.crese200.withOpacity(0.13);

    final highlightColor = isDark
        ? Colors.white.withOpacity(0.08)
        : TColors.crese600.withOpacity(0.07);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: 300.w,
        height: 270.h,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            5,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _block(width: 220.w, height: 24.h, isDark: isDark),
            ),
          ),
        ),
      ),
    );
  }

  /// Details section shimmer (indicators + "Created by")
  static Widget _detailsSectionShimmer({required bool isDark}) {
    final baseColor = isDark ? TColors.darkContainer2.withOpacity(0.33) : Colors.grey.shade200;
    final highlightColor = isDark ? TColors.darkGrey.withOpacity(0.13) : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        margin: EdgeInsets.only(top: 24.h),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _block(width: 100.w, height: 18.h, isDark: isDark),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: List.generate(
                5,
                (i) => _block(width: 68.w, height: 28.h, isDark: isDark),
              ),
            ),
            SizedBox(height: 32.h),
            _block(width: 100.w, height: 16.h, isDark: isDark),
            SizedBox(height: 10.h),
            _block(width: 140.w, height: 22.h, isDark: isDark),
          ],
        ),
      ),
    );
  }
}
