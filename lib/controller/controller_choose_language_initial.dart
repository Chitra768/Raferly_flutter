import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_welcome.dart';

import 'edit_profile_controller.dart';

// Model class for Country
class ModelCountryList {
  final String name;
  final Locale locale;
  final String countryCode;
  final String flag;
  final String mode;

  ModelCountryList({
    required this.name,
    required this.locale,
    required this.countryCode,
    required this.flag,
    required this.mode,
  });
}

class ControllerChooseLanguageInitial extends GetxController {
  final selectedLanguage = RxString('fr'); // Default to English
  final List<ModelCountryList> languages = [
    ModelCountryList(
      name: 'English',
      locale: const Locale('en', 'US'),
      countryCode: 'en',
      flag: '🇺🇸',
      mode: 'dummy',
    ),
    ModelCountryList(
      name: 'Español',
      locale: const Locale('es', 'ES'),
      countryCode: 'es',
      flag: '🇪🇸',
      mode: 'dummy',
    ),
    ModelCountryList(
      name: 'Français',
      locale: const Locale('fr', 'FR'),
      countryCode: 'fr',
      flag: '🇫🇷',
      mode: 'dummy',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = LanguageController.to.currentLanguage;
    print(selectedLanguage.value);
    changeLanguage(selectedLanguage.value);
  }

  Future<void> changeLanguage(String languageCode) async {
    selectedLanguage.value = languageCode;
    final selectedLocale = languages
        .firstWhere(
          (language) => language.locale.languageCode == languageCode,
        )
        .locale;

    Get.updateLocale(selectedLocale);
    await AppPreference.setLanguage(languageCode);
    await LanguageController.to.changeLanguage(languageCode);

    // Verify the language was set correctly
    final currentLanguage = AppPreference.getLanguage();
    print('Current language after change: $currentLanguage');
  }

  void goToNextScreen() {
    Get.offNamed(ScreenWelcome.pageId); // Use Get.offNamed
  }

  // Get the language name from the code.
  String getLanguageName(String languageCode) {
    final language = languages.firstWhere(
      (language) => language.locale.languageCode == languageCode,
      orElse: () => ModelCountryList(
          name: 'Unknown',
          locale: const Locale('en', 'US'),
          countryCode: '',
          flag: '',
          mode: ''), // Provide a default value
    );
    return language.name;
  }

  String getLanguageFlag(String languageCode) {
    final language = languages.firstWhere(
      (language) => language.locale.languageCode == languageCode,
      orElse: () => ModelCountryList(
          name: 'Unknown',
          locale: const Locale('en', 'US'),
          countryCode: '',
          flag: '',
          mode: ''), // Provide a default value
    );
    return language.flag;
  }

  String getLanguageMode(String languageCode) {
    final language = languages.firstWhere(
      (language) => language.locale.languageCode == languageCode,
      orElse: () => ModelCountryList(
          name: 'Unknown',
          locale: const Locale('en', 'US'),
          countryCode: '',
          flag: '',
          mode: 'dummy'), // Provide a default value
    );
    return language.mode;
  }
}
