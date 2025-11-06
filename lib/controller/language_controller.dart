import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/languages/en.dart';
import 'package:referaly/languages/es.dart';
import 'package:referaly/languages/fr.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.put(LanguageController());

  final _currentLanguage = 'fr'.obs;
  final _translations = {
    'en': en,
    'es': es,
    'fr': fr,
  };
  final translations = {
    'en': en,
    'es': es,
    'fr': fr,
  };
  String get currentLanguage => _currentLanguage.value;
  Map<String, String> get currentTranslations =>
      _translations[_currentLanguage.value] ?? fr;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLanguage = AppPreference.getLanguage();
    if (savedLanguage.isNotEmpty) {
      _currentLanguage.value = savedLanguage;
      Get.updateLocale(Locale(savedLanguage));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_translations.containsKey(languageCode)) {
      _currentLanguage.value = languageCode;
      await AppPreference.setLanguage(languageCode);

      // Update the app locale
      Get.updateLocale(Locale(languageCode));

      // Notify all listeners that the language has changed
      update();

      // Verify the language was set correctly
      final currentLanguage = AppPreference.getLanguage();
      print(
          'LanguageController - Current language after change: $currentLanguage');
    }
  }

  String translate(String key) {
    try {
      return currentTranslations[key] ?? key;
    } catch (e) {
      return key;
    }
  }
}
