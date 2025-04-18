import 'package:opms/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: const Color(0xFF707070),
    suffixIconColor: const Color(0xFF707070),
    fillColor: const Color(0xFFF5F5F5),
    filled: true,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: const Color(0xFF707070)),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: const Color(0xFF707070), fontWeight: FontWeight.w400),
    errorStyle: const TextStyle().copyWith(fontWeight: FontWeight.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withOpacity(.8)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    fillColor: TColors.dark,
    filled: true,
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.white.withOpacity(.8)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 0, color: Colors.transparent),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );
}
