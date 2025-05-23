import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/controller/runing_cost_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/relief_assistance_item.dart';
import 'package:opms/features/admin/budget/views/widgets/running_cost_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RunningCostList extends StatelessWidget {
  const RunningCostList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RunningCostController>(
      builder: (controller) => Skeletonizer(
        enabled: controller.getRunningCostStatus == RequestState.loading,
        child: TGridLayout(
          // animationType: AnimationType.slide,
          crossCount: HelperFunctions.isTabletScreen(context) || HelperFunctions.isMobileScreen(context) ? 1 : 3,
          mainAxisExtent: 150,
          // animationType: AnimationType.scale,
          itemCount: controller.runningCostModel.data?.length ?? 0,
          itemBuilder: (context, index) => RunningCostItem(runningCost: controller.runningCostModel.data![index],),
        ),
      ),
    );
  }
}
