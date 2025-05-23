import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/images/circular_image.dart';
import 'package:opms/features/admin/auth/controller/login_controller.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/utils/helpers/validation.dart';

class LoginDesktopScreen extends GetView<LoginController> {
  const LoginDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 550.h,
          child: SingleChildScrollView(
            child: TRoundedContainer(
              padding: const EdgeInsets.all((Sizes.spaceBtwSections * 2)),
              backgroundColor: dark ? TColors.dark : TColors.white,
              showShadow: true,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              radius: Sizes.cardRadiusLg,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TCircularImage(
                          image: ImagesAssets.logo,
                          backgroundColor: Colors.transparent,
                          width: 150,
                          height: 170,
                        ),
                        Sizes.spaceBtwSections.verticalSpace,
                        'Welcome to the Red Crescent Management System'.s17w700,
                        Sizes.sm.verticalSpace,
                        'Please sign in to access your dashboard and manage operations efficiently.'.s17w400,
                      ],
                    ),
                  ),
                  Sizes.spaceBtwSections.verticalSpace,
                  Column(
                    children: [
                      LabeledTextFeild(
                        label: '',
                        controller: controller.emailController,
                        hint: 'Email Address',
                        prefix: const Icon(Iconsax.direct_right),
                        validator: (value) => Validator.validateEmail(value),
                      ),
                      Sizes.spaceBtwItems.verticalSpace,
                      LabeledTextFeild(
                        label: '',
                        controller: controller.passwordController,
                        prefix: const Icon(Iconsax.lock),
                        hint: 'Security Code',
                        isPassword: true,
                        validator: (value) => Validator.validateEmptyText(value, 'Security Code'),
                      ),
                      Sizes.spaceBtwItems.verticalSpace,
                      GetBuilder<LoginController>(builder: (controller) => SizedBox(
                        height: 45.h,
                        width: double.infinity,
                        child: CustomButton(
                          title: 'Login',
                          isLoading: controller.loginState == RequestState.loading,
                          onTap: () => controller.login(),
                        ),
                      ))
                    ],
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
