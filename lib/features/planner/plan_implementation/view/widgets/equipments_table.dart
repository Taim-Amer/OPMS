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
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<EquipmentOptionModel> equipmentOptions;
  final bool equipmentOptionsLoading;

  const EquipmentsTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
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
    _items = List.from(widget.items);
  }

  void _update(int i, EquipmentItem e) {
    setState(() => _items[i] = e);
    widget.onEdit(i, e);
  }

  String _fmt(num n) => n.toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final cellTextStyle = Theme.of(context).textTheme.bodySmall;

    return DataEntryTable<EquipmentItem>(
      items: _items,
      emptyMessage: 'No equipments found.',
      columns: [
        // 1. Facility Type
        DataColumnConfig<EquipmentItem>(
          label: 'Facility Type',
          fixedWidth: 150,
          cellBuilder: (e, i) => DataCell(
            Tooltip(
              message: 'Select facility type',
              child: widget.facilityTypesLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<int>(
                      value: e.facilityTypeId,
                      items: widget.facilityTypes
                          .map((ft) => DropdownMenuItem(
                                child: Text(ft.name),
                                value: ft.id,
                              ))
                          .toList(),
                      onChanged: widget.isEditable
                          ? (id) => _update(i, e.copyWith(facilityTypeId: id))
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
                      decoration: InputDecoration(border: InputBorder.none),
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
                      decoration: InputDecoration(border: InputBorder.none),
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
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<EquipmentOptionModel>(
                      value: widget.equipmentOptions
                          .firstWhereOrNull((o) => o.id == e.equipmentId),
                      items: widget.equipmentOptions
                          .map((opt) => DropdownMenuItem(
                                child: Text(opt.type),
                                value: opt,
                              ))
                          .toList(),
                      onChanged: widget.isEditable
                          ? (opt) {
                              if (opt != null) {
                                _update(i, e.copyWith(
                                  equipmentId: opt.id,
                                  equipment: opt,
                                ));
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
                      decoration: InputDecoration(border: InputBorder.none),
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
                      decoration: InputDecoration(border: InputBorder.none),
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
