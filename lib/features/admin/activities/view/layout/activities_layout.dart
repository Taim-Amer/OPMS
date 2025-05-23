import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/features/admin/activities/view/screens/activities_desktop_screen.dart';

class ActivitiesLayout extends StatelessWidget {
  const ActivitiesLayout({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return TResponsiveWidget(
      desktop: ActivitiesDesktopScreen(fromAnother: fromAnother,),
      tablet: ActivitiesDesktopScreen(fromAnother: fromAnother,),
      mobile: ActivitiesDesktopScreen(fromAnother: fromAnother,),
    );
  }
}
