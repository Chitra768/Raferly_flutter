import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxString('');
  final successMessage = RxString('');

  Future<void> resetPassword() async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    // Simulate an API call for password reset
    await Future.delayed(const Duration(seconds: 2));

    final email = emailController.text.trim();

    // In a real application, you would send this email to your backend
    if (email == 'test@example.com') {
      successMessage.value = 'A password reset link has been sent to your email address.';
    } else {
      errorMessage.value = 'No account found with this email address.';
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}