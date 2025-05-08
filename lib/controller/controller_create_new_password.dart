import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_helper.dart';

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

      // For example: perform API call to update password
      // Assuming the password change is successful:
      Get.snackbar('Success', 'Your password has been updated');
    } else {
      // Show validation errors
      Get.snackbar('Error', 'Please fix the errors');
    }
  }
}
