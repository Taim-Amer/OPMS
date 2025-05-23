import 'package:get/get.dart';
import 'package:opms/features/admin/activities/view/layout/activities_layout.dart';
import 'package:opms/features/admin/app/controllers/breadcrumb_controller.dart';
import 'package:opms/features/admin/auth/view/layouts/login_layout.dart';
import 'package:opms/features/admin/budget/views/layouts/budget_layout.dart';
import 'package:opms/features/admin/departments/views/layouts/department_layout.dart';
import 'package:opms/features/admin/indicators/views/layouts/indicators_layout.dart';
import 'package:opms/features/admin/outcomes/views/layouts/outcome_layout.dart';
import 'package:opms/features/admin/outputs/views/layouts/outputs_layout.dart';
import 'package:opms/features/admin/projects/view/layouts/projects_layout.dart';
import 'package:opms/features/admin/sidebar/views/layouts/sidebar_menu.dart';
import 'package:opms/utils/dependencies/activities_bindings.dart';
import 'package:opms/utils/dependencies/budget_bindings.dart';
import 'package:opms/utils/dependencies/indicators_bindings.dart';
import 'package:opms/utils/dependencies/login_bindings.dart';
import 'package:opms/utils/dependencies/outcome_bindings.dart';
import 'package:opms/utils/dependencies/outputs_bindings.dart';
import 'package:opms/utils/dependencies/sidebar_bindings.dart';

class AppRoutes {
  static const kLogin = '/kLogin';

  // static const kHome = '/kHome';
  static const kSidebar = '/kSidebarMenu';
  static const kOutputs = '/kOutputs';
  static const kOutcome = '/kOutcome';
  static const kIndicator = '/kIndicator';
  static const kActivities = '/kActivities';
  static const kDepartments = '/kDepartments';
  static const kProjects = '/kProjects';
  static const kBudget = '/kBudget';

  static List<GetPage> routes = [
    GetPage(
        name: kLogin,
        page: () => const LoginLayout(),
        binding: LoginBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kDepartments,
          page: () => const DepartmentLayout(),
        // binding: Departments(),
        transition: Transition.noTransition),
    GetPage(
        name: kProjects,
        page: () => const ProjectsLayout(),
        // binding: LoginBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kSidebar,
        page: () => const SidebarMenu(),
        binding: SidebarBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kOutputs,
        page: () => const OutputsLayout(fromAnother: true),
        binding: OutputsBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kOutcome,
        page: () => const OutcomeLayout(fromAnother: true),
        binding: OutcomeBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kIndicator,
        page: () => const IndicatorLayout(fromAnother: true),
        binding: IndicatorsBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kActivities,
        page: () => const ActivitiesLayout(fromAnother: true),
        binding: ActivitiesBindings(),
        transition: Transition.noTransition),
    GetPage(
        name: kBudget,
        page: () => const BudgetLayout(),
        binding: BudgetBindings(),
        transition: Transition.noTransition),
  ];

  static Future<T?>? toNamed<T>(String routeName, {dynamic arguments}) {
    Get.find<BreadcrumbController>().addTitleForRoute(routeName);
    return Get.toNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?>? offNamed<T>(String routeName, {dynamic arguments}) {
    Get.find<BreadcrumbController>().addTitleForRoute(routeName);
    return Get.offNamed<T>(routeName, arguments: arguments);
  }

  static void back() {
    Get.find<BreadcrumbController>().titles.removeLast();
    Get.back();
  }
}
