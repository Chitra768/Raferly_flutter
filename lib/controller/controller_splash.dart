import 'dart:async';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';


class ControllerSplash extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Wait for 4 seconds then navigate
    Timer(const Duration(seconds: 4), () {
      Get.offAllNamed(ScreenLogin.pageId); // Use Get.offAllNamed to prevent back navigation
    });
  }
}
