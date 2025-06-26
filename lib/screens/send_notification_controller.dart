import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/screens/dashboard/add_coworker_dialog.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
   FocusScope.of(Get.context!).unfocus();
    Get.dialog(AddCoworkerDialog());
  }

  final RxString error = ''.obs;

  Future<void> sendNotificationInDeals(List<String> id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.sendNotificationInDeals(
          titleController.text, descriptionController.text, id);
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {}
      } else if (response is ApiFailure) {}
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
