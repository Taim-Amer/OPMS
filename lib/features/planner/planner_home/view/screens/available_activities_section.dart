// lib/features/planner/planner_home/view/widgets/available_activities_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

import 'package:opms/common/widgets/layouts/rounded_section_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/planner/planner_home/controller/planner_controller.dart';
import 'package:opms/features/planner/planner_home/model/planner_activities_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';

class AvailableActivitiesSection extends StatelessWidget {
  AvailableActivitiesSection({Key? key}) : super(key: key);

  final _ctrl = PlannerController.instance;
  final _searchC = TextEditingController();

  bool get _isMobile {
    final w = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    return w < Sizes.tabletScreenSize;
  }

  Widget _shimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: _isMobile
          ? ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: Sizes.sm.h),
              itemBuilder: (_, __) => Container(
                height: 80.h,
                margin: EdgeInsets.symmetric(vertical: Sizes.xs.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: Sizes.sm.w,
                mainAxisSpacing: Sizes.sm.h,
                childAspectRatio: 3,
              ),
              itemCount: 8,
              itemBuilder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
    );
  }

  Widget _buildAvailable(List<PlannerActivitiesModel> items,
      List<int> selectedIds, BuildContext context) {
    if (_isMobile) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: Sizes.sm.h),
        itemBuilder: (_, i) {
          final a = items[i];
          final selected = selectedIds.contains(a.id);
          return Card(
            color: selected ? TColors.redColor : null,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  HelperFunctions.isMobileScreen(context) ? 30.r : 12.r),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: Sizes.sm.h,
                horizontal: Sizes.md.w,
              ),
              title: TextWidget(
                text: a.name.s16w400(context),
                color: HelperFunctions.isDarkMode(context)
                    ? selected
                        ? TColors.dark
                        : Colors.white
                    : selected
                        ? Colors.white
                        : TColors.dark,
              ),
              subtitle: TextWidget(
                text: a.code.s14w700(context),
                color: selected ? Colors.white : TColors.darkGrey,
              ),
              // trailing: Icon(
              //   selected ? Icons.check_circle : Icons.check_circle_outline,
              //   size: 20.w,
              //   color: selected ? Colors.white : TColors.primary,
              // ),
              onTap: () => _ctrl.toggleAvailableSelection(a.id),
            ),
          );
        },
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: Sizes.sm.w,
          mainAxisSpacing: Sizes.sm.h,
          childAspectRatio: 3,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final a = items[i];
          final selected = selectedIds.contains(a.id);
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              color: selected ? TColors.redColor : null,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: () => _ctrl.toggleAvailableSelection(a.id),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        text: a.name.s14w700(context),
                        color: selected
                            ? Colors.white
                            : HelperFunctions.isDarkMode(context) ?   TColors.white  : TColors.dark,
                      ),
                      SizedBox(height: Sizes.xs.h),
                      TextWidget(
                        text: a.code.s14w700(context),
                        color: selected ? Colors.white : TColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedSectionContainer(
      radius: 24,
      padding: EdgeInsets.all(Sizes.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header + Search + Reserve Button ───────────

          Container(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.sm.h,
              horizontal: Sizes.md.w,
            ),
            decoration: BoxDecoration(
              color: HelperFunctions.isDarkMode(context)
                  ? TColors.darkGrey
                  : TColors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                // only show label on desktop
                if (!_isMobile) ...[
                  TextWidget(
                    text: 'Available Activities:'.s16w700(context),
                    color: TColors.cresePrimarySwatch,
                  ),
                  SizedBox(width: Sizes.md.w),
                ],

                // Search field
                Expanded(
                  child: SizedBox(
                    height: 40.h,
                    child: TextField(
                      controller: _searchC,
                      onChanged: _ctrl.searchQuery,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TColors.lightGrey.withOpacity(0.2),
                        hintText: 'Search by name or code',
                        hintStyle: TextStyle(fontSize: HelperFunctions.isMobileScreen(context) ? 40.sp: 14.sp , color: HelperFunctions.isDarkMode(context)? Colors.white : Colors.grey),
                        prefixIcon: Icon(Icons.search, color: TColors.darkGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Sizes.sm.w),

                // Reserve button (desktop & mobile)
                Obx(() {
                  final selectedIds = _ctrl.selectedAvailableIds;
                  final isLoading =
                      _ctrl.reserveState.value == RequestState.loading;

                  if (selectedIds.isEmpty) return const SizedBox.shrink();

                  return ElevatedButton(
                    onPressed: isLoading ? null : _ctrl.reserveSelected,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(140.w, 40.h),
                      backgroundColor: TColors.cresePrimarySwatch,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                      padding: EdgeInsets.symmetric(horizontal: Sizes.md.w),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : TextWidget(
                            text: 'Reserve Activities'.s14w700(context),
                            color: Colors.white,
                          ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: Sizes.md.h),

          // ── Body ───────────────────────────────────────
          Expanded(
            child: Obx(() {
              final selectedIds = List<int>.from(_ctrl.selectedAvailableIds);

              switch (_ctrl.availLoadState.value) {
                case RequestState.loading:
                  return _shimmerGrid();
                case RequestState.error:
                  return Center(
                    child: TextWidget(
                      text: 'Failed to load available activities'.s14w400(context),
                      color: Colors.orangeAccent,
                    ),
                  );
                case RequestState.success:
                  final filtered = _ctrl.filteredAvailable;
                  if (filtered.isEmpty) {
                    return Center(
                      child: TextWidget(
                        text: 'No activities match your search'.s14w400(context),
                        color: TColors.darkGrey,
                      ),
                    );
                  }
                  return _buildAvailable(filtered, selectedIds, context);
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
