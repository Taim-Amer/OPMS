import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opms/features/planner/plan_implementation/controller/plan_implementation_conrtoller.dart';
import 'package:opms/features/planner/plan_implementation/model/training_cost_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_description_option_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_item_model.dart';
import 'package:opms/features/planner/plan_implementation/model/training_sub_description_option_model.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_column_config.dart';
import 'package:opms/features/planner/plan_implementation/view/widgets/data_entry_table.dart';

class TrainingsTable extends StatefulWidget {
  final List<TrainingItem> trainings;
  final bool isEditable;
  final void Function(int, TrainingItem) onEditTraining;
  final void Function(int, int, TrainingCostItem) onEditCost;
  final List<TrainingDescriptionOptionModel> descriptionOptions;
  final bool descLoading;
  final Map<int, List<TrainingSubDescriptionOptionModel>> subOptions;
  final Map<int, bool> subLoading;
  final PlanImplementationController ctrl;

  const TrainingsTable({
    super.key,
    required this.trainings,
    required this.isEditable,
    required this.onEditTraining,
    required this.onEditCost,
    required this.descriptionOptions,
    required this.descLoading,
    required this.subOptions,
    required this.subLoading,
    required this.ctrl,
  });

  @override
  State<TrainingsTable> createState() => _TrainingsTableState();
}

class _TrainingsTableState extends State<TrainingsTable> {
  @override
  Widget build(BuildContext context) {
    // 1) split by type
    final byType =
        groupBy(widget.trainings, (TrainingItem t) => t.trainingType);
    return Column(
      children: byType.entries.map((e) {
        final type = e.key, list = e.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // numeric fields row:
            Row(children: [
              _buildNumField(
                  'Requested Trainings', list[0].numberOfRequestedTrainings,
                  (v) {
                widget.onEditTraining(widget.trainings.indexOf(list[0]),
                    list[0].copyWith(numberOfRequestedTrainings: v));
              }),
              _buildNumField('Participants', list[0].targetedParticipants, (v) {
                /*…*/
              }),
              _buildNumField('Training Days', list[0].numberOfTrainingDays,
                  (v) {/*…*/}),
            ]),
            const SizedBox(height: 8),
            DataEntryTable<TrainingItem>(
              items: list,
              emptyMessage: 'No trainings',
              columns: [
                // cost table columns here
                DataColumnConfig<TrainingItem>(
                  label: 'Description',
                  cellBuilder: (t, ti) {
                    final idx = widget.trainings.indexOf(t);
                    return DataCell(widget.descLoading
                        ? CircularProgressIndicator()
                        : DropdownButtonFormField<int>(
                            value: t.trainingCosts[ti].subDescriptionId,
                            items: widget.descriptionOptions
                                .map((d) => DropdownMenuItem<int>(
                                      value: d.id,
                                      child: Text(d.name),
                                    ))
                                .toList(),
                            onChanged: widget.isEditable
                                ? (descId) {
                                    if (descId != null) {
                                      // fetch sub-descriptions
                                      //// here pass the ctrl tp make the api request insted of
                                      widget.ctrl.fetchSubDescriptions(descId);
                                      final cost = t.trainingCosts[ti]
                                          .copyWith(subDescriptionId: descId);
                                      widget.onEditCost(idx, ti, cost);
                                    }
                                  }
                                : null,
                          ));
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'Sub Description',
                  cellBuilder: (t, ti) {
                    final descId = t.trainingCosts[ti].subDescriptionId;
                    final loading = widget.subLoading[descId] ?? false;
                    final options = widget.subOptions[descId] ?? [];
                    return DataCell(loading
                        ? CircularProgressIndicator()
                        : DropdownButtonFormField<int>(
                            value: t.trainingCosts[ti].subDescriptionId,
                            items: options
                                .map((sd) => DropdownMenuItem<int>(
                                      value: sd.id,
                                      child: Text(sd.name),
                                    ))
                                .toList(),
                            onChanged: widget.isEditable
                                ? (sdId) {
                                    if (sdId != null) {
                                      final chosen = options
                                          .firstWhere((o) => o.id == sdId);
                                      final cost = t.trainingCosts[ti].copyWith(
                                        subDescriptionId: sdId,
                                        price: chosen.price,
                                        currency: chosen.currency,
                                      );
                                      widget.onEditCost(
                                          widget.trainings.indexOf(t),
                                          ti,
                                          cost);
                                    }
                                  }
                                : null,
                          ));
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'Unit Name',
                  cellBuilder: (t, ti) {
                    return DataCell(Text(t.trainingCosts[ti].unitName));
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'Currency',
                  cellBuilder: (t, ti) {
                    final c = t.trainingCosts[ti];
                    return DataCell(widget.isEditable && c.isPriceByPlanner
                        ? TextFormField(
                            initialValue: c.currency?.toString(),
                            decoration:
                                InputDecoration(hintText: 'Currency ID'),
                            onChanged: (v) {
                              final cost = c.copyWith(currency: v);
                              widget.onEditCost(
                                  widget.trainings.indexOf(t), ti, cost);
                            },
                          )
                        : Text(c.currency?.toString() ?? ''));
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'Price',
                  cellBuilder: (t, ti) {
                    final c = t.trainingCosts[ti];
                    return DataCell(widget.isEditable && c.isPriceByPlanner
                        ? TextFormField(
                            initialValue: c.price?.toString(),
                            decoration: InputDecoration(hintText: 'Price'),
                            onChanged: (v) {
                              final cost = c.copyWith(price: int.tryParse(v));
                              widget.onEditCost(
                                  widget.trainings.indexOf(t), ti, cost);
                            },
                          )
                        : Text(c.price?.toString() ?? ''));
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'No. of Units',
                  cellBuilder: (t, ti) {
                    final c = t.trainingCosts[ti];
                    return DataCell(
                      widget.isEditable
                          ? TextFormField(
                              initialValue: c.numberOfUnits.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (v) {
                                final cost =
                                    c.copyWith(numberOfUnits: int.tryParse(v));
                                widget.onEditCost(
                                    widget.trainings.indexOf(t), ti, cost);
                              },
                            )
                          : Text('${c.numberOfUnits}'),
                    );
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'No. of Days',
                  cellBuilder: (t, ti) {
                    final c = t.trainingCosts[ti];
                    return DataCell(
                      widget.isEditable
                          ? TextFormField(
                              initialValue: c.numberOfDays.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (v) {
                                final cost =
                                    c.copyWith(numberOfDays: int.tryParse(v));
                                widget.onEditCost(
                                    widget.trainings.indexOf(t), ti, cost);
                              },
                            )
                          : Text('${c.numberOfDays}'),
                    );
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'Cost',
                  cellBuilder: (t, ti) {
                    final c = t.trainingCosts[ti];
                    final total =
                        (c.price ?? 0) * c.numberOfUnits * c.numberOfDays;
                    return DataCell(Text(total.toString()));
                  },
                ),

                DataColumnConfig<TrainingItem>(
                  label: 'Remarks',
                  cellBuilder: (t, ti) {
                    final c = t.trainingCosts[ti];
                    return DataCell(
                      widget.isEditable
                          ? TextFormField(
                              initialValue: c.remarks,
                              onChanged: (v) {
                                widget.onEditCost(widget.trainings.indexOf(t),
                                    ti, c.copyWith(remarks: v));
                              },
                            )
                          : Text(c.remarks ?? ''),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildNumField(String label, int value, ValueChanged<int> onChanged) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        widget.isEditable
            ? TextFormField(
                initialValue: value.toString(),
                keyboardType: TextInputType.number,
                onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
              )
            : Text('$value'),
      ],
    ));
  }
}
