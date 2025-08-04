// lib/utils/router/planner_router.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/director/director_home/controller/bindings/director_bindings.dart';
import 'package:opms/features/director/director_home/controller/director_controller.dart';
import 'package:opms/features/director/director_shell.dart';
import 'package:opms/features/manger/manager_activity_details/view/layouts/manager_plan_activity_details_layout.dart';
import 'package:opms/features/manger/manager_home/controller/bindings/manager_bindings.dart';
import 'package:opms/features/manger/manager_home/controller/manager_controller.dart';
import 'package:opms/features/manger/manager_home/view/screens/manager_active_activities.dart';
import 'package:opms/features/manger/manager_home/view/screens/manager_users_screen.dart';
import 'package:opms/features/manger/manager_home/view/screens/manger_archived_activities.dart';
import 'package:opms/features/manger/manager_shell.dart';

import 'package:opms/features/planner/activity_plan_details/view/layouts/activity_plan_details_layout.dart';
import 'package:opms/features/planner/auth/sign_in_layout.dart';
import 'package:opms/features/planner/plan_implementation/view/layouts/plan_implementation_layout.dart';
import 'package:opms/features/planner/planner_home/controller/bindings/planner_bindings.dart';
import 'package:opms/utils/dependencies/bread_crumb_controler.dart';
import 'package:opms/features/planner/planner_home/controller/planner_controller.dart';
import 'package:opms/features/planner/planner_home/view/screens/active_actvites.dart';
import 'package:opms/features/planner/planner_home/view/screens/available_activities_section.dart';
import 'package:opms/features/planner/planner_home/view/screens/archived_activities_section.dart';
import 'package:opms/features/planner/planner_shell.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';

class AppRoutesNew {
  // ─── Route PATHS ───────────────────────────────────────────────────────
  // planner routes path
  static const String pathLogin = '/login';
  static const String plannerBase = '/planner';
  static const String active = '$plannerBase/active';
  static const String available = '$plannerBase/available';
  static const String tree = '$plannerBase/tree';
  static const String archive = '$plannerBase/archive';
  static const String notifications = '$plannerBase/notifications';
  static const String activityDetails = '$plannerBase/activity/:id';

  // manger router paths
  static const String managerBase = '/manager';
  static const String managerActive = '$managerBase/active';
  static const String managerusers = '$managerBase/users';
  static const String managertree = '$managerBase/tree';
  static const String managerarchive = '$managerBase/archive';
  static const String managernotifications = '$managerBase/notifications';
  static const String manageractivityDetails = '$managerBase/activity/:id';

// director router paths
  static const String directorBase = '/director';
  static const String directorActive = '$directorBase/active';
  static const String directorUnits = '$directorBase/units';
  static const String directorUsers = '$directorBase/users/:id';
  static const String directortree = '$directorBase/tree';
  static const String directorarchive = '$directorBase/archive';
  static const String directornotifications = '$directorBase/notifications';
  static const String directoractivityDetails = '$directorBase/activity/:id';

  // geenral routes
  static const String planImplementation = '/plan-implementation';

  // ─── Route NAMES ───────────────────────────────────────────────────────
  static const String nameLogin = 'login';
  // planner routes names
  static const String nameActive = 'plannerActive';
  static const String nameAvailable = 'plannerAvailable';
  static const String nameTree = 'plannerTree';
  static const String nameArchive = 'plannerArchive';
  static const String nameNotifications = 'plannerNotifications';
  static const String nameActivityDetails = 'activityDetails';

  // manger routes names
  static const String nameManagerActive = 'managerActive';
  static const String nameManagerUsers = 'managerUsers';
  static const String nameManagerTree = 'managerTree';
  static const String nameManagerArchive = 'managerArchive';
  static const String nameManagerNotifications = 'managerNotifications';
  static const String nameManagerActivityDetails = 'manageractivityDetails';

  // director routes names
  static const String nameDirectorActive = 'directorActive';
  static const String nameDirectoUnits = 'directorUnits';
  static const String nameDirectoUsers = 'directorUsers';
  static const String nameDirectorTree = 'directorTree';
  static const String nameDirectorArchive = 'directorArchive';
  static const String nameDirectorNotifications = 'directorNotifications';
  static const String nameDirectorActivityDetails = 'directoractivityDetails';

// general routes
  static const String namePlanImplementation = 'planImplementation';
  //
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final token = CacheHelper.getData(key: Keys.token);
      final role = CacheHelper.getData(key: Keys.roleName);

      // not logged in → login
      if (token == null && state.uri.toString() != pathLogin) {
        return pathLogin;
      }
      // logged in + on login → go to home by role
      if (token != null && state.uri.toString() == pathLogin) {
        if (role == 'program_user') return active;
        if (role == "manger") return managerActive;
        if (role == "director") return directorActive;
      }
      // at root → go to home by role
      if (token != null && state.uri.toString() == '/') {
        if (role == 'program_user') return active;
        if (role == "manger") return managerActive;
        if (role == "director") return directorActive;
      }
      return null;
    },
    routes: [
      // ─── login ──────────────────────────────────────────────────────────
      GoRoute(
        path: pathLogin,
        name: nameLogin,
        builder: (ctx, state) => const SignInLayout(),
      ),

      // ─── Shell for both planner & manager ──────────────────────────────
      ShellRoute(
        builder: (context, state, child) {
          final role = CacheHelper.getData(key: Keys.roleName);
          if (role == 'program_user') {
            // planner chrome
            PlannerBindings().dependencies();
            final ctrl = Get.find<PlannerController>();
            final crumbs = Get.find<BreadcrumbController>();
            crumbs.setCurrentRoute(state.uri.toString());
            // map tab to fetch
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
            return PlannerShell(child: child);
          } else if (role == "manager") {
            ManagerBindings().dependencies();
            final ctrl = Get.find<ManagerController>();
            final crumbs = Get.find<BreadcrumbController>();
            crumbs.setCurrentRoute(state.uri.toString());
            // map tab to fetch
            switch (state.uri.toString()) {
              case managerActive:
                ctrl.selectedIndex.value = 0;
                ctrl.fetchReserved();
                break;
              case managerusers:
                ctrl.selectedIndex.value = 1;
                ctrl.fetchUsers();

                break;
              case managertree:
                ctrl.selectedIndex.value = 2;
                break;
              case managerarchive:
                ctrl.selectedIndex.value = 3;
                ctrl.fetchArchived();
                break;
              case managernotifications:
                ctrl.selectedIndex.value = 4;
                break;
            }

            // manager chrome
            return ManagerShell(child: child);
          } else {
            DirectorBindings().dependencies();
            final ctrl = Get.find<DirectorController>();
            final crumbs = Get.find<BreadcrumbController>();
            crumbs.setCurrentRoute(state.uri.toString());
            // map tab to fetch
            switch (state.uri.toString()) {
              case directorActive:
                ctrl.selectedIndex.value = 0;
                ctrl.fetchReserved();
                break;
              case directorUnits:
                ctrl.selectedIndex.value = 1;
                // ctrl.fetchUsers();

                break;
              case directortree:
                ctrl.selectedIndex.value = 2;
                break;
              case directorarchive:
                ctrl.selectedIndex.value = 3;
                ctrl.fetchArchived();
                break;
              case directornotifications:
                ctrl.selectedIndex.value = 4;
                break;
            }

            // manager chrome
            return DirectorShell(child: child);
          }
        },
        routes: [
          // ─── Planner sub‐routes ───────────────────────────────────────
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
          GoRoute(
            name: 'activityDetails',
            path: activityDetails,
            builder: (ctx, state) {
              final planActivityId = int.parse(state.pathParameters['id']!);
              return ActivityPlanDetailsLayout(planActivityId: planActivityId);
            },
          ),
          GoRoute(
            name: namePlanImplementation,
            path: '$planImplementation/:planActivityId/:regionType/:regionId',
            builder: (ctx, state) {
              final pid = int.parse(state.pathParameters['planActivityId']!);
              final type = state.pathParameters['regionType']!;
              final rid = int.parse(state.pathParameters['regionId']!);
              final name = state.uri.queryParameters['regionName'] ?? 'Region';
              final extra = state.extra;
              final edit = extra is Map<String, Object?>
                  ? (extra['isEditable'] as bool? ?? false)
                  : false;

              return PlanImplementationLayout(
                planActivityId: pid,
                regionType: type,
                regionId: rid,
                regionName: name,
                isEditable: edit,
              );
            },
          ),

          // ─── Manager sub‐routes ───────────────────────────────────────
          GoRoute(
              name: nameManagerActive,
              path: managerActive,
              builder: (_, __) => const ManagerActiveActivities()),
          GoRoute(
              name: nameManagerUsers,
              path: managerusers,
              builder: (_, __) => const ManagerUsersScreen()),
          GoRoute(
              name: nameManagerArchive,
              path: managerarchive,
              builder: (_, __) => const ManagerArchivedActivitiesSection()),
          GoRoute(
            name: nameManagerTree,
            path: managertree,
            builder: (_, __) => Container(
              color: Colors.pink,
            ),
          ),
          GoRoute(
            name: nameManagerNotifications,
            path: managernotifications,
            builder: (_, __) => Container(color: Colors.green),
          ),
          GoRoute(
            name: AppRoutesNew.nameManagerActivityDetails,
            path: manageractivityDetails,
            builder: (ctx, state) {
              final planActivityId = int.parse(state.pathParameters['id']!);
              return ManagerActivityPlanDetailsLayout(
                  planActivityId: planActivityId);
            },
          ),
          // ─── Director sub‐routes ───────────────────────────────────────
          GoRoute(
              name: nameDirectorActive,
              path: directorActive,
              builder: (_, __) => Container()),
          GoRoute(
              name: nameDirectoUnits,
              path: directorUnits,
              builder: (_, __) => Container()),
          GoRoute(
              name: nameDirectoUsers,
              path: directorUsers,
              builder: (_, __) => Container()),
          GoRoute(
              name: nameDirectorArchive,
              path: directorarchive,
              builder: (_, __) => Container()),
          GoRoute(
            name: nameDirectorTree,
            path: directortree,
            builder: (_, __) => Container(
              color: Colors.pink,
            ),
          ),
          GoRoute(
            name: nameDirectorNotifications,
            path: directornotifications,
            builder: (_, __) => Container(color: Colors.green),
          ),
          GoRoute(
            name: AppRoutesNew.nameDirectorActivityDetails,
            path: directoractivityDetails,
            builder: (ctx, state) {
              final planActivityId = int.parse(state.pathParameters['id']!);
              return Container();
              // ManagerActivityPlanDetailsLayout(
              //     planActivityId: planActivityId);
            },
          ),

          // ─── Fallback for /planner base ───────────────────────────────
          GoRoute(
            path: plannerBase,
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
