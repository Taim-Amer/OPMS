import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/images/rounded_image.dart';
import 'package:opms/features/admin/outcomes/controllers/outcomes_controller.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/validation.dart';
import 'package:flutter/material.dart';

class UpdateOutcomeDialog extends GetView<OutcomesController> {
  const UpdateOutcomeDialog({super.key, required this.outcomeID,});

  final int outcomeID;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500.w,
            maxHeight: 600.h,
          ),
          child: TSlideAnimation(
            beginOffset: const Offset(0, 1),
            child: TRoundedContainer(
              backgroundColor: dark ? TColors.dark : TColors.lightGrey,
              padding: EdgeInsets.all(Sizes.secondaryPaddingSpace.w),
              margin: EdgeInsets.all(Sizes.defaultPaddingSpace.w),
              // width: HelperFunctions.isMobileScreen(context) ? double.infinity : 50,
              child: Form(
                key: controller.updateFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TRoundedImage(
                      imageUrl: ImagesAssets.edit,
                      useHero: false,
                      width: 100.h,
                      height: 100.h,
                      backgroundColor: Colors.transparent,
                      borderRadius: 0,
                    ),
                    Sizes.spaceBtwSections.verticalSpace,
                    'Update role name from here'.s17w700,
                    Sizes.spaceBtwSections.verticalSpace,
                    LabeledTextFeild(
                      label: '',
                      controller: controller.updateOutcomeController,
                      hint: 'New outcome name',
                      validator: (value) => Validator.validateEmptyText('outcome name', value),
                    ),
                    Sizes.spaceBtwItems.verticalSpace,
                    LabeledTextFeild(
                      label: '',
                      controller: controller.updateCodeController,
                      hint: 'New outcome code',
                      validator: (value) => Validator.validateEmptyText('outcome code', value),
                    ),
                    Sizes.spaceBtwItems.verticalSpace,
                    GetBuilder<OutcomesController>(
                      builder: (controller) => SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          title: 'Update',
                          isLoading: controller.updateOutcomesState == RequestState.loading,
                          onTap: () => controller.updateOutcome(outcomeID: outcomeID),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
