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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Check for deep link navigation
      bool navigated = await handleDeepLinkNavigation();
      if (navigated) return;

      // Get app state
      final isFirstTime = AppPreference.readInt(AppPreference.isFirstTime);
      final isLoggedIn = AppPreference.readInt(AppPreference.isLoggedIn);
      final accessToken = AppPreference.readString(AppPreference.accessToken);

      debugPrint(
          'App State - First Time: $isFirstTime, Logged In: $isLoggedIn, Has Token: ${accessToken != null}');

      // Always show language screen on first time
      if (isFirstTime == 0) {
        debugPrint('Navigating to language screen');
        Get.offAll(() => ScreenInitialLanguage());
        return;
      }

      // Check login state
      if (isLoggedIn == 1 && accessToken != null && accessToken.isNotEmpty) {
        debugPrint('Navigating to main screen');
        Get.offAllNamed(ScreenMain.pageId);
      } else {
        debugPrint('Navigating to login screen');
        Get.offAllNamed(ScreenLogin.pageId);
      }
    } catch (e) {
      debugPrint('Error in splash initialization: $e');
      // On error, go to language screen
      Get.offAll(() => ScreenInitialLanguage());
    }
  }

  Future<bool> handleDeepLinkNavigation() async {
    if (_branchController.hasValidDeepLink &&
        AppPreference.accessToken.isNotEmpty) {
      debugPrint('Navigating via deep link');
      Get.offAllNamed(ScreenMain.pageId, arguments: {
        'dealId': _branchController.dealId,
      });
      return true;
    }
    return false;
  }
}
