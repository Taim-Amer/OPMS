import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/field_visit_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/field_visit_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FieldVisitList extends StatelessWidget {
  const FieldVisitList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FieldVisitController>(
      builder: (controller) => TGridLayout(
        // animationType: AnimationType.slide,
        crossCount: HelperFunctions.isTabletScreen(context) || HelperFunctions.isMobileScreen(context) ? 1 : 3,
        mainAxisExtent: 150,
        animationType: AnimationType.scale,
        itemCount: controller.fieldVisitModel.data?.length ?? 0,
        itemBuilder: (context, index) => Skeletonizer(
          enabled: controller.getFieldVisitStatus == RequestState.loading,
          child: FieldVisitItem(
            fieldVisit: controller.fieldVisitModel.data![index],
          ),
        ),
      ),
    );
  }
}
