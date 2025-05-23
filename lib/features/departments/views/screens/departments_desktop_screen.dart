import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/departments/controller/departments_controller.dart';
import 'package:opms/features/departments/views/widgets/department_item.dart';
import 'package:opms/features/departments/views/widgets/new_department_dialog.dart';
import 'package:opms/features/departments/views/widgets/projects_list.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DepartmentsDesktopScreen extends GetView<DepartmentsController> {
  const DepartmentsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TSiteTemplate(
      useLayout: false,
      clickableSidebar: false,
      desktop: SingleChildScrollView(
        child: TRoundedContainer(
          backgroundColor: dark ? TColors.black2 : Colors.white,
          radius: 0,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Departments'.s16w700,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      softWrap: true,
                    ),
                    SizedBox(
                      width: 100,
                      child: CustomButton(
                        title: '+ New',
                        onTap: () {
                          controller.departemntCode.clear();
                          controller.departmentName.clear();
                          Get.dialog(
                              const NewDepartmentDialog()
                          );
                        },
                      ),
                    )
                  ],
                ),
                Sizes.spaceBtwSections.verticalSpace,
                Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: HelperFunctions.isTabletScreen(context) ? 2 : 3,
                      child: Skeletonizer(
                        enabled: controller.getDepartmentsRequestStatus.value == RequestState.loading,
                        child: StaggeredGrid.count(
                          crossAxisCount: HelperFunctions.isTabletScreen(context) ? controller.showProjects.value ? 2 : 4 :controller.showProjects.value ? 4 : 5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          // axisDirection: AxisDirection.right,
                          children: List.generate(
                            controller.departmentsModel.value.departments?.length ?? 0,
                                (index) => StaggeredGridTile.count(
                              crossAxisCellCount: 1,
                              mainAxisCellCount: index.isEven ? .6 : .8,
                              // mainAxisCellCount: 1 ,
                              child: TSlideAnimation(
                                beginOffset: Offset(0, index.isEven ? 1 : -1),
                                child: DepartmentItem(
                                  department: controller.departmentsModel.value.departments![index],
                                  onTap: () {
                                    controller.toggleShowProjects(
                                      departmentID: controller.departmentsModel
                                          .value.departments![index].id!,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    controller.showProjects.value ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Sizes.spaceBtwSections.horizontalSpace,
                        Flexible(
                          fit: FlexFit.loose,
                          flex: HelperFunctions.isTabletScreen(context) ? 2 : 3,
                          child: const ProjectsList(),
                        ),
                      ],
                    ) : const SizedBox()
                  ],
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}