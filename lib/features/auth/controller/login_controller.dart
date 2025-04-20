import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opms/common/widgets/alerts/snackbar.dart';
import 'package:opms/utils/api/data_state.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:opms/utils/constants/keys.dart';
import 'package:opms/utils/helpers/cache_helper.dart';
import 'package:opms/utils/repositories/general_repo.dart';
import 'package:opms/utils/repositories/general_repo_impl.dart';
import 'package:opms/utils/router/app_router.dart';

class LoginController extends GetxController{
  final GeneralRepo _repo = GeneralRepoImpl();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  RequestState loginState = RequestState.begin;
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    loginState = RequestState.loading;
    update();
    final dataState = await _repo.login(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    );
    if (dataState is DataSuccess) {
      loginState = RequestState.success;
      CacheHelper.saveData(key: Keys.token, value: dataState.data!.data!.accessToken);
      showSnackBar(dataState.data!.message!, AlertState.success);
      Get.offAllNamed(AppRoutes.kHome);
      update();
    } else if (dataState is DataFailed) {
      loginState = RequestState.error;
      update();
      showSnackBar(dataState.error!.data.toString(), AlertState.error);
    }
  }
}