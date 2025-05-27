import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_container.dart';
import 'package:opms/common/widgets/fields/labeled_date_field.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/features/admin/budget/controller/equipments_controller.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertEquipmentContainer extends StatelessWidget {
  const InsertEquipmentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EquipmentsController>(
      builder: (controller) => CustomInsertContainer(
        formKey: controller.equipmentFormKey,
        isLoading: controller.insertEquipmentsRequestStatus == RequestState.loading,
        title: 'Insert new Equipment',
        fields: [
          LabeledTextFeild(
            label: '',
            hint: 'Type',
            validator: (value) => Validator.validateEmptyText('type', value),
            controller: controller.equipmentTypeController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Description',
            validator: (value) => Validator.validateEmptyText('description', value),
            controller: controller.equipmentDescriptionController,
          ),
          LabeledTextFeild(
            label: '',
            hint: 'Cost',
            validator: (value) => Validator.validateEmptyText('cost', value),
            controller: controller.equipmentCostController,
          ),
          LabeledDateField(
            label: '',
            hint: 'Date',
            validator: (value) => Validator.validateEmptyText('date', value),
            controller: controller.equipmentDateController,
          ),
        ],
        onSubmit: () => controller.insertEquipments(),
      ),
    );
  }
}
