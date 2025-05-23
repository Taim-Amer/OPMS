import 'package:get/get.dart';
import 'package:opms/features/admin/budget/models/salaries_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class SalariesController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getSalaries();
    super.onInit();
  }


  RequestState getSalariesStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  SalariesModel salariesModel = SalariesModel.skeleton;

  Future<void> getSalaries() async {
    getSalariesStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getSalaries();

    if (response is DataSuccess) {
      getSalariesStatus = RequestState.success;
      update();
      salariesModel = response.data!;
    } else {
      getSalariesStatus = RequestState.error;
      update();
    }
  }
}