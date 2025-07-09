import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/users/models/users_model.dart';
import 'package:opms/features/admin/users/models/users_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/logger.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

import '../models/governorate_model.dart';


class GovernorateController extends GetxController{
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getGovernoratesState = RequestState.begin;
  GovernorateModel governorateModel = GovernorateModel.skeleton;

  // int? selectedgovernorateID;

  @override
  void onInit() {
    getGovernorates();
    super.onInit();
  }

  // void changeSelectedGorvernorate(int id) {
  //   if (selectedgovernorateID == id) {
  //     selectedgovernorateID = null; // لإلغاء التحديد إذا نُقر عليه مرة أخرى
  //   } else {
  //     selectedgovernorateID = id;
  //   }
  //   update(); // لإعلام GetBuilder أو GetX بالتحديث
  // }


  Future<void> getGovernorates() async{
    getGovernoratesState = RequestState.loading;
    update();
    final dataState = await _repo.getGovernorates();
    if (dataState is DataSuccess) {
      governorateModel = dataState.data!;
      governorateModel.data?.isEmpty ?? true ? getGovernoratesState = RequestState.empty : getGovernoratesState = RequestState.success;
      update();
    } else if (dataState is DataFailed) {
      getGovernoratesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }
}