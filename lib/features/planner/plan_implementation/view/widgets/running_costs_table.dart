// lib/features/planner/plan_implementation/view/widgets/running_costs_table.dart

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:opms/features/planner/plan_implementation/model/running_cost_model.dart';
import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';

class RunningCostsTable extends StatefulWidget {
  final List<RunningCostItem> items;
  final bool isEditable;
  final void Function(int, RunningCostItem) onEdit;
  final void Function(RunningCostItem) onAdd;
  final void Function(int) onDelete;
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<RunningCostOptionModel> costOptions;
  final bool costOptionsLoading;

  const RunningCostsTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.costOptions,
    required this.costOptionsLoading,
  });

  @override
  State<RunningCostsTable> createState() => _RunningCostsTableState();
}

class _RunningCostsTableState extends State<RunningCostsTable> {
  late List<RunningCostItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant RunningCostsTable old) {
    super.didUpdateWidget(old);
    if (widget.items.isNotEmpty) {
      _items = List.from(widget.items);
    }
  }

  /// Blank row template
  RunningCostItem _newRow() {
    return RunningCostItem(
      id: 0,
      planImplementationId: 0,
      runningCostId: 0,
      facilityTypeId: 0,
      facilityNameEn: '',
      facilityNameAr: '',
      description: '',
      numberOfUnitsEveryMonth: 0,
      frequencyNumberOfMonths: 1,
      remarks: '',
      runningCost: RunningCostOptionModel(
        id: 0,
        expenseType: '',
        unitType: '',
        unitCost: 0,
        date: '',
      ),
      facilityType: FacilityTypeModel(id: 0, name: ""),
    );
  }

  void _addRow() {
    final row = _newRow();
    setState(() => _items.add(row));
    widget.onAdd(row);
  }

  void _deleteRow(int idx) {
    final rowNum = idx + 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Running Cost Row #$rowNum?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _items.removeAt(idx));
              widget.onDelete(idx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _update(int i, RunningCostItem e) {
    setState(() => _items[i] = e);
    widget.onEdit(i, e);
  }

  String _fmt(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    // Create button when empty & editable
    if (_items.isEmpty && widget.isEditable) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.table_rows),
          label: const Text('Create Running Costs Table'),
          onPressed: _addRow,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataEntryTable<RunningCostItem>(
          items: _items,
          emptyMessage: (_items.isEmpty && !widget.isEditable)
              ? 'No running costs found.'
              : '',
          headingHeight: 44,
          rowHeight: 54,
          maxHeightFactor: 0.6,
          columns: [
            // 1. Facility Type
            DataColumnConfig<RunningCostItem>(
              label: 'Facility Type',
              fixedWidth: 150,
              cellBuilder: (e, i) {
                return DataCell(
                  widget.facilityTypesLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : Tooltip(
                          message: widget.facilityTypes
                                  .firstWhereOrNull(
                                      (ft) => ft.id == e.facilityTypeId)
                                  ?.name ??
                              '',
                          child: DropdownButtonFormField<int>(
                            value:
                                e.facilityTypeId == 0 ? null : e.facilityTypeId,
                            items: widget.facilityTypes
                                .map((ft) => DropdownMenuItem(
                                      value: ft.id,
                                      child: Text(ft.name),
                                    ))
                                .toList(),
                            onChanged: widget.isEditable
                                ? (id) => id != null
                                    ? _update(i, e.copyWith(facilityTypeId: id))
                                    : null
                                : null,
                          ),
                        ),
                );
              },
            ),

            // 2. Facility Name (EN)
            DataColumnConfig<RunningCostItem>(
              label: 'Facility Name (EN)',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: e.facilityNameEn,
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.facilityNameEn,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) =>
                              _update(i, e.copyWith(facilityNameEn: t)),
                        )
                      : Text(e.facilityNameEn),
                ),
              ),
            ),

            // 3. Facility Name (AR)
            DataColumnConfig<RunningCostItem>(
              label: 'Facility Name (AR)',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: e.facilityNameAr,
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.facilityNameAr,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) =>
                              _update(i, e.copyWith(facilityNameAr: t)),
                        )
                      : Text(e.facilityNameAr),
                ),
              ),
            ),

            // 4. Expense Type
            DataColumnConfig<RunningCostItem>(
              label: 'Expense Type',
              fixedWidth: 180,
              cellBuilder: (e, i) => DataCell(
                widget.costOptionsLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator())
                    : Tooltip(
                        message: widget.costOptions
                                .firstWhereOrNull(
                                    (opt) => opt.id == e.runningCostId)
                                ?.expenseType ??
                            '',
                        child: DropdownButtonFormField<RunningCostOptionModel>(
                          value: widget.costOptions.firstWhereOrNull(
                              (opt) => opt.id == e.runningCostId),
                          items: widget.costOptions
                              .map((opt) => DropdownMenuItem(
                                    value: opt,
                                    child: Text(opt.expenseType),
                                  ))
                              .toList(),
                          onChanged: widget.isEditable
                              ? (sel) {
                                  if (sel != null) {
                                    _update(
                                      i,
                                      e.copyWith(
                                        runningCostId: sel.id,
                                        runningCost: sel,
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                      ),
              ),
            ),

            // 5. Expense Description
            DataColumnConfig<RunningCostItem>(
              label: 'Expense Description',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: e.description,
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.description,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (t) =>
                              _update(i, e.copyWith(description: t)),
                        )
                      : Text(e.description),
                ),
              ),
            ),

            // 6. Unit Type
            DataColumnConfig<RunningCostItem>(
              label: 'Unit Type',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: e.runningCost.unitType,
                  child: Text(e.runningCost.unitType),
                ),
              ),
            ),

            // 7. No. of Units
            DataColumnConfig<RunningCostItem>(
              label: 'No. of Units',
              fixedWidth: 100,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: e.numberOfUnitsEveryMonth.toString(),
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.numberOfUnitsEveryMonth.toString(),
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) {
                            final v = int.tryParse(t) ?? 0;
                            _update(i, e.copyWith(numberOfUnitsEveryMonth: v));
                          },
                        )
                      : Text('${e.numberOfUnitsEveryMonth}'),
                ),
              ),
            ),

            // 8. Unit Cost
            DataColumnConfig<RunningCostItem>(
              label: 'Unit Cost',
              fixedWidth: 120,
              cellBuilder: (e, i) {
                final cost = _fmt(e.runningCost.unitCost);
                return DataCell(Text(cost));
              },
            ),

            // 9. Monthly Cost
            DataColumnConfig<RunningCostItem>(
              label: 'Monthly Cost',
              fixedWidth: 130,
              cellBuilder: (e, i) {
                final unitCost = e.runningCost.unitCost;
                final units = e.numberOfUnitsEveryMonth;
                final monthly = unitCost * units;
                return DataCell(
                  Tooltip(
                    padding: const EdgeInsets.all(8),
                    message: [
                      'Monthly Cost = Unit Cost × No. of Units',
                      '             = ${_fmt(unitCost)} × $units',
                      '             = ${_fmt(monthly)}',
                    ].join('\n'),
                    child: Text(_fmt(monthly)),
                  ),
                );
              },
            ),

            // 10. Frequency
            DataColumnConfig<RunningCostItem>(
              label: 'Frequency (Mo.)',
              fixedWidth: 140,
              cellBuilder: (e, i) => DataCell(
                Text('${e.frequencyNumberOfMonths}'),
              ),
            ),

            // 11. Total
            DataColumnConfig<RunningCostItem>(
              label: 'Total',
              fixedWidth: 130,
              cellBuilder: (e, i) {
                final unitCost = e.runningCost.unitCost;
                final units = e.numberOfUnitsEveryMonth;
                final monthly = unitCost * units;
                final total = monthly * e.frequencyNumberOfMonths;
                return DataCell(
                  Tooltip(
                    padding: const EdgeInsets.all(8),
                    message: [
                      'Total = Monthly Cost × Frequency',
                      '      = ${_fmt(monthly)} × ${e.frequencyNumberOfMonths}',
                      '      = ${_fmt(total)}',
                    ].join('\n'),
                    child: Text(_fmt(total)),
                  ),
                );
              },
            ),

            // 12. Remarks
            DataColumnConfig<RunningCostItem>(
              label: 'Remarks',
              fixedWidth: 200,
              cellBuilder: (e, i) => DataCell(
                widget.isEditable
                    ? TextFormField(
                        initialValue: e.remarks,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        onChanged: (t) => _update(i, e.copyWith(remarks: t)),
                      )
                    : Text(e.remarks ?? ''),
              ),
            ),

            // 13. Actions (Delete)
            DataColumnConfig<RunningCostItem>(
              label: 'Actions',
              fixedWidth: 64,
              cellBuilder: (_, i) => DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  onPressed: widget.isEditable ? () => _deleteRow(i) : null,
                  tooltip: 'Delete row',
                ),
              ),
            ),
          ],
        ),

        // Add Row button
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Row'),
                onPressed: _addRow,
              ),
            ),
          ),
      ],
    );
  }
}
