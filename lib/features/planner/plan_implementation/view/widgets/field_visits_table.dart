// lib/features/planner/plan_implementation/view/widgets/field_visits_table.dart

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:opms/features/planner/plan_implementation/model/field_visit_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/field_visit_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_options_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';

class FieldVisitsTable extends StatefulWidget {
  final List<FieldVisitItem> items;
  final bool isEditable;
  final void Function(int, FieldVisitItem) onEdit;
  final List<FieldVisitOptionModel> visitOptions;
  final bool visitOptionsLoading;
  final List<SalaryOptionModel> salaryOptions;
  final bool salaryOptionsLoading;

  const FieldVisitsTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
    required this.visitOptions,
    required this.visitOptionsLoading,
    required this.salaryOptions,
    required this.salaryOptionsLoading,
  });

  @override
  State<FieldVisitsTable> createState() => _FieldVisitsTableState();
}

class _FieldVisitsTableState extends State<FieldVisitsTable> {
  late List<FieldVisitItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant FieldVisitsTable old) {
    super.didUpdateWidget(old);
    _items = List.from(widget.items);
  }

  void _update(int i, FieldVisitItem e) {
    setState(() => _items[i] = e);
    widget.onEdit(i, e);
  }

  String _fmt(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    return DataEntryTable<FieldVisitItem>(
      items: _items,
      emptyMessage: 'No field visits found.',
      columns: [
        // 1. Description
        DataColumnConfig<FieldVisitItem>(
          label: 'Description',
          cellBuilder: (e, i) => DataCell(Text(e.description)),
        ),

        // 2. Unit Type ← two typed dropdowns
        DataColumnConfig<FieldVisitItem>(
          label: 'Unit Type',
          fixedWidth: 120,
          cellBuilder: (e, i) {
            final isVisit = e.typeType.endsWith('FieldVisit');
            final options = isVisit
                ? widget.visitOptions.cast<Object?>()
                : widget.salaryOptions.cast<Object?>();
            final loading = isVisit
                ? widget.visitOptionsLoading
                : widget.salaryOptionsLoading;

            if (loading) {
              return const DataCell(CircularProgressIndicator());
            }

            // safely find the selected item (or null)
            final selected = isVisit
                ? widget.visitOptions
                    .firstWhereOrNull((opt) => opt.id == e.typeId)
                : widget.salaryOptions
                    .firstWhereOrNull((opt) => opt.id == e.typeId);

            return DataCell(
              Tooltip(
                message: e.unitType,
                child: widget.isEditable
                    ? DropdownButtonFormField<Object>(
                        value: selected,
                        items: options.map((opt) {
                          final label = isVisit
                              ? (opt as FieldVisitOptionModel).unitType
                              : (opt as SalaryOptionModel).type;
                          return DropdownMenuItem<Object>(
                            value: opt,
                            child: Text(label),
                          );
                        }).toList(),
                        onChanged: (sel) {
                          if (sel != null) {
                            _update(
                              i,
                              e.copyWith(
                                typeId: (sel as dynamic).id,
                                type: sel,
                              ),
                            );
                          }
                        },
                      )
                    : Text(e.unitType),
              ),
            );
          },
        ),

        // 3. Number of Units (travels per year)
        DataColumnConfig<FieldVisitItem>(
          label: 'Number of Units',
          fixedWidth: 100,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: 'Number of travels per year',
              child: widget.isEditable
                  ? TextFormField(
                      initialValue: e.numOfUnitsPerYear.toString(),
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (t) {
                        final v = int.tryParse(t) ?? 0;
                        _update(i, e.copyWith(numOfUnitsPerYear: v));
                      },
                    )
                  : Text('${e.numOfUnitsPerYear}'),
            ),
          ),
        ),

        // 4. Specific Unit/Day
        DataColumnConfig<FieldVisitItem>(
          label: 'Specific Unit/Day',
          fixedWidth: 100,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: 'Specific unit per day',
              child: widget.isEditable
                  ? TextFormField(
                      initialValue: e.specificUnitDay.toString(),
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (t) {
                        final v = int.tryParse(t) ?? 0;
                        _update(i, e.copyWith(specificUnitDay: v));
                      },
                    )
                  : Text('${e.specificUnitDay}'),
            ),
          ),
        ),

        // 5. Unit Price
        DataColumnConfig<FieldVisitItem>(
          label: 'Unit Price',
          fixedWidth: 120,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: _fmt(e.unitPrice),
              child: Text(_fmt(e.unitPrice)),
            ),
          ),
        ),

        // 6. Number of Units (staff per travel)
        DataColumnConfig<FieldVisitItem>(
          label: 'Number of Units',
          fixedWidth: 100,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: 'Number of staff in one travel',
              child: widget.isEditable
                  ? TextFormField(
                      initialValue: e.numberOfUnitsPerTravel.toString(),
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (t) {
                        final v = int.tryParse(t) ?? 0;
                        _update(i, e.copyWith(numberOfUnitsPerTravel: v));
                      },
                    )
                  : Text('${e.numberOfUnitsPerTravel}'),
            ),
          ),
        ),

        // 7. Annual Cost = years × days × staff × price
        DataColumnConfig<FieldVisitItem>(
          label: 'Annual Cost',
          fixedWidth: 130,
          cellBuilder: (e, i) {
            final total = e.numOfUnitsPerYear *
                e.specificUnitDay *
                e.numberOfUnitsPerTravel *
                e.unitPrice;
            return DataCell(
              Tooltip(
                message:
                    '${e.numOfUnitsPerYear}×${e.specificUnitDay}×${e.numberOfUnitsPerTravel}×${_fmt(e.unitPrice)} = ${_fmt(total)}',
                child: Text(_fmt(total)),
              ),
            );
          },
        ),

        // 8. Remarks
        DataColumnConfig<FieldVisitItem>(
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
