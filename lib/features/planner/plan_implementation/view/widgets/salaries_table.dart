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
  final void Function(SalaryItem) onAddSalary;
  final void Function(int index) onDeleteRow;
  final Future<List<SalaryOptionModel>> Function(String type)
      fetchSalaryOptions;

  const SalariesTable({
    super.key,
    required this.salaries,
    required this.isEditable,
    required this.onAddSalary,
    required this.onEditSalary,
    required this.facilityTypes,
    required this.onDeleteRow,
    required this.facilityTypesLoading,
    required this.fetchSalaryOptions,
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
    // Only reset if the API has actually returned rows:
    if (widget.salaries.isNotEmpty) {
      _items = List.from(widget.salaries);
    }
    // Otherwise (empty incoming), keep any local _items you've added.
  }

  /// Creates a blank salary row for user input.
  SalaryItem _newRow() {
    return SalaryItem(
      id: 0,
      planImplementationId: 0,
      salaryId: 0,
      frequencyOfMonth: 1,
      numberOfStaff: 0,
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
      facilityType: FacilityType(id: 0, name: ''),
    );
  }

  void _addRow() {
    setState(() => _items.add(_newRow()));
    final newRow = _newRow();
    setState(() => _items.add(newRow));
    // inform controller so model.salaries grows too
    widget.onAddSalary(newRow);
  }

  void _updateItem(int index, SalaryItem updated) {
    setState(() => _items[index] = updated);
    widget.onEditSalary(index, updated);
  }

  Future<void> _confirmDelete(int index, SalaryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Salary Row'),
        content: Text('Are you sure you want to delete row id ${item.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _items.removeAt(index));
      widget.onDeleteRow(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no rows yet and editable: show “Create” button instead of table
    if (_items.isEmpty && widget.isEditable) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.table_rows),
          label: const Text('Create Salaries Table'),
          onPressed: _addRow,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataEntryTable<SalaryItem>(
            items: _items,
            emptyMessage: (_items.isEmpty && !widget.isEditable)
                ? 'No salaries found.'
                : '',
            headingHeight: 44,
            rowHeight: 54,
            maxHeightFactor: 0.6,
            columns: [
              DataColumnConfig<SalaryItem>(
                label: 'Facility Type',
                fixedWidth: 150,
                cellBuilder: (item, i) =>
                    DataCell(_buildFacilityTypeCell(item, i)),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Facility Name in English',
                cellBuilder: (item, i) => DataCell(_buildTextCell(
                  value: item.facilityNameEn,
                  tooltip: 'Facility Name EN: ${item.facilityNameEn}',
                  editable: widget.isEditable,
                  onChanged: (v) =>
                      _updateItem(i, item.copyWith(facilityNameEn: v)),
                )),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Facility Name in Arabic',
                cellBuilder: (item, i) => DataCell(_buildTextCell(
                  value: item.facilityNameAr,
                  tooltip: 'Facility Name AR: ${item.facilityNameAr}',
                  editable: widget.isEditable,
                  onChanged: (v) =>
                      _updateItem(i, item.copyWith(facilityNameAr: v)),
                )),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Position',
                cellBuilder: (item, i) => DataCell(_buildPositionCell(item, i)),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Monthly Salary',
                fixedWidth: 110,
                cellBuilder: (item, i) => DataCell(
                  Tooltip(
                    message:
                        "Monthly salary changes according to the selected position",
                    child: Text(_formatNumber(item.salary.salary)),
                  ),
                ),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'No. of Staff',
                cellBuilder: (item, i) => DataCell(_buildIntCell(
                  value: item.numberOfStaff,
                  tooltip: 'No. of Staff: ${item.numberOfStaff}',
                  editable: widget.isEditable,
                  onChanged: (v) => _updateItem(
                    i,
                    item.copyWith(numberOfStaff: v <= 0 ? 0 : v),
                  ),
                )),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Frequency of Month',
                fixedWidth: 120,
                cellBuilder: (item, i) => DataCell(
                  Tooltip(
                    message: "Frequency of Months cannot be changed",
                    child: Text(item.frequencyOfMonth.toString()),
                  ),
                ),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Cost of Living Allowance',
                fixedWidth: 150,
                cellBuilder: (item, i) => DataCell(
                  Tooltip(
                    message: "Changes according to the selected position",
                    child:
                        Text(_formatNumber(item.salary.costOfLivingAllowance)),
                  ),
                ),
              ),
              DataColumnConfig<SalaryItem>(
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
                        color: Theme.of(context).brightness == Brightness.dark
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
                      child: Text(
                        _formatNumber(total),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Remarks',
                fixedWidth: 200,
                cellBuilder: (item, i) => DataCell(
                  Tooltip(
                    message: 'Remarks: ${item.remarks}',
                    child: widget.isEditable
                        ? TextFormField(
                            initialValue: item.remarks,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                            ),
                            style: const TextStyle(fontSize: 14),
                            onChanged: (v) =>
                                _updateItem(i, item.copyWith(remarks: v)),
                          )
                        : Text(item.remarks),
                  ),
                ),
              ),
              DataColumnConfig<SalaryItem>(
                label: 'Actions',
                fixedWidth: 60,
                cellBuilder: (item, i) => DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    tooltip: 'Delete row id ${item.id}',
                    onPressed: widget.isEditable
                        ? () => _confirmDelete(i, item)
                        : null,
                  ),
                ),
              ),
            ]),
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

  Widget _buildFacilityTypeCell(SalaryItem item, int i) {
    if (widget.facilityTypesLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Tooltip(
      message: "Select facility type",
      child: DropdownButtonFormField<int>(
        value: item.facilityTypeId == 0 ? null : item.facilityTypeId,
        items: widget.facilityTypes
            .map((ft) => DropdownMenuItem(value: ft.id, child: Text(ft.name)))
            .toList(),
        onChanged: widget.isEditable
            ? (id) {
                if (id != null)
                  _updateItem(i, item.copyWith(facilityTypeId: id));
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
              onChanged: onChanged,
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
              onChanged: (v) {
                final n = v.trim().isEmpty ? 0 : int.parse(v);
                onChanged(n);
              },
              style: const TextStyle(fontSize: 14),
            )
          : Text(value.toString()),
    );
  }

  Widget _buildPositionCell(SalaryItem item, int i) {
    return Tooltip(
      message: 'Position: ${item.salary.positions} — select from the list',
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
                    ),
                  );
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
    // mark loading
    if (!mounted) return;
    setState(() => _loading = true);

    // fetch from API
    final opts = await widget.fetchOptions('Employee');

    // bail out if this widget has been removed
    if (!mounted) return;

    setState(() {
      _options = opts;
      _selected =
          _options.firstWhereOrNull((s) => s.id == widget.currentSalary.id) ??
              (_options.isNotEmpty ? _options.first : null);
      _loading = false;
    });
  }

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

    final selected =
        _options.firstWhereOrNull((opt) => opt.id == _selected?.id) ??
            _options.first;

    return DropdownButtonFormField<SalaryOptionModel>(
      value: selected,
      isExpanded: true,
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
                      : Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      selectedItemBuilder: (context) => _options
          .map((opt) => Text(opt.positions, style: theme.textTheme.bodyMedium))
          .toList(),
      onChanged: (opt) {
        if (!mounted) return;
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

  String _formatNumber(num n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
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
