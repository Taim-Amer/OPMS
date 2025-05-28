import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/salaries_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class SalaryItem extends StatelessWidget {
  const SalaryItem({super.key, required this.salary, required this.onTap});

  final Salary salary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final redColor = Colors.red.shade700;
    final backgroundColor = isDark
        ? const Color(0xFF1E1E1E) // لون داكن ناعم في الوضع المظلم
        : const Color(0xFFF5F5F5); // لون فاتح ناعم في الوضع الفاتح

    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: borderColor,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              TextWidget(
                text: (salary.type ?? 'Unknown Type').s16w700,
                fontSize: 18,
              ),
              IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.work_outline, size: 18),
              SizedBox(width: 6.w),
              Expanded(
                child: TextWidget(
                  text: (salary.positions ?? 'No positions').s14w400,
                ),
              ),
              const Icon(Icons.date_range, size: 18),
              SizedBox(width: 6.w),
              TextWidget(
                text: (salary.date ?? 'N/A').s12w400,
                fontSize: 13,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.monetization_on_outlined, size: 18, color: redColor),
                  SizedBox(width: 6.w),
                  TextWidget(
                    text: 'Salary: ${salary.salary ?? 0}'.s14w700,
                    color: redColor,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.attach_money_outlined, size: 18),
                  SizedBox(width: 6.w),
                  TextWidget(
                    text: 'Allowance: ${salary.costOfLivingAllowance ?? 0}'.s14w400,
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
