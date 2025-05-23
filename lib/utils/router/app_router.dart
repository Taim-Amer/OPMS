import 'package:get/get.dart';
import 'package:opms/features/activities/view/layout/activities_layout.dart';
import 'package:opms/features/auth/view/layouts/login_layout.dart';
import 'package:opms/features/indicators/views/layouts/indicators_layout.dart';
import 'package:opms/features/outcomes/views/layouts/outcome_layout.dart';
import 'package:opms/features/outputs/views/layouts/outputs_layout.dart';
import 'package:opms/features/sidebar/views/layouts/sidebar_menu.dart';
import 'package:opms/utils/dependencies/activities_bindings.dart';
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

  static List<GetPage> routes = [
    GetPage(
      name: kLogin,
      page: () => const LoginLayout(),
      binding: LoginBindings(),
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
  ];
}
