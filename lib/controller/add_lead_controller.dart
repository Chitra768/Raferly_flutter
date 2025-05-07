import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/popups/add_lead_dialog.dart' show AddLeadDialog;
import 'package:referaly/popups/out_of_referaly_dialog.dart'
    show OutOfReferalyDialog;
import 'package:referaly/screens/edit_profile_screen.dart';

class AddLeadController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  var selectedFeedbackType = RxnString();
  final feedbackTypes = ['Type 1', 'Type 2', 'Type 3'];

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: OutOfReferalyDialog(), // Your dialog content widget
      ),
    ),
  );
}
