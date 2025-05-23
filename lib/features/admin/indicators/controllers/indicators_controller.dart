import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/admin/indicators/models/indicators_model.dart';
import 'package:opms/features/admin/indicators/views/widgets/update_indicator_dialog.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/formatter.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';

class IndicatorsController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  RequestState getIndicatorsState = RequestState.begin;
  RequestState insertIndicatorsState = RequestState.begin;
  RequestState updateIndicatorsState = RequestState.begin;

  final indicatorNameController = TextEditingController();
  final updateNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var updateFormKey = GlobalKey<FormState>();

  IndicatorsModel outputModel = IndicatorsModel.skeleton;

  IndicatorsDataTableSource? dataSource;

  int? outputID;

  @override
  void onInit() {
    outputID = Get.arguments?['outputID'] as int?;
    if (outputID != null) {
      dataSource = IndicatorsDataTableSource(outputModel.data ?? [], outputID: outputID);
      getIndicators(outputID: outputID);
    } else {
      dataSource = IndicatorsDataTableSource(outputModel.data ?? [], outputID: outputID);
      getIndicators();
    }
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<IndicatorsController>();
    super.onClose();
  }


  Future<void> getIndicators({int? outputID}) async {
    getIndicatorsState = RequestState.loading;
    update();

    final dataState = await _repo.getIndicators(outputID);

    if (dataState is DataSuccess) {
      outputModel = dataState.data!;
      if (outputModel.data?.isEmpty ?? true) {
        getIndicatorsState = RequestState.empty;
      } else {
        dataSource = IndicatorsDataTableSource(outputModel.data!, outputID: outputID);
        getIndicatorsState = RequestState.success;
      }
      update();
    } else if (dataState is DataFailed) {
      getIndicatorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> insertIndicator() async{
    if (!formKey.currentState!.validate()) return;
    insertIndicatorsState = RequestState.loading;
    update();
    final dataState = await _repo.insertIndicator(
      name: indicatorNameController.text.toString(),
      outputID: outputID!,
    );
    if (dataState is DataSuccess) {
      insertIndicatorsState = RequestState.success;
      indicatorNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getIndicators(outputID: outputID!);
      update();
    } else if (dataState is DataFailed) {
      insertIndicatorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateIndicator({required int indicatorID}) async{
    if (!updateFormKey.currentState!.validate()) return;
    updateIndicatorsState = RequestState.loading;
    update();
    final dataState = await _repo.updateIndicator(
        name: updateNameController.text.toString(),
        // outputID: outputID!,
        indicatorID: indicatorID,
    );
    if (dataState is DataSuccess) {
      updateIndicatorsState = RequestState.success;
      updateNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      outputID == null ? getIndicators() : getIndicators(outputID: outputID);
      update();
    } else if (dataState is DataFailed) {
      updateIndicatorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
    Navigator.pop(Get.context!);
  }
}

class IndicatorsDataTableSource extends DataTableSource {
  final List<Data> indicator;
  final int? outputID;

  IndicatorsDataTableSource(this.indicator, {this.outputID});

  @override
  DataRow2 getRow(int index) {
    final item = indicator[index];
    return DataRow2(
      cells: [
        DataCell(item.description?.s17w400 ?? const Text('')),
        DataCell(Formatter.formatDate(item.createdAt).s17w400),
        DataCell(Formatter.formatDate(item.updatedAt).s17w400),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit, color:Colors.blue),
            tooltip: 'Edit',
            onPressed: () => Get.dialog(UpdateIndicatorDialog(indicatorID: item.id!)),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => indicator.length;

  @override
  int get selectedRowCount => 0;
}