import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_add_lead_with_referrer_request.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/models/model_redeive_lead_deal.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/lead_added_success_popup.dart';
import 'dart:async';

class AddLeadSourceController extends GetxController {
  // Selected lead source: 'network' for Referrer in network, 'external' for External Source
  var selectedLeadSource = 'network'.obs;
  final MyActivityController myActivityCntrl = Get.find();
  // Step management
  var currentStep = 1.obs; // 1 or 2

  // Business referrer search
  TextEditingController searchController = TextEditingController();
  RxList<BusinessReferrers> businessReferrers = <BusinessReferrers>[].obs;
  RxList<BusinessReferrers> filteredReferrers = <BusinessReferrers>[].obs;
  var selectedReferrerId = Rxn<int>();
  var selectedBusinessDealId = Rxn<int>();
  RxBool isLoadingReferrers = false.obs;
  RxBool showAllReferrers = false.obs;
  final RxList<RedeiveLeadDealData> businessDeals = <RedeiveLeadDealData>[].obs;
  final RxBool isLoadingBusinessDeals = false.obs;
  final RxString businessDealError = ''.obs;

  // External referrer form fields
  TextEditingController referrerFirstNameController = TextEditingController();
  TextEditingController referrerLastNameController = TextEditingController();
  TextEditingController referrerEmailController = TextEditingController();
  TextEditingController referrerPhoneController = TextEditingController();
  TextEditingController referrerJobTitleController = TextEditingController();
  TextEditingController referrerCityController = TextEditingController();
  var selectedLanguage = Rxn<String>();
  
  // Available languages
  final List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
  ];

  // Lead form fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final RxInt noteLength = 0.obs;
  final RxBool isSubmitting = false.obs;

  VoidCallback? _noteListener;

  @override
  void onInit() {
    super.onInit();
    if (selectedLeadSource.value == 'network') {
      fetchBusinessReferrers();
    } else {
      fetchBusinessDeals();
      // Set default language to French when external is selected
      if (selectedLanguage.value == null) {
        selectedLanguage.value = 'fr';
      }
    }
    _noteListener = () {
      noteLength.value = noteController.text.length;
    };
    noteController.addListener(_noteListener!);
    noteLength.value = noteController.text.length;
  }

  @override
  void onClose() {
    searchController.dispose();
    referrerFirstNameController.dispose();
    referrerLastNameController.dispose();
    referrerEmailController.dispose();
    referrerPhoneController.dispose();
    referrerJobTitleController.dispose();
    referrerCityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    if (_noteListener != null) {
      noteController.removeListener(_noteListener!);
    }
    noteController.dispose();
    super.onClose();
  }

  void selectLeadSource(String source) {
    selectedLeadSource.value = source;
    if (source == 'network') {
      selectedBusinessDealId.value = null;
      selectedLanguage.value = null;
      if (businessReferrers.isEmpty) {
        fetchBusinessReferrers();
      }
    } else {
      if (businessDeals.isEmpty) {
        fetchBusinessDeals();
      } else if (selectedBusinessDealId.value == null &&
          businessDeals.isNotEmpty) {
        selectedBusinessDealId.value = businessDeals.first.id;
      }
      // Set default language to French if not set
      if (selectedLanguage.value == null) {
        selectedLanguage.value = 'fr';
      }
    }
  }

  void filterReferrers() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      filteredReferrers.value = List.from(businessReferrers);
      // Reset showAllReferrers when search is cleared
      showAllReferrers.value = false;
    } else {
      filteredReferrers.value = businessReferrers.where((referrer) {
        final firstName = referrer.firstName?.toLowerCase() ?? '';
        final lastName = referrer.lastName?.toLowerCase() ?? '';
        final fullName = '$firstName $lastName';
        final email = referrer.email?.toLowerCase() ?? '';
        final phone = referrer.phoneNumber?.toLowerCase() ?? '';
        final job = referrer.job?.toLowerCase() ?? '';

        return fullName.contains(query) ||
            email.contains(query) ||
            phone.contains(query) ||
            job.contains(query);
      }).toList();
      // When searching, show all filtered results
      showAllReferrers.value = true;
    }
  }

  void toggleShowAllReferrers() {
    showAllReferrers.value = !showAllReferrers.value;
  }

  Future<void> fetchBusinessReferrers() async {
    isLoadingReferrers.value = true;
    try {
      final response = await RESTAuth.getNetworkList();
      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          businessReferrers.value = response.data.data?.businessReferrers ?? [];
          filteredReferrers.value = List.from(businessReferrers);
          showAllReferrers.value = false; // Reset to show only 3 initially
        }
      }
    } catch (e) {
      print('Error fetching business referrers: $e');
    } finally {
      isLoadingReferrers.value = false;
    }
  }

  Future<void> fetchBusinessDeals() async {
    isLoadingBusinessDeals.value = true;
    businessDealError.value = '';
    try {
      final response = await RESTAuth.businessReferralDealList();
      if (response is ApiSuccess<ModelRedeiveLeadDeal>) {
        if (response.data.status == true) {
          businessDeals.value = response.data.data ?? [];
          if (businessDeals.isNotEmpty) {
            selectedBusinessDealId.value ??= businessDeals.first.id;
          }
        } else {
          businessDealError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        businessDealError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      businessDealError.value = e.toString();
    } finally {
      isLoadingBusinessDeals.value = false;
    }
  }

  void selectReferrer(int? referrerId) {
    selectedReferrerId.value = referrerId;
  }

  void onContinue() {
    if (currentStep.value == 1) {
      currentStep.value = 2;
    }
  }

  void onBack() {
    if (currentStep.value == 2) {
      currentStep.value = 1;
    } else {
      Get.back();
    }
  }

  Future<void> onAddLead() async {
    if (isSubmitting.value) return;

    if (selectedLeadSource.value == 'network') {
      if (!_validateNetworkLeadForm()) {
        return;
      }
      await _submitNetworkLead();
    } else {
      if (!_validateExternalLeadForm()) {
        return;
      }
      await _submitExternalLead();
    }
  }

  Future<void> _submitNetworkLead() async {
    final BusinessReferrers? selectedReferrer =
        _findReferrerById(selectedReferrerId.value);
    if (selectedReferrer == null) {
      _showError(tr(LanguageKeys.pleaseSelectReferrer));
      return;
    }

    final String dealId = selectedReferrer.dealId?.toString() ?? '';
    if (dealId.isEmpty) {
      _showError(tr(LanguageKeys.pleaseSelectDeal));
      return;
    }

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String phone = phoneController.text.trim();
    final String email = emailController.text.trim();
    final String note = noteController.text.trim();

    isSubmitting.value = true;
    try {
      final ApiResult result = await RESTAuth.createLead(
        firstName,
        lastName,
        phone,
        email,
        note,
        tr(LanguageKeys.businessReferrer),
        dealId,
        dealId,
        selectedReferrer.id?.toString() ?? '',
        '',
        selectedLanguage.value ?? '',
      );

      if (result is ApiSuccess<ModelLeadCreate>) {
        final leadFullName = '$firstName $lastName'.trim();
        _resetLeadForm();
        _showSuccessPopup(leadFullName);
      } else if (result is ApiFailure) {
        _showError(result.error.message ?? tr(LanguageKeys.somethingWentWrong));
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _submitExternalLead() async {
    final request = AddLeadWithReferrerRequest(
      dealId: selectedBusinessDealId.value?.toString() ?? '',
      firstName: referrerFirstNameController.text.trim(),
      lastName: referrerLastNameController.text.trim(),
      email: referrerEmailController.text.trim(),
      phoneNumber: referrerPhoneController.text.trim(),
      job: referrerJobTitleController.text.trim(),
      city: referrerCityController.text.trim(),
      language: selectedLanguage.value ?? '',
      lead: LeadPayload(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        note: noteController.text.trim(),
      ),
    );

    isSubmitting.value = true;
    try {
      final ApiResult result = await RESTAuth.addLeadWithReferrer(request);

      if (result is ApiSuccess<ModelLeadCreate>) {
        final leadFullName =
            '${request.lead.firstName} ${request.lead.lastName}'.trim();
        _resetExternalReferrerForm();
        _resetLeadForm();
        _showSuccessPopup(leadFullName);
      } else if (result is ApiFailure) {
        _showError(result.error.message ?? tr(LanguageKeys.somethingWentWrong));
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _validateNetworkLeadForm() {
    if (selectedReferrerId.value == null) {
      _showError(tr(LanguageKeys.pleaseSelectReferrer));
      return false;
    }
    if (!_validateLeadContactFields()) {
      return false;
    }
    if (noteController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterLeadNote));
      return false;
    }
    return true;
  }

  bool _validateExternalLeadForm() {
    if (referrerFirstNameController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterFirstName));
      return false;
    }
    if (referrerLastNameController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterLastName));
      return false;
    }
    if (referrerPhoneController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterPhoneNumber));
      return false;
    }
    if (referrerEmailController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterEmail));
      return false;
    }
    if (!_validateLeadContactFields()) {
      return false;
    }
    if (selectedBusinessDealId.value == null) {
      _showError(tr(LanguageKeys.selectDealErr));
      return false;
    }
    if (noteController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterLeadNote));
      return false;
    }
    return true;
  }

  bool _validateLeadContactFields() {
    if (firstNameController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterFirstName));
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterLastName));
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterPhoneNumber));
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      _showError(tr(LanguageKeys.pleaseEnterEmail));
      return false;
    }
    return true;
  }

  BusinessReferrers? _findReferrerById(int? id) {
    if (id == null) return null;
    for (final BusinessReferrers referrer in businessReferrers) {
      if (referrer.id == id) {
        return referrer;
      }
    }
    return null;
  }

  void _resetLeadForm() {
    selectedReferrerId.value = null;
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    noteController.clear();
    noteLength.value = 0;
  }

  void _resetExternalReferrerForm() {
    referrerFirstNameController.clear();
    referrerLastNameController.clear();
    referrerEmailController.clear();
    referrerPhoneController.clear();
    referrerJobTitleController.clear();
    referrerCityController.clear();
    selectedLanguage.value = null;
  }

  void _showSuccessPopup(String leadFullName) {
    Get.dialog(
      LeadAddedSuccessPopup(
        leadName: leadFullName,
        onClose: () {
          Get.back();
        },
      ),
      barrierDismissible: false,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      tr(LanguageKeys.error),
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
