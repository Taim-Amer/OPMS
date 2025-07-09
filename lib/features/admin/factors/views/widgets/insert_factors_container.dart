import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/factors/controllers/factors_controller.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertFactorContainer extends StatelessWidget {
  const InsertFactorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FactorsController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        title: 'Insert new role form here',
        isLoading: controller.insertFactorsState == RequestState.loading,
        onSubmit: () => controller.insertFactor(),
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.factorTitleController,
            hint: 'Factor Title',
            validator: (value) => Validator.validateEmptyText('role name', value),
          ),
        ],
      ),
    );
  }
}
