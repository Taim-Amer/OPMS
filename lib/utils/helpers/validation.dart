import 'package:opms/utils/localization/keys.dart';

class TValidator {

  static String? validateEmptyText(String? fieldName, String? value){
    if(value == null || value.isEmpty){
      return '${TranslationKey.kEmptyValidation}$fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty){
      return TranslationKey.kEmailInvalid;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if(!emailRegExp.hasMatch(value)){
      return TranslationKey.kEmailInvalid;
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
}