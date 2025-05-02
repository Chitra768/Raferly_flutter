import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller_forgot.dart';
import '../../resources/app_colors.dart';
import '../../widgets/primary_button.dart'; // Assuming you're using GetX for state management

class ScreenForgotPassword extends GetView<ForgotPasswordController> {
  ScreenForgotPassword({super.key});
  static const String pageId = '/ScreenForgotPassword';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
          color: Colors.black, // Or your preferred back button color
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Or your preferred heading color
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Don't worry! It occurs. Please enter the email address linked with your account.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54, // Or your preferred subtitle color
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter Your Email",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Obx(
                () => PrimaryButton(
                  text: "Continue",
                  onPressed: controller.isLoading.isFalse
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            controller.resetPassword();
                          }
                        }
                      : null,
                  borderRadius: 12,
                  disabledBackgroundColor:
                      Colors.grey[300], // Example disabled color
                ),
              ),
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              Obx(() {
                if (controller.successMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      controller.successMessage.value,
                      style: const TextStyle(color: Colors.green),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              Obx(() => controller.isLoading.isTrue
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primary,
                      )),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
