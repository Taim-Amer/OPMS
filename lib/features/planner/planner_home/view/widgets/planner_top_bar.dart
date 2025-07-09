// lib/features/planner/planner_home/view/widgets/planner_top_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/common/extensions/text_extensions2.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/features/planner/planner_home/controller/planner_bread_crumb_controler.dart';
import 'package:opms/features/planner/planner_home/view/widgets/info_item.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/router/planner_router.dart';

class PlannerTopBar extends StatelessWidget implements PreferredSizeWidget {
  const PlannerTopBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  bool _isMobile(double width) => width < Sizes.tabletScreenSize;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final year = DateTime.now().year + 1;
    final bc = Get.find<PlannerBreadcrumbController>();

    // Update the breadcrumb controller once after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current =
          GoRouter.of(context).routeInformationProvider.value.uri.toString();
      bc.setCurrentRoute(current);
    });

    return LayoutBuilder(builder: (_, constraints) {
      final mobile = _isMobile(constraints.maxWidth);

      if (mobile) {
        // ─── Mobile ─────────────────────────────
        return Container(
          color: TColors.primary,
          height: kToolbarHeight.h,
          padding: EdgeInsets.symmetric(horizontal: Sizes.md.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(builder: (ctx) {
                return IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: HelperFunctions.isMobileScreen(context) ? 50.w : 24.w,
                  ),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                );
              }),
              InfoItem(
                icon: Icons.calendar_today_rounded,
                label: 'Year of Implementation: $year',
              ),
            ],
          ),
        );
      }

      // ─── Desktop / Wide ──────────────────────

      // friendly titles for your base routes
      const routeTitles = {
        PlannerRouter.active: 'Active Activities',
        PlannerRouter.available: 'Available Activities',
        PlannerRouter.tree: 'Tree',
        PlannerRouter.archive: 'Archived Activities',
        PlannerRouter.notifications: 'Notifications',
      };

      return TRoundedContainer(
        width: double.infinity,
        height: kToolbarHeight.h,
        backgroundColor: dark ? TColors.black2 : const Color(0xfffffdfb),
        padding: EdgeInsets.only(
          right: Sizes.md.w,
          left: Sizes.md.w,
          top: Sizes.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ─ Logo + Breadcrumbs ─
            Row(
              children: [
                Image.asset(
                  dark ? ImagesAssets.darkLogo : ImagesAssets.lightLogo,
                  fit: BoxFit.fitHeight,
                  height: 100.w,
                ),
                SizedBox(width: Sizes.md.w),
                "Syrian Arab Red Crescent - Operational Plan".s16w700(context),
                SizedBox(width: Sizes.md.w),

                // Breadcrumb row
                Obx(() {
                  final crumbs = bc.crumbs;
                  if (crumbs.isEmpty) return const SizedBox.shrink();

                  return Row(
                    children: List.generate(crumbs.length * 2 - 1, (i) {
                      if (i.isOdd) {
                        // separator arrow
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Image.asset(
                            "assets/images/next.png",
                            height: 20.w,
                          ),
                        );
                      }
                      final idx = i ~/ 2;
                      final item = crumbs[idx];
                      final isLast = idx == crumbs.length - 1;

                      // compute friendly label (including details)
                      final displayTitle = routeTitles[item.route] ??
                          (item.route
                                  .startsWith('${PlannerRouter.base}/activity/')
                              ? 'Plan Activity Details'
                              : item.title);

                      final text = Text(
                        displayTitle,
                        style: TextStyle(
                          fontWeight:
                              isLast ? FontWeight.bold : FontWeight.normal,
                          color: isLast
                              ? TColors.cresePrimarySwatch
                              : TColors.darkGrey,
                          decoration: isLast
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      );

                      if (isLast) {
                        // last crumb: no tap
                        return text;
                      } else {
                        return InkWell(
                          onTap: () => context.go(item.route),
                          child: text,
                        );
                      }
                    }),
                  );
                }),
              ],
            ),

            // ─ Right Info ─
            InfoItem(
              icon: Icons.calendar_today_rounded,
              label: 'Year of Implementation: $year',
            ),
          ],
        ),
      );
    });
  }
}
