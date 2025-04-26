import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/outcomes/views/screens/outcomes_desktop_screen.dart';
import 'package:opms/features/outcomes/views/screens/outcomes_mobile_screen.dart';

class OutcomeLayout extends StatelessWidget {
  const OutcomeLayout({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      tablet: OutcomesDesktopScreen(fromAnother: fromAnother,),
      desktop: OutcomesDesktopScreen(fromAnother: fromAnother,),
      mobile: OutcomesMobileScreen(fromAnother: fromAnother,),
    );
  }
}
