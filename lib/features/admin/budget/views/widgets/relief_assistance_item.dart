import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/relief_assistance_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class ReliefAssistanceItem extends StatelessWidget {
  final ReliefAssistance reliefAssistance;

  const ReliefAssistanceItem({
    super.key, required this.reliefAssistance,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: dark ? TColors.darkBorder : TColors.lightBorder,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: dark ? TColors.dark : TColors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.volunteer_activism,
            color: TColors.primary,
            size: 32,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: (reliefAssistance.type ?? 'Unknown Type').s16w700,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 6.h),
                TextWidget(
                  text: (reliefAssistance.description ?? 'No description provided.').s14w700,
                  fontSize: 14,
                  color: dark ? TColors.light : TColors.dark,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 18, color: Colors.green),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: (reliefAssistance.unitCost != null ? '${reliefAssistance.unitCost}' : 'N/A').s14w400,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                    const Spacer(),
                    const Icon(Icons.date_range, size: 18, color: Colors.blueGrey),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: (reliefAssistance.date ?? 'No date').s14w400,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                TextWidget(
                  text: 'ID: ${reliefAssistance.id ?? 'N/A'}'.s14w400,
                  fontSize: 12,
                  color: dark ? TColors.light : TColors.dark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
