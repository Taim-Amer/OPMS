import 'package:opms/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TFloatingActionButtonTheme{
  TFloatingActionButtonTheme._();

  static FloatingActionButtonThemeData lightFloatingActionTheme = const FloatingActionButtonThemeData(
    backgroundColor: TColors.primary,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  );

  static FloatingActionButtonThemeData darkFloatingActionTheme = const FloatingActionButtonThemeData(
    backgroundColor: TColors.primary,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  );
}