import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_create_deal.dart';

class BusinessReferrerContractController extends GetxController {
  // Observable variables
  final RxString dealName = ''.obs;
  final RxBool isUniqueCommission = true.obs;
  final RxString selectedCommissionOption = 'Choose One option'.obs;
  final RxBool isGenerateContract = true.obs;
  final RxString dealId = ''.obs; // Add dealId for edit mode

  // Track name and stage tracking
  final RxString trackName = 'Contact called'.obs;

  // Completion stages
  final RxBool isContractSigned = false.obs;
  final RxBool isServiceDelivered = false.obs;
  final RxBool isPaymentReceived = false.obs;
  final RxBool isCommissionPaid = false.obs;

  // Validation
  final RxBool isDealNameValid = false.obs;

  // Text controllers
  final TextEditingController dealNameController = TextEditingController();

  /// Dynamic text fields for custom entries
  final RxList<TextEditingController> dynamicFields = <TextEditingController>[
    TextEditingController(text: 'Contact called'),
    TextEditingController(text: 'Contract signed'),
    TextEditingController(text: 'Service delivered'),
    TextEditingController(text: 'Payment received'),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      // Edit mode
      dealId.value = args['deal_id']?.toString() ?? '';
      dealNameController.text = args['deal_name'] ?? '';
      selectedCommissionOption.value =
          mapApiCommissionTypeToUi(args['commission_type'] ?? '');
      // isUniqueCommission.value = args['is_unique_commission'] ?? true;
      // isGenerateContract.value = args['is_generate_contract'] ?? true;
      dynamicFields.value = args['track_names'] ?? [];
      // Set track names if provided
      if (args['track_names'] != null && args['track_names'] is List) {
        dynamicFields.clear();
        for (var trackName in args['track_names']) {
          dynamicFields.add(TextEditingController(text: trackName));
        }
      }
    }
  }

  @override
  void onClose() {
    for (var ctrl in dynamicFields) {
      ctrl.dispose();
    }
    dynamicFields.clear();
    dealNameController.dispose();
    super.onClose();
  }

  // Validate deal name
  void _validateDealName() {
    dealName.value = dealNameController.text;
    isDealNameValid.value = dealNameController.text.isNotEmpty;
  }

  // Toggle commission type
  void toggleCommissionType(bool isUnique) {
    isUniqueCommission.value = isUnique;
  }

  // Map API commission type to UI value
  String mapApiCommissionTypeToUi(String apiType) {
    switch (apiType.toLowerCase()) {
      case 'fix_commission':
        return 'Fix Commission';
      case 'no_commission':
        return 'No Commission';
      default:
        return 'Percentage Commission';
    }
  }

  // Map UI commission type to API value
  String mapUiCommissionTypeToApi(String uiType) {
    switch (uiType) {
      case 'Fix Commission':
        return 'fix_commission';
      case 'No Commission':
        return 'no_commission';
      default:
        return 'percentage';
    }
  }

  // Set commission option
  void setCommissionOption(String option) {
    selectedCommissionOption.value = option;
  }

  // Toggle contract generation type
  void toggleContractGeneration(bool isGenerate) {
    isGenerateContract.value = isGenerate;
  }

  // Update track name
  void updateTrackName(String name) {
    trackName.value = name;
  }

  // Toggle completion stages
  void toggleContractSigned() {
    isContractSigned.value = !isContractSigned.value;
  }

  void toggleServiceDelivered() {
    isServiceDelivered.value = !isServiceDelivered.value;
  }

  void togglePaymentReceived() {
    isPaymentReceived.value = !isPaymentReceived.value;
  }

  void toggleCommissionPaid() {
    isCommissionPaid.value = !isCommissionPaid.value;
  }

  // Check if form is valid for submission
  bool isFormValid() {
    return isDealNameValid.value;
  }

  // Submit deal
  void submitDeal() {
    if (dealId.value.isNotEmpty) {
      updateDeal();
    } else {
      createDeal();
    }
  }

  /// Add a new dynamic text field
  void addDynamicField() {
    dynamicFields.add(TextEditingController());
  }

  /// Remove a dynamic text field at [index]
  void removeDynamicField(int index) {
    if (index >= 0 && index < dynamicFields.length) {
      dynamicFields[index].dispose();
      dynamicFields.removeAt(index);
    }
  }

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ModelCreateDeal> dealList = <ModelCreateDeal>[].obs;
  final RxString dealError = ''.obs;

  Future<void> createDeal() async {
    isLoading.value = true;
    errorMessage.value = '';

    List<String> trackNameList =
        dynamicFields.map((field) => field.text).toList();

    try {
      final response = await RESTAuth.createDeal(
        dealNameController.text,
        mapUiCommissionTypeToApi(selectedCommissionOption.value),
        dynamicFields.map((field) => field.text).join(', '),
        trackNameList,
      );

      if (response is ApiSuccess<ModelCreateDeal>) {
        if (response.data.status == true) {
          dealList.add(response.data);
          Get.back();
        } else {
          dealError.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        dealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeal() async {
    isLoading.value = true;
    errorMessage.value = '';

    List<String> trackNameList =
        dynamicFields.map((field) => field.text).toList();

    try {
      final response = await RESTAuth.updateDeal(
        dealNameController.text,
        mapUiCommissionTypeToApi(selectedCommissionOption.value),
        dynamicFields.value.map((field) => field.text).join(', '),
        trackNameList,
        dealId.value,
      );

      if (response is ApiSuccess<ModelCreateDeal>) {
        if (response.data.status == true) {
          Get.back();
        } else {
          dealError.value = response.data.message ?? 'Failed to update deal';
        }
      } else if (response is ApiFailure) {
        dealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }
}
