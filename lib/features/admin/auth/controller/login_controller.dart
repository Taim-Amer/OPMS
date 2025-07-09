// lib/features/auth/controller/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/features/planner/planner_app.dart';
import 'package:opms/features/planner/planner_home/controller/planner_bread_crumb_controler.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/utils/router/app_router.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  final GeneralRepo _repo = GeneralRepoImpl();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RequestState loginState = RequestState.begin;

  Future<void> login() async {
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
      //    Using CacheHelper (shared_preferences under the hood on Web)
      await CacheHelper.saveData(key: Keys.token, value: token);
      await CacheHelper.saveData(key: Keys.roleName, value: role);

      // 4️⃣ Clear inputs & show success
      emailController.clear();
      passwordController.clear();
      showSnackBar(model.message, AlertState.success);

      // 5️⃣ Navigate based on role
      //    program_user → Planner home; others → Admin sidebar
      if (role == 'program_user') {
        // Clear any existing planner breadcrumb state
        Get.delete<PlannerBreadcrumbController>(force: true);
        // Launch the GoRouter-powered PlannerApp
        Get.offAll(() => const PlannerApp());
      } else {
        Get.offAllNamed(AppRoutes.kSidebar);
      }

      loginState = RequestState.success;
      update();
    } else {
      // 6️⃣ On error: clear, show message, revert to form
      loginState = RequestState.error;
      update();
      emailController.clear();
      passwordController.clear();
      showSnackBar(
          (result as DataFailed).error!.data.toString(), AlertState.error);
    }
  }
}
