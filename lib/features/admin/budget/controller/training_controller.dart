// import 'package:get/get.dart';
// import 'package:opms/features/admin/budget/models/salaries_model.dart';
// import 'package:opms/utils/api/data_state.dart';
// import 'package:opms/utils/constants/enums.dart';
// import 'package:opms/utils/repositories/general_repo_impl.dart';
//
// class TrainingController extends GetxController{
//   final _globalRepo = GeneralRepoImpl();
//
//   @override
//   void onInit() {
//     getTraining();
//     super.onInit();
//   }
//
//
//   RequestState getTrainingStatus = RequestState.begin;
//   Rx<RequestState> updateActivityRequestStatus = RequestState.begin.obs;
//   RequestState insertActivityRequestStatus = RequestState.begin;
//
//   Trainin salariesModel = TrainingModel.skeleton;
//
//   Future<void> getTraining() async {
//     getTrainingStatus = RequestState.loading;
//     update();
//     final response = await _globalRepo.getTraining();
//
//     if (response is DataSuccess) {
//       getTrainingStatus = RequestState.success;
//       update();
//       salariesModel = response.data!;
//     } else {
//       getTrainingStatus = RequestState.error;
//       update();
//     }
//   }
// }