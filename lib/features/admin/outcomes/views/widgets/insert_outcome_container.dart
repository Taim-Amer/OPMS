import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertOutcomeContainer extends StatelessWidget {
  const InsertOutcomeContainer({super.key, required this.enable});

  final bool enable;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OutcomesController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        isLoading: controller.insertOutcomesState == RequestState.loading,
        title: 'Insert new Outcome form here',
        onSubmit: () => controller.insertOutcome(),
        enableInsert: enable,
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.outcomeNameController,
            hint: 'Outcome Name',
            validator: (value) => Validator.validateEmptyText('Outcome name', value),
          ),
          LabeledTextFeild(
            label: '',
            controller: controller.outcomeCodeController,
            hint: 'Outcome Code',
            validator: (value) => Validator.validateEmptyText('Outcome code', value),
          ),
        ],
      ),
    );
  }
}

