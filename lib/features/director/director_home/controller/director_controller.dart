import 'package:get/get.dart';
import 'package:opms/features/manger/manager_home/model/manager_active_activities_model.dart';
import 'package:opms/utils/api/api_service.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/api_constants.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/models/message_model.dart';
import 'package:opms/utils/router/app_routes.dart';

class DirectorController extends GetxController {
  static DirectorController get instance => Get.find();
  final ApiService _api = Get.find();

  /// 0 = Active, 1 = Archived
  final selectedIndex = 0.obs;

  /// Active & Archived activities
  final activities = <MaActiveActivity>[].obs;
  final archivedActivities = <MaActiveActivity>[].obs;

  /// Manager users
  // final users = <ManagerUser>[].obs;

  /// Loading states
  final loadState = RequestState.begin.obs;
  final archivedLoadState = RequestState.begin.obs;
  // final usersLoadState = RequestState.begin.obs;

  /// Logout state
  final logoutState = RequestState.begin.obs;

  /// Fetch active activities
  Future<void> fetchReserved() => _fetchReserved();

  /// Fetch archived activities
  Future<void> fetchArchived() => _fetchArchived();

  /// Fetch manager users
  // Future<void> fetchUsers() async {
  //   usersLoadState.value = RequestState.loading;
  //   final resp = await _api.getData<List<ManagerUser>>(
  //     endPoint: ApiConstants.users,
  //     fromJson: (json) {
  //       final raw = (json['data'] as List<dynamic>?) ?? [];
  //       return raw
  //           .cast<Map<String, dynamic>>()
  //           .map((m) => ManagerUser.fromJson(m))
  //           .toList();
  //     },
  //   );

  //   if (resp is DataSuccess<List<ManagerUser>>) {
  //     users.assignAll(resp.data!);
  //     usersLoadState.value = RequestState.success;
  //   } else {
  //     usersLoadState.value = RequestState.error;
  //   }
  // }

  Future<void> _fetchReserved() async {
    loadState.value = RequestState.loading;
    final resp = await _api.getData<ManagerActiveActivitiesModel>(
      endPoint: ApiConstants.activities,
      queryParameters: {'is_reserved': 1},
      fromJson: (json) => ManagerActiveActivitiesModel.fromJson(json),
    );
    if (resp is DataSuccess<ManagerActiveActivitiesModel>) {
      activities.assignAll(resp.data!.data);
      loadState.value = RequestState.success;
    } else {
      loadState.value = RequestState.error;
    }
  }

  Future<void> _fetchArchived() async {
    archivedLoadState.value = RequestState.loading;
    final resp = await _api.getData<ManagerActiveActivitiesModel>(
      endPoint: ApiConstants.activities,
      queryParameters: {'is_archive': 1},
      fromJson: (json) => ManagerActiveActivitiesModel.fromJson(json),
    );
    if (resp is DataSuccess<ManagerActiveActivitiesModel>) {
      archivedActivities.assignAll(resp.data!.data);
      archivedLoadState.value = RequestState.success;
    } else {
      archivedLoadState.value = RequestState.error;
    }
  }

  Future<void> logout() async {
    logoutState.value = RequestState.loading;
    update();

    try {
      await _api.getData<MessageModel>(
        endPoint: ApiConstants.logout,
        fromJson: MessageModel.fromJson,
      );
    } catch (_) {
      // ignore
    } finally {
      CacheHelper.removeData(key: Keys.token);
      CacheHelper.removeData(key: Keys.roleName);
      logoutState.value = RequestState.begin;
      update();
      AppRoutesNew.router.go(AppRoutesNew.pathLogin);
    }
  }
}
