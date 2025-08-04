// lib/features/planner/plan_implementation/view/widgets/relief_assistance_table.dart

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:opms/features/planner/plan_implementation/model/relief_assistance_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';

class ReliefAssistanceTable extends StatefulWidget {
  final List<ReliefAssistanceItem> items;
  final bool isEditable;
  final void Function(int, ReliefAssistanceItem) onEdit;
  final void Function(ReliefAssistanceItem) onAdd;
  final void Function(int) onDelete;
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<ReliefAssistanceOptionModel> reliefOptions;
  final bool reliefOptionsLoading;

  const ReliefAssistanceTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.reliefOptions,
    required this.reliefOptionsLoading,
  });

  @override
  State<ReliefAssistanceTable> createState() => _ReliefAssistanceTableState();
}

class _ReliefAssistanceTableState extends State<ReliefAssistanceTable> {
  late List<ReliefAssistanceItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant ReliefAssistanceTable old) {
    super.didUpdateWidget(old);
    if (widget.items.isNotEmpty) {
      _items = List.from(widget.items);
    }
  }

  /// Creates a blank relief‐item row for user input.
  ReliefAssistanceItem _newRow() {
    return ReliefAssistanceItem(
      id: 0,
      planImplementationId: 0,
      reliefId: 0,
      facilityTypeId: 0,
      facilityNameEn: '',
      facilityNameAr: '',
      quantity: 0,
      remarks: '',
      reliefItem: ReliefAssistanceOptionModel(
        id: 0,
        type: '',
        description: '',
        unitCost: 0,
        date: '',
      ),
      facilityType: FacilityTypeModel(id: 0, name: ""),
    );
  }

  void _addRow() {
    final newRow = _newRow();
    setState(() => _items.add(newRow));
    widget.onAdd(newRow);
  }

  void _deleteRow(int idx) {
    final row = idx + 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Relief Row #$row?'),
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

  void _update(int i, ReliefAssistanceItem e) {
    setState(() => _items[i] = e);
    widget.onEdit(i, e);
  }

  String _fmt(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    // 1) “Create” button when empty & editable
    if (_items.isEmpty && widget.isEditable) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.table_rows),
          label: const Text('Create Relief Table'),
          onPressed: _addRow,
          style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataEntryTable<ReliefAssistanceItem>(
          items: _items,
          emptyMessage: (_items.isEmpty && !widget.isEditable)
              ? 'No relief items found.'
              : '',
          headingHeight: 44,
          rowHeight: 54,
          maxHeightFactor: 0.6,
          columns: [
            // 1. Facility Type
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Facility Type',
              fixedWidth: 150,
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Select facility type',
                  child: widget.facilityTypesLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          value:
                              r.facilityTypeId == 0 ? null : r.facilityTypeId,
                          items: widget.facilityTypes
                              .map((ft) => DropdownMenuItem(
                                    value: ft.id,
                                    child: Text(ft.name),
                                  ))
                              .toList(),
                          onChanged: widget.isEditable
                              ? (id) => id != null
                                  ? _update(i, r.copyWith(facilityTypeId: id))
                                  : null
                              : null,
                        ),
                ),
              ),
            ),

            // 2. Facility Name EN
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Facility Name in English',
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Facility Name EN: ${r.facilityNameEn}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: r.facilityNameEn,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) =>
                              _update(i, r.copyWith(facilityNameEn: t)),
                        )
                      : Text(r.facilityNameEn),
                ),
              ),
            ),

            // 3. Facility Name AR
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Facility Name in Arabic',
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Facility Name AR: ${r.facilityNameAr}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: r.facilityNameAr,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) =>
                              _update(i, r.copyWith(facilityNameAr: t)),
                        )
                      : Text(r.facilityNameAr),
                ),
              ),
            ),

            // 4. Item Type
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Item Type',
              fixedWidth: 160,
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Select relief item type',
                  child: widget.reliefOptionsLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : DropdownButtonFormField<ReliefAssistanceOptionModel>(
                          value: widget.reliefOptions
                              .firstWhereOrNull((o) => o.id == r.reliefId),
                          items: widget.reliefOptions
                              .map((opt) => DropdownMenuItem(
                                    value: opt,
                                    child: Text(opt.type),
                                  ))
                              .toList(),
                          onChanged: widget.isEditable
                              ? (opt) {
                                  if (opt != null) {
                                    _update(
                                      i,
                                      r.copyWith(
                                        reliefId: opt.id,
                                        reliefItem: opt,
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                ),
              ),
            ),

            // 5. Description (readonly)
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Item Description',
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Description: ${r.reliefItem.description}',
                  child: Text(r.reliefItem.description),
                ),
              ),
            ),

            // 6. Quantity
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Quantity',
              fixedWidth: 100,
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Quantity: ${r.quantity}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: r.quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) {
                            final q = int.tryParse(t) ?? 0;
                            _update(i, r.copyWith(quantity: q));
                          },
                        )
                      : Text(r.quantity.toString()),
                ),
              ),
            ),

            // 7. Unit Cost
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Unit Cost',
              fixedWidth: 120,
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Unit cost: ${_fmt(r.reliefItem.unitCost)}',
                  child: Text(_fmt(r.reliefItem.unitCost)),
                ),
              ),
            ),

            // 8. Total
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Total',
              fixedWidth: 130,
              cellBuilder: (r, i) {
                final tot = r.quantity * r.reliefItem.unitCost;
                return DataCell(
                  Tooltip(
                    message:
                        'Total = ${r.quantity} × ${_fmt(r.reliefItem.unitCost)} = ${_fmt(tot)}',
                    child: Text(_fmt(tot)),
                  ),
                );
              },
            ),

            // 9. Remarks
            DataColumnConfig<ReliefAssistanceItem>(
              label: 'Remarks',
              fixedWidth: 200,
              cellBuilder: (r, i) => DataCell(
                Tooltip(
                  message: 'Remarks: ${r.remarks ?? ""}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: r.remarks,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) => _update(i, r.copyWith(remarks: t)),
                        )
                      : Text(r.remarks ?? ''),
                ),
              ),
            ),

            // 10. Actions (Delete)
            DataColumnConfig<ReliefAssistanceItem>(
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

        // 2) Add Row button
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
