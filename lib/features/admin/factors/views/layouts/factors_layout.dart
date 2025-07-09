import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/factors/views/screens/factors_desktop_screen.dart';
import 'package:opms/features/admin/factors/views/screens/factors_mobile_screen.dart';
import 'package:opms/features/admin/roles/views/screens/roles_desktop_screen.dart';
import 'package:opms/features/admin/roles/views/screens/roles_mobile_screen.dart';

class FactorsLayout extends StatelessWidget {
  const FactorsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      mobile: FactorsMobileScreen(),
      desktop: FactorsDesktopScreen(),
      tablet: FactorsDesktopScreen(),
    );
  }
}
