import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/utils/theme/custom_themes/text_theme.dart';

extension TextStyleExtensions on String {
  /// Scales [base] by .sp, then clamps to [min]..[max].
  /// to pervent the texts from getting too large or too small
  static double _safeSp(double base, {double min = 13.0, double max = 30.0}) {
    final scaled = base.sp;
    return (scaled.clamp(min, max) as double);
  }

  Text _getStyledText(TextStyle? darkStyle, TextStyle? lightStyle) {
    if (isEmpty) return const Text('');

    // 1) pick the correct theme style
    final baseStyle = (Theme.of(Get.context!).brightness == Brightness.dark
        ? darkStyle
        : lightStyle);

    // 2) if it had a fontSize, apply safe scaling+clamp
    final styled = (baseStyle != null && baseStyle.fontSize != null)
        ? baseStyle.copyWith(
            fontSize: _safeSp(baseStyle.fontSize!),
          )
        : baseStyle;

    return Text(
      this,
      style: styled ?? const TextStyle(),
    );
  }

  Text get s24w700 => _getStyledText(
        TTextTheme.darkTextTheme.headlineLarge,
        TTextTheme.lightTextTheme.headlineLarge,
      );

  Text get s16w400 => _getStyledText(
        TTextTheme.darkTextTheme.bodyLarge,
        TTextTheme.lightTextTheme.bodyLarge,
      );

  Text get s17w400 => _getStyledText(
        // original override to 17 → now safeSp(17)
        TTextTheme.darkTextTheme.headlineSmall?.copyWith(fontSize: 17),
        TTextTheme.lightTextTheme.headlineSmall?.copyWith(fontSize: 17),
      );

  Text get s17w700 => _getStyledText(
        TTextTheme.darkTextTheme.titleLarge,
        TTextTheme.lightTextTheme.titleLarge,
      );

  Text get s14w700 => _getStyledText(
        TTextTheme.darkTextTheme.titleMedium,
        TTextTheme.lightTextTheme.titleMedium,
      );

  Text get s12w400 => _getStyledText(
        TTextTheme.darkTextTheme.titleSmall,
        TTextTheme.lightTextTheme.titleSmall,
      );
       Text get s12w700 => _getStyledText(
        TTextTheme.darkTextTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
        TTextTheme.lightTextTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
      );

  Text get s16w700 => _getStyledText(
        TTextTheme.darkTextTheme.bodyLarge,
        TTextTheme.lightTextTheme.bodyLarge,
      );

  Text get s14w400 => _getStyledText(
        TTextTheme.darkTextTheme.bodyMedium,
        TTextTheme.lightTextTheme.bodyMedium,
      );
}
