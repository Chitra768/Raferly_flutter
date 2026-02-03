import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_accept_list.dart' as accept_list;
import 'package:referaly/models/model_redeive_lead_deal.dart';
import 'package:referaly/resources/app_preference.dart';
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
  var selectedBusinessDealId = RxnString();
  var selectedCreatedBy = RxnString();
  final RxList<accept_list.Data> dealList = <accept_list.Data>[].obs;
  final RxBool isLoadingDeals = false.obs;
  final RxString dealError = ''.obs;
  var type = "".obs;
  var dealName = "".obs;
  var id = "";
  final RxList<Contact> contacts = <Contact>[].obs;
  final RxList<Contact> filteredContacts = <Contact>[].obs;
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
      dealName.value = args['deal_name'] ?? '';
      type.value = args['type'] ?? '';
      if (args['business_referrer_id'] != null) {
        selectedBusinessReferrerId.value =
            args['business_referrer_id'].toString();
      }
      if (args['created_by'] != null) {
        selectedCreatedBy.value = args['created_by'].toString();
      }
    }
    selectedFeedbackType.value = tr(LanguageKeys.mySelf);
    print("selectedFeedbackType.value: ${selectedFeedbackType.value}");
    getDeals();
    getBusinessReferralLead();
    businessDealList();
    noteController.addListener(() {
      noteLength.value = noteController.text.length;
    });
    loadContacts();
    getAcceptList();
  }

  Future<void> loadContacts() async {
    final permission = await FlutterContacts.requestPermission();
    if (!permission) return;

    isLoading.value = true;

    // Optimize by not loading unnecessary data like photos or emails
    contacts.value = await FlutterContacts.getContacts(
      withProperties: true, // get phone/email
      withPhoto: false, // disable photos to improve speed
    );

    isLoading.value = false;
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
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        businessReferralLeadError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
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
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        businessReferralDealError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
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
      final bool hasBusinessReferrerSelection =
          (selectedBusinessReferrerId.value?.isNotEmpty ?? false) ||
              (selectedBusinessDealId.value?.isNotEmpty ?? false);

      final String leadAssignTypePayload = hasBusinessReferrerSelection
          ? tr(LanguageKeys.businessReferrer)
          : (selectedFeedbackType.value ?? '');

      final response = await RESTAuth.createLead(
          firstNameController.text,
          lastNameController.text,
          phoneController.text,
          emailController.text,
          noteController.text,
          leadAssignTypePayload,
          selectedDealId.value ?? '',
          selectedBusinessDealId.value ?? '',
          selectedBusinessReferrerId.value ?? '',
          selectedCreatedBy.value ?? '',
          AppPreference.getLanguage());
      if (response is ApiSuccess<ModelLeadCreate>) {
        lead.value = response.data;
        // Refresh deals list
        await getDeals();
        Get.find<TrackLeadsController>().getSendLeads();
        // Show success popup
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () {
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
                selectedCreatedBy.value = null;
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }
        // // Clear all form fields

        // // Refresh deals list
        // await getDeals();
        // // Show success popup
        // if (Get.context != null) {
        //   showDialog(
        //     context: Get.context!,
        //     builder: (context) => SuccessPopup(
        //       message: response.data.message ?? '',
        //       onOk: () {
        //             firstNameController.clear();
        // lastNameController.clear();
        // phoneController.clear();
        // emailController.clear();
        // noteController.clear();
        // selectedFeedbackType.value = null;
        // selectedBusinessReferrer.value = null;
        // selectedBusinessDeal.value = null;
        // selectedDealId.value = null;
        // selectedBusinessReferrerId.value = null;
        //         Get.back();
        //       },
        //     ),
        //     barrierDismissible: false,
        //   );
        // }
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
        selectedCreatedBy.value ?? '',
      );
      if (response is ApiSuccess<ModelLeadCreate>) {
        lead.value = response.data;
        // Refresh deals list
        await getDeals();
        Get.find<TrackLeadsController>().getSendLeads();
        // Show success popup
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () {
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
                selectedCreatedBy.value = null;
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
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

  final RxList<accept_list.Data> acceptList = <accept_list.Data>[].obs;

  Future<void> getAcceptList() async {
    try {
      final response = await RESTAuth.getAcceptList();
      if (response is ApiSuccess<accept_list.ModelAcceptList>) {
        if (response.data.status == true) {
          acceptList.value = response.data.data ?? [];
          // Set the first item as default selection if no deal is currently selected
          if (selectedDealId.value?.isEmpty == true && acceptList.isNotEmpty) {
            selectedDealId.value = acceptList.first.id.toString();
            selectedBusinessReferrerId.value = acceptList.first.createdBy ?? "";
          } else if (selectedDealId.value?.isNotEmpty == true) {
            // If a deal is already selected, find its createdBy value
            final selectedDeal = acceptList.firstWhere(
              (deal) => deal.id.toString() == selectedDealId.value,
              orElse: () => accept_list.Data(),
            );
            if (selectedDeal.id != null) {
              selectedBusinessReferrerId.value = selectedDeal.createdBy ?? "";
            }
          }
        }
      }
    } catch (e) {}
  }

  // Validation methods
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${tr(LanguageKeys.firstName)} is required';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${tr(LanguageKeys.lastName)} is required';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${tr(LanguageKeys.phoneNumber)} is required';
    }
    // Basic phone validation - you can enhance this based on your requirements
    if (value.length < 10) {
      return '${tr(LanguageKeys.phoneNumber)} must be at least 10 digits';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      // Basic email validation - allows special characters
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  String? validateDealSelection(String? value) {
    if (value == null || value.isEmpty) {
      return '${tr(LanguageKeys.selectDeal)} is required';
    }
    return null;
  }
}
