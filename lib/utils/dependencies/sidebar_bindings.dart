import 'package:get/get.dart';
import 'package:opms/features/admin/budget/controller/budget_controller.dart';
import 'package:opms/features/admin/budget/controller/equipments_controller.dart';
import 'package:opms/features/admin/budget/controller/field_visit_controller.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/controller/runing_cost_controller.dart';
import 'package:opms/features/admin/budget/controller/salary_controller.dart';
import 'package:opms/features/admin/budget/controller/training_description_controller.dart';
import 'package:opms/features/admin/factors/controllers/factors_controller.dart';
import 'package:opms/features/admin/indicators/controllers/indicators_controller.dart';
import 'package:opms/features/admin/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/features/admin/outputs/controller/outputs_controller.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/features/admin/activities/controller/activities_controller.dart';
import 'package:opms/features/admin/departments/controller/departments_controller.dart';
import 'package:opms/features/admin/projects/controller/projects_controller.dart';
import 'package:opms/features/admin/users/controllers/users_controller.dart';
import 'package:opms/features/coordinator/districts/controller/districts_controller.dart';
import 'package:opms/features/coordinator/governorates/controllers/gorvernorate_controller.dart';
import 'package:opms/features/coordinator/home/controllers/home_controller.dart';
import 'package:opms/features/coordinator/risk_assessments/controllers/risk_controller.dart';

import '../constants/keys.dart';
import '../helpers/cache_helper.dart';

class SidebarBindings extends Bindings{

  @override
  void dependencies() {
    final role = CacheHelper.getData(key: Keys.role) as String? ?? '';

    if(role == 'admin'){
      Get.lazyPut<DepartmentsController>(() => DepartmentsController(), fenix: true);
      Get.lazyPut<RolesController>(() => RolesController(), fenix: true);
      Get.lazyPut<UsersController>(() => UsersController(), fenix: true);
      Get.lazyPut<OutcomesController>(() => OutcomesController(), fenix: true);
      Get.lazyPut<OutputsController>(() => OutputsController(), fenix: true);
      Get.lazyPut<IndicatorsController>(() => IndicatorsController(), fenix: true);
      Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
      Get.lazyPut<ActivitiesController>(() => ActivitiesController(), fenix: true);
      Get.lazyPut<FactorsController>(() => FactorsController(), fenix: true);

      //Budget
      Get.lazyPut<BudgetController>(() => BudgetController(), fenix: true);
      Get.lazyPut<ReliefAssistanceController>(() => ReliefAssistanceController(), fenix: true);
      Get.lazyPut<SalariesController>(() => SalariesController(), fenix: true);
      Get.lazyPut<RunningCostController>(() => RunningCostController(), fenix: true);
      Get.lazyPut<TrainingDescriptionController>(() => TrainingDescriptionController(), fenix: true);
      Get.lazyPut<EquipmentsController>(() => EquipmentsController(), fenix: true);
      Get.lazyPut<FieldVisitController>(() => FieldVisitController(), fenix: true);
    } else if(role == 'risk_coordinator'){
      // Get.put<GovernorateController>(GovernorateController());
      Get.lazyPut<GovernorateController>(() => GovernorateController(), fenix: true);
      Get.lazyPut<DistrictsController>(() => DistrictsController(), fenix: true);
      Get.lazyPut<RiskController>(() => RiskController(), fenix: true);
      Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
      Get.put<FactorsController>(FactorsController());
    }
  }
}