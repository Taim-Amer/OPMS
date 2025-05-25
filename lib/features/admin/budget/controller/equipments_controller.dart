import 'package:get/get.dart';
import 'package:opms/features/admin/budget/models/equipments_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class EquipmentsController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getEquipments();
    super.onInit();
  }


  RequestState getEquipmentsStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  EquipmentsModel equipmentsModel = EquipmentsModel.skeleton;

  Future<void> getEquipments() async {
    getEquipmentsStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getEquipments();

    if (response is DataSuccess) {
      getEquipmentsStatus = RequestState.success;
      update();
      equipmentsModel = response.data!;
    } else {
      getEquipmentsStatus = RequestState.error;
      update();
    }
  }
}