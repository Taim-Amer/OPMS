import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/layouts/templates/site_template.dart';
import 'package:opms/features/planner/auth/sign_in_controller.dart';
import 'package:opms/features/planner/auth/sing_in_desktop.dart';
import 'package:opms/features/planner/auth/sing_in_mobile.dart';

class SignInLayout extends GetView<SignInController> {
  const SignInLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: const TSiteTemplate(
        useLayout: false,
        desktop: SingInDesktop(),
        mobile: SingInMobile(),
        tablet: SingInDesktop(),
      ),
    );
  }
}
