import 'package:opms/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'phoneValidation': TArabicTexts.phoneValidation,
      'emptyValidation': TArabicTexts.emptyValidation,
      'emailValidation': TArabicTexts.emailValidation,
      'emailInvalid': TArabicTexts.emailInvalid,
    },
    'ar': {
      'phoneValidation': TEnglishTexts.phoneValidation,
      'emptyValidation': TEnglishTexts.emptyValidation,
      'emailValidation': TEnglishTexts.emailValidation,
      'emailInvalid': TEnglishTexts.emailInvalid,
    },
  };
}
