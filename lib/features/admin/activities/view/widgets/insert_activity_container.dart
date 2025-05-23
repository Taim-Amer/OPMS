import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/activities/controller/activities_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertActivityContainer extends StatelessWidget {
  const InsertActivityContainer({super.key, required this.enable});

  final bool enable;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivitiesController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        title: 'Insert new Activity form here',
        enableInsert: enable,
        isLoading: controller.insertActivityRequestStatus == RequestState.loading,
        onSubmit: () => controller.insertActivity(),
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.newActivityName,
            hint: 'Activity Name',
            validator: (value) => Validator.validateEmptyText('Activity name', value),
          ),
          LabeledTextFeild(
            label: '',
            controller: controller.newActivityCode,
            hint: 'Activity Code',
            validator: (value) => Validator.validateEmptyText('Activity code', value),
          ),
        ],
      ),
    );
  }
}

