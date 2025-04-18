import 'package:opms/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TSwitchButtonTheme{
  TSwitchButtonTheme._();

  static SwitchThemeData lightSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return TColors.white;
        }
        return Colors.grey;
      },
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      return Colors.transparent;
    },
    ),
    trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return TColors.primary;
        }
        return Colors.grey.withOpacity(0.2);
      },
    ),
  );

  static SwitchThemeData darkSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return TColors.white;
      }
      return Colors.grey;
    },
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      return Colors.transparent;
    },
    ),
    trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF009B3C);
      }
      return Colors.grey.withOpacity(0.2);
    },
    ),
  );
}