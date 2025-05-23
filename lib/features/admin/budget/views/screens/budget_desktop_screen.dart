import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/budget/controller/budget_controller.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/views/widgets/budget_options_list.dart';
import 'package:opms/features/admin/budget/views/widgets/relief_assistance_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BudgetDesktopScreen extends StatelessWidget {
  const BudgetDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TSiteTemplate(
      useLayout: false,
      clickableSidebar: true,
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
                text: 'Budget'.s17w700,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
              Sizes.spaceBtwSections.verticalSpace,
              Expanded(
                child: GetBuilder<BudgetController>(
                  builder: (controller) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: controller.itemsList[controller.selectedChip],
                      ),
                      Sizes.spaceBtwSections.horizontalSpace,
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            const BudgetOptionsList(),
                            Sizes.spaceBtwSections.verticalSpace,
                            const Expanded(
                              flex: 2,
                              child: TRoundedContainer(
                                backgroundColor: TColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
