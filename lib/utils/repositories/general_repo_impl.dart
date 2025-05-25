import 'package:get/get.dart';
import 'package:opms/features/admin/activities/models/activities_model.dart';
import 'package:opms/features/admin/auth/models/login_model.dart';
import 'package:opms/features/admin/budget/models/equipments_model.dart';
import 'package:opms/features/admin/budget/models/field_visit_model.dart';
import 'package:opms/features/admin/budget/models/relief_assistance_model.dart';
import 'package:opms/features/admin/budget/models/running_cost_model.dart';
import 'package:opms/features/admin/budget/models/salaries_model.dart';
import 'package:opms/features/admin/budget/models/training_description_model.dart';
import 'package:opms/features/admin/departments/models/departments_model.dart';
import 'package:opms/features/admin/indicators/models/indicators_model.dart';
import 'package:opms/features/admin/outcomes/models/outcomes_model.dart';
import 'package:opms/features/admin/outputs/models/outputs_model.dart';
import 'package:opms/features/admin/projects/models/all_projects_model.dart';
import 'package:opms/features/admin/roles/models/roles_model.dart';
import 'package:opms/features/admin/users/models/users_model.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:opms/utils/models/message_model.dart';
import 'package:opms/utils/repositories/general_repo.dart';

class GeneralRepoImpl implements GeneralRepo {
  final _apiService = Get.find<ApiService>();

  @override
  Future<DataState<MessageModel>> addRoleToUser(
      {required int roleID,
      required int userID,
      required List<int> departmentIDs,
      required List<int> unitsIDs}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.userRole,
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<ActivitiesModel>> getActivities({
    required bool paginate,
    required int perPage,
    required int page,
    int? outputID,
    bool? isReserved,
  }) async {
    return await _apiService.getData(
      queryParameters: {
        "paginate": paginate,
        "per_page": perPage,
        "page": page,
        if (outputID != null) 'output_id': outputID,
        if (isReserved != null) 'is_reserved': isReserved
        // "search": searchQuery,
      },
      endPoint: ApiConstants.activities,
      fromJson: ActivitiesModel.fromJson,
    );
  }

  @override
  Future<DataState<DepartmentsModel>> getDepartments() async {
    return await _apiService.getData(
      endPoint: ApiConstants.departments,
      fromJson: DepartmentsModel.fromJson,
    );
  }

  @override
  Future<DataState<IndicatorsModel>> getIndicators(int? outputID) async {
    return await _apiService.getData(
      endPoint: ApiConstants.indicators,
      queryParameters: {if (outputID != null) 'output_id': outputID},
      fromJson: IndicatorsModel.fromJson,
    );
  }

  @override
  Future<DataState<OutcomesModel>> getOutcomes(int? unitID) async {
    return await _apiService.getData(
      endPoint: ApiConstants.outcomes,
      queryParameters: {if (unitID != null) 'unit_id': unitID},
      fromJson: OutcomesModel.fromJson,
    );
  }

  @override
  Future<DataState<OutputsModel>> getOutputs(int? outcomeID) async {
    return await _apiService.getData(
      endPoint: ApiConstants.outputs,
      queryParameters: {if (outcomeID != null) 'outcome_id': outcomeID},
      fromJson: OutputsModel.fromJson,
    );
  }

  @override
  Future<DataState<RolesModel>> getRoles() async {
    return await _apiService.getData(
        endPoint: ApiConstants.roles, fromJson: RolesModel.fromJson);
  }

  @override
  Future<DataState<ProjectsModel>> getUnits(
      {int? departmentID,
      int page = 1,
      int perPage = 10,
      String? search,
      required bool paginate}) async {
    return await _apiService.getData(
      endPoint: ApiConstants.units,
      queryParameters: {
        'paginate': paginate,
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (departmentID != null) 'department_id': departmentID,
      },
      fromJson: ProjectsModel.fromJson,
    );
  }

  @override
  Future<DataState<UsersModel>> getUsers(String? registeredBy) async {
    return await _apiService.getData(
      endPoint: ApiConstants.users,
      queryParameters: {'with': registeredBy},
      fromJson: UsersModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertActivity(
      {required int outputID,
      required String name,
      required String code}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.activities,
      data: {'output_id': outputID, 'name': name, 'code': code},
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertIndicator(
      {required int outputID, required String name}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.indicators,
      data: {'output_id': outputID, 'name': name},
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertOutcome(
      {required int unitID, required String name, required String code}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.outcomes,
      data: {
        'unit_id': unitID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertOutput(
      {required int outcomeID,
      required String name,
      required String code}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.outputs,
      data: {
        'outcome_id': outcomeID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertRole({required String name}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.roles,
      data: {'name': name},
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertUnit(
      {required int departmentID,
      required String name,
      required String type,
      required String code}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.units,
      data: {
        'department_id': departmentID,
        'name': name,
        'type': 'project',
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertUser(
      {required String name,
      required String email,
      required String password,
      required String passwordConfirm}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.users,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<LoginModel>> login(
      {required String email, required String password}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
      fromJson: LoginModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> logout() async {
    return await _apiService.getData(
      endPoint: ApiConstants.logout,
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateActivity(
      {required int activityID, String? name, String? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.activities}/$activityID',
      data: {
        // 'output_id' : outputID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateDepartment(
      {required int departmentID, String? name, String? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.departments}/$departmentID',
      data: {
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateIndicator(
      {required int indicatorID, String? name}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.indicators}/$indicatorID',
      data: {
        // 'output_id' : outputID,
        'name': name,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateOutcome(
      {required int outcomeID, String? name, String? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.outcomes}/$outcomeID',
      data: {
        // 'unit_id' : unitID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateOutput(
      {required int outputID, String? name, String? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.outputs}/$outputID',
      data: {
        // 'outcome_id' : outcomeID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateRole(
      {required int roleID, required String name}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.roles}/$roleID',
      data: {
        'name': name,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateUnit(
      {required int unitID,
      required int departmentID,
      String? name,
      String? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.units}/$unitID',
      data: {
        'department_id': departmentID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateUser(
      {required int userID,
      required String name,
      required String email,
      required String password,
      required String passwordConfirm,
      required String method}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.departments}/$userID',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertDepartment(
      {required String name, required String code}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.departments,
      data: {
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<ReliefAssistanceModel>> getReliefAssistance() async {
    return await _apiService.getData(
      endPoint: ApiConstants.reliefAssistance,
      fromJson: ReliefAssistanceModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateReliefAssistance({
    required int id,
    required String type,
    required String description,
    required String unitCost,
    required String date,
  }) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.reliefAssistance}/$id',
      data: {
        'type': type,
        'description': description,
        'unit_cost': unitCost,
        'date': date
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertReliefAssistance({
    required String type,
    required String description,
    required String unitCost,
    required String date,
  }) async {
    return await _apiService.postData(
      endPoint: ApiConstants.reliefAssistance,
      data: {
        'type': type,
        'description': description,
        'unit_cost': unitCost,
        'date': date
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<SalariesModel>> getSalaries() async {
    return await _apiService.getData(
      endPoint: ApiConstants.salaries,
      fromJson: SalariesModel.fromJson,
    );
  }

  @override
  Future<DataState<RunningCostModel>> getRunningCost() async{
    return await _apiService.getData(
      endPoint: ApiConstants.runningCost,
      fromJson: RunningCostModel.fromJson,
    );
  }

  @override
  Future<DataState<TrainingDescriptionModel>> getTrainingDescription() async{
    return await _apiService.getData(
      endPoint: ApiConstants.trainingDescriptions,
      fromJson: TrainingDescriptionModel.fromJson,
    );
  }

  @override
  Future<DataState<EquipmentsModel>> getEquipments() async{
    return await _apiService.getData(
      endPoint: ApiConstants.equipments,
      fromJson: EquipmentsModel.fromJson,
    );
  }

  @override
  Future<DataState<FieldVisitModel>> getFieldVisit() async{
    return await _apiService.getData(
      endPoint: ApiConstants.fieldVisits,
      fromJson: FieldVisitModel.fromJson,
    );
  }
}
