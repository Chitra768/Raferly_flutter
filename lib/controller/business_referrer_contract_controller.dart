import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessReferrerContractController extends GetxController {
  // Observable variables
  final RxString dealName = ''.obs;
  final RxBool isUniqueCommission = true.obs;
  final RxString selectedCommissionOption = 'Choose One option'.obs;
  final RxBool isGenerateContract = true.obs;

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
    if (isFormValid()) {
      // Implementation for API call or data saving
      Get.snackbar(
        'Success',
        'Deal submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
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
}
