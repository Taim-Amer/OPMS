import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class DataEntryTable<T> extends StatelessWidget {
  final List<T> items;
  final List<DataColumnConfig<T>> columns;
  final double headingHeight;
  final double rowHeight;
  final double maxHeightFactor; // e.g. 0.6 to cap at 60% of screen
  final String emptyMessage;

  const DataEntryTable({
    super.key,
    required this.items,
    required this.columns,
    this.headingHeight = 44,
    this.rowHeight = 54,
    this.maxHeightFactor = 0.6,
    this.emptyMessage = 'No data found.',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Center(
          child: Text(
            emptyMessage,
            style: TextStyle(fontSize: 16, color: theme.disabledColor),
          ),
        ),
      );
    }

    // Total content height based on number of rows:
    final contentHeight = headingHeight + rowHeight * items.length;
    final maxHeight = MediaQuery.of(context).size.height * maxHeightFactor;
    final tableHeight = contentHeight < maxHeight ? contentHeight : maxHeight;

    // Stripe colour for even rows:
    final stripeColor = isDark
        ? TColors.creseDark.withOpacity(0.05)
        : TColors.creseLight.withOpacity(0.03);

    // Header & data text styles:
    final headingTextStyle = theme.textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: HelperFunctions.isDarkMode(context)?TColors.white:  TColors.crese600,
    );
    final dataTextStyle = theme.textTheme.bodyMedium;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: tableHeight,
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 6,
            radius: const Radius.circular(3),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  // total width = sum of fixed + flexible
                  width: columns.fold<double>(
                    0,
                    (sum, col) => sum + (col.fixedWidth ?? 200),
                  ),
                  child: DataTable2(
                    minWidth: columns.fold<double>(
                        0, (sum, c) => sum + (c.fixedWidth ?? 200)),
                    headingRowHeight: headingHeight,
                    dataRowHeight: rowHeight,
                    columnSpacing:
                        MediaQuery.of(context).size.width < 850 ? 10 : 24,
                    headingRowColor: MaterialStateProperty.all(
                      TColors.cresePrimarySwatch.withOpacity(0.1),
                    ),
                    headingTextStyle: headingTextStyle,
                    dataTextStyle: dataTextStyle,
                    dividerThickness: 1.2,
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: theme.dividerColor,
                        width: 0.5,
                      ),
                    ),
                    columns: columns
                        .map((c) => DataColumn2(
                              label: Text(c.label),
                              fixedWidth: c.fixedWidth,
                            ))
                        .toList(),
                    rows: List<DataRow>.generate(items.length, (i) {
                      final item = items[i];
                      return DataRow(
                        color: MaterialStateProperty.all(
                          i.isEven ? stripeColor : Colors.transparent,
                        ),
                        cells:
                            columns.map((c) => c.cellBuilder(item, i)).toList(),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
