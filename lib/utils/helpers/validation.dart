import 'package:opms/utils/localization/keys.dart';

class Validator {
  Validator._();

  static String? validateEmptyText(String? fieldName, String? value){
    if(value == null || value.isEmpty){
      return '${TranslationKey.kEmptyValidation}$fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty){
      return 'Email is required';
    }

    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if(!emailRegExp.hasMatch(value)){
      return 'Invalid Email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if(value == null || value.isEmpty){
      return "Password is required" ;
    }

    if(value.length < 6){
      return "Password must be at least 6 characters long." ;
    }

    if(!value.contains(RegExp(r'[A-Z]'))){
      return "Password must contain at least one uppercase letter.";
    }

    if(!value.contains(RegExp(r'[0-9]'))){
      return "Password must contain at least one number.";
    }

    if(!value.contains(RegExp(r'[!@#$%^&*(),.?:{}|<>]'))){
      return "Password must contain at least one special character.";
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if(value == null || value.isEmpty){
      return TranslationKey.kPhoneValidation ;
    }

    return null;
  }

  static String? minimumValidator(String? val, {required int minimum}) {
    if ((val ?? '').length < minimum) {
      return 'This field must at least $minimum';
    } else {
      return null;
    }
  }

  static String? exactlyValidator(String? val, int length) {
    if ((val ?? '').length != length) {
      return 'This field must exactly $length';
    } else {
      return null;
    }
  }

  static String formatPhoneNumberUI(String phone) {
    String countryCode = phone.substring(0, 4);
    String phoneNumber = phone.substring(4, phone.length);
    return '($countryCode) $phoneNumber';
  }
}