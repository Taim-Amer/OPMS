import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/running_cost_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class RunningCostItem extends StatelessWidget {
  const RunningCostItem({
    super.key,
    required this.runningCost,
    required this.onTap,
  });

  final RunningCost runningCost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);

    final borderColor = dark ? Colors.grey.shade800 : Colors.grey.shade300;
    final redColor = Colors.red.shade700;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: borderColor,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                text: (runningCost.expenseType ?? 'Unknown').s16w700,
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
              const Icon(Icons.category_outlined, size: 18),
              SizedBox(width: 6.w),
              TextWidget(
                text: (runningCost.unitType ?? 'Unit type N/A').s14w400,
              ),
              const Spacer(),
              const Icon(Icons.calendar_today_outlined, size: 18),
              SizedBox(width: 6.w),
              TextWidget(
                text: (runningCost.date ?? 'N/A').s12w400,
                fontSize: 13,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.attach_money, size: 18, color: redColor),
              SizedBox(width: 6.w),
              TextWidget(
                text: 'Cost: ${runningCost.unitCost ?? '0'}'.s14w700,
                color: redColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
