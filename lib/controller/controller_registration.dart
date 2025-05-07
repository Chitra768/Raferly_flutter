import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resources/app_log.dart';

class RegistrationController extends GetxController {
  // Text editing controllers for the input fields
  final tcFirstNameController = TextEditingController();
  final tcLastNameController = TextEditingController();
  final tcEmailController = TextEditingController();
  final tcPasswordController = TextEditingController();
  final tcPhoneNumberController = TextEditingController();
  final tcJobController = TextEditingController();
  final tcCity = TextEditingController();

  final Rx<Country> selectedCountry = Country(name: 'United States', emoji: '🇺🇸', code: '+1').obs;

  final List<Country> countries = [
    Country(name: 'United States', emoji: '🇺🇸', code: '+1'),
    Country(name: 'Spain', emoji: '🇪🇸', code: '+34'),
    Country(name: 'Belgium', emoji: '🇧🇪', code: '+32'),
    Country(name: 'France', emoji: '🇫🇷', code: '+33'),
    Country(name: 'Luxembourg', emoji: '🇱🇺', code: '+352'),
    Country(name: 'Switzerland', emoji: '🇨🇭', code: '+41'),
  ];


  // RxBool for radio button selection
  final isProfessional = true.obs;

  // RxBool to toggle password visibility
  final isPasswordVisible = false.obs;

  // Privacy policies
  RxBool isAccepted  = false.obs;

  // Function to handle the registration process
  void register() {
    if (tcFirstNameController.text.isEmpty ||
        tcLastNameController.text.isEmpty ||
        tcEmailController.text.isEmpty ||
        tcPasswordController.text.isEmpty ||
        tcPhoneNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Log input values
    AppLog.d('First Name: ${tcFirstNameController.text}');
    AppLog.d('Last Name: ${tcLastNameController.text}');
    AppLog.d('Email: ${tcEmailController.text}');
    AppLog.d('Password: ${tcPasswordController.text}');
    AppLog.d('Phone Number: ${tcPhoneNumberController.text}');
    AppLog.d('Professional: $isProfessional');
    AppLog.d('Job: ${tcJobController.text}');

    // Show a success message
    Get.snackbar(
      'Success',
      'Registration successful!',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Clear fields after successful registration
    tcFirstNameController.clear();
    tcLastNameController.clear();
    tcEmailController.clear();
    tcPasswordController.clear();
    tcPhoneNumberController.clear();
    tcJobController.clear();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void dispose() {
    tcFirstNameController.dispose();
    tcLastNameController.dispose();
    tcEmailController.dispose();
    tcPasswordController.dispose();
    tcPhoneNumberController.dispose();
    tcJobController.dispose();
    super.dispose();
  }
}

class Country {
  final String name;
  final String emoji;
  final String code;

  Country({required this.name, required this.emoji, required this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              emoji == other.emoji &&
              code == other.code;

  @override
  int get hashCode => name.hashCode ^ emoji.hashCode ^ code.hashCode;
}
