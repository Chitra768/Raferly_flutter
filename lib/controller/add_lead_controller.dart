import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLeadController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  var selectedFeedbackType = RxnString();
  final feedbackTypes = [
    'My Self',
    'Busniess referrer',
  ];

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
