import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/appbar/app_top_bar.dart';
import 'package:opms/common/widgets/layouts/rounded_section_container.dart';
import 'package:opms/features/director/director_home/view/widgets/director_side_bar.dart';

import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class DirectorShell extends StatelessWidget {
  final Widget child;

  const DirectorShell({super.key, required this.child});

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
      drawer: isMobile ? const DirectorSideBar() : null,

      body: Column(
        children: [
          // top bar is always shown
          const AppTopBar(),

          Expanded(
            child: Row(
              children: [
                // on desktop, pin the sidebar on the left
                if (!isMobile) const DirectorSideBar(),

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
