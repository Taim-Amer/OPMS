import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/dialogs/insert_dialog.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/grid_layout.dart';
import 'package:opms/features/admin/factors/controllers/factors_controller.dart';
import 'package:opms/features/admin/factors/views/widgets/factor_item.dart';
import 'package:opms/features/admin/factors/views/widgets/insert_factors_container.dart';
import 'package:opms/features/admin/roles/views/widgets/insert_role_container.dart';
import 'package:opms/features/admin/roles/controllers/roles_controller.dart';
import 'package:opms/features/admin/roles/views/widgets/role_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FactorsDesktopScreen extends StatelessWidget {
  const FactorsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TRoundedContainer(
      backgroundColor: dark ? TColors.black2 : Colors.white,
      radius: 2,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextWidget(
                  text: 'Factors'.s16w700,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  softWrap: true,
                ),
              ],
            ),
            Sizes.spaceBtwSections.verticalSpace,
            Expanded(
              child: GetBuilder<FactorsController>(
                builder: (controller) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: HelperFunctions.isTabletScreen(context) ? 2 : 3,
                      child: TGridLayout(
                          itemCount: controller.factorsModel.data?.length ?? 0,
                          // shrink: true,
                          crossCount: HelperFunctions.isTabletScreen(context) ? 1 : 3,
                          itemBuilder: (context, index) => Skeletonizer(
                            enabled: controller.getFactorsState == RequestState.loading,
                            child: FactorItem(
                              factor: controller.factorsModel.data![index],
                              onEditTap: () {
                                controller.updateFactorTitleController.text = controller.factorsModel.data?[index].title ?? '';
                                final fields = [
                                  InsertFieldConfig(
                                      label: '',
                                      controller: controller.updateFactorTitleController,
                                      hint: 'Enter Factor Title',
                                      validator: (value) => Validator.validateEmptyText('factor', value)
                                  ),
                                ];

                                Get.dialog(
                                  InsertRecordDialog(
                                    title: 'Update Factor',
                                    fields: fields,
                                    submitStatus: controller.updateFactorsState,
                                    onSubmit: () => controller.updateFactor(factorID: controller.factorsModel.data?[index].id ?? 0),
                                    showAsset: true,
                                  ),
                                );
                              },
                            ),
                          ),
                          mainAxisExtent: 150.h,
                          animationType: AnimationType.slide,
                          // separatorBuilder: (context, _) => Sizes.spaceBtwItems.verticalSpace,
                        ),
                    ),
                    Sizes.spaceBtwSections.horizontalSpace,
                    Expanded(
                      flex: HelperFunctions.isTabletScreen(context) ? 2 : 1,
                      child: const InsertFactorContainer(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
