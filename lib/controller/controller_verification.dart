import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final code = RxString('');
  final isVerifying = false.obs;
  final resendTimerSeconds = 59.obs; // Added for timer
  Timer? _timer;

  var pinputController = TextEditingController();

  // Called when the user submits the verification code.
  Future<void> verifyCode() async {
    if (code.value.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter the complete code.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isVerifying.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isVerifying.value = false;

    Get.offNamed('/home'); //  Use Get.offNamed to remove the current route
  }

  // Called when the user requests to resend the code.
  void resendCode() {
    if (resendTimerSeconds.value > 0) return; // Prevent multiple requests

    // Simulate sending a new code.  Replace this with your actual
    // resend code logic.
    print('Resending code...');
    resendTimerSeconds.value = 59; // Reset the timer
    startTimer();
    // Simulate a successful resend
    Get.snackbar(
      'Code Sent',
      'A new verification code has been sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // startResendTimer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimerSeconds.value > 0) {
        resendTimerSeconds.value--;
      } else {
        _timer?.cancel(); // Use _timer?.cancel()
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.onClose();
  }
}
