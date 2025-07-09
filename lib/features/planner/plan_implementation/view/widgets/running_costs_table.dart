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
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<RunningCostOptionModel> costOptions;
  final bool costOptionsLoading;

  const RunningCostsTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
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
    _items = List.from(widget.items);
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
    return DataEntryTable<RunningCostItem>(
      items: _items,
      emptyMessage: 'No running costs found.',
      columns: [
        // 1. Facility Type
        DataColumnConfig<RunningCostItem>(
          label: 'Facility Type',
          fixedWidth: 150,
          cellBuilder: (e, i) {
            final name = widget.facilityTypes
                    .firstWhereOrNull((ft) => ft.id == e.facilityTypeId)
                    ?.name ??
                '';
            return DataCell(
              widget.facilityTypesLoading
                  ? const CircularProgressIndicator()
                  : Tooltip(
                      message: name,
                      child: DropdownButtonFormField<int>(
                        value: e.facilityTypeId,
                        items: widget.facilityTypes
                            .map((ft) => DropdownMenuItem(
                                  value: ft.id,
                                  child: Text(ft.name),
                                ))
                            .toList(),
                        onChanged: widget.isEditable
                            ? (id) => _update(
                                i, e.copyWith(facilityTypeId: id))
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
          cellBuilder: (e, i) {
            final opt = widget.costOptions
                .firstWhereOrNull((opt) => opt.id == e.runningCostId);
            return DataCell(
              widget.costOptionsLoading
                  ? const CircularProgressIndicator()
                  : Tooltip(
                      message: opt?.expenseType ?? '',
                      child: DropdownButtonFormField<RunningCostOptionModel>(
                        value: opt,
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
                                        // if you want to reset description on type-change:
                                        // description: sel.expenseType,
                                      ));
                                }
                              }
                            : null,
                      ),
                    ),
            );
          },
        ),

        // 5. Expense Description (now editable + validated)
        DataColumnConfig<RunningCostItem>(
          label: 'Expense Description',
          cellBuilder: (e, i) {
            final isEmpty = e.description.trim().isEmpty;
            return DataCell(
              Tooltip(
                message: e.description,
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: e.description,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Describe expense',
                          errorText: isEmpty ? 'Required' : null,
                        ),
                        onChanged: (t) =>
                            _update(i, e.copyWith(description: t)),
                      )
                    : Text(e.description),
              ),
            );
          },
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
            return DataCell(
              Tooltip(message: cost, child: Text(cost)),
            );
          },
        ),

        // 9. Monthly Cost = unitCost * noUnits
        DataColumnConfig<RunningCostItem>(
          label: 'Monthly Cost',
          fixedWidth: 130,
          cellBuilder: (e, i) {
            final unitCost = e.runningCost.unitCost;
            final units = e.numberOfUnitsEveryMonth;
            final monthly = unitCost * units;
            final mFmt = _fmt(monthly);
            return DataCell(
              Tooltip(
                message:
                    'Unit Cost (${_fmt(unitCost)}) × Units ($units) = $mFmt',
                child: Text(mFmt),
              ),
            );
          },
        ),

        // 10. Frequency (read-only)
        DataColumnConfig<RunningCostItem>(
          label: 'Frequency (No. of Month)',
          fixedWidth: 140,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: '${e.frequencyNumberOfMonths}',
              child: Text('${e.frequencyNumberOfMonths}'),
            ),
          ),
        ),

        // 11. Total = MonthlyCost × Frequency
        DataColumnConfig<RunningCostItem>(
          label: 'Total',
          fixedWidth: 130,
          cellBuilder: (e, i) {
            final monthly = e.runningCost.unitCost * e.numberOfUnitsEveryMonth;
            final total = monthly * e.frequencyNumberOfMonths;
            final tFmt = _fmt(total);
            return DataCell(
              Tooltip(
                message:
                    'Monthly Cost (${_fmt(monthly)}) × Frequency (${e.frequencyNumberOfMonths}) = $tFmt',
                child: Text(tFmt),
              ),
            );
          },
        ),

        // 12. Remarks
        DataColumnConfig<RunningCostItem>(
          label: 'Remarks',
          fixedWidth: 200,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: e.remarks ?? '',
              child: widget.isEditable
                  ? TextFormField(
                      initialValue: e.remarks,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (t) => _update(i, e.copyWith(remarks: t)),
                    )
                  : Text(e.remarks ?? ''),
            ),
          ),
        ),
      ],
    );
  }
}
