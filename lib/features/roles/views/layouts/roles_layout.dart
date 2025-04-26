import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/roles/views/screens/roles_desktop_screen.dart';
import 'package:opms/features/roles/views/screens/roles_mobile_screen.dart';

class RolesLayout extends StatelessWidget {
  const RolesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      mobile: RolesMobileScreen(),
      desktop: RolesDesktopScreen(),
      tablet: RolesDesktopScreen(),
    );
  }
}
