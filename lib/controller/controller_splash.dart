import 'dart:async';
import 'package:get/get.dart';
import '../screens/auth/screen_choose_language.dart';

class ControllerSplash extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Timer(const Duration(seconds: 2), () {
      Get.offAllNamed(ScreenChooseLanguage.pageId);
    });
  }
}
