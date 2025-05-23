import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/outputs/views/widgets/insert_output_container.dart';
import 'package:opms/features/projects/controller/projects_controller.dart';
import 'package:opms/features/projects/view/widgets/projects_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:opms/common/widgets/data_table/pagination_controls.dart';

class ProjectsMobileScreen extends GetView<ProjectsController> {
  const ProjectsMobileScreen({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TSiteTemplate(
      useLayout: fromAnother,
      clickableSidebar: false,
      mobile: TRoundedContainer(
        backgroundColor: dark ? TColors.black2 : Colors.white,
        radius: 0,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Obx(() {
            final projects = controller.allProjectsModel.value.data ?? [];
            final isLoading = controller.getAllProjectsRequestStatus.value == RequestState.loading;

            return Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Projects & Units'.s16w700,
                      fontSize: 20,
                    ),
                    Sizes.spaceBtwSections.verticalSpace,
                    if (projects.isEmpty && !isLoading)
                      const Center(child: Text('No projects found'))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ProjectItem(project: projects[index]),
                          );
                        },
                      ),
                    Sizes.spaceBtwSections.verticalSpace,
                    TPaginationControls(
                      totalItemCount: controller.allProjectsModel.value.meta?.total ?? 0,
                      currentPage: controller.currentPage.value,
                      totalPages: controller.totalPages.value,
                      perPage: controller.perPage.value,
                      perPageOptions: const [5, 10, 20, 50],
                      onPrevious: () {
                        controller.getProjects(page: controller.currentPage.value - 1);
                      },
                      onNext: () {
                        controller.getProjects(page: controller.currentPage.value + 1);
                      },
                      onPerPageChanged: (newPerPage) {
                        controller.perPage.value = newPerPage;
                        controller.getProjects(page: 1, perPageOverride: newPerPage);
                      },
                    ),
                    if (fromAnother) ...[
                      Sizes.spaceBtwSections.verticalSpace,
                      InsertOutputContainer(enable: fromAnother,),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
