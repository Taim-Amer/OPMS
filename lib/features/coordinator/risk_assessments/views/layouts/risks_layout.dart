import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/features/coordinator/risk_assessments/views/screens/risks_desktop_screen.dart';
import 'package:opms/features/coordinator/risk_assessments/views/screens/risks_mobile_screen.dart';

class RisksLayout extends StatelessWidget {
  const RisksLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TResponsiveWidget(
      desktop: RisksDesktopScreen(),
      tablet: RisksDesktopScreen(),
      mobile: RisksMobileScreen(),
    );
  }
}
