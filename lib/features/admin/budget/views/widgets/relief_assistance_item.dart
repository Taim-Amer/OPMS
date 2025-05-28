import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/controller/relief_assistance_controller.dart';
import 'package:opms/features/admin/budget/models/relief_assistance_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';

class ReliefAssistanceItem extends GetView<ReliefAssistanceController> {
  final ReliefAssistance reliefAssistance;
  final VoidCallback onTap;

  const ReliefAssistanceItem({
    super.key,
    required this.reliefAssistance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final redColor = Colors.red.shade700;
    final backgroundColor = isDark
        ? const Color(0xFF1E1E1E) // خلفية داكنة ناعمة
        : const Color(0xFFF5F5F5); // خلفية فاتحة هادئة

    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return TRoundedContainer(
      showBorder: true,
      radius: 12.r,
      borderColor: borderColor,
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      backgroundColor: backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.volunteer_activism,
            size: 32,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextWidget(
                      text: (reliefAssistance.type ?? 'Unknown Type').s16w700,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
                SizedBox(height: 6.h),
                TextWidget(
                  text: (reliefAssistance.description ?? 'No description provided.').s14w700,
                  fontSize: 14,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 18, color: redColor),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: (reliefAssistance.unitCost != null
                          ? '${reliefAssistance.unitCost}'
                          : 'N/A')
                          .s14w400,
                      fontSize: 14,
                      color: redColor,
                    ),
                    const Spacer(),
                    const Icon(Icons.date_range, size: 18),
                    SizedBox(width: 4.w),
                    TextWidget(
                      text: (reliefAssistance.date ?? 'No date').s14w400,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
