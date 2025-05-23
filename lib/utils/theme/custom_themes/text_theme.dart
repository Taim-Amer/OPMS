import 'package:flutter/material.dart';
import 'package:opms/utils/constants/colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: TColors.textPrimary),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: TColors.textPrimary),
    headlineSmall: const TextStyle().copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: TColors.textPrimary),

    titleLarge: const TextStyle().copyWith(fontSize: 17, fontWeight: FontWeight.w700, color: TColors.textPrimary),
    titleMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: TColors.textPrimary),
    titleSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: TColors.textPrimary),

    bodyLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: TColors.textPrimary),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.textPrimary),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: TColors.textPrimary),

    labelLarge: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.textPrimary),
    labelMedium: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: TColors.textPrimary),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: TColors.white),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: TColors.white),
    headlineSmall: const TextStyle().copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: TColors.white),

    titleLarge: const TextStyle().copyWith(fontSize: 17, fontWeight: FontWeight.w700, color: TColors.white),
    titleMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: TColors.white),
    titleSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: TColors.white),

    bodyLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: TColors.white),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.white),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: TColors.white),

    labelLarge: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: TColors.white),
    labelMedium: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: TColors.white),
  );
}