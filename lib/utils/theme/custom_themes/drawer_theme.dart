import 'package:opms/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TDrawerTheme{
  TDrawerTheme._();

  static DrawerThemeData lightDrawerTheme = const DrawerThemeData(
    width: 270,
    backgroundColor: Colors.white,
  );

  static DrawerThemeData darkDrawerTheme = const DrawerThemeData(
    width: 270,
    backgroundColor: TColors.dark,
  );
}
