import 'package:opms/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme(bool isSelected) {
    return ChipThemeData(
      disabledColor: Colors.white,
      backgroundColor: isSelected ? TColors.buttonPrimary : Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : TColors.buttonPrimary, // Dynamically set the text color
      ),
      selectedColor: TColors.buttonPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: isSelected ? Colors.white : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: isSelected ? Colors.transparent : TColors.buttonPrimary,
          width: 1.5,
        ),
      ),
    );
  }

  static ChipThemeData darkChipTheme(bool isSelected) {
    return ChipThemeData(
      disabledColor: Colors.white,
      backgroundColor: isSelected ? TColors.buttonPrimary : Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : TColors.buttonPrimary, // Dynamically set the text color
      ),
      selectedColor: TColors.buttonPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: isSelected ? Colors.white : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: isSelected ? Colors.transparent : TColors.buttonPrimary,
          width: 1.5,
        ),
      ),
    );
  }
}
