import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/features/planner/plan_implementation/model/months_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class MonthsSelector extends StatelessWidget {
  final List<MonthModel> allMonths;
  final List<int> selectedMonths;
  final bool isEditable;
  final void Function(int) onMonthToggled;
  final bool loading;
  final VoidCallback fetchMonths;
  final bool horizontal;

  const MonthsSelector({
    super.key,
    required this.allMonths,
    required this.selectedMonths,
    required this.isEditable,
    required this.onMonthToggled,
    required this.loading,
    required this.fetchMonths,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < Sizes.tabletScreenSize;
    ;

    if (loading) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.download_rounded),
        label: const Text('Load Months'),
        onPressed: fetchMonths,
      );
    }

    // Responsive grid for months (3 columns desktop, 2 on mobile)
    final crossAxisCount = isMobile ? 2 : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Months',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allMonths.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 12.w,
            childAspectRatio: 2.3.w,
          ),
          itemBuilder: (ctx, i) {
            final month = allMonths[i];
            final isSelected = selectedMonths.contains(month.id);

            return Tooltip(
              message: 'Toggle ${month.name}',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? TColors.cresePrimarySwatch.withOpacity(0.20)
                          : TColors.cresePrimarySwatch.withOpacity(0.15))
                      : (isDark ? const Color(0xFF1B1A1F) : Colors.white),
                  border: Border.all(
                    color: isSelected
                        ? TColors.cresePrimarySwatch
                        : (isDark
                            ? Colors.white24
                            : TColors.crese200.withOpacity(0.47)),
                    width: isSelected ? 2.3 : 1.1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: TColors.cresePrimarySwatch.withOpacity(0.14),
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isEditable ? () => onMonthToggled(month.id) : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.check_circle,
                              color: TColors.cresePrimarySwatch,
                              size: 19,
                            ),
                          ),
                        Text(
                          month.name,
                          style: TextStyle(
                            color: isSelected
                                ? TColors.cresePrimarySwatch
                                : (isDark ? Colors.white70 : TColors.crese800),
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: isMobile ? 40.sp : 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
