import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class DepartmentItem extends StatelessWidget {
  const DepartmentItem({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    return TRoundedContainer(
      // height: 70.h,
      showBorder: true,
      radius: 6,
      borderColor: dark ? TColors.grey.withOpacity(.3) : TColors.grey,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: Colors.transparent,
      child: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'IT Telecome Depatrments'.s16w700,
                  fontWeight: FontWeight.w700,
                  softWrap: true,
                ),
                TextWidget(
                  text: '+5 from yesterday'.s13w400,
                  fontSize: 13,
                  softWrap: true,
                )
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: dark ? TColors.light : TColors.dark,
          )
        ],
      )),
    );
  }
}
