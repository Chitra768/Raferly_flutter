import 'package:flutter/material.dart';
import '../models/model_user_profile.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final jobController = TextEditingController();
  final cityController = TextEditingController();
  final languageController = TextEditingController();

  var userType = 'Professional'.obs;

  // Country code dropdown support
  final countryCodes = ['+1', '+91', '+44']; // Add more as needed
  var selectedCountryCode = '+1'.obs;

  void setUserType(String value) => userType.value = value;

  String get fullPhoneNumber =>
      '${selectedCountryCode.value} ${phoneController.text}';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  UserProfile getUserProfile() {
    return UserProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phone: fullPhoneNumber,
      userType: userType.value,
      job: jobController.text,
      city: cityController.text,
      language: languageController.text,
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    jobController.dispose();
    cityController.dispose();
    languageController.dispose();
    super.onClose();
  }
}
