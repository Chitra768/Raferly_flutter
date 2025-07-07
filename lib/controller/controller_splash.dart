import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_password_changed_success.dart'
    show ScreenPasswordChangedSuccess;
import 'package:referaly/screens/home/screen_main.dart';

import '../helpers/branch_deep_link/branch_deep_link_controller.dart';
import '../languages/languagekeys.dart';
import '../utils/translations.dart';
import '../widgets/custom_toast_msg.dart';
import 'controller_main_professional.dart';

class ControllerSplash extends GetxController {
  late final BranchDeepLinkController _branchController;
  StreamSubscription<Map<dynamic, dynamic>>? _branchSubscription;
  String? _lastHandledBranchViewId;
  @override
  void onInit() {
    super.onInit();
    _branchController = Get.put(BranchDeepLinkController());
    _initializeApp();
    _initBranch();
  }

  void _initBranch() {
    // For killed state

    FlutterBranchSdk.getLatestReferringParams().then((data) {
      debugPrint(' Branch SDK initialized');
      _handleDeepLink(data);
    });

    // For background/foreground state
    _branchSubscription = FlutterBranchSdk.listSession().listen(
          (data) {
        debugPrint(' Branch SDK initialized');
        _handleDeepLink(data);
      },
      onError: (error) => debugPrint(' Branch SDK error: $error'),
    );
  }
  void _handleDeepLink(Map<dynamic, dynamic> data) {
    if (!(data.containsKey('+clicked_branch_link') &&
        data['+clicked_branch_link'] == true)) {
      return;
    }

    // Prevent handling the same deep link twice
    final branchViewId = data['+branch_view_id']?.toString();
    if (branchViewId != null && branchViewId == _lastHandledBranchViewId) {
      return;
    }
    _lastHandledBranchViewId = branchViewId;

    debugPrint(' DeepLink Data: ${jsonEncode(data)}');
    _branchController.updateBranchData(data);
    debugPrint('-> Branch Link Clicked');
    debugPrint('-> Referring link: ${data['~referring_link']}');
    debugPrint('-> deeplink_path: ${data['deeplink_path']}');

    final sendLeadOut = int.tryParse(data['send_lead_out']?.toString() ?? '');
    final dealId = data['deal_id'];

    final campaign = data['~campaign'];
    final stage = data['~stage'];

    debugPrint('-> sendLeadOut: $sendLeadOut');
    debugPrint('-> dealId: $dealId}');

    if (sendLeadOut == 0 &&
        dealId != null &&
        AppPreference.accessToken.isNotEmpty) {
      debugPrint('------> Navigating with lead out : $sendLeadOut');
      Future.delayed(Duration(seconds: 1), () {

        Get.find<ControllerMainProfessional>()
            .handleDealId(dealId.toString(), campaign, stage);

        Get.offNamed(ScreenMain.pageId, arguments: {
          'dealId': dealId.toString(),
         });
      });


    } else {
      Get.offAllNamed(ScreenLogin.pageId);
    }
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
