import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/auth/screen_password_changed_success.dart';
import 'package:referaly/utils/translations.dart';

class ControllerCreateNewPassword extends GetxController {
  // TextControllers for the form fields
  final TextEditingController tcPassword = TextEditingController();
  final TextEditingController tcConfirmPassword = TextEditingController();

  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Handle form submission
  void onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      // If the form is valid, handle the password change logic here
      String newPassword = tcPassword.text;
      String confirmPassword = tcConfirmPassword.text;
      
    
      Get.offAllNamed(ScreenPasswordChangedSuccess.pageId);
      // For example: perform API call to update password
    } else {
      // Show validation errors
      Get.snackbar(tr(LanguageKeys.error), tr(LanguageKeys.pleaseEnterPassword));
    }
  }
}
