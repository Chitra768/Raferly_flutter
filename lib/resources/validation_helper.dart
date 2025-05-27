

import 'app_strings.dart';

class ValidationHelper{
  static dynamic isValidEmail(String email, {String? message}) {
    if (email.isEmpty) {
      return message ?? 'Required';
    } else if (!RegExp(AppString.regexEmail).hasMatch(email)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }
  static bool isValidString(String? strToValidate) {
    bool result = false;

    if (strToValidate != null &&
        strToValidate.trim() != 'null' &&
        strToValidate.trim().isNotEmpty) {
      result = true;
    }

    return result;
  }
}