  import 'package:get/get.dart';
import 'package:opms/features/auth/view/layouts/login_layout.dart';
import 'package:opms/features/home/views/layouts/home_layout.dart';
import 'package:opms/utils/dependencies/login_bindings.dart';

class AppRoutes {
  static const kLogin = '/kLogin';
  static const kHome = '/kHome';

  static List<GetPage> routes = [

    GetPage(
        name: kLogin,
        page: () => const LoginLayout(),
        binding: LoginBindings(),
        transition: Transition.noTransition
    ),

    GetPage(
        name: kHome,
        page: () => const HomeLayout(),
        // binding: LoginBindings(),
        transition: Transition.noTransition
    ),

  ];
}