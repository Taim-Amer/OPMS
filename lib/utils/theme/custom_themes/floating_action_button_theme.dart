import 'package:opms/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TFloatingActionButtonTheme{
  TFloatingActionButtonTheme._();

  static FloatingActionButtonThemeData lightFloatingActionTheme = FloatingActionButtonThemeData(
    backgroundColor: TColors.primary,
    foregroundColor: Colors.white,
    shape: const CircleBorder(),
  );

  static FloatingActionButtonThemeData darkFloatingActionTheme = FloatingActionButtonThemeData(
    backgroundColor: TColors.primary,
    foregroundColor: Colors.white,
    shape: const CircleBorder(),
  );
}