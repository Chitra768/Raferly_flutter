import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_add_business_referrer_request.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_redeive_lead_deal.dart';
import 'package:referaly/utils/translations.dart';

import '../resources/app_log.dart';

class AddBusinessReferrerController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  /// User type: 'professional' or 'individual' (maps to company_type in API)
  final RxString userType = 'professional'.obs;
  final Rxn<String> selectedLanguage = Rxn<String>();
  final RxBool referralAgreementChecked = false.obs;

  final RxList<RedeiveLeadDealData> businessDeals = <RedeiveLeadDealData>[].obs;
  final RxBool isLoadingDeals = false.obs;
  final Rxn<int> selectedDealId = Rxn<int>();
  final RxBool isSubmitting = false.obs;

  final List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
  ];

  final RxBool createdByParent = false.obs;

  int? _tryParseDealId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  bool _tryParseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.trim().toLowerCase() == 'true';
    if (value is num) return value != 0;
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    selectedDealId.value = _tryParseDealId(args?['deal_id']);
    createdByParent.value = _tryParseBool(args?['created_by_parent']);
    fetchBusinessDeals();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    countryCodeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    jobTitleController.dispose();
    super.onClose();
  }

  String? _normalizeCountryCode(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    if (value.startsWith('+')) return value;
    return '+$value';
  }

  Future<void> fetchBusinessDeals() async {
    isLoadingDeals.value = true;
    try {
      final response = await RESTAuth.businessReferralDealList();
      if (response is ApiSuccess<ModelRedeiveLeadDeal>) {
        if (response.data.status == true) {
          businessDeals.value = response.data.data ?? [];
          if (selectedDealId.value == null && businessDeals.isNotEmpty) {
            selectedDealId.value = businessDeals.first.id;
          }
        }
      }
    } finally {
      isLoadingDeals.value = false;
    }
  }

  void setUserType(String type) {
    userType.value = type;
  }

  void onBack() {
    Get.back();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LanguageKeys.pleaseEnterEmail);
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return tr(LanguageKeys.invalidEmail);
    }
    return null;
  }

  Future<void> onSubmit() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final countryCode = _normalizeCountryCode(countryCodeController.text);
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final job = jobTitleController.text.trim();
    final dealId = selectedDealId.value;

    AppLog.d("dealId: $dealId");

    if (firstName.isEmpty) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.firastNameError),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (lastName.isEmpty) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.lastNameError),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (phone.isEmpty) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.phoneNumError),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final emailError = _validateEmail(email);
    if (emailError != null) {
      Get.snackbar(tr(LanguageKeys.error), emailError, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (job.isEmpty) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.jobError), snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (dealId == null) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.selectDealErr),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!referralAgreementChecked.value) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.referralAgreementConfirm),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      final request = AddBusinessReferrerRequest(
        dealId: dealId,
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
        phoneNumber: phone,
        email: email,
        job: job,
        companyType: userType.value,
        createdByParent: createdByParent.value,
      );

      final response = await RESTAuth.addBusinessReferrer(request);

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          Get.back(result: true);
          Get.snackbar(
            tr(LanguageKeys.addBusinessReferrer),
            response.data.message ?? tr(LanguageKeys.addBusinessReferrer),
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            tr(LanguageKeys.error),
            response.data.message ?? tr(LanguageKeys.somethingWentWrong),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (response is ApiFailure) {
        Get.snackbar(
          tr(LanguageKeys.error),
          response.error.message ?? tr(LanguageKeys.somethingWentWrong),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isSubmitting.value = false;
    }
  }
}
