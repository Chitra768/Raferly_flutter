import 'package:flutter/material.dart';
import '../models/model_user_profile.dart';

class EditProfileController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final jobController = TextEditingController();
  final cityController = TextEditingController();
  final languageController = TextEditingController();

  String userType = 'Professional';

  void setUserType(String value) {
    userType = value;
    notifyListeners();
  }

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
      phone: phoneController.text,
      userType: userType,
      job: jobController.text,
      city: cityController.text,
      language: languageController.text,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    jobController.dispose();
    cityController.dispose();
    languageController.dispose();
    super.dispose();
  }
}
