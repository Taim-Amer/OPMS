import 'package:flutter/material.dart';

import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/projects/view/screens/projects_desktop_screen.dart';
import 'package:opms/features/admin/projects/view/screens/projects_mobile_screen.dart';

class ProjectsLayout extends StatelessWidget {
  const ProjectsLayout({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      tablet: ProjectsDesktopScreen(fromAnother: fromAnother),
      desktop: ProjectsDesktopScreen(fromAnother: fromAnother),
      mobile: ProjectsMobileScreen(fromAnother: fromAnother,),
    );
  }
}
