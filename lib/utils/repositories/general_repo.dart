import 'package:opms/features/activities/models/activities_model.dart';
import 'package:opms/features/auth/models/login_model.dart';
import 'package:opms/features/departments/models/departments_model.dart';
import 'package:opms/features/indicators/models/indicators_model.dart';
import 'package:opms/features/outcomes/models/outcomes_model.dart';
import 'package:opms/features/outputs/models/outputs_model.dart';
import 'package:opms/features/roles/models/roles_model.dart';
import 'package:opms/features/projects/models/all_projects_model.dart';
import 'package:opms/features/users/models/users_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/models/message_model.dart';

abstract class GeneralRepo {
  //Auth
  Future<DataState<LoginModel>> login({
    required String email,
    required String password,
  });
  Future<DataState<MessageModel>> logout();

  //Users
  Future<DataState<UsersModel>> getUsers(String? registeredBy);
  Future<DataState<MessageModel>> insertUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  });
  Future<DataState<MessageModel>> updateUser({
    required int userID,
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
    required String method,
  });

  //Departments
  Future<DataState<DepartmentsModel>> getDepartments();
  Future<DataState<MessageModel>> insertDepartment({
    required String name,
    required String code,
  });
  Future<DataState<MessageModel>> updateDepartment({
    required int departmentID,
    String? name,
    String? code,
  });

  //Units
  Future<DataState<ProjectsModel>> getUnits({int? departmentID, required bool paginate});
  Future<DataState<MessageModel>> insertUnit({
    required int departmentID,
    required String name,
    required String type,
    required String code,
  });
  Future<DataState<MessageModel>> updateUnit({
    required int unitID,
    required int departmentID,
    String? name,
    String? code
  });

  //Outcomes
  Future<DataState<OutcomesModel>> getOutcomes(int? unitID);
  Future<DataState<MessageModel>> insertOutcome({
    required int unitID,
    required String name,
    required String code,
  });
  Future<DataState<MessageModel>> updateOutcome({
    required int outcomeID,
    // required int departmentID,
    String? name,
    String? code,
  });

  //Outputs
  Future<DataState<OutputsModel>> getOutputs(int? outcomeID);
  Future<DataState<MessageModel>> insertOutput({
    required int outcomeID,
    required String name,
    required String code,
  });
  Future<DataState<MessageModel>> updateOutput({
    // required int outcomeID,
    required int outputID,
    String? name,
    String? code,
  });

  //Indicators
  Future<DataState<IndicatorsModel>> getIndicators(int? outputID);
  Future<DataState<MessageModel>> insertIndicator({
    required int outputID,
    required String name,
  });
  Future<DataState<MessageModel>> updateIndicator({
    // required int outputID,
    required int indicatorID,
    String? name,
  });

  //Activities
  Future<DataState<ActivitiesModel>> getActivities({
    int? outputID,
    bool? isReserved,
    required bool paginate,
    required  int perPage,
    required  int page,
  //     required  String searchQuery
  });
  Future<DataState<MessageModel>> insertActivity({
    required int outputID,
    required String name,
    required String code,
  });
  Future<DataState<MessageModel>> updateActivity({
    // required int outputID,
    required int activityID,
    String? name,
    String? code,
  });

  //Roles
  Future<DataState<RolesModel>> getRoles();
  Future<DataState<MessageModel>> insertRole({required String name});
  Future<DataState<MessageModel>> updateRole({
    required int roleID,
    required String name,
  });
  Future<DataState<MessageModel>> addRoleToUser({
    required int roleID,
    required int userID,
    required List<int> departmentIDs,
    required List<int> unitsIDs,
  });
}
