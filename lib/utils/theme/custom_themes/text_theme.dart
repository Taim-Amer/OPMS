import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF6D6E72)),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF383838)),
    headlineSmall: const TextStyle().copyWith(fontSize: 18, fontWeight: FontWeight.w400, color: const Color(0xFFA9A9A9)),

    titleLarge: const TextStyle().copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF383838)),
    titleMedium: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF6D6E72)),
    titleSmall: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF6D6E72)),

    bodyLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF383838)),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: const Color(0xFF383838)),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black.withOpacity(.5)),

    labelLarge: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFFC6C6C6)),
    labelMedium: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: const Color(0xFFC6C6C6)),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: const TextStyle().copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
    headlineSmall: const TextStyle().copyWith(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),

    titleLarge: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    titleMedium: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: const TextStyle().copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),

    bodyLarge: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: const TextStyle().copyWith(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(.5)),

    labelLarge: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.normal, color: const Color(0xFFC6C6C6)),
    labelMedium: const TextStyle().copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(.5)),);
}