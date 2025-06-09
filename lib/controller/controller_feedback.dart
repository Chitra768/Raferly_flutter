import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_feedback.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class FeedbackController extends GetxController {
  // List of feedback types for dropdown
  final feedbackTypes = <String>[
   tr(LanguageKeys.featureIdea),
    tr(LanguageKeys.reportABug),
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
              message: tr(LanguageKeys.feedbackSubmittedSuccessfully) ?? tr(LanguageKeys.feedbackSubmittedSuccessfully),
              onOk: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }
     
        return response.data as FeedbackModel;
      } else {
        errorMessage.value = response.message ?? '';
        return FeedbackModel(
          status: false,
          message: response.message ?? tr(LanguageKeys.somethingWentWrong),
        );
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
      return FeedbackModel(
        status: false,
        message: tr(LanguageKeys.somethingWentWrong),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
