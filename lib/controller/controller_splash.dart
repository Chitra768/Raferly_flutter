import 'dart:async';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/screens/home/screen_main.dart';

class ControllerSplash extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () async {
      final isFirstTime =
          AppPreference.readInt(AppPreference.isFirstTime); // 0 = first time
      final isLoggedIn =
          AppPreference.readInt(AppPreference.isLoggedIn); // 1 = logged in

      if (isFirstTime == 0) {
        AppPreference.writeInt(AppPreference.isFirstTime, 1);
        Get.offAllNamed(ScreenWelcome.pageId);
      } else if (isLoggedIn == 1) {
        Get.offAllNamed(ScreenMain.pageId);
      } else {
        Get.offAllNamed(ScreenLogin.pageId);
      }
    });
  }
}
