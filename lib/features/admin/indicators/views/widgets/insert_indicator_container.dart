import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/indicators/controllers/indicators_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';


class InsertIndicatorContainer extends StatelessWidget {
  const InsertIndicatorContainer({super.key, required this.enable});

  final bool enable;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndicatorsController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.formKey,
        title: 'Insert new Indicator form here',
        isLoading: controller.insertIndicatorsState == RequestState.loading,
        enableInsert: enable,
        onSubmit: () => controller.insertIndicator(),
        fields: [
          LabeledTextFeild(
            label: '',
            controller: controller.indicatorNameController,
            hint: 'Indicator Name',
            validator: (value) => Validator.validateEmptyText('Indicator name', value),
          ),
        ],
      ),
    );
  }
}

