// ignore_for_file: must_be_immutable

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class TPaginatedDataTable extends StatelessWidget {
  const TPaginatedDataTable({
    super.key,
    this.sortAscending = true,
    this.sortColumnIndex,
    this.rowsPerPage = 10,
    required this.source,
    required this.columns,
    this.onPageChanged,
    this.dataRowHeight = 50,
    this.tableHeight = 760,
    this.minWidth = 1000,
    this.isEmpty = false,
  });

  final bool sortAscending;
  final int? sortColumnIndex;
  final int rowsPerPage;
  final DataTableSource? source;
  final List<DataColumn> columns;
  final Function(int)? onPageChanged;
  final double dataRowHeight;
  final double tableHeight;
  final double? minWidth;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.dark : TColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: tableHeight,
        child: Theme(
          data: Theme.of(context).copyWith(
            cardTheme: CardTheme(color: dark ? TColors.dark: TColors.white, elevation: 0),
          ),
          child: PaginatedDataTable2(
            columnSpacing: 16,
            minWidth: minWidth,
            dividerThickness: 0.7,
            horizontalMargin: 12,
            dataRowHeight: dataRowHeight,
            rowsPerPage: rowsPerPage,
            showCheckboxColumn: true,
            headingTextStyle: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: TColors.textPrimary),
            showFirstLastButtons: true,
            renderEmptyRowsInTheEnd: false,
            onRowsPerPageChanged: (noOfRows) {},
            onPageChanged: onPageChanged,
            sortAscending: sortAscending,
            sortArrowAlwaysVisible: true,
            sortArrowAnimationDuration: const Duration(milliseconds: 200),
            sortArrowIcon: Icons.keyboard_arrow_up,
            sortColumnIndex: sortColumnIndex,

            sortArrowBuilder: (bool ascending, bool sorted) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: sorted
                    ? Icon(
                  ascending ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  key: ValueKey(ascending),
                  size: Sizes.iconMd,
                  color: TColors.accent,
                )
                    : const Icon(Icons.unfold_more, size: Sizes.iconMd, color: Colors.grey),
              );
            },
            dataTextStyle: Theme.of(context).textTheme.headlineLarge,
            headingRowColor: WidgetStateProperty.resolveWith(
                    (state) => TColors.primary.withOpacity(0.9)),
            headingRowDecoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),

            horizontalScrollController: ScrollController(),
            isHorizontalScrollBarVisible: true,
            isVerticalScrollBarVisible: true,

            columns: columns,
            source: isEmpty ? EmptyDataSource() : source ?? EmptyDataSource(),
          ),
        ),
      ),
    );
  }
}

class EmptyDataSource extends DataTableSource {
  @override
  int get rowCount => 0;

  @override
  DataRow? getRow(int index) => null;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
