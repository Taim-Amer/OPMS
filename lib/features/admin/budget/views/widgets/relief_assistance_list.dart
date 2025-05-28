import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/relief_assistance_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReliefAssistanceList extends StatelessWidget {
  const ReliefAssistanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReliefAssistanceController>(
      builder: (controller) {
        final list = controller.filteredReliefAssistance;

        return Form(
          key: controller.updateFormKey,
          child: Column(
            children: [
              LabeledTextFeild(
                label: '',
                hint: 'Search relief assistance...',
                prefix: const Icon(Icons.search),
                onChanged: controller.updateSearchQuery,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TGridLayout(
                  crossCount: HelperFunctions.isTabletScreen(context) ||
                      HelperFunctions.isMobileScreen(context)
                      ? 1
                      : 3,
                  mainAxisExtent: 150,
                  animationType: AnimationType.scale,
                  itemCount: list.length,
                  itemBuilder: (ctx, idx) => Skeletonizer(
                    enabled: controller.getReliefAssistanceStatus ==
                        RequestState.loading,
                    child: ReliefAssistanceItem(
                      reliefAssistance: list[idx],
                      onTap: () {
                        final c = Get.find<ReliefAssistanceController>();

                        c.updateTypeController.text = list[idx].type ?? '';
                        c.updateDescriptionController.text =
                            list[idx].description ?? '';
                        c.updateUnitController.text =
                            list[idx].unitCost ?? '';
                        c.updateDateController.text = list[idx].date ?? '';

                        final fields = [
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateTypeController,
                            hint: 'Enter type',
                            validator: (value) =>
                                Validator.validateEmptyText('type', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateDescriptionController,
                            hint: 'Enter description',
                            validator: (value) =>
                                Validator.validateEmptyText('description', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateUnitController,
                            hint: 'Enter unit cost',
                            isNumber: true,
                            validator: (value) =>
                                Validator.validateEmptyText('cost', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateDateController,
                            hint: 'Enter date',
                            validator: (value) =>
                                Validator.validateEmptyText('date', value),
                          ),
                        ];

                        Get.dialog(
                          InsertRecordDialog(
                            title: 'Update Relief Assistance',
                            fields: fields,
                            submitStatus: c.updateReliefAssistanceRequestStatus,
                            onSubmit: () => c.updateReliefAssistance(id: list[idx].id!),
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
