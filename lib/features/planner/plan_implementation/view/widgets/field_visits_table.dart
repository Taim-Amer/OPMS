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
  final void Function(FieldVisitItem) onAdd;
  final void Function(int) onDelete;
  final List<FieldVisitOptionModel> visitOptions;
  final bool visitOptionsLoading;
  final List<SalaryOptionModel> salaryOptions;
  final bool salaryOptionsLoading;

  const FieldVisitsTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
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
    // Only reset from parent when they actually pass rows back
    if (widget.items.isNotEmpty) {
      _items = List.from(widget.items);
    }
  }

  /// Build a new blank row of given `typeType` & `initialType`.
  FieldVisitItem _newRow({
    required String typeType,
    required dynamic initialType,
  }) {
    return FieldVisitItem(
      id: 0,
      planImplementationId: 0,
      typeType: typeType,
      typeId: initialType.id,
      numOfUnitsPerYear: 0,
      specificUnitDay: 0,
      numberOfUnitsPerTravel: 0,
      remarks: '',
      type: initialType,
    );
  }

  void _addFieldVisitRow() {
    final init = widget.visitOptions.first;
    final row = _newRow(
      typeType: r'\App\Models\FieldVisit',
      initialType: init,
    );
    setState(() => _items.add(row));
    widget.onAdd(row);
  }

  void _addSalaryRow() {
    final init = widget.salaryOptions.first;
    final row = _newRow(
      typeType: r'\App\Models\Salary',
      initialType: init,
    );
    setState(() => _items.add(row));
    widget.onAdd(row);
  }

  void _deleteRow(int idx) {
    final rowNum = idx + 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Row #$rowNum?'),
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

  void _update(int i, FieldVisitItem e) {
    setState(() => _items[i] = e);
    widget.onEdit(i, e);
  }

  String _fmt(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    // 1) If empty & editable: show "Create" button
    if (_items.isEmpty && widget.isEditable) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.table_rows),
          label: const Text('Create Field Visits Table'),
          onPressed: _addFieldVisitRow,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
    }

    // 2) Otherwise show the table + bottom Add buttons
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataEntryTable<FieldVisitItem>(
          items: _items,
          emptyMessage: (_items.isEmpty && !widget.isEditable)
              ? 'No field visits found.'
              : '',
          headingHeight: 44,
          rowHeight: 54,
          maxHeightFactor: 0.6,
          columns: [
            // A) Row‐Type selector column
            DataColumnConfig<FieldVisitItem>(
              label: 'Row Type',
              fixedWidth: 140,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: e.typeType.endsWith('FieldVisit')
                      ? 'Field Visit'
                      : 'Salary',
                  child: DropdownButtonFormField<String>(
                    value: e.typeType,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: r'\App\Models\FieldVisit',
                        child: Text('Field Visit'),
                      ),
                      DropdownMenuItem(
                        value: r'\App\Models\Salary',
                        child: Text('Salary'),
                      ),
                    ],
                    onChanged: widget.isEditable
                        ? (val) {
                            if (val == r'\App\Models\FieldVisit') {
                              final init = widget.visitOptions.first;
                              _update(
                                i,
                                e.copyWith(
                                  typeType: val,
                                  typeId: init.id,
                                  type: init,
                                ),
                              );
                            } else {
                              final init = widget.salaryOptions.first;
                              _update(
                                i,
                                e.copyWith(
                                  typeType: val,
                                  typeId: init.id,
                                  type: init,
                                ),
                              );
                            }
                          }
                        : null,
                  ),
                ),
              ),
            ),

            // 1. Description
            DataColumnConfig<FieldVisitItem>(
              label: 'Description',
              cellBuilder: (e, i) => DataCell(Text(e.description)),
            ),

            // 2. Unit Type dropdown
            DataColumnConfig<FieldVisitItem>(
              label: 'Unit Type',
              fixedWidth: 120,
              cellBuilder: (e, i) {
                final isVisit = e.typeType.endsWith('FieldVisit');
                final loading = isVisit
                    ? widget.visitOptionsLoading
                    : widget.salaryOptionsLoading;
                final options = isVisit
                    ? widget.visitOptions.cast<Object?>()
                    : widget.salaryOptions.cast<Object?>();

                if (loading) {
                  return const DataCell(
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final selected = isVisit
                    ? widget.visitOptions
                        .firstWhereOrNull((o) => o.id == e.typeId)
                    : widget.salaryOptions
                        .firstWhereOrNull((o) => o.id == e.typeId);

                return DataCell(Tooltip(
                  message: e.unitType,
                  child: widget.isEditable
                      ? DropdownButtonFormField<Object>(
                          value: selected,
                          isExpanded: true,
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
                                  ));
                            }
                          },
                        )
                      : Text(e.unitType),
                ));
              },
            ),

            // 3. Number of travels per year
            DataColumnConfig<FieldVisitItem>(
              label: 'No. of Travels/Year',
              fixedWidth: 120,
              cellBuilder: (e, i) => DataCell(Tooltip(
                message: 'Travels per year: ${e.numOfUnitsPerYear}',
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
              )),
            ),

            // 4. Specific unit/day
            DataColumnConfig<FieldVisitItem>(
              label: 'Specific Unit/Day',
              fixedWidth: 120,
              cellBuilder: (e, i) => DataCell(Tooltip(
                message: 'Per‐day units: ${e.specificUnitDay}',
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
              )),
            ),

            // 5. Unit Price
            DataColumnConfig<FieldVisitItem>(
              label: 'Unit Price',
              fixedWidth: 120,
              cellBuilder: (e, i) => DataCell(Tooltip(
                message: _fmt(e.unitPrice),
                child: Text(_fmt(e.unitPrice)),
              )),
            ),

            // 6. Staff per travel
            DataColumnConfig<FieldVisitItem>(
              label: 'Staff/Travel',
              fixedWidth: 120,
              cellBuilder: (e, i) => DataCell(Tooltip(
                message: 'Staff per travel: ${e.numberOfUnitsPerTravel}',
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
              )),
            ),

            // 7. Annual Cost with tooltip formula
            DataColumnConfig<FieldVisitItem>(
              label: 'Annual Cost',
              fixedWidth: 140,
              cellBuilder: (e, i) {
                final total = e.numOfUnitsPerYear *
                    e.specificUnitDay *
                    e.numberOfUnitsPerTravel *
                    e.unitPrice;
                return DataCell(Tooltip(
                  message:
                      '${e.numOfUnitsPerYear} × ${e.specificUnitDay} × ${e.numberOfUnitsPerTravel} × ${_fmt(e.unitPrice)}\n= ${_fmt(total)}',
                  child: Text(_fmt(total)),
                ));
              },
            ),

            // 8. Remarks
            DataColumnConfig<FieldVisitItem>(
              label: 'Remarks',
              fixedWidth: 200,
              cellBuilder: (e, i) => DataCell(Tooltip(
                message: e.remarks ?? '',
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: e.remarks,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        onChanged: (t) => _update(i, e.copyWith(remarks: t)),
                      )
                    : Text(e.remarks ?? ''),
              )),
            ),

            // 9. Delete action
            DataColumnConfig<FieldVisitItem>(
              label: 'Actions',
              fixedWidth: 64,
              cellBuilder: (_, i) => DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  tooltip: 'Delete row',
                  onPressed: widget.isEditable ? () => _deleteRow(i) : null,
                ),
              ),
            ),
          ],
        ),

        // Add Row buttons
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.location_on),
                  label: const Text('Add Field Visit'),
                  onPressed: _addFieldVisitRow,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.attach_money),
                  label: const Text('Add Salary'),
                  onPressed: _addSalaryRow,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
