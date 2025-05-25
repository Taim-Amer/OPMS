import 'package:get/get.dart';
import 'package:opms/features/admin/budget/models/training_description_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class TrainingDescriptionController extends GetxController{
  final _globalRepo = GeneralRepoImpl();

  @override
  void onInit() {
    getTrainingDescription();
    super.onInit();
  }


  RequestState getTrainingDescriptionStatus = RequestState.begin;
  Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
  RequestState insertActivityRequestStatus = RequestState.begin;

  TrainingDescriptionModel trainingDescriptionModel = TrainingDescriptionModel.skeleton;

  Future<void> getTrainingDescription() async {
    getTrainingDescriptionStatus = RequestState.loading;
    update();
    final response = await _globalRepo.getTrainingDescription();

    if (response is DataSuccess) {
      getTrainingDescriptionStatus = RequestState.success;
      update();
      trainingDescriptionModel = response.data!;
    } else {
      getTrainingDescriptionStatus = RequestState.error;
      update();
    }
  }
}