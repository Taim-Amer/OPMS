import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/indicators/views/screens/indicators_desktop_screen.dart';
import 'package:opms/features/admin/indicators/views/screens/indicators_mobile_screen.dart';

class IndicatorLayout extends StatelessWidget {
  const IndicatorLayout({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      useLayout: false,
      tablet: IndicatorsDesktopScreen(fromAnother: fromAnother),
      desktop: IndicatorsDesktopScreen(fromAnother: fromAnother),
      mobile: IndicatorsMobileScreen(fromAnother: fromAnother,),
    );
  }
}
