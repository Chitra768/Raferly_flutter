import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_feedback.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/feedback_thank_you_dialog.dart';

enum FeedbackTabKind { idea, bug }

extension FeedbackTabKindApi on FeedbackTabKind {
  String get apiType => this == FeedbackTabKind.idea ? 'feature_idea' : 'bug';
}

class FeedbackController extends GetxController {
  final selectedTab = FeedbackTabKind.idea.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void selectTab(FeedbackTabKind kind) {
    selectedTab.value = kind;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void onSubmit() {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    if (title.isEmpty) {
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.pleaseEnterTitle));
      return;
    }
    if (desc.isEmpty) {
      Get.snackbar(
        tr(LanguageKeys.error),
        tr(LanguageKeys.pleaseEnterDescription),
      );
      return;
    }
    submitFeedback(
      title: title,
      description: desc,
      type: selectedTab.value.apiType,
      email: AppPreference.readString(AppPreference.email) ?? '',
    );
  }

  Future<FeedbackModel> submitFeedback({
    required String title,
    required String description,
    required String type,
    required String email,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await RESTAuth.submitFeedback(
        title: title,
        description: description,
        type: type,
        email: email,
      );

      if (response.status == true) {
        final ctx = Get.context;
        if (ctx != null && ctx.mounted) {
          await FeedbackThankYouDialog.show(
            ctx,
            onBackToApp: Get.back,
          );
        }
        return response;
      } else {
        errorMessage.value = response.message ?? '';
        if (errorMessage.value.isNotEmpty) {
          Get.snackbar(tr(LanguageKeys.error), errorMessage.value);
        }
        return response;
      }
    } catch (e) {
      errorMessage.value = tr(LanguageKeys.somethingWentWrong);
      Get.snackbar(tr(LanguageKeys.error), errorMessage.value);
      return FeedbackModel(
        status: false,
        message: tr(LanguageKeys.somethingWentWrong),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
