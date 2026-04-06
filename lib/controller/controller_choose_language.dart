import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/controller/profile_controller.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';

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

class ControllerChooseLanguage extends GetxController {
  final selectedLanguage = RxString('fr'); // Default to English
  final controller = Get.find<ProfileController>();
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
    _updateSelectedLanguageLabel(selectedLanguage.value);
  }

  Future<void> changeLanguage(String languageCode) async {
    selectedLanguage.value = languageCode;
    _updateSelectedLanguageLabel(languageCode);

    // Delegate locale + persistence to the single source of truth.
    await LanguageController.to.changeLanguage(languageCode);
  }

  void _updateSelectedLanguageLabel(String languageCode) {
    controller.languageController.text = languageCode == "en"
        ? "English"
        : languageCode == "es"
            ? "Español"
            : languageCode == "fr"
                ? "Français"
                : "Other";
  }

  void goToNextScreen() {
    Get.offNamed(ScreenInitialLanguage.pageId); // Use Get.offNamed
  }

  // Get the language name from the code.
  String getLanguageName(String languageCode) {
    final language = languages.firstWhere(
      (language) => language.locale.languageCode == languageCode,
      orElse: () => ModelCountryList(
          name: 'Unknown',
          locale: const Locale('fr', 'FR'),
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
          locale: const Locale('fr', 'FR'),
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
          locale: const Locale('fr', 'FR'),
          countryCode: '',
          flag: '',
          mode: 'dummy'), // Provide a default value
    );
    return language.mode;
  }
}
