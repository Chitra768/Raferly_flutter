import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/models/model_common.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../resources/app_helper.dart';
import '../widgets/custom_toast_msg.dart';

class ForgotPasswordController extends GetxController {
  final tcEmail = TextEditingController();
  RxBool isLoadingForgotPassword = false.obs;

  // Add this line for local use
  final emailForLocalUse = ''.obs;

  Future<void> forgotPasswordApi({bool isResend = false}) async {
    AppHelper.hideKeyboard(Get.overlayContext!);
    final email = tcEmail.text.trim();
    isLoadingForgotPassword.value = true;

    try {
      final response = await RESTAuth.forgotPassword(
        email: email.toLowerCase(),
        resend: isResend ? "1" : "0",
      );

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          CustomToast.show(Get.overlayContext!,
              response.data.message ?? 'OTP sent successfully');

          if (!isResend) {
            // Save email before clearing
            emailForLocalUse.value = email;
            Get.toNamed(ScreenVerification.pageId);
          }
        } else {
          CustomToast.show(
              Get.overlayContext!, response.data.message ?? 'Request failed');
        }
      } else if (response is ApiFailure) {
        final errorMsg = response.error.message ?? 'Something went wrong';
        CustomToast.show(Get.overlayContext!, errorMsg);
      }
    } catch (e) {
      CustomToast.show(Get.overlayContext!, 'Something went wrong');
      debugPrint('ForgotPassword Error: $e');
    } finally {
      isLoadingForgotPassword.value = false;
    }
  }

  @override
  void onClose() {
    tcEmail.dispose();
    super.onClose();
  }
}
