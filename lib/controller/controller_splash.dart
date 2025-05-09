import 'dart:async';

import 'package:get/get.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/screens/home/screen_main.dart';

class ControllerSplash extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      if (AppPreference.readInt(AppPreference.isLoggedIn) == 1) {
        Get.offAllNamed(ScreenMain.pageId);
      } else {
        Get.offAllNamed(ScreenLogin.pageId);
      }
    });
  }
}
