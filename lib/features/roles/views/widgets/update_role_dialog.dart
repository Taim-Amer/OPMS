import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/animations/slide_animation.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/images/rounded_image.dart';
import 'package:opms/features/roles/controllers/roles_controller.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/validation.dart';

class UpdateRoleDialog extends GetView<RolesController> {
  const UpdateRoleDialog({super.key, required this.roleID});

  final int roleID;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500.w,
            maxHeight: 500.h,
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
                      controller: controller.updateRoleController,
                      hint: 'New role Name',
                      validator: (value) => Validator.validateEmptyText('role name', value),
                    ),
                    Sizes.spaceBtwItems.verticalSpace,
                    GetBuilder<RolesController>(
                        builder: (controller) => SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            title: 'Update',
                            isLoading: controller.updateRolesState == RequestState.loading,
                            onTap: () => controller.updateRole(roleID: roleID),
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
