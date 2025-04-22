import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/buttons/custom_button.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/common/widgets/layouts/lists/list_layout.dart';
import 'package:opms/features/home/views/widgets/department_item.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class HomeDesktopScreen extends StatelessWidget {
  const HomeDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return TRoundedContainer(
      backgroundColor: dark ? TColors.deepBlack : Colors.white,
      radius: 0,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: 'Departments'.s16w700,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        softWrap: true,
                      ),
                      const CustomButton(
                        title: '+ New',
                        radius: 6,
                        height: 40,
                        // color: ,
                      )
                    ],
                  ),
                  Sizes.spaceBtwSections.verticalSpace,
                  Expanded(
                    child: TListView(
                      itemCount: 12,
                      // shrink: true,
                      itemBuilder: (context, index) => const DepartmentItem(),
                      separatorBuilder: (context, _) => Sizes.spaceBtwItems.verticalSpace,
                    ),
                  ),
                ],
              ),
            ),
            Sizes.spaceBtwSections.horizontalSpace,
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const TRoundedContainer(
                    height: 500,
                    backgroundColor: Colors.orangeAccent,
                  ),
                  Sizes.spaceBtwSections.verticalSpace,
                  const Column(
                    children: [
                      DepartmentItem(),
                      DepartmentItem(),
                      DepartmentItem(),
                      DepartmentItem(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
