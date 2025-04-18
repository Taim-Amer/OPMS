import 'package:opms/dependencies/global_bindings.dart';
import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/helpers/helper_functions.dart';
import 'package:opms/utils/localization/translations.dart';
import 'package:opms/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Opms extends StatelessWidget {
  const Opms({super.key});

  @override
  Widget build(BuildContext context) {
    // String? token = TCacheHelper.getData(key: "token");
    // String initialRoute = token != null ? AppRoutes.order : AppRoutes.signin;
    // String? language = TCacheHelper.getData(key: "locale");
    return ScreenUtilInit(
      designSize: Size(THelperFunctions.screenWidth(context), THelperFunctions.screenHeight(context)),
      builder: (_, child) =>  GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // themeMode: ThemeMode.system,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        // initialRoute: initialRoute,
        // getPages: AppRoutes.routes,
        translations: TAppTranslations(),
        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        initialBinding: GlobalBindings(),
        // home: const LocationMap(),
        home: Container(color: TColors.redColor,),
      ),
    );
  }
}