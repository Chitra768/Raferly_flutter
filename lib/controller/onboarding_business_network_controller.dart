import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';

class OnboardingBusinessNetworkController extends GetxController {
  final activityController = TextEditingController();
  final cityController = TextEditingController();
  final referrerTypeController = TextEditingController();
  final canReferController = TextEditingController();

  final RxList<String> referrerTypes = <String>[].obs;
  final RxList<String> canReferList = <String>[].obs;
  final RxBool shareCommission = false.obs;
  final RxString clientLocation = tr(LanguageKeys.online).obs;

  // Validation error states
  final RxString activityError = ''.obs;
  final RxString referrerTypeError = ''.obs;
  final RxString canReferError = ''.obs;
  final RxString cityError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Clear all error messages on init
    activityError.value = '';
    referrerTypeError.value = '';
    canReferError.value = '';
    error.value = '';

    // Clear activity error when text changes
    activityController.addListener(() {
      if (activityController.text.isNotEmpty) {
        activityError.value = '';
      }
    });

    cityController.addListener(() {
      if (cityController.text.isNotEmpty) {
        cityError.value = '';
      }
    });

    // Clear referrer type error when text changes
    referrerTypeController.addListener(() {
      if (referrerTypeController.text.isNotEmpty) {
        referrerTypeError.value = '';
      }
    });

    // Clear can refer error when text changes
    canReferController.addListener(() {
      if (canReferController.text.isNotEmpty) {
        canReferError.value = '';
      }
    });
  }

  bool validateForm() {
    bool isValid = true;

    // Validate Business Activity
    if (activityController.text.trim().isEmpty) {
      activityError.value = tr(LanguageKeys.businessActivityRequired);
      isValid = false;
    } else {
      activityError.value = '';
    }

    // Validate City
    if (cityController.text.trim().isEmpty) {
      cityError.value = tr(LanguageKeys.cityIsRequired);
      isValid = false;
    } else {
      cityError.value = '';
    }

    // Validate Referrer Types
    if (referrerTypes.isEmpty) {
      referrerTypeError.value = tr(LanguageKeys.atLeastOneReferrerTypeRequired);
      isValid = false;
    } else {
      referrerTypeError.value = '';
    }

    // Validate Can Refer List
    if (canReferList.isEmpty) {
      canReferError.value = tr(LanguageKeys.atLeastOneCanReferItemRequired);
      isValid = false;
    } else {
      canReferError.value = '';
    }

    return isValid;
  }

  void addReferrerType() {
    final value = referrerTypeController.text.trim();
    if (value.isNotEmpty) {
      referrerTypes.add(value);
      referrerTypeController.clear();
      referrerTypeError.value = '';
    }
  }

  void removeReferrerType(String value) {
    referrerTypes.remove(value);
    if (referrerTypes.isEmpty) {
      referrerTypeError.value = tr(LanguageKeys.atLeastOneReferrerTypeRequired);
    }
  }

  void addCanRefer() {
    final value = canReferController.text.trim();
    if (value.isNotEmpty) {
      canReferList.add(value);
      canReferController.clear();
      canReferError.value = '';
    }
  }

  void removeCanRefer(String value) {
    canReferList.remove(value);
    if (canReferList.isEmpty) {
      canReferError.value = tr(LanguageKeys.atLeastOneCanReferItemRequired);
    }
  }

  @override
  void onClose() {
    activityController.dispose();
    cityController.dispose();
    referrerTypeController.dispose();
    canReferController.dispose();
    super.onClose();
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> sendReferral() async {
    if (!validateForm()) {
      return;
    }

    final clientLocations = clientLocation.value;
    final firstName = activityController.text.trim();
    final city = cityController.text.trim();
    final refereeEmails = canReferList;
    final referrerEmails = referrerTypes;
    final sharesCommission = shareCommission.value == true ? "yes" : "no";

    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.sendReferralRequest(
          clientLocation: clientLocations,
          firstName: firstName,
          refereeEmails: refereeEmails,
          referrerEmails: referrerEmails,
          sharesCommission: sharesCommission,
          city: city);

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          // Clear all fields
          activityController.clear();
          cityController.clear();
          referrerTypeController.clear();
          canReferController.clear();
          referrerTypes.clear();
          canReferList.clear();
          shareCommission.value = false;
          clientLocation.value = tr(LanguageKeys.online);

          Get.toNamed('/onboarding_consultation_success');
        } else {
          error.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
