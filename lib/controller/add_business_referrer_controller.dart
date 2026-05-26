import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_add_business_referrer_request.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_network_response.dart';
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

  /// null = unselected; true = professional; false = individual (maps to company_type in API)
  final RxnBool isProfessional = RxnBool(null);
  final RxBool showUserTypeError = false.obs;
  final RxString selectedJobId = ''.obs;
  final Rxn<String> selectedLanguage = Rxn<String>();
  final RxBool referralAgreementChecked = false.obs;

  final RxList<RedeiveLeadDealData> businessDeals = <RedeiveLeadDealData>[].obs;
  final RxBool isLoadingDeals = false.obs;
  final Rxn<int> selectedDealId = Rxn<int>();
  final RxBool isSubmitting = false.obs;

  /// Whether the new referrer was sponsored by an existing network member.
  final RxBool isSponsored = false.obs;
  final Rxn<int> selectedSponsorId = Rxn<int>();
  final RxList<BusinessReferrers> sponsors = <BusinessReferrers>[].obs;
  final RxBool isLoadingSponsors = false.obs;
  bool _sponsorsFetched = false;

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

  /// Fetch the existing network so the user can pick a sponsor.
  /// Only confirmed members (non-pending) can sponsor a new referrer.
  Future<void> fetchSponsors() async {
    if (_sponsorsFetched) return;
    isLoadingSponsors.value = true;
    try {
      final response = await RESTAuth.getNetworkList();
      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          final list = response.data.data?.businessReferrers ?? <BusinessReferrers>[];
          sponsors.value = list
              .where((b) => !(b.isPendingInvitation ?? false) && b.id != null)
              .toList();
          _sponsorsFetched = true;
        }
      }
    } finally {
      isLoadingSponsors.value = false;
    }
  }

  void setIsSponsored(bool value) {
    isSponsored.value = value;
    if (!value) {
      selectedSponsorId.value = null;
      return;
    }
    if (!_sponsorsFetched) {
      fetchSponsors();
    }
  }

  bool get isJobRequired => isProfessional.value == true;

  void selectProfessional() {
    isProfessional.value = true;
    showUserTypeError.value = false;
  }

  void selectIndividual() {
    isProfessional.value = false;
    showUserTypeError.value = false;
    _clearJobSelection();
  }

  void _clearJobSelection() {
    jobTitleController.clear();
    selectedJobId.value = '';
  }

  void onJobSelected(int id, String title) {
    selectedJobId.value = id.toString();
  }

  void onBack() {
    Get.back();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr(LanguageKeys.pleaseEnterEmail);
    }
    if (!GetUtils.isEmail(value.trim())) {
      return tr(LanguageKeys.invalidEmail);
    }
    return null;
  }

  Future<void> onSubmit() async {
    final profile =
        Get.find<ControllerMainProfessional>().profile.value?.data;
    if (!AgencyColleagueAccessHelper.guardEdit(
        profile, AgencyPermission.businessReferrers)) {
      return;
    }
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
    if (isProfessional.value == null) {
      showUserTypeError.value = true;
      Get.snackbar(
        tr(LanguageKeys.error),
        tr(LanguageKeys.pleaseSelectUserType),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (isProfessional.value == true && job.isEmpty) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.jobRequired), snackPosition: SnackPosition.BOTTOM);
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
    final bool sponsorRequired = !createdByParent.value && isSponsored.value;
    if (sponsorRequired && selectedSponsorId.value == null) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.selectSponsorErr),
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final bool isSponsoredApi = sponsorRequired;
    final int? sponsorUserIdApi =
        isSponsoredApi ? selectedSponsorId.value : null;

    isSubmitting.value = true;
    try {
      final isPro = isProfessional.value == true;
      final request = AddBusinessReferrerRequest(
        dealId: dealId,
        firstName: firstName,
        lastName: lastName,
        countryCode: countryCode,
        phoneNumber: phone,
        email: email,
        job: isPro ? job : '',
        jobId: isPro && selectedJobId.value.isNotEmpty ? selectedJobId.value : null,
        companyType: isPro ? 'professional' : 'individual',
        createdByParent: createdByParent.value,
        isSponsored: isSponsoredApi,
        sponsorUserId: sponsorUserIdApi,
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
