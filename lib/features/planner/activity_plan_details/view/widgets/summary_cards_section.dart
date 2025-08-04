import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opms/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart';
import 'package:opms/features/planner/activity_plan_details/model/activity_plan_details_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class SummaryCardsSection extends StatelessWidget {
  final ActivityPlanData data;
  final int activityID;
  const SummaryCardsSection(
      {super.key, required this.data, required this.activityID});

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
              child: Icon(Icons.info_outline_rounded,
                  size: 18.sp, color: TColors.cresePrimarySwatch),
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
              tooltip:
                  'Shows the current project status (e.g., planned, ongoing, completed).',
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
              tooltip:
                  'Total estimated cost for this plan, formatted with separators.',
              onMenuTap: () {},
            ),
            _SummaryCard(
              icon: Icons.calendar_today_rounded,
              mainText:
                  '${data.yearOfImplementation ?? '—'} • ${data.numberOfYearsToImplementation ?? '—'} ${(data.numberOfYearsToImplementation ?? 0) > 1 ? 'years' : 'year'}',
              label: 'Timeline',
              tooltip: 'Year of start and duration of implementation.',
              onMenuTap: () => _showChangeTimelineDialog(
                  context, activityID, data.numberOfYearsToImplementation ?? 1),
            ),
          ],
        ),
      ],
    );
  }
}

void _showChangeTimelineDialog(
  BuildContext context,
  int planActivityID,
  int yearsImp,
) {
  final controller =
      Get.find<ActivityPlanDetailsController>(tag: "$planActivityID");
  int years = yearsImp;
  String comment = '';

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ─── Header ───────────────────────────
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 28, color: Colors.blueAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Adjust Implementation Duration',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontSize: 16),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ─── Current Value ────────────────────
                Text(
                  'Duration (years):',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),

                // ─── Stepper Controls ──────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: years > 1 ? TColors.cresecondary : Colors.grey,
                      iconSize: 30,
                      onPressed:
                          years > 1 ? () => setState(() => years--) : null,
                      tooltip: 'Decrease',
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$years',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: years < 10 ? TColors.cresecondary : Colors.grey,
                      iconSize: 30,
                      onPressed:
                          years < 10 ? () => setState(() => years++) : null,
                      tooltip: 'Increase',
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // ─── Comment Field ────────────────────
                TextField(
                  onChanged: (v) => comment = v,
                  decoration: InputDecoration(
                    labelText: 'Comments (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                // ─── Actions ──────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.cresecondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          GoRouter.of(context).pop();
                          final success = await controller.updateplan(
                            isMovedToNext: 0,
                            context: context,
                            years: years,
                            comment: comment.isNotEmpty ? comment : null,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              backgroundColor:
                                  success ? Colors.green : Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              duration: const Duration(seconds: 4),
                              content: Row(
                                children: [
                                  Icon(
                                    success
                                        ? Icons.check_circle_outline
                                        : Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      success
                                          ? "The number of years of implementation has been updated successfully."
                                          : 'Failed to save update',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Text('Confirm'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
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
            color: isDark
                ? Colors.black.withOpacity(0.09)
                : Colors.black.withOpacity(0.04),
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
                Icon(icon,
                    size: 26.sp,
                    color: HelperFunctions.isDarkMode(context)
                        ? TColors.white
                        : TColors.black),
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
