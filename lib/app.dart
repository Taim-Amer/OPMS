import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/dependencies/global_bindings.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
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
    String? token = CacheHelper.getData(key: TKeys.token);
    // String initialRoute = token != null ? AppRoutes.order : AppRoutes.signin;
    String? language = CacheHelper.getData(key: TKeys.language);
    return ScreenUtilInit(
      designSize: Size(HelperFunctions.screenWidth(context), HelperFunctions.screenHeight(context)),
      builder: (_, child) =>  GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        // initialRoute: initialRoute,
        // getPages: AppRoutes.routes,
        translations: AppTranslations(),
        locale: language == 'en' ? const Locale('en') : const Locale('ar'),
        fallbackLocale: const Locale('en'),
        initialBinding: GlobalBindings(),
        home: Container(color: TColors.redColor,),
      ),
    );
  }
}