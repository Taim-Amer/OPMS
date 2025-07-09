
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:opms/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/fields_section.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/months_selector.dart';

class MobileFieldsAndMonths extends StatelessWidget {
  final PlanImplementationController ctrl;
  final bool isEditable;
  const MobileFieldsAndMonths({super.key, 
    required this.ctrl,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FieldsSection(ctrl: ctrl, isEditable: isEditable),
        const SizedBox(height: 18),
        Card(
          elevation: 0,
          color: Colors.transparent,
          child: MonthsSelector(
            allMonths: ctrl.allMonths,
            selectedMonths: ctrl.selectedMonthsIds,
            isEditable: isEditable,
            onMonthToggled: ctrl.toggleMonth,
            loading: ctrl.allMonths.isEmpty,
            fetchMonths: ctrl.fetchMonths,
            horizontal: true,
          ),
        ),
      ],
    );
  }
}