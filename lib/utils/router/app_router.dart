  import 'package:get/get.dart';
import 'package:opms/features/auth/view/layouts/login_layout.dart';
import 'package:opms/utils/dependencies/login_bindings.dart';

class AppRoutes {
  static const kLogin = '/kLogin';

  static List<GetPage> routes = [

    GetPage(
        name: kLogin,
        page: () => const LoginLayout(),
        binding: LoginBindings(),
        transition: Transition.noTransition
    ),

  ];
}