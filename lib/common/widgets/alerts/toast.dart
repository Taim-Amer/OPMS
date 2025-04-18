import 'package:opms/utils/constants/colors.dart';
import 'package:opms/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String txt, AlertState toastState) => Fluttertoast.showToast(
    msg: txt,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 80,
    backgroundColor: chooseToastColor(toastState),
    textColor: Colors.white,
    fontSize: 16.0,
);

Color chooseToastColor(AlertState state) {
  Color color;
  switch (state) {
    case AlertState.success:
      color = TColors.greenColor;
      break;
    case AlertState.error:
      color = TColors.redColor;
      break;
    case AlertState.warning:
      color = TColors.yellowColor;
      break;
  }
  return color;
}
