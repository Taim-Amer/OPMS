// file: lib/common/widgets/error_display_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/common/extensions/text_extensions.dart';
import 'package:opms/common/widgets/handlers/text_widget.dart';
import 'package:opms/utils/constants/colors.dart';

/// A global error placeholder for dashboards.
///
/// Displays an error icon, message, and an optional Retry button.
class ErrorDisplayWidget extends StatelessWidget {
  /// The error message to show.
  final String message;

  /// Optional callback to retry the failed action.
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    const iconColor = Colors.redAccent;
    final textColor = dark ? TColors.light : Colors.black87;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.r,
              color: iconColor,
            ),
            SizedBox(height: 16.h),
            TextWidget(
              text: message.s16w400,
              color: textColor,
              fontSize: 16,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded,
                    color: Colors.white, size: 20),
                label: TextWidget(
                  text: 'Retry'.s14w700,
                  color: Colors.white,
                  fontSize: 14,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
