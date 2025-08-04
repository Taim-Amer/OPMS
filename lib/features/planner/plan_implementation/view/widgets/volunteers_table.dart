// lib/features/planner/plan_implementation/view/widgets/volunteers_table.dart

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_model.dart';
import 'package:opms/features/planner/plan_implementation/model/volunteer_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_options_model.dart';
import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/salaries_table.dart';

class VolunteersTable extends StatefulWidget {
  final List<VolunteerItem> volunteers;
  final bool isEditable;
  final void Function(int, VolunteerItem) onEditVolunteer;
  final void Function(VolunteerItem) onAddVolunteer;
  final void Function(int) onDeleteVolunteer;
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<SalaryOptionModel> volunteerOptions;
  final bool volunteerOptionsLoading;
  final Future<List<SalaryOptionModel>> Function(String type)
      fetchVolunteerOptions;

  const VolunteersTable({
    super.key,
    required this.volunteers,
    required this.isEditable,
    required this.onEditVolunteer,
    required this.onAddVolunteer,
    required this.onDeleteVolunteer,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.volunteerOptions,
    required this.volunteerOptionsLoading,
    required this.fetchVolunteerOptions,
  });

  @override
  State<VolunteersTable> createState() => _VolunteersTableState();
}

class _VolunteersTableState extends State<VolunteersTable> {
  late List<VolunteerItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.volunteers);
  }

  @override
  void didUpdateWidget(covariant VolunteersTable old) {
    super.didUpdateWidget(old);
    // Only reset when the API actually returned rows:
    if (widget.volunteers.isNotEmpty) {
      _items = List.from(widget.volunteers);
    }
    // Otherwise keep local additions until save/fetch
  }

  VolunteerItem _newRow() {
    // match VolunteerItem constructor
    return VolunteerItem(
      id: 0,
      planImplementationId: 0,
      salaryId: 0,
      frequencyNumberOfMonths: 1,
      numberOfVolunteers: 0,
      numberOfShifts: 0,
      facilityTypeId: 0,
      facilityNameEn: '',
      facilityNameAr: '',
      remarks: '',
      salary: Salary(
        id: 0,
        type: '',
        positions: '',
        salary: 0,
        costOfLivingAllowance: 0,
        date: '',
      ),
      facilityType: FacilityTypeModel(id: 0, name: ''),
    );
  }

  void _addRow() {
    final newRow = _newRow();
    setState(() => _items.add(newRow));
    widget.onAddVolunteer(newRow);
  }

  void _deleteRow(int idx) {
    final rowNum = idx + 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Volunteer Row #$rowNum?'),
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
              widget.onDeleteVolunteer(idx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateItem(int idx, VolunteerItem v) {
    setState(() => _items[idx] = v);
    widget.onEditVolunteer(idx, v);
  }

  String _fmt(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    // 1) Create button when empty & editable
    if (_items.isEmpty && widget.isEditable) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.table_rows),
          label: const Text('Create Volunteers Table'),
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
        DataEntryTable<VolunteerItem>(
          items: _items,
          emptyMessage: (_items.isEmpty && !widget.isEditable)
              ? 'No volunteers found.'
              : '',
          headingHeight: 44,
          rowHeight: 54,
          maxHeightFactor: 0.6,
          columns: [
            // Facility Type
            DataColumnConfig<VolunteerItem>(
              label: 'Facility Type',
              fixedWidth: 150,
              cellBuilder: (v, i) => DataCell(
                widget.facilityTypesLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator())
                    : Tooltip(
                        message: 'Select facility type',
                        child: DropdownButtonFormField<int>(
                          value:
                              v.facilityTypeId == 0 ? null : v.facilityTypeId,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          items: widget.facilityTypes
                              .map((ft) => DropdownMenuItem<int>(
                                    value: ft.id,
                                    child: Text(ft.name),
                                  ))
                              .toList(),
                          onChanged: widget.isEditable
                              ? (id) => id != null
                                  ? _updateItem(
                                      i, v.copyWith(facilityTypeId: id))
                                  : null
                              : null,
                        ),
                      ),
              ),
            ),
            // Facility Name EN
            DataColumnConfig<VolunteerItem>(
              label: 'Facility Name in English',
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Facility Name (English): ${v.facilityNameEn}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: v.facilityNameEn,
                          decoration: const InputDecoration(
                              border: InputBorder.none, isDense: true),
                          onChanged: (t) =>
                              _updateItem(i, v.copyWith(facilityNameEn: t)),
                          style: const TextStyle(fontSize: 14),
                        )
                      : Text(
                          v.facilityNameEn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                ),
              ),
            ),
            // Facility Name AR
            DataColumnConfig<VolunteerItem>(
              label: 'Facility Name in Arabic',
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Facility Name (Arabic): ${v.facilityNameAr}',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: v.facilityNameAr,
                          decoration: const InputDecoration(
                              border: InputBorder.none, isDense: true),
                          onChanged: (t) =>
                              _updateItem(i, v.copyWith(facilityNameAr: t)),
                          style: const TextStyle(fontSize: 14),
                        )
                      : Text(
                          v.facilityNameAr ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                ),
              ),
            ),
            // Shift Allowance (Position)
            DataColumnConfig<VolunteerItem>(
              label: 'Shift Allowance',
              fixedWidth: 120,
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Select per‐shift allowance',
                  child: widget.volunteerOptionsLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator())
                      : DropdownButtonFormField<SalaryOptionModel>(
                          isExpanded: true,
                          value: widget.volunteerOptions
                              .firstWhereOrNull((o) => o.id == v.salaryId),
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4))),
                          items: widget.volunteerOptions.map((opt) {
                            return DropdownMenuItem<SalaryOptionModel>(
                              value: opt,
                              child: Text(opt.positions),
                            );
                          }).toList(),
                          onChanged: widget.isEditable
                              ? (opt) {
                                  if (opt != null) {
                                    _updateItem(
                                      i,
                                      v.copyWith(
                                        salaryId: opt.id,
                                        salary:
                                            v.salary.copyWithFromOption(opt),
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                ),
              ),
            ),
            // No. of Volunteers
            DataColumnConfig<VolunteerItem>(
              label: 'No. of Volunteers',
              fixedWidth: 120,
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Number of volunteers',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: v.numberOfVolunteers.toString(),
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) {
                            final n = t.trim().isEmpty
                                ? 0
                                : (int.tryParse(t.trim()) ?? 0);
                            _updateItem(i, v.copyWith(numberOfVolunteers: n));
                          },
                        )
                      : Text(v.numberOfVolunteers.toString()),
                ),
              ),
            ),
            // No. of Shifts
            DataColumnConfig<VolunteerItem>(
              label: 'No. of Shifts',
              fixedWidth: 100,
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Number of shifts per volunteer',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: v.numberOfShifts.toString(),
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) {
                            final s = t.trim().isEmpty
                                ? 0
                                : (int.tryParse(t.trim()) ?? 0);
                            _updateItem(i, v.copyWith(numberOfShifts: s));
                          },
                        )
                      : Text(v.numberOfShifts.toString()),
                ),
              ),
            ),
            // Monthly Shifts
            DataColumnConfig<VolunteerItem>(
              label: 'Monthly Shifts',
              fixedWidth: 110,
              cellBuilder: (v, i) {
                final ms = v.numberOfVolunteers * v.numberOfShifts;
                return DataCell(
                  Tooltip(
                    message:
                        'Monthly Shifts = No. of Volunteers × No. of Shifts\n'
                        '               = ${v.numberOfVolunteers} × ${v.numberOfShifts}\n'
                        '               = ${_fmt(ms)}',
                    child: Text(_fmt(ms)),
                  ),
                );
              },
            ),
            // Frequency
            DataColumnConfig<VolunteerItem>(
              label: 'Frequency (Mo.)',
              fixedWidth: 100,
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Frequency cannot be edited',
                  child: Text(v.frequencyNumberOfMonths.toString()),
                ),
              ),
            ),
            // Total Volunteers Cost
            DataColumnConfig<VolunteerItem>(
              label: 'Total Volunteers Cost',
              fixedWidth: 140,
              cellBuilder: (v, i) {
                final ms = v.numberOfVolunteers * v.numberOfShifts;
                final total = v.salary.salary * ms * v.frequencyNumberOfMonths;
                return DataCell(
                  Tooltip(
                    message:
                        'Total = Shift Allowance × Monthly Shifts × Frequency\n'
                        '      = ${_fmt(v.salary.salary)} × ${_fmt(ms)} × ${v.frequencyNumberOfMonths}\n'
                        '      = ${_fmt(total)}',
                    child: Text(_fmt(total)),
                  ),
                );
              },
            ),
            // Remarks
            DataColumnConfig<VolunteerItem>(
              label: 'Remarks',
              fixedWidth: 200,
              cellBuilder: (v, i) => DataCell(
                Tooltip(
                  message: 'Any additional remarks',
                  child: widget.isEditable
                      ? TextFormField(
                          initialValue: v.remarks ?? '',
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (t) =>
                              _updateItem(i, v.copyWith(remarks: t)),
                        )
                      : Text(v.remarks ?? ''),
                ),
              ),
            ),
            // Actions (Delete)
            DataColumnConfig<VolunteerItem>(
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
