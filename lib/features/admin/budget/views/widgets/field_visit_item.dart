import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/features/admin/budget/models/field_visit_model.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/sizes.dart';
import 'package:opms/common/extensions/text_extensions.dart';

class FieldVisitItem extends StatelessWidget {
  const FieldVisitItem({
    super.key,
    required this.fieldVisit,
    required this.onTap,
  });

  final FieldVisit fieldVisit;
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
                text: (fieldVisit.unitType ?? 'Field Visit').s16w700,
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
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.description_outlined, size: 18),
              SizedBox(width: 6.w),
              Expanded(
                child: TextWidget(
                  text: (fieldVisit.description ?? 'No description').s14w400,
                  fontSize: 14,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.monetization_on_outlined, size: 18, color: redColor),
              SizedBox(width: 6.w),
              TextWidget(
                text: 'Unit Price: ${fieldVisit.unitPrice ?? '0'}'.s14w700,
                fontSize: 14,
                color: redColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

