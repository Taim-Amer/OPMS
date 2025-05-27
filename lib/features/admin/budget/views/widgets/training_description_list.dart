import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/budget/controller/training_description_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/training_description_item.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TrainingDescriptionList extends StatelessWidget {
  const TrainingDescriptionList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingDescriptionController>(
      builder: (controller) {
        final list = controller.filteredDescriptions;

        return Column(
          children: [
            LabeledTextFeild(
              label: '',
              hint: 'Search training descriptions...',
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
                  enabled: controller.getTrainingDescriptionStatus ==
                      RequestState.loading,
                  child: TrainingDescriptionItem(
                    trainingDescription: list[idx],
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
