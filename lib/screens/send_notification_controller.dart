import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Get.snackbar('Success', 'Notification sent!');
    // Optionally clear fields or pop screen
  }
}
