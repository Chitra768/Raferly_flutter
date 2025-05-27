import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_feedback.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class FeedbackController extends GetxController {
  // List of feedback types for dropdown
  final feedbackTypes = <String>[
    'Feature idea',
    'Report a bug',
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
    submitFeedback(
      type: selectedType.value,
      description: desc,
      email: AppPreference.readString(AppPreference.email) ?? '',
            );
  }

  // Loading state for submit feedback
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<FeedbackModel> submitFeedback(
      {required String type,
      required String description,
      required String email}) async {
    isLoading.value = true;
    errorMessage.value = '';



    try {
      final response = await RESTAuth.submitFeedback(
        type: type,
        description: description,
        email: email,
      );

      if (response.status == true) {
         if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.message ?? 'Feedback submitted successfully',
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }
        // Show success message
        // Get.snackbar(
        //   'Success',
        //   response.message ?? '',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        // Get.back();
        return response.data as FeedbackModel;
      } else {
        errorMessage.value = response.message ?? '';
        return FeedbackModel(
          status: false,
          message: response.message ?? 'Feedback submission failed',
        );
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      return FeedbackModel(
        status: false,
        message: 'An unexpected error occurred',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
