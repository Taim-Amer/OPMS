import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/helpers/validation.dart';

class InsertRoleContainer extends StatelessWidget {
  const InsertRoleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return GetBuilder<RolesController>(
      builder: (controller) => Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          child: TRoundedContainer(
          backgroundColor: dark ? TColors.dark : TColors.lightGrey,
          height: !HelperFunctions.isMobileScreen(context) ? 1.sh : null,
          width: 400.w,
          padding: EdgeInsets.all(Sizes.secondaryPaddingSpace.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TRoundedImage(
                  imageUrl: ImagesAssets.add,
                  useHero: false,
                  width: 100.h,
                  height: 100.h,
                  backgroundColor: Colors.transparent,
                  borderRadius: 0,
                ),
                Sizes.spaceBtwSections.verticalSpace,
                'Insert new role form here'.s17w700,
                Sizes.spaceBtwSections.verticalSpace,
                LabeledTextFeild(
                  label: '',
                  controller: controller.roleNameController,
                  hint: 'Role Name',
                  validator: (value) => Validator.validateEmptyText('role name', value),
                ),
                Sizes.spaceBtwItems.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: 'Insert',
                    isLoading: controller.insertRolesState == RequestState.loading,
                    onTap: () => controller.insertRole(),
                  ),
                )
              ],
            ),
          ),
              ),
        ),
      ),
    );
  }
}
