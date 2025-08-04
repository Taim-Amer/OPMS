// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';

import 'package:opms/features/manger/manager_activity_details/controller/manager_activity_plan_details_controller.dart';
import 'package:opms/features/manger/manager_activity_details/model/manager_plan_activity_details_model.dart';
import 'package:opms/features/manger/manager_activity_details/view/widgets/manager_plan_regions_panel.dart';
import 'package:opms/features/manger/manager_activity_details/view/widgets/manager_remain_details_section.dart';
import 'package:opms/features/manger/manager_activity_details/view/widgets/manager_summary_cards_section.dart';

import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:shimmer/shimmer.dart';

class ManagerActivityPlanDetailsDesktop extends StatelessWidget {
  final ActivityPlanData data;
  final int activityID;
  const ManagerActivityPlanDetailsDesktop(
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
                  GetBuilder<ManagerActivityPlanDetailsController>(
                    tag: '$activityID',
                    builder: (ctrl) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        padding: EdgeInsets.symmetric(
                            vertical: 13.h, horizontal: 20.w),
                        elevation: 0,
                      ),
                      onPressed:
                          ctrl.historyLoadState.value == RequestState.loading
                              ? null
                              : () {
                                  ctrl.fetchHistory();
                                  _showHistoryDialog(context, activityID);
                                },
                      child: ctrl.historyLoadState.value == RequestState.loading
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.history),
                                const SizedBox(width: 8),
                                'History'.s14w700(context),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  GetBuilder<ManagerActivityPlanDetailsController>(
                    tag: '$activityID',
                    builder: (ctrl) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 20.w),
                          elevation: 0,
                        ),
                        onPressed: ctrl.isRequestingEdits.value
                            ? null
                            : () => _showNeedEditsDialog(context, activityID),
                        child: ctrl.isRequestingEdits.value
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.edit),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Need edits',
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

                  SizedBox(width: 10.w),

                  // ── Approve Button ─────────────────────
                  GetBuilder<ManagerActivityPlanDetailsController>(
                    tag: '$activityID',
                    builder: (ctrl) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.cresecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 20.w),
                          elevation: 0,
                        ),
                        onPressed: ctrl.isApproving.value
                            ? null
                            : () async {
                                final success = await ctrl.updateplan(
                                  isMovedToNext: 1,
                                  context: context,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? 'Plan approved successfully.'
                                        : 'Failed to approve plan.'),
                                    backgroundColor:
                                        success ? Colors.green : Colors.red,
                                  ),
                                );
                              },
                        child: ctrl.isApproving.value
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.send_rounded),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Approve',
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
                      ManagerSummaryCardsSection(
                        data: data,
                        activityID: activityID,
                      ),
                      SizedBox(height: 18.h),
                      ManagerPlanDetailsSection(data: data),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  flex: 2,
                  child: ManagerPlanRegionsPanel(
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

  void _showNeedEditsDialog(
    BuildContext parentContext,
    int activityID,
  ) {
    final controller = Get.find<ManagerActivityPlanDetailsController>(
      tag: '$activityID',
    );
    String comment = '';

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ──────────────────────────────────────
                Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 28.w,
                      color: TColors.cresePrimarySwatch,
                    ),
                    SizedBox(width: 12.w),
                    'Request Changes'.s17w700(parentContext),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please explain why this plan needs edits. Your feedback will be sent to the planner.',
                  style: Theme.of(parentContext).textTheme.bodyMedium,
                ),
                SizedBox(height: 16.h),

                // ─── Comment Input ─────────────────────────────
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter comments (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  onChanged: (v) => comment = v,
                ),
                SizedBox(height: 24.h),

                // ─── Actions ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: 'Cancel'.s14w700(parentContext)),
                    SizedBox(width: 12.w),
                    Obx(() {
                      final loading = controller.isRequestingEdits.value;
                      return ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  Navigator.of(ctx).pop();
                                  final success = await controller.updateplan(
                                    isMovedToNext: 0,
                                    comment: comment,
                                    context: parentContext,
                                  );
                                  ScaffoldMessenger.of(parentContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(success
                                          ? 'Edits sent to planner.'
                                          : 'Failed to send edits.'),
                                      backgroundColor:
                                          success ? Colors.orange : Colors.red,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.cresePrimarySwatch,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: loading
                              ? SizedBox(
                                  width: 16.w,
                                  height: 16.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : 'Submit'.s14w700(parentContext));
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHistoryDialog(BuildContext context, int activityID) {
    final ctrl =
        Get.find<ManagerActivityPlanDetailsController>(tag: '$activityID');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.25,
          vertical: MediaQuery.of(context).size.height * 0.10,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.50,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ──
                Row(
                  children: [
                    Icon(Icons.history,
                        size: 28.w, color: TColors.cresePrimarySwatch),
                    SizedBox(width: 12.w),
                    'History'.s17w700(context),
                    const Spacer(),
                    IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close)),
                  ],
                ),
                SizedBox(height: 16.h),

                // ── Body ──
                Expanded(
                  child: Obx(() {
                    switch (ctrl.historyLoadState.value) {
                      case RequestState.loading:
                        // a simple shimmer list
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (_, __) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Container(
                                height: 80.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );

                      case RequestState.error:
                        return Center(
                            child: TextWidget(
                          text: 'Failed to load history.'.s14w400(context),
                          color: TColors.cresePrimarySwatch,
                        ));

                      case RequestState.success:
                        final items = ctrl.histories;
                        if (items.isEmpty) {
                          return Center(
                              child: 'No history found.'.s14w400(context));
                        }
                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (__, idx) {
                            final h = items[idx];
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16.r,
                                          child:
                                              Text(h.user.name.substring(0, 1)),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: h.user.name.s14w700(context),
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd HH:mm')
                                              .format(h.createdAt),
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: TColors.darkGrey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    'Action: ${h.action}'.s14w400(context),
                                    SizedBox(height: 4.h),
                                    'Comment: ${h.comment.isNotEmpty ? h.comment : '—'}'
                                        .s14w400(context),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
