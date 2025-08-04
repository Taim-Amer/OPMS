// lib/features/planner/activity_plan_details/view/layouts/activity_plan_details_desktop.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart';
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
                  GetBuilder<ActivityPlanDetailsController>(
                    tag: '$activityID',
                    builder: (ctrl) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.cresecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 22),
                          elevation: 0,
                        ),
                        onPressed: ctrl.savingToManager.value
                            ? null
                            : () =>
                                _showSaveToManagerDialog(context, activityID),
                        child: ctrl.savingToManager.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.send_rounded),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Save to manager',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                                  600
                                              ? 14.5
                                              : 15.5,
                                    ),
                                  ),
                                ],
                              ),
                      );
                    },
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
                      SummaryCardsSection(
                        data: data,
                        activityID: activityID,
                      ),
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

  void _showSaveToManagerDialog(
    BuildContext parentContext,
    int activityID,
  ) {
    final controller = Get.find<ActivityPlanDetailsController>(
      tag: '$activityID',
    );
    String comment = '';

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setState) => Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Header ────────────────────────────────
                  Row(
                    children: [
                      const Icon(Icons.help_outline,
                          size: 28, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Confirm submission',
                          style: Theme.of(parentContext)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(dialogCtx).pop(),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Are you sure you want to send this plan to your manager for approval?',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // ─── Optional comment ───────────────────────
                  TextField(
                    onChanged: (v) => comment = v,
                    decoration: InputDecoration(
                      labelText: 'Comments (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  // ─── Actions ────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => Navigator.of(dialogCtx).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            // 1) Close the dialog
                            Navigator.of(dialogCtx).pop();

                            // 2) Call your controller
                            final success = await controller.updateplan(
                              context: parentContext,
                              isMovedToNext: 1,
                              years: null,
                              comment: comment.isNotEmpty ? comment : null,
                            );

                            // 3) Schedule the SnackBar in next frame
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) {
                              ScaffoldMessenger.of(parentContext)
                                  .showSnackBar(
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
                                              ? "The plan has been sent to the manager."
                                              : "Failed to send to manager.",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
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

}
