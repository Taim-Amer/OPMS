// lib/features/planner/planner_home/controller/planner_bread_crumb_controler.dart

import 'package:get/get.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/router/app_routes.dart'; // <-- import AppRoutes

class BreadcrumbItem {
  final String title;
  final String route;
  BreadcrumbItem(this.title, this.route);
}

class BreadcrumbController extends GetxController {
  final crumbs = <BreadcrumbItem>[].obs;

  /// Call this when the route changes (with GoRouter's current location)
  void setCurrentRoute(String route) {
    // Remove query params
    final path = route.split('?').first;
    final segs = path.split('/').where((s) => s.isNotEmpty).toList();
    final List<BreadcrumbItem> items = [];
    if (segs.isNotEmpty && segs[0] == 'plan-implementation') {
      final planId = segs[1];
      final role = CacheHelper.getData(key: Keys.roleName) as String?;
      // 1) Home crumb
      if (role == 'program_user') {
        items.add(BreadcrumbItem('Active Activities', AppRoutesNew.active));
      } else {
        items.add(BreadcrumbItem('Manager Home', AppRoutesNew.managerActive));
      }
      // 2) Details crumb
      final detailRoute = role == 'program_user'
          ? '/planner/activity/$planId'
          : '/manager/activity/$planId';
      items.add(BreadcrumbItem('Activity Details', detailRoute));
      // 3) Plan-implementation crumb
      items.add(BreadcrumbItem(
        'Plan Implementation',
        path,
      ));
      crumbs.assignAll(items);
      return;
    }

    // 1) Detect Manager base vs Planner base:
    if (path.startsWith(AppRoutesNew.managerBase)) {
      // Always start with Manager Home
      items.add(BreadcrumbItem('Manager Home', AppRoutesNew.managerActive));

      // Detect plan‐implementation under /manager/plan-implementation/…
      final planImplIdx = segs.indexWhere((e) => e == 'plan-implementation');
      if (planImplIdx != -1 && segs.length > planImplIdx + 3) {
        final planActivityId = segs[planImplIdx + 1];
        items.add(BreadcrumbItem(
          'Activity Details',
          '/manager/activity/$planActivityId',
        ));
        items.add(BreadcrumbItem(
          'Plan Implementation',
          '/plan-implementation/'
              '$planActivityId/${segs[planImplIdx + 2]}/${segs[planImplIdx + 3]}',
        ));
        crumbs.assignAll(items);
        return;
      }

      // Detect a direct /manager/activity/:id
      final activityIdx = segs.indexWhere((e) => e == 'activity');
      if (activityIdx != -1 && segs.length > activityIdx + 1) {
        final activityId = segs[activityIdx + 1];
        items.add(BreadcrumbItem(
          'Activity Details',
          '/manager/activity/$activityId',
        ));
      }

      crumbs.assignAll(items);
      return;
    }
      // 2) Detect Director base :
    if (path.startsWith(AppRoutesNew.directorBase)) {
      // Always start with Manager Home
      items.add(BreadcrumbItem('Director Home', AppRoutesNew.directorActive));

      // Detect plan‐implementation under /manager/plan-implementation/…
      final planImplIdx = segs.indexWhere((e) => e == 'plan-implementation');
      if (planImplIdx != -1 && segs.length > planImplIdx + 3) {
        final planActivityId = segs[planImplIdx + 1];
        items.add(BreadcrumbItem(
          'Activity Details',
          '/director/activity/$planActivityId',
        ));
        items.add(BreadcrumbItem(
          'Plan Implementation',
          '/plan-implementation/'
              '$planActivityId/${segs[planImplIdx + 2]}/${segs[planImplIdx + 3]}',
        ));
        crumbs.assignAll(items);
        return;
      }

      // Detect a direct /manager/activity/:id
      final activityIdx = segs.indexWhere((e) => e == 'activity');
      if (activityIdx != -1 && segs.length > activityIdx + 1) {
        final activityId = segs[activityIdx + 1];
        items.add(BreadcrumbItem(
          'Activity Details',
          '/director/activity/$activityId',
        ));
      }

      crumbs.assignAll(items);
      return;
    }

    // 3) If this is a Planner detail, fall back to your existing logic:
    if (path.startsWith(AppRoutesNew.plannerBase)) {
      items.add(BreadcrumbItem('Planner Home', AppRoutesNew.active));
      // (Your existing “plan-implementation” detection code unchanged…)
      final planImplIdx = segs.indexWhere((e) => e == 'plan-implementation');
      if (planImplIdx != -1 && segs.length > planImplIdx + 3) {
        final planActivityId = segs[planImplIdx + 1];
        items.add(BreadcrumbItem(
          'Activity Details',
          '/planner/activity/$planActivityId',
        ));
        items.add(BreadcrumbItem(
          'Plan Implementation',
          '/plan-implementation/'
              '$planActivityId/${segs[planImplIdx + 2]}/${segs[planImplIdx + 3]}',
        ));
        crumbs.assignAll(items);
        return;
      }

      final activityIdx = segs.indexWhere((e) => e == 'activity');
      if (activityIdx != -1 && segs.length > activityIdx + 1) {
        final activityId = segs[activityIdx + 1];
        items.add(BreadcrumbItem(
          'Activity Details',
          '/planner/activity/$activityId',
        ));
      }
    }

    crumbs.assignAll(items);
  }
}
