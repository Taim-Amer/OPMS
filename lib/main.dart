import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:opms/app.dart';
import 'package:opms/features/planner/planner_app.dart';
import 'package:opms/features/planner/planner_home/controller/planner_bread_crumb_controler.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/helpers/scree_size_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Get.put<PlannerBreadcrumbController>(PlannerBreadcrumbController());
  final token = CacheHelper.getData(key: Keys.token);
  final role = CacheHelper.getData(key: Keys.roleName);
  if (token != null && role == 'program_user') {
    print("gonig to planner");
  } else {
    print("not goinig to planner");
  }
  runApp(
    (token != null && role == 'program_user')
        ? const PlannerApp()
        : const WebResizeLogger(child: OPMSSystem()),
  );
}
