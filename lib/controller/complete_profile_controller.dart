import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/screens/search/search_professionals_screen.dart';
import 'package:referaly/utils/translations.dart';

class CompleteProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final jobController = TextEditingController();
  final professionalsCanReferController = TextEditingController();
  final whoCanReferMeController = TextEditingController();
  final cityController = TextEditingController();

  // Tag lists (storing IDs)
  final RxList<int> professionalsCanReferList = <int>[].obs;
  final RxList<int> whoCanReferMeList = <int>[].obs;

  // Maps to store ID -> Title for display
  final RxMap<int, String> professionalsCanReferTitles = <int, String>{}.obs;
  final RxMap<int, String> whoCanReferMeTitles = <int, String>{}.obs;

  // Error states for tags
  final RxString professionalsCanReferError = ''.obs;
  final RxString whoCanReferMeError = ''.obs;

  // Commission sharing
  var sharesCommissions = true.obs; // true = Yes, false = No

  // Work preferences (single selection only)
  var selectedWorkPreference = Rxn<String>();

  // Profile image
  var profileImagePath = Rxn<String>();

  // Loading state
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Clear errors when text changes
    professionalsCanReferController.addListener(() {
      if (professionalsCanReferController.text.isNotEmpty) {
        professionalsCanReferError.value = '';
      }
    });
    whoCanReferMeController.addListener(() {
      if (whoCanReferMeController.text.isNotEmpty) {
        whoCanReferMeError.value = '';
      }
    });
  }

  @override
  void onClose() {
    jobController.dispose();
    professionalsCanReferController.dispose();
    whoCanReferMeController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void toggleCommissionSharing(bool value) {
    sharesCommissions.value = value;
  }

  void selectWorkPreference(String preference) {
    // Single selection: if clicking the same one, deselect it; otherwise select the new one
    if (selectedWorkPreference.value == preference) {
      selectedWorkPreference.value = null;
    } else {
      selectedWorkPreference.value = preference;
    }
  }

  void removeProfessionalsCanRefer(int id) {
    professionalsCanReferList.remove(id);
    professionalsCanReferTitles.remove(id);
    if (professionalsCanReferList.isEmpty) {
      professionalsCanReferError.value =
          tr(LanguageKeys.pleaseEnterDescription);
    }
  }

  void removeWhoCanReferMe(int id) {
    whoCanReferMeList.remove(id);
    whoCanReferMeTitles.remove(id);
    if (whoCanReferMeList.isEmpty) {
      whoCanReferMeError.value = tr(LanguageKeys.pleaseEnterDescription);
    }
  }

  bool validateForm() {
    errorMessage.value = '';
    professionalsCanReferError.value = '';
    whoCanReferMeError.value = '';

    final form = formKey.currentState;
    if (form != null && form.validate()) {
      // Validate professionals can refer list
      if (professionalsCanReferList.isEmpty) {
        professionalsCanReferError.value =
            tr(LanguageKeys.pleaseEnterDescription);
        return false;
      }

      // Validate who can refer me list
      if (whoCanReferMeList.isEmpty) {
        whoCanReferMeError.value = tr(LanguageKeys.pleaseEnterDescription);
        return false;
      }

      // Validate work preference is selected
      if (selectedWorkPreference.value == null) {
        errorMessage.value =
            '${tr(LanguageKeys.workPreferences)} ${tr(LanguageKeys.required)}';
        return false;
      }
      return true;
    }
    return false;
  }

  /// Maps work preference key to API value
  /// API expects: "remote", "on-site", or "hybrid"
  String _mapWorkPreferenceToApiValue(String? preferenceKey) {
    switch (preferenceKey) {
      case 'remote':
        return 'remote'; // Work From Home / Remote Only
      case 'in_person':
        return 'on-site'; // In Person Only
      case 'hybrid':
        return 'hybrid'; // Hybrid
      default:
        return '';
    }
  }

  Future<void> saveProfile() async {
    if (!validateForm()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await RESTAuth.saveFinderDetails(
        job: jobController.text.trim(),
        professionalICanRefer: professionalsCanReferList.toList(),
        whoCanReferMe: whoCanReferMeList.toList(),
        shareCommissions: sharesCommissions.value ? '1' : '0',
        city: cityController.text.trim(),
        workPreferences:
            _mapWorkPreferenceToApiValue(selectedWorkPreference.value),
      );

      if (result is ApiSuccess<ModelCommon>) {
        final data = result.data;
        if (data.status == true) {
          // Navigate to next screen on success
          Get.offNamed(SearchProfessionalsScreen.pageId);
        } else {
          errorMessage.value =
              data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (result is ApiFailure) {
        errorMessage.value =
            result.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
