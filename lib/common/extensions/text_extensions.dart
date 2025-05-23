import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/utils/theme/custom_themes/text_theme.dart';

extension TextStyleExtensions on String {
  Text _getStyledText(TextStyle? darkStyle, TextStyle? lightStyle) {
    if (isEmpty) return const Text('');
    return Text(
      this,
      style: (Theme.of(Get.context!).brightness == Brightness.dark
          ? darkStyle
          : lightStyle) ?? const TextStyle(),
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

  Text get s16w700 => _getStyledText(
    TTextTheme.darkTextTheme.bodyLarge,
    TTextTheme.lightTextTheme.bodyLarge,
  );

  Text get s14w400 => _getStyledText(
    TTextTheme.darkTextTheme.bodyMedium,
    TTextTheme.lightTextTheme.bodyMedium,
  );
}