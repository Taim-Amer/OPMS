import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:opms/features/planner/plan_implementation/model/facility_type_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_model.dart';
import 'package:opms/features/planner/plan_implementation/model/salary_options_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';
import 'package:opms/utils/helpers/helper_functions.dart';

class SalariesTable extends StatefulWidget {
  final List<SalaryItem> salaries;
  final bool isEditable;
  final void Function(int, SalaryItem) onEditSalary;
  final List<FacilityTypeModel> facilityTypes;
  final bool facilityTypesLoading;
  final Future<List<SalaryOptionModel>> Function(String type)
      fetchSalaryOptions;

  const SalariesTable({
    required this.salaries,
    required this.isEditable,
    required this.onEditSalary,
    required this.facilityTypes,
    required this.facilityTypesLoading,
    required this.fetchSalaryOptions,
    super.key,
  });

  @override
  State<SalariesTable> createState() => _SalariesTableState();
}

class _SalariesTableState extends State<SalariesTable> {
  late List<SalaryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.salaries);
  }

  @override
  void didUpdateWidget(covariant SalariesTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _items = List.from(widget.salaries);
  }

  @override
  Widget build(BuildContext context) {
    return DataEntryTable<SalaryItem>(
      items: _items,
      emptyMessage: 'No salaries found.',
      headingHeight: 44,
      rowHeight: 54,
      maxHeightFactor: 0.6,
      columns: [
        // Facility Type → inline dropdown
        DataColumnConfig(
            label: 'Facility Type',
            fixedWidth: 150,
            cellBuilder: (item, i) {
              return DataCell(_buildFacilityTypeCell(item, i));
            }),
        // Facility Name EN
        DataColumnConfig(
            label: 'Facility Name in English',
            cellBuilder: (item, i) {
              return DataCell(_buildTextCell(
                value: item.facilityNameEn,
                tooltip: 'Facility Name EN: ${item.facilityNameEn}',
                editable: widget.isEditable,
                onChanged: (val) =>
                    _updateItem(i, item.copyWith(facilityNameEn: val)),
              ));
            }),
        // Facility Name AR
        DataColumnConfig(
            label: 'Facility Name in Arabic',
            cellBuilder: (item, i) {
              return DataCell(_buildTextCell(
                value: item.facilityNameAr,
                tooltip: 'Facility Name AR: ${item.facilityNameAr}',
                editable: widget.isEditable,
                onChanged: (val) =>
                    _updateItem(i, item.copyWith(facilityNameAr: val)),
              ));
            }),
        // Position → dropdown from API
        DataColumnConfig(
            label: 'Position',
            cellBuilder: (item, i) {
              return DataCell(_buildPositionCell(item, i));
            }),
        // Monthly Salary (readonly)
        DataColumnConfig(
            label: 'Monthly Salary',
            fixedWidth: 110,
            cellBuilder: (item, i) {
              return DataCell(Tooltip(
                  message:
                      "Monthly salary changes according to the selected position",
                  child: Text(_formatNumber(item.salary.salary))));
            }),
        // No. of Staff (editable int)
        DataColumnConfig(
            label: 'No. of Staff',
            cellBuilder: (item, i) {
              return DataCell(_buildIntCell(
                value: item.numberOfStaff,
                tooltip: 'No. of Staff: ${item.numberOfStaff}',
                editable: widget.isEditable,
                onChanged: (v) => _updateItem(
                    i,
                    item.copyWith(
                      numberOfStaff: v <= 0 ? 0 : v,
                    )),
              ));
            }),
        // Frequency (readonly)
        DataColumnConfig(
            label: 'Frequency of Month',
            fixedWidth: 120,
            cellBuilder: (item, i) {
              return DataCell(Tooltip(
                  message: "Frequency of Months can not change it ",
                  child: Text(item.frequencyOfMonth.toString())));
            }),
        // COLA (readonly)
        DataColumnConfig(
            label: 'Cost of Living Allowance',
            fixedWidth: 150,
            cellBuilder: (item, i) {
              return DataCell(Tooltip(
                  message: "changes according to the selected position",
                  child:
                      Text(_formatNumber(item.salary.costOfLivingAllowance))));
            }),
        // Total = (salary+cola)*freq*staff
        DataColumnConfig(
            label: 'Total',
            fixedWidth: 110,
            cellBuilder: (item, i) {
              final s = item.salary.salary;
              final c = item.salary.costOfLivingAllowance;
              final f = item.frequencyOfMonth;
              final st = item.numberOfStaff;
              final total = (s + c) * f * st;
              return DataCell(
                Tooltip(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HelperFunctions.isDarkMode(context)
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textStyle: Theme.of(context).tooltipTheme.textStyle,
                  message: [
                    'Total = (Monthly Salary + COLA) × Frequency × Staff',
                    '      = (${_formatNumber(s)} + ${_formatNumber(c)}) × $f × $st',
                    '      = ${_formatNumber(total)}',
                  ].join('\n'),
                  child: Text(_formatNumber(total),
                      overflow: TextOverflow.ellipsis),
                ),
              );
            }),
        DataColumnConfig<SalaryItem>(
          label: 'Remarks',
          fixedWidth: 200,
          cellBuilder: (item, i) {
            return DataCell(
              Tooltip(
                message: 'Remarks: ${item.remarks}',
                child: widget.isEditable
                    ? TextFormField(
                        initialValue: item.remarks,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        ),
                        style: const TextStyle(fontSize: 14),
                        // <— CHANGE HERE: use onChanged instead of onFieldSubmitted
                        onChanged: (val) {
                          _updateItem(i, item.copyWith(remarks: val));
                        },
                      )
                    : Text(item.remarks),
              ),
            );
          },
        ),
      ],
    );
  }

  // Helpers to rebuild specific cells:

  void _updateItem(int index, SalaryItem newItem) {
    setState(() {
      _items[index] = newItem;
    });
    widget.onEditSalary(index, newItem);
  }

  Widget _buildFacilityTypeCell(SalaryItem item, int i) {
    if (widget.facilityTypesLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Tooltip(
      message: "select the facilty type from the list",
      child: DropdownButtonFormField<int>(
        value: item.facilityTypeId,
        items: widget.facilityTypes.map((ft) {
          return DropdownMenuItem(value: ft.id, child: Text(ft.name));
        }).toList(),
        onChanged: widget.isEditable
            ? (id) {
                if (id != null) {
                  _updateItem(i, item.copyWith(facilityTypeId: id));
                }
              }
            : null,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide:
                BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        ),
        dropdownColor: Theme.of(context).cardColor,
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Widget _buildTextCell({
    required String value,
    required String tooltip,
    required bool editable,
    required void Function(String) onChanged,
  }) {
    return Tooltip(
      message: tooltip,
      child: editable
          ? TextFormField(
              initialValue: value,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              ),
              onFieldSubmitted: onChanged,
              style: const TextStyle(fontSize: 14),
            )
          : Text(value),
    );
  }

  Widget _buildIntCell({
    required int value,
    required String tooltip,
    required bool editable,
    required void Function(int) onChanged,
  }) {
    return Tooltip(
      message: tooltip,
      child: editable
          ? TextFormField(
              initialValue: value.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              ),
              onChanged: (val) {
                final n =
                    val.trim().isEmpty ? 0 : (int.tryParse(val.trim()) ?? 0);
                onChanged(n);
              },
              style: const TextStyle(fontSize: 14),
            )
          : Text(value.toString()),
    );
  }

  Widget _buildPositionCell(SalaryItem item, int i) {
    return Tooltip(
      message:
          'Position: ${item.salary.positions} ,  select the position from the list',
      child: widget.isEditable
          ? _EditablePositionCell(
              currentSalary: item.salary,
              fetchOptions: widget.fetchSalaryOptions,
              onChanged: (opt) {
                if (opt != null) {
                  _updateItem(
                      i,
                      item.copyWith(
                        salaryId: opt.id,
                        salary: item.salary.copyWithFromOption(opt),
                      ));
                }
              },
            )
          : Text(item.salary.positions),
    );
  }

  String _formatNumber(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}

class _EditablePositionCell extends StatefulWidget {
  final Salary currentSalary;
  final Future<List<SalaryOptionModel>> Function(String type) fetchOptions;
  final void Function(SalaryOptionModel?) onChanged;

  const _EditablePositionCell({
    required this.currentSalary,
    required this.fetchOptions,
    required this.onChanged,
  });

  @override
  State<_EditablePositionCell> createState() => _EditablePositionCellState();
}

class _EditablePositionCellState extends State<_EditablePositionCell> {
  List<SalaryOptionModel> _options = [];
  bool _loading = false;
  SalaryOptionModel? _selected;

  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }

  Future<void> _fetchOptions() async {
    setState(() => _loading = true);
    final opts = await widget.fetchOptions('Employee');
    setState(() {
      _options = opts;
      _selected =
          _options.firstWhereOrNull((s) => s.id == widget.currentSalary.id) ??
              (_options.isNotEmpty ? _options.first : null);
      _loading = false;
    });
  }

  String _formatNumber(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (_options.isEmpty) {
      return const Text('-', style: TextStyle(color: Colors.grey));
    }

    // ensure _selected remains valid
    final selected =
        _options.firstWhereOrNull((opt) => opt.id == _selected?.id) ??
            _options.first;

    return DropdownButtonFormField<SalaryOptionModel>(
      value: selected,
      isExpanded: true,
      // menu items: show two lines (position + salary/CO​LA)
      items: _options.map((opt) {
        return DropdownMenuItem<SalaryOptionModel>(
          value: opt,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(opt.positions, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                '${_formatNumber(opt.salary)} salary • ${_formatNumber(opt.costOfLivingAllowance)} COLA',
                style: TextStyle(
                    color: HelperFunctions.isDarkMode(context)
                        ? Colors.white
                        : Colors.black),
              ),
            ],
          ),
        );
      }).toList(),

      // selected view: only show the position text
      selectedItemBuilder: (context) {
        return _options.map((opt) {
          return Text(opt.positions, style: theme.textTheme.bodyMedium);
        }).toList();
      },

      onChanged: (opt) {
        setState(() => _selected = opt);
        widget.onChanged(opt);
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: theme.dividerColor, width: 1),
        ),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
      ),
      dropdownColor: theme.cardColor,
      icon: const Icon(Icons.arrow_drop_down),
      style: theme.textTheme.bodyMedium,
    );
  }
}

extension SalaryCopyFromOption on Salary {
  Salary copyWithFromOption(SalaryOptionModel opt) {
    return Salary(
      id: opt.id,
      type: opt.type,
      positions: opt.positions,
      salary: opt.salary,
      costOfLivingAllowance: opt.costOfLivingAllowance,
      date: opt.date,
    );
  }
}
