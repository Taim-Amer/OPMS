import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/outputs/models/outputs_model.dart';
import 'package:opms/features/admin/outputs/views/widgets/update_output_dialog.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/helpers/logger.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:opms/utils/router/app_router.dart';

class OutputsController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getOutputsState = RequestState.begin;
  RequestState insertOutputsState = RequestState.begin;
  RequestState updateOutputsState = RequestState.begin;

  final outputNameController = TextEditingController();
  final outputCodeController = TextEditingController();
  final updateOutputController = TextEditingController();
  final updateCodeController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var updateFormKey = GlobalKey<FormState>();

  OutputsModel outputModel = OutputsModel.skeleton;

  OutputsDataTableSource? dataSource;

  int? outcomeID;

  @override
  void onInit() {
    outcomeID = Get.arguments?['outcomeID'] as int?;
    LoggerHelper.error(outcomeID.toString());
    if (outcomeID != null) {
      dataSource = OutputsDataTableSource(outputModel.data ?? [], outcomeID: outcomeID);
      getOutputs(outcomeID: outcomeID);
    } else {
      dataSource = OutputsDataTableSource(outputModel.data ?? [], outcomeID: outcomeID);
      getOutputs();
    }
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<OutputsController>();
    super.onClose();
  }


  Future<void> getOutputs({int? outcomeID}) async {
    getOutputsState = RequestState.loading;
    update();

    final dataState = await _repo.getOutputs(outcomeID);

    if (dataState is DataSuccess) {
      outputModel = dataState.data!;
      if (outputModel.data?.isEmpty ?? true) {
        getOutputsState = RequestState.empty;
      } else {
        dataSource = OutputsDataTableSource(outputModel.data!, outcomeID: outcomeID);
        getOutputsState = RequestState.success;
      }
      update();
    } else if (dataState is DataFailed) {
      getOutputsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> insertOutput() async{
    if (!formKey.currentState!.validate()) return;
    insertOutputsState = RequestState.loading;
    update();
    final dataState = await _repo.insertOutput(
      name: outputNameController.text.toString(),
      outcomeID: outcomeID!,
      code: outputCodeController.text.toString(),
    );
    if (dataState is DataSuccess) {
      insertOutputsState = RequestState.success;
      outputNameController.clear();
      outputCodeController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getOutputs(outcomeID: outcomeID!);
      update();
    } else if (dataState is DataFailed) {
      insertOutputsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateOutput({required int outputID}) async{
    if (!updateFormKey.currentState!.validate()) return;
    updateOutputsState = RequestState.loading;
    update();
    final dataState = await _repo.updateOutput(
        name: updateOutputController.text.toString(),
        // outcomeID: outcomeID!,
        outputID: outputID,
        code: updateCodeController.text.toString()
    );
    if (dataState is DataSuccess) {
      updateOutputsState = RequestState.success;
      updateOutputController.clear();
      updateCodeController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      outcomeID == null ? getOutputs() : getOutputs(outcomeID: outcomeID);
      update();
    } else if (dataState is DataFailed) {
      updateOutputsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
    Navigator.pop(Get.context!);
  }
}

class OutputsDataTableSource extends DataTableSource {
  final List<Data> output;
  final int? outcomeID;

  OutputsDataTableSource(this.output, {this.outcomeID});

  @override
  DataRow2 getRow(int index) {
    final item = output[index];
    return DataRow2(
      cells: [
        DataCell(item.name?.s17w400 ?? const Text('')),
        DataCell(item.code?.s17w400 ?? const Text('')),
        DataCell(Formatter.formatDate(item.createdAt).s17w400),
        DataCell(Formatter.formatDate(item.updatedAt).s17w400),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit, color:Colors.blue),
            tooltip: 'Edit',
            onPressed:  () => Get.dialog(UpdateOutputDialog(outputID: item.id!,)) ,
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, color: TColors.primary),
            tooltip: 'show indicators',
            onPressed: () => AppRoutes.toNamed(
                AppRoutes.kIndicator,
                arguments: {
                  'outputID' : item.id
                }
            ),
          ),
        ),
        DataCell(
          IconButton(
          icon: const Icon(Icons.grid_view_rounded, color: Colors.orange),
          tooltip: 'show activities',
          onPressed: () => AppRoutes.toNamed(
              AppRoutes.kActivities,
              arguments: {
                'outputID' : item.id
              }
          ),
        ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => output.length;

  @override
  int get selectedRowCount => 0;
}
