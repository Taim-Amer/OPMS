import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String txt, AlertState toastState) {
  Get.snackbar(
    chooseTitle(toastState),
    txt,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    backgroundColor: chooseSnackBarColor(toastState),
    colorText: Colors.white,
    snackStyle: SnackStyle.FLOATING,
    borderRadius: 8,
    margin: const EdgeInsets.all(10),
    maxWidth: 500
  );
}

Color chooseSnackBarColor(AlertState state) {
  Color color;
  switch (state) {
    case AlertState.success:
      color = TColors.info;
      break;
    case AlertState.error:
      color = TColors.error;
      break;
    case AlertState.warning:
      color = TColors.yellowColor;
      break;
  }
  return color;
}

String chooseTitle(AlertState state){
  String title;
  switch (state) {
    case AlertState.success:
      title = "Successfully";
      break;
    case AlertState.error:
      title = "Error";
      break;
    case AlertState.warning:
      title = "Warning";
      break;
  }
  return title;
}
