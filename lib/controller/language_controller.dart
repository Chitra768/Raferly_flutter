import 'package:get/get.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/languages/en.dart';
import 'package:referaly/languages/es.dart';
import 'package:referaly/languages/fr.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.put(LanguageController());

  final _currentLanguage = 'en'.obs;
  final _translations = {
    'en': en,
    'es': es,
    'fr': fr,
  };

  String get currentLanguage => _currentLanguage.value;
  Map<String, String> get currentTranslations =>
      _translations[_currentLanguage.value] ?? en;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLanguage = await AppPreference.readString('language');
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      _currentLanguage.value = savedLanguage;
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_translations.containsKey(languageCode)) {
      _currentLanguage.value = languageCode;
      await AppPreference.writeString('language', languageCode);
      update();
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
