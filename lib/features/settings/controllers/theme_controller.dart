import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/theme/theme.dart';

class ThemeController extends GetxController{
  @override
  void onInit() {
    String? savedTheme = CacheHelper.getData(key: Keys.theme);
    if (savedTheme == "light") {
      themeMode.value = ThemeMode.light;
    } else if (savedTheme == "dark") {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
    super.onInit();
  }

  var themeMode = ThemeMode.light.obs;

  ThemeData getTheme(ThemeMode themeMode){
    return themeMode == ThemeMode.light ? AppTheme.lightTheme : AppTheme.darkTheme;
  }
  void updateThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    String themeString = mode == ThemeMode.light ? "light" : mode == ThemeMode.dark ? "dark" : "system";
    CacheHelper.saveData(key: Keys.theme, value: themeString);
  }
}