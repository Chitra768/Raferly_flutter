import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_accept_list.dart' as accept_list;
import 'package:referaly/models/model_redeive_lead_deal.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class AddLeadController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();
  var noteLength = 0.obs;

  var selectedFeedbackType = RxnString();
  var selectedBusinessReferrer = RxnString();
  var selectedBusinessDeal = RxnString();
  var selectedDealId = RxnString();
  var selectedBusinessReferrerId = RxnString();
  final RxList<accept_list.Data> dealList = <accept_list.Data>[].obs;
  final RxBool isLoadingDeals = false.obs;
  final RxString dealError = ''.obs;
  var id = "";
  final feedbackTypes = [
    tr(LanguageKeys.mySelf),
    tr(LanguageKeys.businessReferrer),
  ];

  final RxBool isConsentChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    Map<String, dynamic> safeArgs = {};
    if (args is Map<String, dynamic>) {
      // Now args is always a Map, possibly empty
      selectedFeedbackType.value = args['lead_assign_type'];
      firstNameController.text = args['first'] ?? '';
      lastNameController.text = args['last'] ?? '';
      emailController.text = args['email'] ?? '';
      phoneController.text = args['phone'] ?? '';
      noteController.text = args['description'] ?? '';
      id = (args['id'] ?? '').toString();
      selectedDealId.value = (args['deal_id'] ?? '').toString();
      if (args['business_referrer_id'] != null) {
        selectedBusinessReferrerId.value =
            args['business_referrer_id'].toString();
      }
    }
    print("selectedFeedbackType.value: ${selectedFeedbackType.value}");
    getDeals();
    getBusinessReferralLead();
    businessDealList();
    noteController.addListener(() {
      noteLength.value = noteController.text.length;
    });
  }

  Future<void> getDeals() async {
    isLoadingDeals.value = true;
    dealError.value = '';
    try {
      final response = await RESTAuth.getAcceptList();
      if (response is ApiSuccess<accept_list.ModelAcceptList>) {
        if (response.data.status == true) {
          dealList.value = response.data.data ?? [];
        } else {
          dealError.value = response.data.message ?? 'Failed to get deals';
        }
      } else if (response is ApiFailure) {
        dealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      dealError.value = e.toString();
    } finally {
      isLoadingDeals.value = false;
    }
  }

  final RxList<BusinessReferralLeadData> businessReferralLeadList =
      <BusinessReferralLeadData>[].obs;
  final RxBool isLoadingBusinessReferralLead = false.obs;
  final RxString businessReferralLeadError = ''.obs;

  Future<void> getBusinessReferralLead() async {
    isLoadingBusinessReferralLead.value = true;
    businessReferralLeadError.value = '';
    try {
      final response = await RESTAuth.businessReferralLead(
        '',
        '',
      );
      if (response is ApiSuccess<ModelBusinessReferralLead>) {
        if (response.data.status == true) {
          // Use a Map to ensure unique entries based on ID
          final Map<int, BusinessReferralLeadData> uniqueMap = {};
          for (var item in response.data.data ?? []) {
            if (item.id != null) {
              uniqueMap[item.id!] = item;
            }
          }
          // Convert map values back to list
          businessReferralLeadList.value = uniqueMap.values.toList();

          // Set initial value if we have a selected ID
          if (selectedBusinessReferrerId.value != null &&
              selectedBusinessReferrerId.value!.isNotEmpty) {
            final selectedId = int.tryParse(selectedBusinessReferrerId.value!);
            if (selectedId != null && uniqueMap.containsKey(selectedId)) {
              final selectedItem = uniqueMap[selectedId]!;
              selectedBusinessReferrer.value = selectedId.toString();
            }
          }
        } else {
          businessReferralLeadError.value =
              response.data.message ?? 'Failed to get deals';
        }
      } else if (response is ApiFailure) {
        businessReferralLeadError.value =
            response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      businessReferralLeadError.value = e.toString();
    } finally {
      isLoadingBusinessReferralLead.value = false;
    }
  }

  final RxList<RedeiveLeadDealData> businessReferralDealList =
      <RedeiveLeadDealData>[].obs;
  final RxBool isLoadingBusinessReferralDeal = false.obs;
  final RxString businessReferralDealError = ''.obs;

  Future<void> businessDealList() async {
    isLoadingBusinessReferralDeal.value = true;
    businessReferralDealError.value = '';
    try {
      final response = await RESTAuth.businessReferralDealList();
      if (response is ApiSuccess<ModelRedeiveLeadDeal>) {
        if (response.data.status == true) {
          businessReferralDealList.value = response.data.data ?? [];
        } else {
          businessReferralDealError.value =
              response.data.message ?? 'Failed to get deals';
        }
      } else if (response is ApiFailure) {
        businessReferralDealError.value =
            response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      businessReferralDealError.value = e.toString();
    } finally {
      isLoadingBusinessReferralDeal.value = false;
    }
  }



  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    noteController.dispose();
    super.onClose();
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<ModelLeadCreate?> lead = Rx<ModelLeadCreate?>(null);
  Future<void> createLead() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.createLead(
          firstNameController.text,
          lastNameController.text,
          phoneController.text,
          emailController.text,
          noteController.text,
          selectedFeedbackType.value ?? '',
          selectedDealId.value ?? '',
          selectedBusinessReferrerId.value ?? '',
          selectedBusinessDeal.value ?? '');
      if (response is ApiSuccess<ModelLeadCreate>) {
        lead.value = response.data;
        // Clear all form fields
        firstNameController.clear();
        lastNameController.clear();
        phoneController.clear();
        emailController.clear();
        noteController.clear();
        selectedFeedbackType.value = null;
        selectedBusinessReferrer.value = null;
        selectedBusinessDeal.value = null;
        selectedDealId.value = null;
        selectedBusinessReferrerId.value = null;
        // Refresh deals list
        await getDeals();
        // Show success popup
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? 'Lead added successfully',
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLead() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.updateLead(
        firstNameController.text,
        lastNameController.text,
        phoneController.text,
        emailController.text,
        noteController.text,
        selectedFeedbackType.value ?? '',
        selectedDealId.value ?? '',
        id ?? '',
      );
      if (response is ApiSuccess<ModelLeadCreate>) {
        lead.value = response.data;
        // Refresh deals list
        await getDeals();
        // Show success popup
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? 'Lead updated successfully',
            ),
            barrierDismissible: false,
          );
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
