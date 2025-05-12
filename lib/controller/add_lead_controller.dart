import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_accept_list.dart' as accept_list;
import 'package:referaly/models/model_redeive_lead_deal.dart';

class AddLeadController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  var selectedFeedbackType = RxnString();
  var selectedBusinessReferrer = RxnString();
  var selectedBusinessDeal = RxnString();
  var selectedDealId = RxnString();
  var selectedBusinessReferrerId = RxnString();
  final RxList<accept_list.Data> dealList = <accept_list.Data>[].obs;
  final RxBool isLoadingDeals = false.obs;
  final RxString dealError = ''.obs;

  final feedbackTypes = [
    'My Self',
    'Busniess referrer',
  ];

  final RxBool isConsentChecked = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    print("lead_assign_type: ${args['lead_assign_type']}"); // Use as needed
    selectedFeedbackType.value = args['lead_assign_type'];
    firstNameController.text = args['first'];
    lastNameController.text = args['last'];
    emailController.text = args['email'];
    phoneController.text = args['phone'];

    getDeals();
    getBusinessReferralLead();
    businessDealList();
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
          businessReferralLeadList.value = response.data.data ?? [];
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

  int getLeadAssignType(String? type) {
    if (type == 'My Self') {
      return 3; // myself
    } else if (type == 'Busniess referrer') {
      return 4; // business_referral
    } else {
      return 3; // no_business_referral
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
          getLeadAssignType(selectedFeedbackType.value).toString(),
          selectedDealId.value ?? '',
          selectedBusinessReferrerId.value ?? '');
      if (response is ApiSuccess<ModelLeadCreate>) {
        lead.value = response.data;
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
