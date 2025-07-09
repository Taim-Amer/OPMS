// lib/features/planner/plan_implementation/view/widgets/volunteers_table.dart

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
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
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final List<SalaryOptionModel> volunteerOptions;
  final bool volunteerOptionsLoading;

  const VolunteersTable({
    super.key,
    required this.volunteers,
    required this.isEditable,
    required this.onEditVolunteer,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.volunteerOptions,
    required this.volunteerOptionsLoading,
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
    _items = List.from(widget.volunteers);
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
    return DataEntryTable<VolunteerItem>(
      items: _items,
      emptyMessage: 'No volunteers found.',
      columns: [
        // 1. Facility Type (unchanged)
        DataColumnConfig<VolunteerItem>(
          label: 'Facility Type',
          fixedWidth: 150,
          cellBuilder: (v, i) => DataCell(
            widget.facilityTypesLoading
                ? const SizedBox(
                    width: 24, height: 24, child: CircularProgressIndicator())
                : Tooltip(
                    message: 'Select facility type',
                    child: DropdownButtonFormField<int>(
                      value: v.facilityTypeId,
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
                              ? _updateItem(i, v.copyWith(facilityTypeId: id))
                              : null
                          : null,
                    ),
                  ),
          ),
        ),

        // 2. Facility Name EN — now onChanged
        DataColumnConfig<VolunteerItem>(
          label: 'Facility Name in English',
          cellBuilder: (v, i) {
            return DataCell(
              Tooltip(
                message: 'Facility Name (English): ${v.facilityNameEn}',
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: v.facilityNameEn,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                        ),
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
            );
          },
        ),

        // 3. Facility Name AR — now onChanged
        DataColumnConfig<VolunteerItem>(
          label: 'Facility Name in Arabic',
          cellBuilder: (v, i) {
            return DataCell(
              Tooltip(
                message: 'Facility Name (Arabic): ${v.facilityNameAr}',
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: v.facilityNameAr,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                        ),
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
            );
          },
        ),

        // 4. Shift Allowance (unchanged)
        DataColumnConfig<VolunteerItem>(
          label: 'Shift Allowance',
          fixedWidth: 120,
          cellBuilder: (v, i) {
            return DataCell(
              Tooltip(
                message: 'Select per‐shift allowance (salary amount)',
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
                            child: Text(opt.salary.toString()),
                          );
                        }).toList(),
                        onChanged: widget.isEditable
                            ? (opt) {
                                if (opt != null) {
                                  _updateItem(
                                    i,
                                    v.copyWith(
                                      salaryId: opt.id,
                                      salary: v.salary.copyWithFromOption(opt),
                                    ),
                                  );
                                }
                              }
                            : null,
                      ),
              ),
            );
          },
        ),

        // 5. No. of Volunteers — now onChanged
        DataColumnConfig<VolunteerItem>(
          label: 'No. of Volunteers',
          fixedWidth: 120,
          cellBuilder: (v, i) {
            return DataCell(
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
            );
          },
        ),

        // 6. No. of Shifts — now onChanged
        DataColumnConfig<VolunteerItem>(
          label: 'No. of Shifts',
          fixedWidth: 100,
          cellBuilder: (v, i) {
            return DataCell(
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
            );
          },
        ),

        // 7. Monthly Shifts (unchanged)
        DataColumnConfig<VolunteerItem>(
          label: 'Monthly Shifts',
          fixedWidth: 110,
          cellBuilder: (v, i) {
            final ms = v.numberOfVolunteers * v.numberOfShifts;
            return DataCell(
              Tooltip(
                message: 'Monthly Shifts = No. of Volunteers × No. of Shifts\n'
                    '               = ${v.numberOfVolunteers} × ${v.numberOfShifts}\n'
                    '               = ${_fmt(ms)}',
                child: Text(_fmt(ms)),
              ),
            );
          },
        ),

        // 8. Frequency (unchanged)
        DataColumnConfig<VolunteerItem>(
          label: 'Frequency (Mo.)',
          fixedWidth: 100,
          cellBuilder: (v, i) => DataCell(
            Tooltip(
              message: 'Frequency (No. of months) – cannot be edited',
              child: Text(v.frequencyNumberOfMonths.toString()),
            ),
          ),
        ),

        // 9. Total Volunteers Cost (unchanged)
        DataColumnConfig<VolunteerItem>(
          label: 'Total Volunteers Cost',
          fixedWidth: 140,
          cellBuilder: (v, i) {
            final ms = v.numberOfVolunteers * v.numberOfShifts;
            final total = v.salary.salary * ms * v.frequencyNumberOfMonths;
            return DataCell(
              Tooltip(
                message:
                    'Total Volunteers Cost = Shift Allowance × Monthly Shifts × Frequency\n'
                    '                      = ${_fmt(v.salary.salary)} × ${_fmt(ms)} × ${v.frequencyNumberOfMonths}\n'
                    '                      = ${_fmt(total)}',
                child: Text(_fmt(total)),
              ),
            );
          },
        ),

        // 10. Remarks — now onChanged
        DataColumnConfig<VolunteerItem>(
          label: 'Remarks',
          fixedWidth: 200,
          cellBuilder: (v, i) {
            return DataCell(
              Tooltip(
                message: 'Any additional remarks',
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: v.remarks,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        onChanged: (t) =>
                            _updateItem(i, v.copyWith(remarks: t)),
                      )
                    : Text(v.remarks ?? ''),
              ),
            );
          },
        ),
      ],
    );
  }
}
