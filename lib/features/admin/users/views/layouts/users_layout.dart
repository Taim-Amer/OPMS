import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/roles/views/screens/roles_desktop_screen.dart';
import 'package:opms/features/admin/roles/views/screens/roles_mobile_screen.dart';
import 'package:opms/features/admin/users/views/screens/users_desktop_screen.dart';
import 'package:opms/features/admin/users/views/screens/users_mobile_screen.dart';

class UsersLayout extends StatelessWidget {
  const UsersLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      mobile: UsersMobileScreen(),
      desktop: UsersDesktopScreen(),
      tablet: UsersDesktopScreen(),
    );
  }
}
