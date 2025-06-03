import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_password_changed_success.dart'
    show ScreenPasswordChangedSuccess;
import 'package:referaly/screens/home/screen_main.dart';

import '../helpers/branch_deep_link/branch_deep_link_controller.dart';

class ControllerSplash extends GetxController {
  final _branchController = Get.find<BranchDeepLinkController>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () async {
      bool navigated = await handleDeepLinkNavigation();
      if (navigated) return;

      final isFirstTime =
          AppPreference.readInt(AppPreference.isFirstTime); // 0 = first time
      final isLoggedIn =
          AppPreference.readInt(AppPreference.isLoggedIn); // 1 = logged in

      if (isFirstTime == 0) {
        Get.offAll(() => ScreenInitialLanguage());
      } else if (isLoggedIn == 1) {
        Get.offAllNamed(ScreenMain.pageId);
      } else {
        Get.offAllNamed(ScreenLogin.pageId);
      }
    });
  }

  Future<bool> handleDeepLinkNavigation() async {
    if (_branchController.hasValidDeepLink &&
        AppPreference.accessToken.isNotEmpty) {
      debugPrint(' Navigating via deep link');
      Get.offAllNamed(ScreenMain.pageId, arguments: {
        'dealId': _branchController.dealId,
      });
      return true;
    }
    return false;
  }
}
