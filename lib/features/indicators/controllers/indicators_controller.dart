import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/indicators/models/indicators_model.dart';
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

  final outputNameController = TextEditingController();
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
      dataSource = IndicatorsDataTableSource(outputModel.data ?? []);
      getIndicators(outputID: outputID);
    } else {
      dataSource = IndicatorsDataTableSource(outputModel.data ?? []);
      getIndicators();
    }
    super.onInit();
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
        dataSource = IndicatorsDataTableSource(outputModel.data!);
        getIndicatorsState = RequestState.success;
      }
      update();
    } else if (dataState is DataFailed) {
      getIndicatorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> insertOutput() async{
    if (!formKey.currentState!.validate()) return;
    insertIndicatorsState = RequestState.loading;
    update();
    final dataState = await _repo.insertIndicator(
      name: outputNameController.text.toString(),
      outputID: outputID!,
    );
    if (dataState is DataSuccess) {
      insertIndicatorsState = RequestState.success;
      outputNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getIndicators();
      update();
    } else if (dataState is DataFailed) {
      insertIndicatorsState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }

  Future<void> updateOutput({required int outputID}) async{
    if (!updateFormKey.currentState!.validate()) return;
    updateIndicatorsState = RequestState.loading;
    update();
    final dataState = await _repo.updateIndicator(
        name: updateNameController.text.toString(),
        outputID: 1,
        departmentID: 1,
    );
    if (dataState is DataSuccess) {
      updateIndicatorsState = RequestState.success;
      updateNameController.clear();
      showSnackBar(dataState.data!.message, AlertState.success);
      getIndicators();
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

  IndicatorsDataTableSource(this.indicator);

  @override
  DataRow2 getRow(int index) {
    final item = indicator[index];
    return DataRow2(
      cells: [
        DataCell(item.description?.s13w400 ?? const Text('')),
        DataCell(Formatter.formatDate(item.createdAt).s13w400),
        DataCell(Formatter.formatDate(item.updatedAt).s13w400),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Edit',
                onPressed: (){},
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
  int get rowCount => indicator.length;

  @override
  int get selectedRowCount => 0;
}