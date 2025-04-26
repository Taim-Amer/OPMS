import 'package:opms/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'phoneValidation': EnglishTexts.phoneValidation,
      'emptyValidation': EnglishTexts.emptyValidation,
      'emailValidation': EnglishTexts.emailValidation,
      'emailInvalid': EnglishTexts.emailInvalid,
    },
    'ar': {
      'phoneValidation': ArabicTexts.phoneValidation,
      'emptyValidation': ArabicTexts.emptyValidation,
      'emailValidation': ArabicTexts.emailValidation,
      'emailInvalid': ArabicTexts.emailInvalid,
    },
  };
}
