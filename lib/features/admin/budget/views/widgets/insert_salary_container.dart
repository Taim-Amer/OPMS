import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_date_field.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/budget/controller/salary_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertSalaryContainer extends StatelessWidget {
  const InsertSalaryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalariesController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.salaryFormKey,
        isLoading: controller.insertSalaryRequestStatus == RequestState.loading,
        title: 'Insert new Salary',
        fields: [
          LabeledTextFeild(
            label: '',
            hint: 'Type',
            validator: (value) => Validator.validateEmptyText('type', value),
            controller: controller.typeController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Positions',
            validator: (value) => Validator.validateEmptyText('positions', value),
            controller: controller.positionsController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Salary',
            validator: (value) => Validator.validateEmptyText('salary', value),
            controller: controller.salaryController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Cost of Living Allowance',
            validator: (value) => Validator.validateEmptyText('cost of living allowance', value),
            controller: controller.costOfLivingController,
          ),
          LabeledDateField(
            label: '',
            hint: 'Date',
            validator: (value) => Validator.validateEmptyText('date', value),
            controller: controller.dateController,
          ),
        ],
        onSubmit: () => controller.insertSalary(),
      ),
    );
  }
}
