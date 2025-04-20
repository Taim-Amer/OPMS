import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/features/departments/views/screens/departments_desktop_screen.dart';

class DepartmentLayout extends StatelessWidget {
  const DepartmentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TResponsiveWidget(
      desktop: DepartmentsDesktopScreen(),
      tablet: DepartmentsDesktopScreen(),
      mobile: DepartmentsDesktopScreen(),
    );
  }
}
