import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/features/activities/view/screens/actvites_desktop_screen.dart';

class ActivitesLayout extends StatelessWidget {
  const ActivitesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TResponsiveWidget(
      desktop: ActivitiesDesktopScreen(),
      tablet: ActivitiesDesktopScreen(),
      mobile: ActivitiesDesktopScreen(),
    );
  }
}
