import 'package:flutter/material.dart';
import 'package:opms/common/responsive/responsive_design.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/departments/views/screens/departments_desktop_screen.dart';
import 'package:opms/features/admin/departments/views/screens/departments_mobile_screen.dart';
import 'package:opms/features/coordinator/districts/views/screens/districts_desktop_screen.dart';
import 'package:opms/features/coordinator/home/views/screens/home_desktop_screen.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, required this.fromAnother});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      desktop: HomeDesktopScreen(fromAnother: fromAnother,),
      tablet: HomeDesktopScreen(fromAnother: fromAnother,),
      mobile: HomeDesktopScreen(fromAnother: fromAnother,),
    );
  }
}
