import 'package:get/get.dart';
import 'package:referaly/controller/language_controller.dart';

class TranslationHelper {
  static String translate(String key) {
    return LanguageController.to.translate(key);
  }

  // Helper method to get translated text with fallback
  static String tr(String key, {String? fallback}) {
    final translation = LanguageController.to.translate(key);
    return translation == key ? (fallback ?? key) : translation;
  }
}
