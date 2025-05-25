import 'package:get/get.dart';
import 'package:opms/features/admin/budget/models/field_visit_model.dart';
import 'package:opms/features/admin/budget/models/salaries_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class FieldVisitController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getFieldVisit();
    super.onInit();
  }


  RequestState getFieldVisitStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  FieldVisitModel fieldVisitModel = FieldVisitModel.skeleton;

  Future<void> getFieldVisit() async {
    getFieldVisitStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getFieldVisit();

    if (response is DataSuccess) {
      getFieldVisitStatus = RequestState.success;
      update();
      fieldVisitModel = response.data!;
    } else {
      getFieldVisitStatus = RequestState.error;
      update();
    }
  }
}