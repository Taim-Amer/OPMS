import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:opms/features/planner/planner_app.dart';
import 'package:opms/utils/dependencies/bread_crumb_controler.dart';
import 'package:opms/utils/helpers/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Get.put<BreadcrumbController>(BreadcrumbController());
  runApp(const PlannerApp());
}
