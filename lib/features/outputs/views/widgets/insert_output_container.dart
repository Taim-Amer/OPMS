import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/outputs/controller/outputs_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertOutputContainer extends StatelessWidget {
  const InsertOutputContainer({super.key, required this.enable});

  final bool enable;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OutputsController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        title: 'Insert new Output form here',
        enableInsert: enable,
        isLoading: controller.insertOutputsState == RequestState.loading,
        onSubmit: () => controller.insertOutput(),
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.outputNameController,
            hint: 'Output Name',
            validator: (value) => Validator.validateEmptyText('Output name', value),
          ),
          LabeledTextFeild(
            label: '',
            controller: controller.outputCodeController,
            hint: 'Output Code',
            validator: (value) => Validator.validateEmptyText('Output code', value),
          ),
        ],
      ),
    );
  }
}
