import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:opms/common/animations/circular_motion_animation.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/utils/constants/sizes.dart';

class TEmptyForm extends StatelessWidget {
  const TEmptyForm({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.showButton = false,
    this.buttonTitle = '',
    this.onTap,
  });

  final String image;
  final String title;
  final String subTitle;
  final bool showButton;
  final String buttonTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.secondaryPaddingSpace),
      child: Expanded(
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TCircularMotionAnimation(child: SvgPicture.asset(image)),
                23.verticalSpace,
                Text(title,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center),
                12.verticalSpace,
                Text(subTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
                if (showButton) ...[
                  Sizes.spaceBtwSections.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      title: buttonTitle,
                      onTap:  onTap,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
