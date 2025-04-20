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

class HomeMobileScreen extends StatelessWidget {
  const HomeMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return TRoundedContainer(
      backgroundColor: dark ? TColors.deepBlack : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.secondaryPaddingSpace),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TRoundedContainer(
                height: 300,
                backgroundColor: Colors.orangeAccent,
              ),
              Sizes.spaceBtwSections.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Departments'.s16w700,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    softWrap: true,
                  ),
                  const CustomButton(
                    title: '+ New',
                    radius: 6,
                    height: 36,
                  ),
                ],
              ),
              Sizes.spaceBtwSections.verticalSpace,
              TListView(
                itemCount: 12,
                shrink: true,
                physics: const NeverScrollableScrollPhysics(), // Scroll خارجي
                itemBuilder: (context, index) => const DepartmentItem(),
                separatorBuilder: (context, _) => Sizes.spaceBtwItems.verticalSpace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
