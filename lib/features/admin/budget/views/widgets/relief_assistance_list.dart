import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/relief_assistance_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReliefAssistanceList extends StatelessWidget {
  const ReliefAssistanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReliefAssistanceController>(
      builder: (controller) => TGridLayout(
        // animationType: AnimationType.slide,
        crossCount: HelperFunctions.isTabletScreen(context) || HelperFunctions.isMobileScreen(context) ? 1 : 3,
        mainAxisExtent: 150,
        animationType: AnimationType.scale,
        itemCount: controller.reliefAssistanceModel.data?.length ?? 0,
        itemBuilder: (context, index) => Skeletonizer(
          enabled: controller.getReliefAssistanceStatus == RequestState.loading,
          child: ReliefAssistanceItem(reliefAssistance: controller.reliefAssistanceModel.data![index],
          ),
        ),
      ),
    );
  }
}
