import 'package:opms/features/planner/plan_implementation/model/training_cost_item_model.dart';

class TrainingItem {
  final int id;
  final String trainingName;
  final String trainingType; // e.g. “HQ Level” or “Branch Level”
  int numberOfRequestedTrainings;
  int targetedParticipants;
  int numberOfTrainingDays;
  List<TrainingCostItem> trainingCosts;

  TrainingItem({
    required this.id,
    required this.trainingName,
    required this.trainingType,
    required this.numberOfRequestedTrainings,
    required this.targetedParticipants,
    required this.numberOfTrainingDays,
    required this.trainingCosts,
  });

  factory TrainingItem.fromJson(Map<String, dynamic> j) {
    return TrainingItem(
      id: j['id'] as int,
      trainingName: j['training_name'] as String,
      trainingType: j['training_type'] as String,
      numberOfRequestedTrainings: j['number_of_requested_trainings'] as int,
      targetedParticipants: j['targeted_participants'] as int,
      numberOfTrainingDays: j['number_of_training_days'] as int,
      trainingCosts: (j['training_costs'] as List)
        .map((e) => TrainingCostItem.fromJson(e))
        .toList(),
    );
  }

  Map<String, dynamic> toDraftJson() => {
    'training_name': trainingName,
    'training_type': trainingType,
    'number_of_requested_trainings': numberOfRequestedTrainings,
    'targeted_participants': targetedParticipants,
    'number_of_training_days': numberOfTrainingDays,
    'info': trainingCosts.map((c) => c.toDraftJson()).toList(),
  };

  TrainingItem copyWith({
    int? numberOfRequestedTrainings,
    int? targetedParticipants,
    int? numberOfTrainingDays,
    List<TrainingCostItem>? trainingCosts,
  }) {
    return TrainingItem(
      id: id,
      trainingName: trainingName,
      trainingType: trainingType,
      numberOfRequestedTrainings: numberOfRequestedTrainings ?? this.numberOfRequestedTrainings,
      targetedParticipants: targetedParticipants ?? this.targetedParticipants,
      numberOfTrainingDays: numberOfTrainingDays ?? this.numberOfTrainingDays,
      trainingCosts: trainingCosts ?? this.trainingCosts,
    );
  }
}
