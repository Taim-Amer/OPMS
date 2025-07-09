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
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<ReliefAssistanceOptionModel> reliefOptions;
  final bool reliefOptionsLoading;

  const ReliefAssistanceTable({
    super.key,
    required this.items,
    required this.isEditable,
    required this.onEdit,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.reliefOptions,
    required this.reliefOptionsLoading,
  });

  @override
  State<ReliefAssistanceTable> createState() =>
      _ReliefAssistanceTableState();
}

class _ReliefAssistanceTableState
    extends State<ReliefAssistanceTable> {
  late List<ReliefAssistanceItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(covariant ReliefAssistanceTable old) {
    super.didUpdateWidget(old);
    _items = List.from(widget.items);
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
    return DataEntryTable<ReliefAssistanceItem>(
      items: _items,
      emptyMessage: 'No relief items found.',
      columns: [
        // 1. Facility Type
        DataColumnConfig<ReliefAssistanceItem>(
          label: 'Facility Type',
          fixedWidth: 150,
          cellBuilder: (r, i) => DataCell(
            Tooltip(
              message: 'Select facility type',
              child: widget.facilityTypesLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<int>(
                      value: r.facilityTypeId,
                      items: widget.facilityTypes
                          .map((ft) => DropdownMenuItem(
                                value: ft.id,
                                child: Text(ft.name),
                              ))
                          .toList(),
                      onChanged: widget.isEditable
                          ? (id) => _update(
                              i, r.copyWith(facilityTypeId: id))
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

        // 4. Item Type (dropdown)
        DataColumnConfig<ReliefAssistanceItem>(
          label: 'Item Type',
          fixedWidth: 160,
          cellBuilder: (r, i) => DataCell(
            Tooltip(
              message: 'Select relief item type',
              child: widget.reliefOptionsLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<
                          ReliefAssistanceOptionModel>(
                      value: widget.reliefOptions.firstWhereOrNull(
                          (o) => o.id == r.reliefId),
                      items: widget.reliefOptions
                          .map((opt) => DropdownMenuItem(
                                value: opt,
                                child: Text(opt.type),
                              ))
                          .toList(),
                      onChanged: widget.isEditable
                          ? (opt) {
                              if (opt != null) {
                                _update(i, r.copyWith(
                                  reliefId: opt.id,
                                  reliefItem: opt,
                                ));
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
              message:
                  'Description: ${r.reliefItem.description}',
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
              message:
                  'Unit cost: ${_fmt(r.reliefItem.unitCost)}',
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
                      onChanged: (t) =>
                          _update(i, r.copyWith(remarks: t)),
                    )
                  : Text(r.remarks ?? ''),
            ),
          ),
        ),
      ],
    );
  }
}
