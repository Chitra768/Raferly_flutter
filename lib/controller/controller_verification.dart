import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/screens/auth/create_new_password.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../apis/api_result.dart';
import '../apis/rest_auth.dart';
import '../models/model_common.dart';
import '../resources/app_colors.dart';
import '../resources/app_helper.dart';
import '../resources/app_log.dart';
import '../widgets/custom_toast_msg.dart';
import 'controller_forgot.dart';

class VerificationController extends GetxController {
  final forgotPasswordController = Get.find<ForgotPasswordController>();

  final isVerifying = false.obs;
  final resendTimerSeconds = 59.obs; // Timer counter
  Timer? _timer;

  var pinputController = TextEditingController();

  // Called when the user submits the verification code.
  Future<void> verifyOtpApi() async {
    startTimer();
    AppHelper.hideKeyboard(Get.overlayContext!);

    final email = forgotPasswordController.emailForLocalUse.value.trim();
    final otp = pinputController.text.trim();

    if (otp.length != 4) {
      CustomToast.show(Get.overlayContext!, 'Please enter a valid 4-digit OTP');
      return;
    }

    isVerifying.value = true;

    try {
      final response = await RESTAuth.verifyOtp(
        email: email.toLowerCase(),
        otp: otp,
      );

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          CustomToast.show(
              Get.overlayContext!, response.data.message ?? 'OTP verified');
          Get.offNamed(ScreenCreateNewPassword.pageId);

          // Start the timer when OTP is verified successfully
          resendCode(); // Start the resend timer
        } else {
          pinputController.clear();
          _showInvalidOtpDialog();
        }
      } else if (response is ApiFailure) {
        final errorMsg = response.error.message ?? 'Something went wrong';
        CustomToast.show(Get.overlayContext!, errorMsg);
      }
    } catch (e) {
      CustomToast.show(Get.overlayContext!, 'Something went wrong');
      debugPrint('VerifyOtp Error: $e');
    } finally {
      isVerifying.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startTimer();
    });
  }

  // Called when the user requests to resend the code.
  void resendCode() {
    if (resendTimerSeconds.value > 0) return; // Prevent multiple requests

    AppLog.d('Resending code...');
    resendTimerSeconds.value = 59; // Reset the timer
    startTimer();

    // Call forgot password API with resend = 1
    final forgotController = Get.find<ForgotPasswordController>();
    forgotController.forgotPasswordApi(isResend: true);
  }

  // startResendTimer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimerSeconds.value > 0) {
        resendTimerSeconds.value--;
      } else {
        _timer?.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  void _showInvalidOtpDialog() {
    Get.defaultDialog(
      title: "Whoops",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      radius: 12,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Invalid OTP",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width * 0.30,
              child: PrimaryButton(
                text: "Okay",
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.onClose();
  }
}
