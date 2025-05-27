import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/language_controller.dart';

String tr(String key) {
  return LanguageController.to.translate(key);
}

final Map<String, Map<String, String>> translations = {
  'en_US': {
    // ... existing translations ...
    LanguageKeys.selectContact: 'Select Contact',
    LanguageKeys.error: 'Error',
    LanguageKeys.contactPermissionDenied:
        'Contact permission is required to import contacts',
  },
  'es_ES': {
    // ... existing translations ...
    LanguageKeys.selectContact: 'Seleccionar Contacto',
    LanguageKeys.error: 'Error',
    LanguageKeys.contactPermissionDenied:
        'Se requiere permiso de contacto para importar contactos',
  },
};
