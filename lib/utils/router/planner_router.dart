// lib/utils/router/planner_router.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/planner/plan_implementation/view/layouts/plan_implementation_layout.dart';
import 'package:opms/features/planner/planner_home/controller/bindings/planner_bindings.dart';
import 'package:opms/features/planner/planner_home/controller/planner_controller.dart';
import 'package:opms/features/planner/planner_home/controller/planner_bread_crumb_controler.dart';
import 'package:opms/features/planner/planner_home/view/screens/active_actvites.dart';
import 'package:opms/features/planner/planner_home/view/screens/available_activities_section.dart';
import 'package:opms/features/planner/planner_home/view/screens/archived_activities_section.dart';
import 'package:opms/features/planner/activity_plan_details/view/layouts/activity_plan_details_layout.dart';
import 'package:opms/features/planner/planner_shell.dart';

class PlannerRouter {
  // ─── Route PATHS ───────────────────────────────────────────────────────
  static const String base = '/planner';
  static const String active = '$base/active';
  static const String available = '$base/available';
  static const String tree = '$base/tree';
  static const String archive = '$base/archive';
  static const String notifications = '$base/notifications';
  static const String activityDetails = '$base/activity/:id';
  static const String planImplementation = '$base/plan-implementation';

  // ─── Route NAMES ───────────────────────────────────────────────────────
  static const String nameActive = 'plannerActive';
  static const String nameAvailable = 'plannerAvailable';
  static const String nameTree = 'plannerTree';
  static const String nameArchive = 'plannerArchive';
  static const String nameNotifications = 'plannerNotifications';
  static const String nameActivityDetails = 'activityDetails';
  static const String namePlanImplementation = 'planImplementation';

  static final GoRouter router = GoRouter(
    initialLocation: active,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          // 1) Bind controllers once:
          PlannerBindings().dependencies();
          final ctrl = Get.find<PlannerController>();
          final crumbs = Get.find<PlannerBreadcrumbController>();

          // 2) Drive breadcrumbs:
          crumbs.setCurrentRoute(state.uri.toString());

          // 3) Map URL to index + fetch
          switch (state.uri.toString()) {
            case active:
              ctrl.selectedIndex.value = 0;
              ctrl.fetchReserved();
              break;
            case available:
              ctrl.selectedIndex.value = 1;
              ctrl.fetchAvailable();
              break;
            case tree:
              ctrl.selectedIndex.value = 2;
              break;
            case archive:
              ctrl.selectedIndex.value = 3;
              ctrl.fetchArchived();
              break;
            case notifications:
              ctrl.selectedIndex.value = 4;
              break;
          }

          // 4) Render your persistent chrome + the “child”
          return PlannerShell(child: child);
        },
        routes: [
          GoRoute(
            name: nameActive,
            path: active,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: ActiveActivitiesSection()),
          ),
          GoRoute(
            name: nameAvailable,
            path: available,
            pageBuilder: (_, __) =>
                NoTransitionPage(child: AvailableActivitiesSection()),
          ),
          GoRoute(
            name: nameTree,
            path: tree,
            pageBuilder: (_, __) => NoTransitionPage(child: Container()),
          ),
          GoRoute(
            name: nameArchive,
            path: archive,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: ArchivedActivitiesSection()),
          ),
          GoRoute(
            name: nameNotifications,
            path: notifications,
            pageBuilder: (_, __) => NoTransitionPage(child: Container()),
          ),

          // Details page with its own binding:
          GoRoute(
            name: 'activityDetails',
            path: '/planner/activity/:id',
            builder: (ctx, state) {
              
              final planActivityId = int.tryParse(state.pathParameters['id']!);

              return ActivityPlanDetailsLayout(planActivityId: planActivityId!);
            },
          ),
          GoRoute(
            name: namePlanImplementation,
            path:
                '$base/plan-implementation/:planActivityId/:regionType/:regionId/:isEditable',
            builder: (ctx, state) {
              final planActivityId =
                  int.tryParse(state.pathParameters['planActivityId']!);
              final regionType = state.pathParameters['regionType']!;
              final regionId = int.tryParse(state.pathParameters['regionId']!);
              final isEditable = state.pathParameters['isEditable'] == 'true';
              return PlanImplementationLayout(
                planActivityId: planActivityId!,
                regionType: regionType,
                regionId: regionId!,
                isEditable: isEditable,
              );
            },
          ),

          // Redirect bare /planner → /planner/active
          GoRoute(
            path: base,
            redirect: (_, __) => active,
          ),
        ],
      ),
    ],
    errorPageBuilder: (ctx, state) => MaterialPage(
      child: Scaffold(body: Center(child: Text('404: ${state.error}'))),
    ),
  );
}
