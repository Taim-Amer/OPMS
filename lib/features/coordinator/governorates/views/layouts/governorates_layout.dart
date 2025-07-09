import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/features/admin/departments/views/screens/departments_desktop_screen.dart';
import 'package:opms/features/admin/departments/views/screens/departments_mobile_screen.dart';
import 'package:opms/features/coordinator/governorates/views/screens/governorates_desktop_screen.dart';
import 'package:opms/features/coordinator/governorates/views/screens/governorates_mobile_screen.dart';

class GovernoratesLayout extends StatelessWidget {
  const GovernoratesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TResponsiveWidget(
      desktop: GovernoratesDesktopScreen(),
      tablet: GovernoratesDesktopScreen(),
      mobile: GovernoratesMobileScreen(),
    );
  }
}
