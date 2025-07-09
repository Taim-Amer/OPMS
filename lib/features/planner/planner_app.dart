// lib/planner_app.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opms/utils/dependencies/planner_global_bindings.dart';
import 'package:opms/utils/theme/theme.dart';
import 'package:opms/features/admin/settings/controllers/theme_controller.dart';
import 'package:opms/utils/router/planner_router.dart';
class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    PlannerGlobalBindings().dependencies();
    final themeCtrl = Get.put(ThemeController());

    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        // rebuild whenever themeMode.value changes
        return Obx(() => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              themeMode: themeCtrl.themeMode.value,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routerConfig: PlannerRouter.router,
              locale: const Locale('en'),
            ));
      },
    );
  }
}
