import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_date_field.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/budget/controller/field_visit_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertFieldVisitContainer extends StatelessWidget {
  const InsertFieldVisitContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FieldVisitController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.fieldVisitFormKey,
        isLoading: controller.insertFieldVisitRequestStatus == RequestState.loading,
        title: 'Insert new Field Visit',
        fields: [
          LabeledTextFeild(
            label: '',
            hint: 'Unit Type',
            validator: (value) => Validator.validateEmptyText('unit type', value),
            controller: controller.fieldVisitUnitTypeController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Description',
            validator: (value) => Validator.validateEmptyText('description', value),
            controller: controller.fieldVisitDescriptionController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Unit Price',
            validator: (value) => Validator.validateEmptyText('unit price', value),
            controller: controller.fieldVisitUnitPriceController,
          ),
          LabeledDateField(
            label: '',
            hint: 'Date',
            validator: (value) => Validator.validateEmptyText('date', value),
            controller: controller.fieldVisitDateController,
          ),
        ],
        onSubmit: () => controller.insertFieldVisit(),
      ),
    );
  }
}
