import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/outcomes/models/outcomes_model.dart';
import 'package:opms/features/outcomes/views/widgets/update_outcome_dialog.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:opms/utils/router/app_router.dart';

class OutcomesController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getOutcomesState = RequestState.begin;
  RequestState insertOutcomesState = RequestState.begin;
  RequestState updateOutcomesState = RequestState.begin;

  final outcomeNameController = TextEditingController();
  final outcomeCodeController = TextEditingController();
  final updateOutcomeController = TextEditingController();
  final updateCodeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var updateFormKey = GlobalKey<FormState>();

  OutcomesModel outcomesModel = OutcomesModel.skeleton;

  OutcomesDataTableSource? dataSource;

  int? unitID;

  @override
  void onInit() {
    unitID = Get.arguments?['unitID'] as int?;
    if(unitID != null){
      dataSource = OutcomesDataTableSource(outcomesModel.data ?? [], unitID: unitID);
      getOutcomes(unitID: unitID);
    } else{
      dataSource = OutcomesDataTableSource(outcomesModel.data ?? [], unitID: unitID);
      getOutcomes();
    }
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<OutcomesController>();
    super.onClose();
  }

  Future<void> getOutcomes({int? unitID}) async {
    getOutcomesState = RequestState.loading;
    update();

    final dataState = await _repo.getOutcomes(unitID);

    if (dataState is DataSuccess) {
      outcomesModel = dataState.data!;
      if (outcomesModel.data?.isEmpty ?? true) {
        getOutcomesState = RequestState.empty;
      } else {
        dataSource = OutcomesDataTableSource(outcomesModel.data!, unitID: unitID);
        getOutcomesState = RequestState.success;
      }
      update();
    } else if (dataState is DataFailed) {
      getOutcomesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> insertOutcome() async{
    if (!formKey.currentState!.validate()) return;
    insertOutcomesState = RequestState.loading;
    update();
    final dataState = await _repo.insertOutcome(name: outcomeNameController.text.toString(), unitID: 1, code: outcomeNameController.text.toString());
    if (dataState is DataSuccess) {
      insertOutcomesState = RequestState.success;
      outcomeNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getOutcomes();
      update();
    } else if (dataState is DataFailed) {
      insertOutcomesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateOutcome({required int outcomeID}) async{
    if (!updateFormKey.currentState!.validate()) return;
    updateOutcomesState = RequestState.loading;
    update();
    final dataState = await _repo.updateOutcome(
      name: updateOutcomeController.text.toString(),
      outcomeID: outcomeID,
      code: updateCodeController.text.toString()
    );
    if (dataState is DataSuccess) {
      updateOutcomesState = RequestState.success;
      updateOutcomeController.clear();
      updateCodeController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      unitID == null ? getOutcomes() : getOutcomes(unitID: unitID);
      update();
    } else if (dataState is DataFailed) {
      updateOutcomesState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
    Navigator.pop(Get.context!);
  }
}

class OutcomesDataTableSource extends DataTableSource {
  final List<Data> outcomes;
  final int? unitID;

  OutcomesDataTableSource(this.outcomes, {this.unitID});

  @override
  DataRow2 getRow(int index) {
    final item = outcomes[index];
    return DataRow2(
      cells: [
        DataCell(item.name?.s17w400 ?? const Text('')),
        DataCell(item.code?.s17w400 ?? const Text('')),
        DataCell(Formatter.formatDate(item.createdAt).s17w400),
        DataCell(Formatter.formatDate(item.updatedAt).s17w400),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Edit',
                onPressed: () => Get.dialog(UpdateOutcomeDialog(outcomeID: item.id!)),
              ),
              Sizes.sm.horizontalSpace,
              IconButton(
                icon: const Icon(Icons.grid_view_rounded, color: TColors.primary),
                tooltip: 'Show Outputs',
                onPressed: () => Get.toNamed(
                  AppRoutes.kOutputs,
                  arguments: {
                    'outcomeID' : item.id,
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => outcomes.length;

  @override
  int get selectedRowCount => 0;
}
