import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/equipments_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/equipment_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EquipmentsList extends StatelessWidget {
  const EquipmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EquipmentsController>(
      builder: (controller) {
        final equipments = controller.filteredEquipments;

        return Form(
          key: controller.updateFormKey,
          child: Column(
            children: [
              LabeledTextFeild(
                label: '',
                // controller: TextEditingController(),
                hint: 'Search Equipments ...',
                prefix: const Icon(Icons.search),
                onChanged: controller.updateSearchQuery,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TGridLayout(
                  crossCount: HelperFunctions.isTabletScreen(context) || HelperFunctions.isMobileScreen(context) ? 1 : 3,
                  mainAxisExtent: 150,
                  animationType: AnimationType.scale,
                  itemCount: equipments.length,
                  itemBuilder: (context, index) => Skeletonizer(
                    enabled: controller.getEquipmentsStatus == RequestState.loading,
                    child: EquipmentItem(
                      equipment: equipments[index],
                      onEditTap: () {
                        final controller = Get.find<EquipmentsController>();
                        controller.updateEquipmentTypeController.text = equipments[index].type ?? '';
                        controller.updateEquipmentDescriptionController.text = equipments[index].equipmentDescription ?? '';
                        controller.updateEquipmentCostController.text = equipments[index].equipmentCost ?? '';
                        controller.updateEquipmentDateController.text = equipments[index].date ?? '';
          
                        final fields = [
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateEquipmentTypeController,
                            hint: 'Enter equipment type',
                              validator: (value) => Validator.validateEmptyText('type', value)
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateEquipmentDescriptionController,
                            hint: 'Enter description',
                            validator: (value) => Validator.validateEmptyText('description', value)
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateEquipmentCostController,
                            isNumber: true,
                            hint: 'Enter cost',
                              validator: (value) => Validator.validateEmptyText('cost', value)
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: controller.updateEquipmentDateController,
                            hint: 'Enter date',
                              validator: (value) => Validator.validateEmptyText('date', value)
                          ),
                        ];
          
                        Get.dialog(
                          InsertRecordDialog(
                            title: 'Update Equipment',
                            fields: fields,
                            submitStatus: controller.updateEquipmentsRequestStatus,
                            onSubmit: () => controller.updateEquipments(id: equipments[index].id!),
                            showAsset: true,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
