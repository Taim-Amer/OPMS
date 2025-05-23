import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/admin/auth/controller/login_controller.dart';
import 'package:opms/features/admin/auth/view/screens/login_desktop_screen.dart';
import 'package:opms/features/admin/auth/view/screens/login_mobile_screen.dart';

class LoginLayout extends GetView<LoginController> {
  const LoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: const TSiteTemplate(
        useLayout: false,
        desktop: LoginDesktopScreen(),
        mobile: LoginMobileScreen(),
        tablet: LoginDesktopScreen(),
      ),
    );
  }
}
