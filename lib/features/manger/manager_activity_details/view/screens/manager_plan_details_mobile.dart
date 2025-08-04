

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/extensions/text_extensions2.dart';

import 'package:opms/common/widgets/layouts/rounded_section_container.dart';
import 'package:opms/features/manger/manager_activity_details/model/manager_plan_activity_details_model.dart';


class ManagerActivityPlanDetailsMobile extends StatelessWidget {
  final ActivityPlanData data;

  const ManagerActivityPlanDetailsMobile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RoundedSectionContainer(
          radius: 12,
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Activity:'.s17w700(context),
              SizedBox(height: 8.h),
              (data.activity?.name ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Code:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.activity?.code ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Output:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.activity?.output?.name ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Outcome:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.activity?.output?.outcome?.name ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Indicators:'.s17w700(context),
              if (data.activity?.output?.indicators.isNotEmpty ?? false)
                ...data.activity!.output!.indicators.map(
                  (i) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: ('• ${i.name}').s14w400(context),
                  ),
                )
              else
                '—'.s16w400(context),

              SizedBox(height: 12.h),
              'Year of Implementation:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.yearOfImplementation ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Duration (years):'.s17w700(context),
              SizedBox(height: 4.h),
              (data.numberOfYearsToImplementation?.toString() ?? '—')
                  .s16w400(context),

              SizedBox(height: 12.h),
              'Project Status:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.projectImplementationStatus ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Total Cost:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.totalCost ?? '—').s16w400(context),

              SizedBox(height: 12.h),
              'Created By:'.s17w700(context),
              SizedBox(height: 4.h),
              (data.createdBy?.name ?? '—').s16w400(context),
            ],
          ),
        ),
      ],
    );
  }
}
