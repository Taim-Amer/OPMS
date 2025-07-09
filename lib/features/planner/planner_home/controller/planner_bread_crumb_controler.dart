// lib/features/planner/planner_home/controller/planner_bread_crumb_controler.dart

import 'package:get/get.dart';

class BreadcrumbItem {
  final String title;
  final String route;
  BreadcrumbItem(this.title, this.route);
}

class PlannerBreadcrumbController extends GetxController {
  final crumbs = <BreadcrumbItem>[].obs;

  /// Call this when the route changes (with GoRouter's current location)
  void setCurrentRoute(String route) {
    // Remove query params
    String path = route.split('?').first;
    final List<BreadcrumbItem> items = [];
    final segs = path.split('/').where((s) => s.isNotEmpty).toList();

    // Always start with Home
    items.add(BreadcrumbItem('Active Activities', '/planner/active'));

    // Detect plan-implementation (always has activityId as first param)
    final planImplIdx = segs.indexWhere((e) => e == 'plan-implementation');
    if (planImplIdx != -1 && segs.length > planImplIdx + 3) {
      final planActivityId = segs[planImplIdx + 1];
      // Add Activity Details crumb using planActivityId
      items.add(BreadcrumbItem(
        'Activity Details',
        '/planner/activity/$planActivityId',
      ));
      // Add Plan Implementation crumb
      final regionType = segs[planImplIdx + 2];
      final regionId = segs[planImplIdx + 3];
      final isEditable =
          segs.length > planImplIdx + 4 ? segs[planImplIdx + 4] : 'true';
      items.add(BreadcrumbItem(
        'Plan Implementation',
        '/planner/plan-implementation/$planActivityId/$regionType/$regionId/$isEditable',
      ));
      crumbs.assignAll(items);
      return;
    }

    // Detect activity details directly
    final activityIdx = segs.indexWhere((e) => e == 'activity');
    if (activityIdx != -1 && segs.length > activityIdx + 1) {
      final activityId = segs[activityIdx + 1];
      items.add(BreadcrumbItem(
        'Activity Details',
        '/planner/activity/$activityId',
      ));
    }

    crumbs.assignAll(items);
  }
}
