import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/helpers/validation.dart';

class NewDepartmentDialog extends GetView<DepartmentsController> {
  const NewDepartmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return InsertRecordDialog(
      showAsset: true,
      assetString: ImagesAssets.add,
      title: 'New Department',
      fields: [
        InsertFieldConfig(
          label: '',
          controller: controller.departmentName,
          validator: (value) => Validator.validateEmptyText('name', value),
          hint: 'New department name',
        ),
        InsertFieldConfig(
          label: '',
          controller: controller.departemntCode,
          hint: 'New department code',
          validator: (value) => Validator.validateEmptyText('code', value)
        ),
      ],
      onSubmit: () => controller.insertDepartment(),
      submitStatus: controller.insertDepartmentsRequestStatus,
    );
  }
}
