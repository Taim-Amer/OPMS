import 'package:get/get.dart';
import 'package:opms/features/activities/models/activities_model.dart';
import 'package:opms/features/auth/models/login_model.dart';
import 'package:opms/features/departments/models/departments_model.dart';
import 'package:opms/features/indicators/models/indicators_model.dart';
import 'package:opms/features/outcomes/models/outcomes_model.dart';
import 'package:opms/features/outputs/models/outputs_model.dart';
import 'package:opms/features/roles/models/roles_model.dart';
import 'package:opms/features/projects/models/all_projects_model.dart';
import 'package:opms/features/users/models/users_model.dart';
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
  Future<DataState<ActivitiesModel>> getActivities(
      {required bool paginate,
      required int pp,
      required int p,
      required String searchQuery}) async {
    return await _apiService.getData(
      queryParameters: {
        "paginate": paginate,
        "per_page": pp,
        "page": p,
        "search": searchQuery,
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
      queryParameters: {'output_id': outputID},
      fromJson: IndicatorsModel.fromJson,
    );
  }

  @override
  Future<DataState<OutcomesModel>> getOutcomes(int? unitID) async {
    return await _apiService.getData(
      endPoint: ApiConstants.outcomes,
      queryParameters: {'unit_id': unitID},
      fromJson: OutcomesModel.fromJson,
    );
  }

  @override
  Future<DataState<OutputsModel>> getOutputs(int? outcomeID) async {
    return await _apiService.getData(
      endPoint: ApiConstants.outputs,
      queryParameters: {'outcome_id': outcomeID},
      fromJson: OutputsModel.fromJson,
    );
  }

  @override
  Future<DataState<RolesModel>> getRoles() async {
    return await _apiService.getData(
        endPoint: ApiConstants.roles, fromJson: RolesModel.fromJson);
  }

  @override
  Future<DataState<ProjectsModel>> getUnits({int? departmentID}) async {
    return await _apiService.getData(
      endPoint: ApiConstants.units,
      // queryParameters: {'department_id': departmentID},
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
      {required int outputID, required String name, required int code}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.activities,
      data: {'output_id': outputID, 'name': name, 'code': code},
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
  Future<DataState<MessageModel>> insertIndicator(
      {required int outputID, required String name}) async {
    return await _apiService.postData(
      endPoint: ApiConstants.indicators,
      data: {'output_id': outputID, 'name': name},
      fromJson: IndicatorsModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> insertOutcome(
      {required int unitID, required String name, required int code}) async {
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
      {required int outcomeID, required String name, required int code}) async {
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
      {required int outputID,
      required int departmentID,
      String? name,
      int? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.activities}/$departmentID',
      data: {
        'output_id': outputID,
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
      {required int outputID, required int departmentID, String? name}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.indicators}/$departmentID',
      data: {
        'output_id': outputID,
        'name': name,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateOutcome(
      {required int unitID,
      required int departmentID,
      String? name,
      int? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.outcomes}/$departmentID',
      data: {
        'unit_id': unitID,
        'name': name,
        'code': code,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  @override
  Future<DataState<MessageModel>> updateOutput(
      {required int outcomeID,
      required int departmentID,
      String? name,
      int? code}) async {
    return await _apiService.putData(
      endPoint: '${ApiConstants.outputs}/$departmentID',
      data: {
        'outcome_id': outcomeID,
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
}
