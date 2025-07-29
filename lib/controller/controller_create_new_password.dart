import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/auth/screen_password_changed_success.dart';
import 'package:referaly/utils/translations.dart';

class ControllerCreateNewPassword extends GetxController {
  // TextControllers for the form fields
  final TextEditingController tcPassword = TextEditingController();
  final TextEditingController tcConfirmPassword = TextEditingController();

  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;
  RxString email = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    email.value = Get.arguments["email"];
  }

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Handle form submission
  void onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      // If the form is valid, handle the password change logic here
      String newPassword = tcPassword.text;
      String confirmPassword = tcConfirmPassword.text;

      resetPasswordApi();
    
     
      // For example: perform API call to update password
    } else {
      // Show validation errors
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.pleaseEnterPassword));
    }
  }
    // Called when the user submits the verification code.
  Future<void> resetPasswordApi() async {
    AppHelper.hideKeyboard(Get.overlayContext!);

    final newPassword = tcPassword.text.trim();
    final confirmPassword = tcConfirmPassword.text.trim();

   

    try {
      final response = await RESTAuth.resetPassword(
        email: email.value,
        newPassword: newPassword,
      );

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          Get.offAllNamed(ScreenPasswordChangedSuccess.pageId);
        } else {
          tcPassword.clear();
          tcConfirmPassword.clear();
        }
      } else if (response is ApiFailure) {
        final errorMsg =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      debugPrint('ResetPassword Error: $e');
    }
  }
}
