import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/salaries_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class SalaryItem extends StatelessWidget {
  const SalaryItem({super.key, required this.salary});

  final Salary salary;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: dark ? TColors.dark : TColors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: (salary.type ?? 'Unknown Type').s16w700,
            fontSize: 18,
            color: dark ? TColors.light : TColors.dark,
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              const Icon(Icons.work_outline, size: 18, color: TColors.primary),
              SizedBox(width: 6.w),
              Expanded(
                child: TextWidget(
                  text: (salary.positions ?? 'No positions').s14w400,
                ),
              ),
              const Icon(Icons.date_range, size: 18, color: Colors.blueGrey),
              SizedBox(width: 6.w),
              TextWidget(
                text: (salary.date ?? 'N/A').s12w400,
                fontSize: 13,
                color: Colors.blueGrey,
              ),
            ],
          ),

          SizedBox(height: 6.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.monetization_on_outlined, size: 18, color: Colors.green),
                  SizedBox(width: 6.w),
                  TextWidget(
                    text: 'Salary: ${salary.salary ?? 0}'.s14w700,
                    color: Colors.green,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.attach_money_outlined, size: 18, color: Colors.orange),
                  SizedBox(width: 6.w),
                  TextWidget(
                    text: 'Allowance: ${salary.costOfLivingAllowance ?? 0}'.s14w400,
                    color: Colors.orange,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
