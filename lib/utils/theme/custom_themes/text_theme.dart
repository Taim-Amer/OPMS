import 'package:flutter/material.dart';
import 'package:opms/utils/constants/colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: TColors.textPrimary , fontFamily: 'Cairo'),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: TColors.textPrimary, fontFamily: 'Cairo'),
    headlineSmall: const TextStyle().copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: TColors.textPrimary, fontFamily: 'Cairo'),

    titleLarge: const TextStyle().copyWith(fontSize: 17, fontWeight: FontWeight.w700, color: TColors.textPrimary, fontFamily: 'Cairo'),
    titleMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: TColors.textPrimary, fontFamily: 'Cairo'),
    titleSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: TColors.textPrimary, fontFamily: 'Cairo'),

    bodyLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: TColors.textPrimary, fontFamily: 'Cairo'),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.textPrimary, fontFamily: 'Cairo'),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: TColors.textPrimary, fontFamily: 'Cairo'),

    labelLarge: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.textPrimary, fontFamily: 'Cairo'),
    labelMedium: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: TColors.textPrimary, fontFamily: 'Cairo'),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: TColors.white, fontFamily: 'Cairo'),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: TColors.white, fontFamily: 'Cairo'),
    headlineSmall: const TextStyle().copyWith(fontSize: 13, fontWeight: FontWeight.w400, color: TColors.white, fontFamily: 'Cairo'),

    titleLarge: const TextStyle().copyWith(fontSize: 17, fontWeight: FontWeight.w700, color: TColors.white, fontFamily: 'Cairo'),
    titleMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: TColors.white, fontFamily: 'Cairo'),
    titleSmall: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: TColors.white, fontFamily: 'Cairo'),

    bodyLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: TColors.white, fontFamily: 'Cairo'),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: TColors.white, fontFamily: 'Cairo'),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: TColors.white, fontFamily: 'Cairo'),

    labelLarge: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: TColors.white, fontFamily: 'Cairo'),
    labelMedium: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: TColors.white, fontFamily: 'Cairo'),
  );
}