// lib/features/planner/planner_home/view/widgets/active_activities_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/planner_router.dart';
import 'package:shimmer/shimmer.dart';

import 'package:opms/common/widgets/layouts/rounded_section_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/planner/planner_home/controller/planner_controller.dart';
import 'package:opms/features/planner/planner_home/model/planner_activities_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class ActiveActivitiesSection extends StatelessWidget {
  const ActiveActivitiesSection({super.key});

  bool get _isMobile {
    final w = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return w < Sizes.tabletScreenSize;
  }

  Widget _buildStatusBadge(String status, BuildContext context) {
    Color bg;
    switch (status.toLowerCase()) {
      case 'done':
        bg = Colors.green.withOpacity(0.2);
        break;
      case 'in-progress':
        bg = Colors.orange.withOpacity(0.2);
        break;
      default:
        bg = Colors.grey.withOpacity(0.2);
    }
    return Container(
      width: 100.w,
      height: 32.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextWidget(
        text: status.s14w700(context),
        color: bg.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      ),
    );
  }

  Widget _shimmerTable(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: Sizes.lg.w,
                  headingRowHeight: 50.h,
                  dataRowHeight: 60.h,
                  dividerThickness: 1,
                  headingRowColor: MaterialStateProperty.all(
                    TColors.primary.withOpacity(0.2),
                  ),
                  columns: [
                    const DataColumn(label: Text('Code')),
                    const DataColumn(label: Text('Name of Activity')),
                    DataColumn(
                      label: SizedBox(
                        width: 100.w,
                        child: const Text(
                          'Status',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const DataColumn(label: Text('By')),
                    const DataColumn(label: Text('Details')),
                  ],
                  rows: List.generate(5, (_) {
                    return DataRow(cells: [
                      DataCell(Container(
                          width: 80.w, height: 16.h, color: Colors.white)),
                      DataCell(Container(
                          width: 120.w, height: 16.h, color: Colors.white)),
                      DataCell(SizedBox(
                        width: 100.w,
                        child: Center(
                            child: Container(
                                width: 80.w,
                                height: 16.h,
                                color: Colors.white)),
                      )),
                      DataCell(Container(
                          width: 60.w, height: 16.h, color: Colors.white)),
                      DataCell(Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      )),
                    ]);
                  }),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTable(List<PlannerActivitiesModel> items, BuildContext context) {
    final isMobile = HelperFunctions.isMobileScreen(context);
    return LayoutBuilder(builder: (ctx, constraints) {
      final table = DataTable(
        columnSpacing: Sizes.lg.w,
        headingRowHeight: 50.h,
        dataRowHeight: 60.h,
        dividerThickness: 1,
        headingRowColor: MaterialStateProperty.all(
          TColors.primary.withOpacity(0.2),
        ),
        headingTextStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        columns: [
          DataColumn(label: 'Code'.s14w700(context)),
          DataColumn(label: 'Name of Activity'.s14w700(context)),
          DataColumn(
            label: SizedBox(
              width: 100.w,
              child: isMobile
                  ? TextWidget(text: 'Status'.s14w700(context))
                  : Text(
                      'Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
              //
            ),
          ),
          DataColumn(label: 'By'.s14w700(context)),
          DataColumn(label: 'Details'.s14w700(context)),
        ],
        rows: List.generate(items.length, (i) {
          final a = items[i];
          final bg = i.isOdd ? TColors.lightGrey.withOpacity(0.1) : null;
          return DataRow(
            color: MaterialStateProperty.all(bg),
            cells: [
              DataCell(Text(
                a.code,
                style: TextStyle(
                    fontSize: isMobile ? 40.sp : 13.sp,
                    fontWeight: FontWeight.w600),
              )),
              DataCell(Text(a.name,
                  style: TextStyle(
                      fontSize: isMobile ? 40.sp : 13.sp,
                      fontWeight: FontWeight.w600))),
              DataCell(SizedBox(
                width: 100.w,
                child:
                    Center(child: _buildStatusBadge(a.status ?? '—', context)),
              )),
              DataCell(Text(a.statusBy ?? '—',
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600))),
              DataCell(
                IconButton(
                  icon: Icon(Icons.info_outline_rounded,
                      size: isMobile ? 40.w : 20.w),
                  onPressed: () async {
                    context.goNamed(
                      PlannerRouter.nameActivityDetails,
                      pathParameters: {'id': a.id.toString()},
                    );
                  },
                ),
              ),
            ],
          );
        }),
      );

      // wrap in both vertical & horizontal scrolls
      return Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _isMobile ? constraints.maxWidth : constraints.maxWidth,
                child: table,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = PlannerController.instance;

    return RoundedSectionContainer(
      radius: 24,
      padding: EdgeInsets.all(Sizes.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          TextWidget(
            text: 'Active Activities:'.s17w700(context),
            color: TColors.primary,
          ),
          SizedBox(height: Sizes.md.h),

          // Body
          Expanded(
            child: Obx(() {
              switch (ctrl.loadState.value) {
                case RequestState.loading:
                  return _shimmerTable(context);
                case RequestState.error:
                  return Center(
                    child: TextWidget(
                      text: 'Failed to load activities'.s14w400(context),
                      color: TColors.redColor,
                    ),
                  );
                case RequestState.success:
                  final items = ctrl.activities;
                  if (items.isEmpty) {
                    return Center(
                      child: TextWidget(
                        text: 'No activities found'.s14w400(context),
                        color: TColors.darkGrey,
                      ),
                    );
                  }
                  return _buildTable(items, context);
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }
}
