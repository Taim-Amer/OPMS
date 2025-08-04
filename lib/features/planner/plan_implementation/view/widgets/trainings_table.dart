// lib/features/planner/plan_implementation/view/widgets/trainings_table.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart';
import 'package:opms/features/planner/plan_implementation/model/training_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_cost_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_description_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_sub_description_option_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';

class TrainingsTable extends StatefulWidget {
  final List<TrainingItem> trainings;
  final bool isEditable;
  final void Function(TrainingItem) onAddTraining;
  final void Function(int, TrainingItem) onEditTraining;
  final void Function(int) onDeleteTraining;
  final void Function(int, TrainingCostItem) onAddCost;
  final void Function(int, int, TrainingCostItem) onEditCost;
  final void Function(int, int) onDeleteCost;
  final List<TrainingDescriptionOptionModel> descriptionOptions;
  final bool descLoading;
  final Map<int, List<TrainingSubDescriptionOptionModel>> subOptions;
  final Map<int, bool> subLoading;
  final PlanImplementationController ctrl;

  const TrainingsTable({
    Key? key,
    required this.trainings,
    required this.isEditable,
    required this.onAddTraining,
    required this.onEditTraining,
    required this.onDeleteTraining,
    required this.onAddCost,
    required this.onEditCost,
    required this.onDeleteCost,
    required this.descriptionOptions,
    required this.descLoading,
    required this.subOptions,
    required this.subLoading,
    required this.ctrl,
  }) : super(key: key);

  @override
  State<TrainingsTable> createState() => _TrainingsTableState();
}

class _TrainingsTableState extends State<TrainingsTable> {
  late List<TrainingItem> _items;
  final _types = const ['HQ Level', 'Branch Level'];

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.trainings);

    // after the first frame, prefetch sub-lists for any existing cost rows
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var training in _items) {
        for (var cost in training.trainingCosts) {
          if (cost.descriptionId != 0 &&
              !widget.subOptions.containsKey(cost.descriptionId)) {
            widget.ctrl.fetchTrainingSubDescriptions(cost.descriptionId);
          }
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant TrainingsTable old) {
    super.didUpdateWidget(old);
    if (widget.trainings != old.trainings) {
      _items = List.from(widget.trainings);

      // schedule the same fetch after this update’s build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var training in _items) {
          for (var cost in training.trainingCosts) {
            if (cost.descriptionId != 0 &&
                !widget.subOptions.containsKey(cost.descriptionId)) {
              widget.ctrl.fetchTrainingSubDescriptions(cost.descriptionId);
            }
          }
        }
      });
    }
  }

  TrainingItem _blankTraining() {
    return TrainingItem(
      id: 0,
      trainingName: '',
      trainingType: _types.first,
      numberOfRequestedTrainings: 0,
      targetedParticipants: 0,
      numberOfTrainingDays: 0,
      trainingCosts: [],
    );
  }

  void _addTraining() {
    final t = _blankTraining();
    setState(() => _items.add(t));
    widget.onAddTraining(t);
  }

  void _updateTraining(int idx, TrainingItem t) {
    setState(() => _items[idx] = t);
    widget.onEditTraining(idx, t);
  }

  Widget _numField(
    String label,
    int value,
    ValueChanged<int> onChanged,
    bool isEditable,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormField(
            initialValue: '$value',
            keyboardType: TextInputType.number,
            enabled: isEditable,
            readOnly: !isEditable,
            onChanged:
                isEditable ? (v) => onChanged(int.tryParse(v) ?? 0) : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add New Training'),
          onPressed: widget.isEditable ? _addTraining : null,
        ),
      );
    }

    final addBtn = widget.isEditable
        ? Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Training'),
              onPressed: _addTraining,
            ),
          )
        : const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addBtn,
        ..._items.asMap().entries.map((entry) {
          final idx = entry.key;
          final t = entry.value;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Type + delete
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: t.trainingType,
                          decoration: const InputDecoration(labelText: 'Type'),
                          items: _types
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: widget.isEditable
                              ? (v) => _updateTraining(
                                  idx, t.copyWith(trainingType: v!))
                              : null,
                        ),
                      ),
                      if (widget.isEditable)
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => widget.onDeleteTraining(idx),
                        ),
                    ],
                  ),

                  SizedBox(height: 15.h),

                  // Name
                  TextFormField(
                    initialValue: t.trainingName,
                    decoration: InputDecoration(
                      labelText: 'Training Name',
                      border: widget.isEditable
                          ? const OutlineInputBorder()
                          : InputBorder.none,
                      // maybe greyed‐out label if read‐only:
                      labelStyle: widget.isEditable
                          ? null
                          : TextStyle(color: Colors.grey.shade600),
                    ),
                    enabled: widget.isEditable,
                    readOnly: !widget.isEditable,
                    onChanged: widget.isEditable
                        ? (v) =>
                            _updateTraining(idx, t.copyWith(trainingName: v))
                        : null,
                  ),

                  const SizedBox(height: 12),

                  // Numeric row
                  Row(
                    children: [
                      _numField(
                          'Requested Trainings',
                          t.numberOfRequestedTrainings,
                          (v) => _updateTraining(
                              idx, t.copyWith(numberOfRequestedTrainings: v)),
                          widget.isEditable),
                      SizedBox(
                        width: 30.w,
                      ),
                      _numField(
                          'Participants',
                          t.targetedParticipants,
                          (v) => _updateTraining(
                              idx, t.copyWith(targetedParticipants: v)),
                          widget.isEditable),
                      SizedBox(
                        width: 30.w,
                      ),
                      _numField(
                          'Training Days',
                          t.numberOfTrainingDays,
                          (v) => _updateTraining(
                              idx, t.copyWith(numberOfTrainingDays: v)),
                          widget.isEditable),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (widget.isEditable)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text('Create Cost Row'),
                        onPressed: () {
                          final blank = TrainingCostItem(
                            id: 0,
                            trainingId: t.id,
                            descriptionId: 0,
                            subDescriptionId: 0,
                            descriptionName: '',
                            subDescriptionName: '',
                            unitName: '',
                            isPriceByPlanner: false,
                            currency: '',
                            price: null,
                            numberOfUnits: 0,
                            numberOfDays: 0,
                            remarks: null,
                          );
                          widget.onAddCost(idx, blank);
                        },
                      ),
                    ),

                  DataEntryTable<TrainingCostItem>(
                    items: t.trainingCosts,
                    emptyMessage:
                        t.trainingCosts.isEmpty ? 'No cost rows yet.' : '',
                    columns: [
                      // ── Description ──
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Description',
                        cellBuilder: (c, ci) {
                          final opts = widget.descriptionOptions;
                          return DataCell(
                            widget.descLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : DropdownButtonFormField<int>(
                                    value: c.descriptionId == 0
                                        ? null
                                        : c.descriptionId,
                                    hint: const Text('Select'),
                                    isExpanded: true,
                                    items: opts
                                        .map((d) => DropdownMenuItem<int>(
                                              value: d.id,
                                              child: Text(d.name),
                                            ))
                                        .toList(),
                                    onChanged: widget.isEditable
                                        ? (dId) async {
                                            if (dId == null) return;
                                            final sel = opts
                                                .firstWhere((d) => d.id == dId);
                                            final cleared = c.copyWith(
                                              descriptionId: dId,
                                              descriptionName: sel.name,
                                              subDescriptionId: 0,
                                              subDescriptionName: '',
                                              unitName: '',
                                              currency: '',
                                              price: null,
                                            );
                                            widget.onEditCost(idx, ci, cleared);
                                            // ensure sub-options for this new selection
                                            await widget.ctrl
                                                .fetchTrainingSubDescriptions(
                                                    dId);
                                          }
                                        : null,
                                  ),
                          );
                        },
                      ),

                      // ── Sub-description ──
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Sub Description',
                        cellBuilder: (c, ci) {
                          final descId = c.descriptionId;
                          // if we haven't fetched this description's subs yet, trigger it
                          if (descId != 0 &&
                              !widget.subOptions.containsKey(descId) &&
                              !(widget.subLoading[descId] ?? false)) {
                            widget.ctrl.fetchTrainingSubDescriptions(descId);
                          }

                          final opts = widget.subOptions[descId] ?? [];
                          final loading = widget.subLoading[descId] ?? false;
                          final current = opts.firstWhereOrNull(
                              (o) => o.id == c.subDescriptionId);

                          return DataCell(
                            loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : DropdownButtonFormField<int>(
                                    value: current?.id,
                                    hint: const Text('Select'),
                                    isExpanded: true,
                                    items: opts
                                        .map((o) => DropdownMenuItem<int>(
                                              value: o.id,
                                              child: Text(o.name),
                                            ))
                                        .toList(),
                                    onChanged: widget.isEditable
                                        ? (sdId) {
                                            if (sdId == null) return;
                                            final chosen = opts.firstWhere(
                                                (o) => o.id == sdId);
                                            final updated = c.copyWith(
                                              subDescriptionId: sdId,
                                              subDescriptionName: chosen.name,
                                              unitName: chosen.unitName,
                                              isPriceByPlanner:
                                                  chosen.isPriceByPlanner,
                                              currency: chosen.currency,
                                              price: chosen.price,
                                            );
                                            widget.onEditCost(idx, ci, updated);
                                          }
                                        : null,
                                  ),
                          );
                        },
                      ),

                      // ── Unit Name ──
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Unit Name',
                        cellBuilder: (c, ci) => DataCell(Text(c.unitName)),
                      ),

                      // ── Currency ──
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Currency',
                        cellBuilder: (c, ci) => DataCell(
                          widget.isEditable && c.isPriceByPlanner
                              ? TextFormField(
                                  initialValue: c.currency,
                                  decoration: const InputDecoration(
                                      hintText: 'Currency'),
                                  onChanged: (v) {
                                    final upd = c.copyWith(currency: v);
                                    widget.onEditCost(idx, ci, upd);
                                  },
                                )
                              : Tooltip(
                                  message:
                                      "this cell can not be edited by your role",
                                  child: Text(c.currency!)),
                        ),
                      ),

                      // ── Price ──
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Price',
                        cellBuilder: (c, ci) => DataCell(
                          widget.isEditable && c.isPriceByPlanner
                              ? TextFormField(
                                  initialValue: c.price?.toString() ?? '',
                                  decoration:
                                      const InputDecoration(hintText: 'Price'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) {
                                    final upd =
                                        c.copyWith(price: int.tryParse(v));
                                    widget.onEditCost(idx, ci, upd);
                                  },
                                )
                              : Tooltip(
                                  message:
                                      "this cell can not be edited by your role",
                                  child: Text(c.price?.toString() ?? '')),
                        ),
                      ),
                      // No. of Units
                      DataColumnConfig<TrainingCostItem>(
                        label: 'No. of Units',
                        cellBuilder: (c, ci) => DataCell(
                          widget.isEditable
                              ? TextFormField(
                                  initialValue: c.numberOfUnits.toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) {
                                    final upd = c.copyWith(
                                        numberOfUnits: int.tryParse(v) ?? 0);
                                    widget.onEditCost(idx, ci, upd);
                                  },
                                )
                              : Text(c.numberOfUnits.toString()),
                        ),
                      ),

                      // No. of Days
                      DataColumnConfig<TrainingCostItem>(
                        label: 'No. of Days',
                        cellBuilder: (c, ci) => DataCell(
                          widget.isEditable
                              ? TextFormField(
                                  initialValue: c.numberOfDays.toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) {
                                    final upd = c.copyWith(
                                        numberOfDays: int.tryParse(v) ?? 0);
                                    widget.onEditCost(idx, ci, upd);
                                  },
                                )
                              : Text(c.numberOfDays.toString()),
                        ),
                      ),

                      // Total
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Total',
                        cellBuilder: (c, ci) {
                          final total =
                              (c.price ?? 0) * c.numberOfUnits * c.numberOfDays;
                          return DataCell(Tooltip(
                              message:
                                  "total = price  * numberOfUnits * numberOfDays ${c.price} * ${c.numberOfUnits} * ${c.numberOfDays} ",
                              child: Text(total.toString())));
                        },
                      ),

                      // Remarks
                      DataColumnConfig<TrainingCostItem>(
                        label: 'Remarks',
                        cellBuilder: (c, ci) => DataCell(
                          widget.isEditable
                              ? TextFormField(
                                  initialValue: c.remarks ?? '',
                                  onChanged: (v) {
                                    final upd = c.copyWith(remarks: v);
                                    widget.onEditCost(idx, ci, upd);
                                  },
                                )
                              : Text(c.remarks ?? ''),
                        ),
                      ),

                      // Delete cost row
                      if (widget.isEditable)
                        DataColumnConfig<TrainingCostItem>(
                          label: 'Actions',
                          fixedWidth: 64,
                          cellBuilder: (_, ci) => DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.redAccent,
                              onPressed: () => widget.onDeleteCost(idx, ci),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
