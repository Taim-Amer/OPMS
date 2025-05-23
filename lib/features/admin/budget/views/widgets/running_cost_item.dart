import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/running_cost_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class RunningCostItem extends StatelessWidget {
  const RunningCostItem({super.key, required this.runningCost});

  final RunningCost runningCost;

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
        children: [
          TextWidget(
            text: (runningCost.expenseType ?? 'Unknown').s16w700,
            fontSize: 18,
            color: dark ? TColors.light : TColors.dark,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Icon(Icons.category_outlined, size: 18, color: TColors.primary),
              SizedBox(width: 6.w),
              TextWidget(
                text: (runningCost.unitType ?? 'Unit type N/A').s14w400,
              ),
              const Spacer(),
              const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.blueGrey),
              SizedBox(width: 6.w),
              TextWidget(
                text: (runningCost.date ?? 'N/A').s12w400,
                fontSize: 13,
                color: Colors.blueGrey,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              const Icon(Icons.attach_money, size: 18, color: Colors.green),
              SizedBox(width: 6.w),
              TextWidget(
                text: 'Cost: ${runningCost.unitCost ?? '0'}'.s14w700,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
