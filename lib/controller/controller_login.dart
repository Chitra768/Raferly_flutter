import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';

class ControllerLogin extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onLoginPressed() {
    // You can add validation or API logic here
    final email = emailController.text;
    final password = passwordController.text;
    print("Email: $email, Password: $password");

    Get.toNamed(ScreenVerification.pageId);
  }
}
