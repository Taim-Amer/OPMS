import 'package:flutter/material.dart';
import 'package:opms/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/fields_section.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/months_selector.dart';

class DesktopFieldsAndMonths extends StatelessWidget {
  final PlanImplementationController ctrl;
  final bool isEditable;
  const DesktopFieldsAndMonths({super.key, 
    required this.ctrl,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fields
        Expanded(
          flex: 3,
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(right: 22.0),
              child: FieldsSection(ctrl: ctrl, isEditable: isEditable),
            ),
          ),
        ),
        // Divider
        Container(
          width: 2,
          height: 300,
          margin: const EdgeInsets.only(top: 10, left: 10, right: 26),
          color: Colors.grey.withOpacity(0.9),
        ),
        // Months
        Expanded(
          flex: 2,
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: MonthsSelector(
              allMonths: ctrl.allMonths,
              selectedMonths: ctrl.selectedMonthsIds,
              isEditable: isEditable,
              onMonthToggled: ctrl.toggleMonth,
              loading: ctrl.allMonths.isEmpty,
              fetchMonths: ctrl.fetchMonths,
              horizontal: false,
            ),
          ),
        ),
      ],
    );
  }
}
