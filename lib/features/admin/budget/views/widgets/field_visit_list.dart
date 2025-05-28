import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/field_visit_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/field_visit_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FieldVisitList extends StatelessWidget {
  const FieldVisitList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FieldVisitController>(
      builder: (controller) {
        final visits = controller.filteredVisits;

        return Form(
          key: controller.updateFormKey,
          child: Column(
            children: [
              LabeledTextFeild(
                label: '',
                hint: 'Search field visits...',
                prefix: const Icon(Icons.search),
                onChanged: controller.updateSearchQuery,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TGridLayout(
                  crossCount: HelperFunctions.isTabletScreen(context) || HelperFunctions.isMobileScreen(context) ? 1 : 3,
                  mainAxisExtent: 150,
                  animationType: AnimationType.scale,
                  itemCount: visits.length,
                  itemBuilder: (ctx, idx) => Skeletonizer(
                    enabled: controller.getFieldVisitStatus == RequestState.loading,
                    child: FieldVisitItem(
                      fieldVisit: visits[idx],
                      onTap: () {
                        final c = Get.find<FieldVisitController>();
          
                        c.updateFieldVisitUnitTypeController.text = visits[idx].unitType ?? '';
                        c.updateFieldVisitDescriptionController.text = visits[idx].description ?? '';
                        c.updateFieldVisitUnitPriceController.text = visits[idx].unitPrice ?? '';
                        c.updateFieldVisitDateController.text = visits[idx].date ?? '';
          
                        final fields = [
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateFieldVisitUnitTypeController,
                            hint: 'Enter unit type',
                            validator: (value) => Validator.validateEmptyText('unit type', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateFieldVisitDescriptionController,
                            hint: 'Enter description',
                            validator: (value) => Validator.validateEmptyText('description', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateFieldVisitUnitPriceController,
                            hint: 'Enter unit price',
                            isNumber: true,
                            validator: (value) => Validator.validateEmptyText('unit price', value),
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateFieldVisitDateController,
                            hint: 'Enter date',
                            validator: (value) => Validator.validateEmptyText('date', value),
                          ),
                        ];
          
                        Get.dialog(
                          InsertRecordDialog(
                            title: 'Update Field Visit',
                            fields: fields,
                            submitStatus: c.updateFieldVisitRequestStatus,
                            onSubmit: () => c.updateFieldVisit(id: visits[idx].id!),
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
