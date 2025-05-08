import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/popups/out_of_referaly_dialog.dart'
    show OutOfReferalyDialog;

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

void showAddLeadDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: OutOfReferalyDialog(), // Your dialog content widget
      ),
    ),
  );
}
