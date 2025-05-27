import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_date_field.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/budget/controller/runing_cost_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertRunningCostContainer extends StatelessWidget {
  const InsertRunningCostContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RunningCostController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.runningCostFormKey,
        isLoading: controller.insertRunningCostRequestStatus == RequestState.loading,
        title: 'Insert new Running Cost',
        fields: [
          LabeledTextFeild(
            label: '',
            hint: 'Expense Type',
            validator: (value) => Validator.validateEmptyText('expense type', value),
            controller: controller.expenseTypeController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Unit Type',
            validator: (value) => Validator.validateEmptyText('unit type', value),
            controller: controller.unitTypeController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Unit Cost',
            validator: (value) => Validator.validateEmptyText('unit cost', value),
            controller: controller.unitCostController,
          ),
          LabeledDateField(
            label: '',
            hint: 'Date',
            validator: (value) => Validator.validateEmptyText('date', value),
            controller: controller.dateController,
          ),
        ],
        onSubmit: () => controller.insertRunningCost(),
      ),
    );
  }
}
