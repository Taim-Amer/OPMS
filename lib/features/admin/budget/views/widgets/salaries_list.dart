import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/salary_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/salary_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalariesList extends StatelessWidget {
  const SalariesList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalariesController>(
      builder: (controller) {
        final list = controller.filteredSalaries;

        return Form(
          key: controller.updateFormKey,
          child: Column(
            children: [
              LabeledTextFeild(
                label: '',
                hint: 'Search salaries...',
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
                  mainAxisExtent: 170,
                  animationType: AnimationType.scale,
                  itemCount: list.length,
                  itemBuilder: (ctx, idx) => Skeletonizer(
                    enabled: controller.getSalariesStatus == RequestState.loading,
                    child: SalaryItem(
                      salary: list[idx],
                      onTap: () {
                        final c = Get.find<SalariesController>();
                        final salary = list[idx];

                        c.updateTypeController.text = salary.type ?? '';
                        c.updatePositionsController.text = salary.positions ?? '';
                        c.updateSalaryController.text = salary.salary.toString() ?? '';
                        c.updateCostOfLivingController.text = salary.costOfLivingAllowance.toString() ?? '';
                        c.updateDateController.text = salary.date ?? '';

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
                            controller: c.updatePositionsController,
                            hint: 'Enter number of positions',
                            validator: (value) =>
                                Validator.validateEmptyText('positions', value),
                            isNumber: true,
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateSalaryController,
                            hint: 'Enter salary',
                            validator: (value) =>
                                Validator.validateEmptyText('salary', value),
                            isNumber: true,
                          ),
                          InsertFieldConfig(
                            label: '',
                            controller: c.updateCostOfLivingController,
                            hint: 'Enter cost of living allowance',
                            validator: (value) => Validator.validateEmptyText(
                                'cost of living allowance', value),
                            isNumber: true,
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
                            title: 'Update Salary',
                            fields: fields,
                            submitStatus: c.updateSalaryRequestStatus,
                            onSubmit: () => c.updateSalary(id: salary.id!),
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
