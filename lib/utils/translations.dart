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
    LanguageKeys.sharingDeal: 'Sharing Deal',
    LanguageKeys.sharingDealInfo: 'Sharing deal information for %s',
    LanguageKeys.deleteDeal: 'Delete Deal',
    LanguageKeys.contractDeletedSuccess: 'Contract deleted successfully',
  },
  'es_ES': {
    // ... existing translations ...
    LanguageKeys.selectContact: 'Seleccionar Contacto',
    LanguageKeys.error: 'Error',
    LanguageKeys.contactPermissionDenied:
        'Se requiere permiso de contacto para importar contactos',
    LanguageKeys.sharingDeal: 'Compartiendo Trato',
    LanguageKeys.sharingDealInfo: 'Compartiendo información del trato para %s',
    LanguageKeys.deleteDeal: 'Eliminar Trato',
    LanguageKeys.contractDeletedSuccess: 'Contrato eliminado con éxito',
  },
  'fr_FR': {
    // ... existing translations ...
    LanguageKeys.selectContact: 'Sélectionner le Contact',
    LanguageKeys.error: 'Erreur',
    LanguageKeys.contactPermissionDenied:
        'L\'autorisation de contact est requise pour importer les contacts',
    LanguageKeys.sharingDeal: 'Partager l\'Affaire',
    LanguageKeys.sharingDealInfo:
        'Partage des informations de l\'affaire pour %s',
    LanguageKeys.deleteDeal: 'Supprimer l\'Affaire',
    LanguageKeys.contractDeletedSuccess: 'Contrat supprimé avec succès',
  },
};
