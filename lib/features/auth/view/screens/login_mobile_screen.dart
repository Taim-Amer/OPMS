import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/fields/labeled_text_feild.dart';
import 'package:opms/common/widgets/images/circular_image.dart';
import 'package:opms/utils/constants/assets.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class LoginMobileScreen extends StatelessWidget {
  const LoginMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultPaddingSpace),
        child: Center(
          child: SizedBox(
            width: 550.h,
            child: SingleChildScrollView(
              child: TRoundedContainer(
                padding: const EdgeInsets.all((Sizes.spaceBtwSections * 2)),
                backgroundColor: dark ? TColors.dark : TColors.white,
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
                          'login title'.s17w700,
                          Sizes.sm.verticalSpace,
                          'Login Sub title'.s13w400,
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        LabeledTextFeild(
                          label: '',
                          controller: TextEditingController(),
                          hint: 'email',
                          prefix: const Icon(Iconsax.direct_right),
                        ),
                        LabeledTextFeild(
                          label: '',
                          controller: TextEditingController(),
                          prefix: const Icon(Iconsax.lock),
                          hint: 'password',
                          isPassword: true,
                        ),
                        (Sizes.spaceBtwItems * 2).verticalSpace,
                        SizedBox(
                          height: 45.h,
                          width: double.infinity,
                          child: const CustomButton(title: 'Login'),
                        )
                      ],
                    )
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
