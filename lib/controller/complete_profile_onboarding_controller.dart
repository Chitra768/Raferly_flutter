import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/utils/translations.dart';
import 'controller_registration.dart';

class CompleteProfileOnboardingController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final phoneNumberController = TextEditingController();
  final cityController = TextEditingController();
  final jobController = TextEditingController();

  // Country selection
  final Rx<Country> selectedCountry = Country(
          name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en')
      .obs;

  final List<Country> countries = [
    Country(
        name: 'United States', emoji: '🇺🇸', code: '+1', languageCode: 'en'),
    Country(name: 'Spain', emoji: '🇪🇸', code: '+34', languageCode: 'es'),
    Country(name: 'Belgium', emoji: '🇧🇪', code: '+32', languageCode: 'es'),
    Country(name: 'France', emoji: '🇫🇷', code: '+33', languageCode: 'fr'),
    Country(
        name: 'Luxembourg', emoji: '🇱🇺', code: '+352', languageCode: 'es'),
    Country(
        name: 'Switzerland', emoji: '🇨🇭', code: '+41', languageCode: 'es'),
  ];

  // Loading state
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set country code based on language
    final lang = AppPreference.getLanguage();
    switch (lang) {
      case 'fr':
        selectedCountry.value = Country(
            name: 'France', emoji: '🇫🇷', code: '+33', languageCode: 'fr');
        break;
      case 'es':
        selectedCountry.value = Country(
            name: 'Spain', emoji: '🇪🇸', code: '+34', languageCode: 'es');
        break;
      case 'en':
      default:
        selectedCountry.value = Country(
            name: 'United States',
            emoji: '🇺🇸',
            code: '+1',
            languageCode: 'en');
        break;
    }
  }

  @override
  void onClose() {
    phoneNumberController.dispose();
    cityController.dispose();
    jobController.dispose();
    super.onClose();
  }

  bool validateForm() {
    errorMessage.value = '';
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      return true;
    }
    return false;
  }

  Future<void> saveAndContinue() async {
    if (!validateForm()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Get user_id from profile if available
      int? userId;
      try {
        final profileController = Get.find<ProfileController>();
        userId = profileController.profile.value?.data?.id;
      } catch (e) {
        // ProfileController not available, try to get profile
        try {
          final profileResponse = await RESTAuth.getProfile();
          if (profileResponse is ApiSuccess) {
            userId = profileResponse.data.data?.id;
          }
        } catch (e2) {
          // If we can't get profile, userId will be null
          // The backend should be able to identify user from token
        }
      }

      // Use updateContact API to save phone, city, and job
      final response = await RESTAuth.updateContact(
        userId: userId,
        phoneNumber: phoneNumberController.text.trim(),
        job: jobController.text.trim(),
        city: cityController.text.trim(),
      );

      if (response is ApiSuccess) {
        // Navigate to profile type selection screen
        Get.offAllNamed(ScreenProfileType.pageId);
      } else if (response is ApiFailure) {
        errorMessage.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      } else {
        errorMessage.value = tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

