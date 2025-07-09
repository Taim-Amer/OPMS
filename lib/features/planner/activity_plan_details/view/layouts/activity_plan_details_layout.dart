// lib/features/planner/activity_plan_details/view/layouts/activity_plan_details_layout.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart';
import 'package:opms/features/planner/activity_plan_details/view/screens/activity_plan_details_desktop.dart';
import 'package:opms/features/planner/activity_plan_details/view/screens/activity_plan_details_mobile.dart';
import 'package:opms/features/planner/activity_plan_details/view/widgets/activity_plan_details_shimmer.dart'; // <--- new
import 'package:opms/utils/constants/enums.dart';

class ActivityPlanDetailsLayout extends StatefulWidget {
  final int planActivityId;
  const ActivityPlanDetailsLayout({super.key, required this.planActivityId});

  @override
  State<ActivityPlanDetailsLayout> createState() =>
      _ActivityPlanDetailsLayoutState();
}

class _ActivityPlanDetailsLayoutState extends State<ActivityPlanDetailsLayout> {
  late final ActivityPlanDetailsController ctrl;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.planActivityId = widget.planActivityId;
      ctrl = Get.put(
        ActivityPlanDetailsController(),
        tag: "${widget.planActivityId}",
      );
      ctrl.preload(
        widget.planActivityId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return GetBuilder<ActivityPlanDetailsController>(
      // Unique tag for this page instance
      tag: "${widget.planActivityId}",
      // Only create if not found
      init: ActivityPlanDetailsController()..preload(widget.planActivityId),
      builder: (ctrl) {
        Widget content;
        switch (ctrl.loadState.value) {
          case RequestState.loading:
            content = const ActivityPlanDetailsShimmer();
            break;
          case RequestState.error:
            content = Center(child: 'Could not load details.'.s16w400(context));
            break;
          case RequestState.success:
            final data = ctrl.details.value?.data;
            content = data == null
                ? Center(child: 'No details.'.s16w400(context))
                : isMobile
                    ? ActivityPlanDetailsMobile(data: data)
                    : ActivityPlanDetailsDesktop(data: data , activityID: widget.planActivityId,);
            break;
          default:
            content = const SizedBox.shrink();
        }

        return content;
      },
    );
  }
}
