// lib/features/planner/plan_implementation/view/widgets/equipments_table.dart

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:opms/features/planner/plan_implementation/model/equipment_model.dart';
import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';

class EquipmentsTable extends StatefulWidget {
  final List<EquipmentItem> items;
  final bool isEditable;
  final void Function(int, EquipmentItem) onEdit;
  final void Function(EquipmentItem) onAdd;
  final void Function(int) onDelete;
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<EquipmentOptionModel> equipmentOptions;
  final bool equipmentOptionsLoading;

  const EquipmentsTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
    required this.onAdd,
    required this.onDelete,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.equipmentOptions,
    required this.equipmentOptionsLoading,
  });

  @override
  State<EquipmentsTable> createState() => _EquipmentsTableState();
}

class _EquipmentsTableState extends State<EquipmentsTable> {
  late List<EquipmentItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant EquipmentsTable old) {
    super.didUpdateWidget(old);
    if (widget.items.isNotEmpty) {
      _items = List.from(widget.items);
    }
  }

  EquipmentItem _newRow() {
    return EquipmentItem(
      id: 0,
      planImplementationId: 0,
      equipmentId: 0,
      facilityTypeId: 0,
      facilityNameEn: '',
      facilityNameAr: '',
      quantity: 0,
      remarks: '',
      equipment: EquipmentOptionModel(
        id: 0,
        type: '',
        equipmentDescription: '',
        equipmentCost: 0,
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
        title: Text('Delete Equipment Row #$row?'),
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

  void _update(int i, EquipmentItem e) {
    setState(() => _items[i] = e);
    widget.onEdit(i, e);
  }

  String _fmt(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final cellTextStyle = Theme.of(context).textTheme.bodySmall;

    // 1) “Create” button when empty & editable
    if (_items.isEmpty && widget.isEditable) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.table_rows),
          label: const Text('Create Equipments Table'),
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
        DataEntryTable<EquipmentItem>(
          items: _items,
          emptyMessage: (_items.isEmpty && !widget.isEditable)
              ? 'No equipments found.'
              : '',
          headingHeight: 44,
          rowHeight: 54,
          maxHeightFactor: 0.6,
          columns: [
            // 1. Facility Type
            DataColumnConfig<EquipmentItem>(
              label: 'Facility Type',
              fixedWidth: 150,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Select facility type',
                  child: widget.facilityTypesLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
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
              ),
            ),

            // 2. Facility Name EN
            DataColumnConfig<EquipmentItem>(
              label: 'Facility Name (EN)',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Facility Name EN: ${e.facilityNameEn}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.facilityNameEn,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: cellTextStyle,
                          onChanged: (t) =>
                              _update(i, e.copyWith(facilityNameEn: t)),
                        )
                      : Text(e.facilityNameEn, style: cellTextStyle),
                ),
              ),
            ),

            // 3. Facility Name AR
            DataColumnConfig<EquipmentItem>(
              label: 'Facility Name (AR)',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Facility Name AR: ${e.facilityNameAr}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.facilityNameAr,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: cellTextStyle,
                          onChanged: (t) =>
                              _update(i, e.copyWith(facilityNameAr: t)),
                        )
                      : Text(e.facilityNameAr, style: cellTextStyle),
                ),
              ),
            ),

            // 4. Equipment Type
            DataColumnConfig<EquipmentItem>(
              label: 'Equipment Type',
              fixedWidth: 180,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Select equipment type',
                  child: widget.equipmentOptionsLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : DropdownButtonFormField<EquipmentOptionModel>(
                          value: widget.equipmentOptions
                              .firstWhereOrNull((o) => o.id == e.equipmentId),
                          items: widget.equipmentOptions
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
                                      e.copyWith(
                                        equipmentId: opt.id,
                                        equipment: opt,
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
            DataColumnConfig<EquipmentItem>(
              label: 'Description',
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Description: ${e.equipment.equipmentDescription}',
                  child: Text(e.equipment.equipmentDescription),
                ),
              ),
            ),

            // 6. Quantity
            DataColumnConfig<EquipmentItem>(
              label: 'Quantity',
              fixedWidth: 100,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Quantity: ${e.quantity}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: e.quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          style: cellTextStyle,
                          onChanged: (t) {
                            final q = int.tryParse(t) ?? 0;
                            _update(i, e.copyWith(quantity: q));
                          },
                        )
                      : Text(e.quantity.toString(), style: cellTextStyle),
                ),
              ),
            ),

            // 7. Unit Cost
            DataColumnConfig<EquipmentItem>(
              label: 'Unit Cost',
              fixedWidth: 120,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Unit cost: ${_fmt(e.equipment.equipmentCost)}',
                  child: Text(_fmt(e.equipment.equipmentCost)),
                ),
              ),
            ),

            // 8. Total
            DataColumnConfig<EquipmentItem>(
              label: 'Total',
              fixedWidth: 130,
              cellBuilder: (e, i) {
                final tot = e.quantity * e.equipment.equipmentCost;
                return DataCell(
                  Tooltip(
                    message:
                        'Total = ${e.quantity} × ${_fmt(e.equipment.equipmentCost)} = ${_fmt(tot)}',
                    child: Text(_fmt(tot)),
                  ),
                );
              },
            ),

            // 9. Remarks
            DataColumnConfig<EquipmentItem>(
              label: 'Remarks',
              fixedWidth: 200,
              cellBuilder: (e, i) => DataCell(
                Tooltip(
                  message: 'Remarks: ${e.remarks ?? ""}',
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

            // 10. Actions (Delete)
            DataColumnConfig<EquipmentItem>(
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
