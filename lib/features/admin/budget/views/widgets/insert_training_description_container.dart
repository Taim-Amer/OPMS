import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/budget/controller/training_description_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertTrainingDescriptionContainer extends StatelessWidget {
  const InsertTrainingDescriptionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingDescriptionController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.trainingFormKey,
        isLoading: controller.insertTrainingDescriptionRequestStatus == RequestState.loading,
        title: 'Insert new Training Description',
        fields: [
          LabeledTextFeild(
            label: '',
            hint: 'Name',
            validator: (value) => Validator.validateEmptyText('name', value),
            controller: controller.trainingNameController,
          ),
        ],
        onSubmit: () => controller.insertTrainingDescription(),
      ),
    );
  }
}
