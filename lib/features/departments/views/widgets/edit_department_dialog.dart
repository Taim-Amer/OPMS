import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';

class EditDepartmentDialog extends StatelessWidget {
  const EditDepartmentDialog({
    super.key,
    required this.name,
    required this.code,
    required this.id,
  });

  final String name;
  final String code;
  final int id;

  @override
  Widget build(BuildContext context) {
    final controller = DepartmentsController.instance;

    controller.departmentName.text = name;
    controller.departemntCode.text = code;

    return InsertRecordDialog(
      showAsset: true,
      submitStatus: controller.updateDepartmentsRequestStatus,
      title: 'Edit Department',
      fields: [
        InsertFieldConfig(
          label: 'Department Name',
          hint: 'Enter name',
          controller: controller.departmentName,
          validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
        ),
        InsertFieldConfig(
          label: 'Code',
          hint: 'Enter code',
          controller: controller.departemntCode,
          validator: (v) => v == null || v.isEmpty ? 'Code is required' : null,
          isNumber: true,
        ),
      ],
      onSubmit: () {
        if (controller.departmentName.text == name &&
            controller.departemntCode.text == code) {
          Get.back();
          return;
        }
        controller.updateDepartment(
          departemtnID: id,
        );
      },
    );
  }
}
