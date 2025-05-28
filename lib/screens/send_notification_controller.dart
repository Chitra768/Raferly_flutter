import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/screens/dashboard/add_coworker_dialog.dart';

class SendNotificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void sendNotification() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    // TODO: Add your API call here
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    Get.dialog(AddCoworkerDialog(

    ));

    // Optionally clear fields or pop screen
  }
}
