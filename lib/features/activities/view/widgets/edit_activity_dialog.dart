import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/features/activities/controller/activities_controller.dart';

class EditActivityDialog extends GetView<ActivitiesController> {
  const EditActivityDialog({
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
    controller.activityName.text = name;
    controller.activityCode.text = code;

    return InsertRecordDialog(
      showAsset: true,
      submitStatus: controller.updateActivityRequestStatus,
      title: 'Edit Activity',
      fields: [
        InsertFieldConfig(
          label: 'Activity Name',
          hint: 'Enter name',
          controller: controller.activityName,
          validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
        ),
        InsertFieldConfig(
          label: 'Code',
          hint: 'Enter code',
          controller: controller.activityCode,
          validator: (v) => v == null || v.isEmpty ? 'Code is required' : null,
          isNumber: true,
        ),
      ],
      onSubmit: () {
        if (controller.activityName.text == name &&
            controller.activityCode.text == code) {
          Get.back();
          return;
        }
        controller.updateActivity(
          activityID: id,
        );
      },
    );
  }
}
