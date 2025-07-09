import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/planner/activity_plan_details/controller/activity_plan_details_controller.dart';
import 'package:opms/features/planner/activity_plan_details/view/widgets/regions_select_dialog.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/planner_router.dart';
import 'package:shimmer/shimmer.dart';

class PlanRegionsPanel extends StatelessWidget {
  final int planActivityId; // pass it down from parent

  const PlanRegionsPanel({super.key, required this.planActivityId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl =
        Get.put(ActivityPlanDetailsController(), tag: "$planActivityId");

    return Container(
      margin: EdgeInsets.only(right: 14.w, top: 10.h),
      width: 380.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.white,
        border: Border.all(
            color: isDark ? TColors.darkBorder : TColors.borderPrimary,
            width: 1.2),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final state = ctrl.planRegionsLoadState.value;
        final regions = ctrl.planRegions.value?.data ?? [];
        final validRegions = regions.where((r) => r.region != null).toList();

        if (state == RequestState.loading) {
          return _PlanRegionsShimmer();
        }
        if (state == RequestState.error || validRegions.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Center(
              child: Text(
                'Failed to load regions',
                style: TextStyle(color: TColors.error, fontSize: 16.sp),
              ),
            ),
          );
        }

        Widget header = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.public, color: TColors.cresePrimarySwatch, size: 22.sp),
            SizedBox(width: 7.w),
            Expanded(
              child: Text(
                'Plan\'s Regions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: isDark ? TColors.white : TColors.textPrimary,
                ),
              ),
            ),
            _DiscoverRegionsButton(
              activityPlanID: planActivityId,
            ),
          ],
        );

        Widget listContent;
        if (validRegions.isEmpty) {
          listContent = Padding(
            padding: EdgeInsets.only(top: 44.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info_outline_rounded,
                    color: TColors.crese300, size: 38.sp),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    'No regions found',
                    style: TextStyle(
                        color:
                            isDark ? TColors.darkGrey : TColors.textSecondary,
                        fontSize: 15.sp),
                  ),
                ),

                // _DiscoverRegionsButton(),
              ],
            ),
          );
        } else {
          listContent = Column(
            children: [
              SizedBox(height: 16.h),
              ...validRegions.map((region) => _RegionTile(
                    region: region,
                    planActivityID: planActivityId,
                  )),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            listContent,
          ],
        );
      }),
    );
  }
}

class _DiscoverRegionsButton extends StatelessWidget {
  const _DiscoverRegionsButton({required this.activityPlanID});
  final int activityPlanID;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: TColors.cresePrimarySwatch,
        backgroundColor: isDark ? TColors.darkContainer2 : TColors.white,
        elevation: 0,
        side: BorderSide(
            color: isDark ? TColors.creseDark : TColors.crese200, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.5.sp,
        ),
      ),
      icon: Icon(Icons.add_location_alt_rounded, size: 17.sp),
      label: Text(
        'Discover New Regions',
        style: TextStyle(
            color: HelperFunctions.isDarkMode(context)
                ? Colors.white
                : TColors.crese700),
      ),
      onPressed: () async {
        final result = await showRegionSelectorDialog(context, activityPlanID);
        if (result != null) {
          // result['id'], result['type'], result['name']
        }
      },
    );
  }
}

class _RegionTile extends StatelessWidget {
  final dynamic region;
  final int planActivityID;
  const _RegionTile({required this.region, required this.planActivityID});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final regionName = region.region?.name ?? '—';
    final regionType = region.regionType ?? '—';
    final regionID = region.region.id.toString() ?? "";

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer2 : TColors.white,
        border: Border.all(
            color: isDark ? TColors.darkBorder : TColors.borderPrimary,
            width: 1),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.16)
                : Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded,
                  color: TColors.cresePrimarySwatch, size: 22.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  regionName,
                  style: TextStyle(
                    color: isDark ? TColors.white : TColors.textPrimary,
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: HelperFunctions.isDarkMode(context)
                      ? TColors.crese400
                      : TColors.cresePrimarySwatch,
                  elevation: 0,
                  minimumSize: Size(0, 34.h),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
                onPressed: () {
                  try {
                    context.goNamed(
                      PlannerRouter.namePlanImplementation,
                      pathParameters: {
                        'planActivityId':
                            Get.find<ActivityPlanDetailsController>(
                                    tag: "$planActivityID")
                                .planActivityId
                                .toString(),
                        'regionType': regionType, // e.g., 'District'
                        'regionId': regionID.toString(),
                        'isEditable': Get.find<ActivityPlanDetailsController>(
                                tag: "$planActivityID")
                            .isPlanEditable
                            .value
                            .toString(), // 'true' or 'false'
                      },
                    );
                  } catch (e) {
                    print("this is the error ${e.toString()}");
                  }
                },
                child: const Text('Plan Implementation'),
              ),
              SizedBox(width: 7.w),
              PopupMenuButton<String>(
                onSelected: (value) {},
                color: isDark ? TColors.darkContainer : TColors.white,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: 'details', child: Text('View Details')),
                  const PopupMenuItem(child: Text('Edit'), value: 'edit'),
                  const PopupMenuItem(child: Text('Remove'), value: 'remove'),
                ],
                icon: Icon(Icons.more_vert,
                    size: 20.sp,
                    color: isDark ? TColors.crese500 : TColors.textSecondary),
                tooltip: "Region actions",
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isDark
                    ? TColors.darkGrey.withOpacity(0.22)
                    : TColors.crese50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                regionType,
                style: TextStyle(
                  color: TColors.cresePrimarySwatch,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanRegionsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 110.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: isDark
                    ? TColors.darkGrey.withOpacity(0.23)
                    : Colors.black.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 90.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: isDark
                    ? TColors.darkGrey.withOpacity(0.18)
                    : Colors.black.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ...List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Shimmer.fromColors(
              baseColor: isDark
                  ? TColors.darkContainer.withOpacity(0.20)
                  : TColors.crese50.withOpacity(0.11),
              highlightColor: isDark
                  ? TColors.darkGrey.withOpacity(0.15)
                  : TColors.crese200.withOpacity(0.09),
              child: Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? TColors.darkGrey.withOpacity(0.13)
                      : Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
