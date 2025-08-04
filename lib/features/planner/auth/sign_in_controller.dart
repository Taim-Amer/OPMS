// lib/features/auth/controller/login_controller.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:opms/features/admin/auth/models/login_model.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/utils/router/app_routes.dart';

class SignInController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RequestState loginState = RequestState.begin;

  Future<void> login(BuildContext context) async {
    // 1️⃣ Form validation
    if (!formKey.currentState!.validate()) return;

    // 2️⃣ Show loading state
    loginState = RequestState.loading;
    update();

    final result = await _repo.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (result is DataSuccess<LoginModel>) {
      final model = result.data!;
      final token = model.data.accessToken;
      final role = model.data.roleName;

      // 3️⃣ Persist token & role in local storage
      await CacheHelper.saveData(key: Keys.token, value: token);
      await CacheHelper.saveData(key: Keys.roleName, value: role);

      // 4️⃣ Clear inputs
      emailController.clear();
      passwordController.clear();

      // 5️⃣ Navigate based on role
      // Use GoRouter to replace the entire navigation stack:
      if (role == 'program_user') {
        // Planner user → planner home
        GoRouter.of(context).go(AppRoutesNew.active);
      } else if (role == 'manager') {
        // Manager → manager home
        GoRouter.of(context).go(AppRoutesNew.managerActive);
      } else {
        // Any other role → fallback or a default dashboard
        GoRouter.of(context).go(AppRoutesNew.active);
      }

      loginState = RequestState.success;
      update();
    } else {
      // 6️⃣ On error: clear, show message, revert to form
      loginState = RequestState.error;
      update();
      emailController.clear();
      passwordController.clear();
      // Optionally show an error Snackbar here
    }
  }
}
