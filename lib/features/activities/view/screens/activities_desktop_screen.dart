import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/data_table/pagination_controls.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/activities/controller/activities_controller.dart';
import 'package:opms/features/activities/view/widgets/activity_item.dart';
import 'package:opms/features/activities/view/widgets/insert_activity_container.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActivitiesDesktopScreen extends GetView<ActivitiesController> {
  const ActivitiesDesktopScreen({super.key, this.fromAnother = false});

  final bool fromAnother;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TSiteTemplate(
      useLayout: fromAnother,
      clickableSidebar: false,
      desktop: TRoundedContainer(
        backgroundColor: dark ? TColors.black2 : Colors.white,
        radius: 0,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: 'Activities'.s17w700,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
              Sizes.spaceBtwSections.verticalSpace,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: GetBuilder<ActivitiesController>(
                        builder: (controller) => Skeletonizer(
                          enabled: controller.getActivitiesStatus == RequestState.loading,
                          child: Column(
                            children: [
                              Expanded(
                                child: TGridLayout(
                                  // animationType: AnimationType.slide,
                                  crossCount: HelperFunctions.isTabletScreen(context) || HelperFunctions.isMobileScreen(context) ? 1 : 3,
                                  mainAxisExtent: 150,
                                  itemCount: controller.activitiesModel.data?.length ?? 0,
                                  itemBuilder: (context, index) => TSlideAnimation(
                                    beginOffset: Offset(index.isEven ? -1 : 1, 0),
                                    child: ActivityItem(
                                      activity: controller.activitiesModel.data![index],
                                    ),
                                  ),
                                ),
                              ),
                              TPaginationControls(
                                totalItemCount: controller.activitiesModel.meta?.total ?? 0,
                                currentPage: controller.currentPage,
                                totalPages: controller.totalPages,
                                perPage: controller.perPage,
                                perPageOptions: const [5, 10, 20, 50],
                                onPrevious: () {
                                  controller.getActivities(page: controller.currentPage - 1);
                                },
                                onNext: () {
                                  controller.getActivities(page: controller.currentPage + 1);
                                },
                                onPerPageChanged: (newPerPage) {
                                  controller.perPage = newPerPage;
                                  controller.getActivities(page: 1, perPageOverride: newPerPage);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if(!HelperFunctions.isMobileScreen(context)) ...[
                      Sizes.spaceBtwSections.horizontalSpace,
                      Expanded(
                        flex: HelperFunctions.isTabletScreen(context) ? 2 : 1,
                        child: InsertActivityContainer(enable: fromAnother,),
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
