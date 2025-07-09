// lib/features/planner/planner_home/view/widgets/planner_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/features/planner/planner_home/view/widgets/planner_side_bar.dart';
import 'package:opms/features/planner/planner_home/view/widgets/planner_top_bar.dart';
import 'package:opms/common/widgets/layouts/rounded_section_container.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

/// A shell widget used by GoRouter’s ShellRoute to keep
/// the sidebar (and top bar) persistent across planner pages.
class PlannerShell extends StatelessWidget {
  final Widget child;

  const PlannerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final bgColor = isDark ? TColors.black2 : const Color(0xfffffdfb);

    // decide mobile vs desktop
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < Sizes.tabletScreenSize;

    return Scaffold(
      backgroundColor: bgColor,

      // only supply drawer on mobile
      drawer: isMobile ? const PlannerSidebar() : null,

      body: Column(
        children: [
          // top bar is always shown
          const PlannerTopBar(),

          Expanded(
            child: Row(
              children: [
                // on desktop, pin the sidebar on the left
                if (!isMobile) const PlannerSidebar(),

                // the routed page
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: RoundedSectionContainer(
                      radius: 24.r,
                      padding: EdgeInsets.zero,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
