import 'package:opms/features/planner/plan_implementation/model/months_model.dart';



class PlanImplementationMonth {
  final int id;
  final int planImplementationId;
  final int monthId;
  final MonthModel month;
  

  PlanImplementationMonth({
    required this.id,
    required this.planImplementationId,
    required this.monthId,
    required this.month,
  });

  factory PlanImplementationMonth.fromJson(Map<String, dynamic> json) =>
      PlanImplementationMonth(
        id: json['id'],
        planImplementationId: json['plan_implementation_id'],
        monthId: json['month_id'],
        month: MonthModel.fromJson(json['month'] ?? {}),
      );
}
