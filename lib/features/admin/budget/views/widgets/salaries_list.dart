import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/salary_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/salary_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalariesList extends StatelessWidget {
  const SalariesList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalariesController>(
      builder: (controller) {
        final list = controller.filteredSalaries;

        return Column(
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
                mainAxisExtent: 150,
                animationType: AnimationType.scale,
                itemCount: list.length,
                itemBuilder: (ctx, idx) => Skeletonizer(
                  enabled:
                  controller.getSalariesStatus == RequestState.loading,
                  child: SalaryItem(
                    salary: list[idx],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
