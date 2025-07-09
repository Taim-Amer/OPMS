import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opms/features/planner/activity_plan_details/model/activity_plan_details_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class SummaryCardsSection extends StatelessWidget {
  final ActivityPlanData data;
  const SummaryCardsSection({super.key, required this.data});

  String formatCost(String? value) {
    if (value == null) return '—';
    try {
      final num = int.tryParse(value);
      if (num == null) return value;
      return NumberFormat("#,##0", "en_US").format(num);
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Key Highlights",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: isDark ? TColors.white : TColors.textPrimary,
              ),
            ),
            SizedBox(width: 6.w),
            Tooltip(
              message:
                  'Quick overview of project status, outputs, outcomes, cost, and timeline.',
              child: Icon(Icons.info_outline_rounded, size: 18.sp, color: TColors.cresePrimarySwatch),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 24.w,
          runSpacing: 24.h,
          children: [
            _SummaryCard(
              assetPath: isDark
                  ? "assets/images/status_dark.png"
                  : "assets/images/status_light.png",
              mainText: data.projectImplementationStatus ?? '—',
              label: 'Project Status',
              tooltip: 'Shows the current project status (e.g., planned, ongoing, completed).',
              badge: (data.projectImplementationStatus == 'planned')
                  ? 'New'
                  : null,
              onMenuTap: () {},
            ),
            _SummaryCard(
              assetPath: isDark
                  ? "assets/images/efficiency_dark.png"
                  : "assets/images/efficiency_light.png",
              mainText: data.activity?.output?.name ?? '—',
              label: 'Output',
              tooltip: 'Main output of this activity plan.',
              onMenuTap: () {},
            ),
            _SummaryCard(
              assetPath: isDark
                  ? "assets/images/income_light.png"
                  : "assets/images/income_dark.png",
              mainText: data.activity?.output?.outcome?.name ?? '—',
              label: 'Outcome',
              tooltip: 'Key outcome associated with the output.',
              onMenuTap: () {},
            ),
            _SummaryCard(
              assetPath: isDark
                  ? "assets/images/cost_dark.png"
                  : "assets/images/cost_light.png",
              mainText: formatCost(data.totalCost),
              label: 'Total Cost',
              tooltip: 'Total estimated cost for this plan, formatted with separators.',
              onMenuTap: () {},
            ),
            _SummaryCard(
              icon: Icons.calendar_today_rounded,
              mainText:
                  '${data.yearOfImplementation ?? '—'} • ${data.numberOfYearsToImplementation ?? '—'} ${(data.numberOfYearsToImplementation ?? 0) > 1 ? 'years' : 'year'}',
              label: 'Timeline',
              tooltip: 'Year of start and duration of implementation.',
              onMenuTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String mainText;
  final String label;
  final String? tooltip;
  final String? badge;
  final VoidCallback onMenuTap;

  const _SummaryCard({
    super.key,
    this.icon,
    this.assetPath,
    required this.mainText,
    required this.label,
    required this.onMenuTap,
    this.tooltip,
    this.badge,
  }) : assert(icon != null || assetPath != null);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = Container(
      width: 262.w,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        border: Border.all(
          color: isDark ? TColors.darkBorder : TColors.crese200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.09) : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (assetPath != null)
                Image.asset(
                  assetPath!,
                  width: 26.sp,
                  height: 26.sp,
                  fit: BoxFit.contain,
                )
              else
                Icon(icon, size: 26.sp, color: HelperFunctions.isDarkMode(context)? TColors.white : TColors.black),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: isDark ? TColors.creseDark : TColors.crese50,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      color: TColors.crese500,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              InkWell(
                onTap: onMenuTap,
                borderRadius: BorderRadius.circular(16.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.more_vert,
                    size: 18.sp,
                    color: isDark ? TColors.darkGrey : TColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SelectableText(
            mainText,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? TColors.white : TColors.textPrimary,
            ),
            maxLines: 1,
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? TColors.darkGrey : TColors.textSecondary,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );

    return Tooltip(
      message: tooltip ?? label,
      preferBelow: false,
      waitDuration: Duration(milliseconds: 350),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: card,
        ),
      ),
    );
  }
}
