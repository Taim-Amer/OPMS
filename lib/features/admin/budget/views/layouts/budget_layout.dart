import 'package:flutter/material.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/budget/views/screens/budget_desktop_screen.dart';
import 'package:opms/features/admin/budget/views/screens/budget_mobile_screen.dart';
import 'package:opms/features/admin/outcomes/views/screens/outcomes_desktop_screen.dart';
import 'package:opms/features/admin/outcomes/views/screens/outcomes_mobile_screen.dart';

class BudgetLayout extends StatelessWidget {
  const BudgetLayout({super.key});

  // final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      useLayout: false,
      tablet: BudgetDesktopScreen(),
      desktop: BudgetDesktopScreen(),
      mobile: BudgetMobileScreen(),
    );
  }
}
