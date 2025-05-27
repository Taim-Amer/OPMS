import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/runing_cost_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/running_cost_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RunningCostList extends StatelessWidget {
  const RunningCostList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RunningCostController>(
      builder: (controller) {
        final list = controller.filteredRunningCosts;

        return Column(
          children: [
            LabeledTextFeild(
              label: '',
              hint: 'Search running costs...',
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
                  controller.getRunningCostStatus == RequestState.loading,
                  child: RunningCostItem(
                    runningCost: list[idx],
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
