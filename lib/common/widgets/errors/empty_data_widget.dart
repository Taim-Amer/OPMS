// file: lib/common/widgets/empty_data_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/utils/constants/colors.dart';

/// A global “no data” placeholder.
///
/// Displays a centered icon and message, adapting to light/dark themes.
class EmptyDataWidget extends StatelessWidget {
  /// The main message to display, e.g. “No projects for this department.”
  final String message;

  /// Optional subtitle below the message (e.g. “Try adding one!”)
  final String? subtitle;

  const EmptyDataWidget({
    super.key,
    required this.message,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final iconColor = dark ? TColors.grey : TColors.darkGrey;
    final textColor = dark ? TColors.lightGrey : TColors.darkGrey;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 72.r,
            color: iconColor,
          ),
          SizedBox(height: 16.h),
          TextWidget(
            text: message.s17w700,
            color: textColor,
            fontSize: 18,
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            TextWidget(
              text: subtitle!.s14w400,
              color: textColor.withOpacity(0.7),
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
