import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/data_table/pagination_controls.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/coordinator/home/controllers/home_controller.dart';
import 'package:opms/features/coordinator/home/views/widgets/home_district_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeDesktopScreen extends GetView<HomeController> {
  const HomeDesktopScreen({super.key, required this.fromAnother});

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
            children: [
              TextWidget(
                text: 'Home'.s16w700,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
              Sizes.spaceBtwSections.verticalSpace,
              Expanded(
                child: GetBuilder<HomeController>(
                  builder: (controller) {
                    final home = controller.homeModel.data ?? [];

                    return Column(
                      children: [
                        Expanded(
                          child: Skeletonizer(
                            enabled: controller.getHomeState == RequestState.loading,
                            child: StaggeredGrid.count(
                              crossAxisCount: HelperFunctions.isMobileScreen(context)
                                  ? 2
                                  : HelperFunctions.isTabletScreen(context)
                                  ? 3
                                  : 5,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: List.generate(
                                home.length,
                                    (index) {
                                  final district = home.reversed.elementAt(index);
                                  return StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: .4,
                                    child: TSlideAnimation(
                                      beginOffset: Offset(0, index.isEven ? 1 : -1),
                                      child: HomeDistrictItem(district: district),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        TPaginationControls(
                          totalItemCount: controller.homeModel.meta?.total ?? 0,
                          currentPage: controller.currentPage,
                          totalPages: controller.totalPages,
                          perPage: controller.perPage,
                          perPageOptions: const [5, 10, 20, 50],
                          onPrevious: () {
                            if (controller.currentPage > 1) {
                              controller.getHome(page: controller.currentPage - 1);
                            }
                          },
                          onNext: () {
                            if (controller.currentPage < controller.totalPages) {
                              controller.getHome(page: controller.currentPage + 1);
                            }
                          },
                          onPerPageChanged: (newPerPage) {
                            controller.perPage = newPerPage;
                            controller.getHome(page: 1, perPageOverride: newPerPage);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
