import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/outputs/views/screens/outputs_desktop_screen.dart';
import 'package:opms/features/outputs/views/screens/outputs_mobile_screen.dart';

class OutputsLayout extends StatelessWidget {
  const OutputsLayout({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      tablet: OutputsDesktopScreen(fromAnother: fromAnother),
      desktop: OutputsDesktopScreen(fromAnother: fromAnother),
      mobile: OutputsMobileScreen(fromAnother: fromAnother,),
    );
  }
}
