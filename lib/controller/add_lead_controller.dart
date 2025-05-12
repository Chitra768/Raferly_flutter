import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_accept_list.dart' as accept_list;

class AddLeadController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  var selectedFeedbackType = RxnString();
  var selectedDealId = RxnString();
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
    getDeals();
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

  int getLeadAssignType(String? type) {
    if (type == 'My Self') {
      return 1; // myself
    } else if (type == 'Busniess referrer') {
      return 2; // business_referral
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
      );
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
