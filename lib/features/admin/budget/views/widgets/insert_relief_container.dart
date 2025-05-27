import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_date_field.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertReliefContainer extends StatelessWidget {
  const InsertReliefContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReliefAssistanceController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        isLoading: controller.insertReliefAssistanceRequestStatus == RequestState.loading,
        title: 'Insert new Relief Assistance',
        fields: [
          LabeledTextFeild(
            label: '',
            hint: 'Type',
            validator: (value) => Validator.validateEmptyText('type', value),
            controller: controller.typeController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Description',
            validator: (value) => Validator.validateEmptyText('description', value),
            controller: controller.descriptionController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Unit Cost',
            validator: (value) => Validator.validateEmptyText('unit cost', value),
            controller: controller.unitController,
          ),
          LabeledDateField(
            label: '',
            hint: 'Date',
            validator: (value) => Validator.validateEmptyText('date', value),
            controller: controller.dateController,
          )
        ],
        onSubmit: () => controller.insertReliefAssistance(),
      ),
    );
  }
}
