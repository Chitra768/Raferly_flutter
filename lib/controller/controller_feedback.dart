import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  // List of feedback types for dropdown
  final feedbackTypes = <String>[
    'General',
    'Bug Report',
    'Feature Request',
    'Other',
  ].obs;

  // Currently selected feedback type
  final selectedType = ''.obs;

  // Controller for description text field
  final descriptionController = TextEditingController();

  @override
  void onClose() {
    // Dispose controller when no longer needed
    descriptionController.dispose();
    super.onClose();
  }

  /// Called when user selects a feedback type
  void onTypeChanged(String? newType) {
    selectedType.value = newType ?? '';
  }

  /// Called when user taps Submit
  void onSubmit() {
    if (selectedType.value.isEmpty) {
      Get.snackbar('Error', 'Please select a feedback type');
      return;
    }
    final desc = descriptionController.text.trim();
    if (desc.isEmpty) {
      Get.snackbar('Error', 'Please enter a description');
      return;
    }
    // TODO: Add actual submission logic here (API call, etc.)
    print('Feedback submitted: Type=${selectedType.value}, Description=$desc');
    Get.back();
  }
}
