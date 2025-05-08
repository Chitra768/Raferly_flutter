import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_helper.dart';

import '../../controller/controller_forgot.dart';
import '../../resources/app_colors.dart';
import '../../widgets/custom_auth_app_bar.dart';
import '../../widgets/primary_button.dart'; // Assuming you're using GetX for state management

class ScreenForgotPassword extends GetView<ForgotPasswordController> {
  ScreenForgotPassword({super.key});
  static const String pageId = '/ScreenForgotPassword';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAuthAppBar(),
        backgroundColor: AppColors.whiteColor,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.black87, // Or your preferred heading color
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Don't worry! It occurs. Please enter the email address linked with your account.",
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Colors.black54, // Or your preferred subtitle color
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Use the custom label and underline field
                      _buildLabel("Email", isRequired: true),
                      _buildUnderlineField(
                        controllerr: controller.emailController,
                        hintText: "Enter Your Email",
                        keyboardType: TextInputType.emailAddress,
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
                                  AppHelper.hideKeyboard(context);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _buildLabel widget to display the label with an optional required marker
  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          if (isRequired)
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
        ],
      ),
    );
  }

  // _buildUnderlineField widget to build a TextFormField with a custom design
  Widget _buildUnderlineField({
    required TextEditingController controllerr,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controllerr,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          filled: true,
          fillColor: Colors.black.withOpacity(0.045),
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
