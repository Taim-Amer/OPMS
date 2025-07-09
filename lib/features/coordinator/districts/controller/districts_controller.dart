import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/outcomes/models/outcomes_model.dart';
import 'package:opms/features/admin/outcomes/views/widgets/update_outcome_dialog.dart';
import 'package:opms/features/coordinator/districts/model/districts_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:opms/utils/router/app_router.dart';

class DistrictsController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getDistrictsState = RequestState.begin;
  // RequestState insertDistrictsState = RequestState.begin;
  // RequestState updateDistrictsState = RequestState.begin;

  // final outcomeNameController = TextEditingController();
  // final outcomeCodeController = TextEditingController();
  // final updateOutcomeController = TextEditingController();
  // final updateCodeController = TextEditingController();
  // var formKey = GlobalKey<FormState>();
  // var updateFormKey = GlobalKey<FormState>();

  DistrictsModel districtsModel = DistrictsModel.skeleton;

  // DistrictsDataTableSource? dataSource;

  int? governorateID;


  int currentPage = 1;
  int perPage = 10;
  int totalPages = 1;

  @override
  void onInit() {
    governorateID = Get.arguments?['governorateID'] as int?;
    getDistricts(governorateID: governorateID);
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<DistrictsController>();
    super.onClose();
  }

  Future<void> getDistricts({
    int? governorateID,
    int? page,
    int? perPageOverride,
  }) async {
    currentPage = page ?? currentPage;
    final usedPerPage = perPageOverride ?? perPage;

    getDistrictsState = RequestState.loading;
    update();

    final response = await _repo.getDistricts(
      governorateID: governorateID,
      page: currentPage,
      perPage: usedPerPage,
      paginate: true,
    );

    if (response is DataSuccess) {
      districtsModel = response.data!;
      totalPages = response.data!.meta?.lastPage ?? 1;

      if ((districtsModel.data?.isEmpty ?? true)) {
        getDistrictsState = RequestState.empty;
      } else {
        getDistrictsState = RequestState.success;
      }
    } else {
      getDistrictsState = RequestState.error;
      showSnackBar(
        (response as DataFailed).error!.data.toString(),
        AlertState.error,
      );
    }
    update();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    getDistricts(
      governorateID: governorateID,
      page: page,
    );
  }

  void nextPage() => goToPage(currentPage + 1);
  void prevPage() => goToPage(currentPage - 1);

  // Future<void> insertOutcome() async{
  //   if (!formKey.currentState!.validate()) return;
  //   insertDistrictsState = RequestState.loading;
  //   update();
  //   final dataState = await _repo.insertOutcome(name: outcomeNameController.text.toString(), unitID: 1, code: outcomeNameController.text.toString());
  //   if (dataState is DataSuccess) {
  //     insertDistrictsState = RequestState.success;
  //     outcomeNameController.clear();
  //     showSnackBar(dataState.data!.message, AlertState.success);
  //     getDistricts();
  //     update();
  //   } else if (dataState is DataFailed) {
  //     insertDistrictsState = RequestState.error;
  //     update();
  //     showSnackBar(dataState.error!.data.toString(), AlertState.error);
  //   }
  // }

}