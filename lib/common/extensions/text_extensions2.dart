// lib/common/extensions/text_style_extensions_with_context.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opms/utils/theme/custom_themes/text_theme.dart';

extension TextStyleExtensionsWithContext on String {
  static double _safeSp(double base, {double min = 13.0, double max = 30.0}) {
    return (base.sp.clamp(min, max) as double);
  }

  Text _getStyledText(
    BuildContext context,
    TextStyle? darkStyle,
    TextStyle? lightStyle,
  ) {
    if (isEmpty) return const Text('');

    final brightness = Theme.of(context).brightness;
    final baseStyle = brightness == Brightness.dark ? darkStyle : lightStyle;
    final styled = (baseStyle != null && baseStyle.fontSize != null)
        ? baseStyle.copyWith(fontSize: _safeSp(baseStyle.fontSize!))
        : baseStyle;

    return Text(this, style: styled ?? const TextStyle());
  }

  Text s24w700(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.headlineLarge,
        TTextTheme.lightTextTheme.headlineLarge,
      );
  Text s16w400(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.bodyLarge,
        TTextTheme.lightTextTheme.bodyLarge,
      );
  Text s17w400(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.headlineSmall?.copyWith(fontSize: 17),
        TTextTheme.lightTextTheme.headlineSmall?.copyWith(fontSize: 17),
      );
  Text s17w700(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.titleLarge,
        TTextTheme.lightTextTheme.titleLarge,
      );
  Text s14w700(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.titleMedium,
        TTextTheme.lightTextTheme.titleMedium,
      );
  Text s12w400(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.titleSmall,
        TTextTheme.lightTextTheme.titleSmall,
      );
  Text s12w700(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.titleSmall!
            .copyWith(fontWeight: FontWeight.w700),
        TTextTheme.lightTextTheme.titleSmall!
            .copyWith(fontWeight: FontWeight.w700),
      );
  Text s16w700(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.bodyLarge,
        TTextTheme.lightTextTheme.bodyLarge,
      );
  Text s14w400(BuildContext context) => _getStyledText(
        context,
        TTextTheme.darkTextTheme.bodyMedium,
        TTextTheme.lightTextTheme.bodyMedium,
      );
}
