import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/projects/view/widgets/projects_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProjectsList extends GetView<DepartmentsController> {
  const ProjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TSlideAnimation(
      beginOffset: const Offset(1, 0),
      child: TRoundedContainer(
        backgroundColor: dark ? TColors.black : TColors.light,
        height: 800,
        width: HelperFunctions.isMobileScreen(context) ? double.infinity : 400,
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: SingleChildScrollView(
          child: Obx(() => Skeletonizer(
            enabled: controller.projectsController.getFilteredProjectsRequestStatus.value == RequestState.loading,
            child: Column(
              children: List.generate(
                controller.projectsController.filteredProjectsModel.value.data?.length ?? 0,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
                      child: ProjectItem(project: controller.projectsController.filteredProjectsModel.value.data![index]),
                    ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
