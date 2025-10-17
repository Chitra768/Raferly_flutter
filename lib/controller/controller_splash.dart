import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/models/model_version_update.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/app_strings.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_password_changed_success.dart'
    show ScreenPasswordChangedSuccess;
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/screens/home/screen_main.dart';

import '../helpers/branch_deep_link/branch_deep_link_controller.dart';
import '../languages/languagekeys.dart';
import '../utils/translations.dart';
import '../widgets/custom_toast_msg.dart';
import 'controller_main_professional.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ControllerSplash extends GetxController {
  late final BranchDeepLinkController _branchController;
  StreamSubscription<Map<dynamic, dynamic>>? _branchSubscription;
  bool _isInitializing = false;
  String?
      _lastHandledBranchViewId; // Track last handled deep link to prevent duplicates

  @override
  void onInit() {
    super.onInit();
    getAppUpdate();
    _branchController = Get.put(BranchDeepLinkController());

    _initBranch();

    // iOS-specific fallback timer (shorter timeout for iOS)
    final timeoutDuration = Platform.isIOS
        ? const Duration(seconds: 8)
        : const Duration(seconds: 15);
    Timer(timeoutDuration, () {
      debugPrint(
          'Fallback timer triggered - proceeding with app initialization');
      _initializeApp();
    });
  }

  bool isApiVersionGreater(String apiVersion, String appVersion) {
    List<int> apiParts = apiVersion.split('.').map(int.parse).toList();
    List<int> appParts = appVersion.split('.').map(int.parse).toList();

    int maxLength =
        [apiParts.length, appParts.length].reduce((a, b) => a > b ? a : b);

    // Normalize lengths by padding with zeros
    while (apiParts.length < maxLength) apiParts.add(0);
    while (appParts.length < maxLength) appParts.add(0);

    // Compare each part
    for (int i = 0; i < maxLength; i++) {
      if (apiParts[i] > appParts[i]) {
        return true; // API version is greater
      } else if (apiParts[i] < appParts[i]) {
        return false; // App version is greater
      }
    }
    return false; // Versions are equal
  }

  Future<ModelVersionUpdate?> getAppUpdate() async {
    try {
      // Add timeout to prevent hanging - shorter timeout for iOS
      final timeoutDuration = Platform.isIOS
          ? const Duration(seconds: 5)
          : const Duration(seconds: 10);
      final response = await RESTAuth.versionUpdate().timeout(
        timeoutDuration,
        onTimeout: () {
          debugPrint(
              'Version update API timeout - proceeding with app initialization');
          return null;
        },
      );

      if (response != null && response.status == true) {
        if (Platform.isAndroid) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          AppHelper.showLog('Running on ${packageInfo.version}');
          AppHelper.showLog('Running on ${packageInfo.buildNumber}');

          AppString.appVersion.value = packageInfo.version;

          if (isApiVersionGreater(response.message!.androidProductionVersion!,
              AppString.appVersion.value)) {
            actionUpdateVersion(
                context: Get.context,
                url:
                    "https://play.google.com/store/apps/details?id=com.referaly&pli=1",
                forceUpdate:
                    response.message!.androidProductionVersionDate.toString());
          } else {
            AppLog.d(
                'App version is up-to-date: ${AppString.appVersion.value}');
            _initializeApp();
          }
        } else if (Platform.isIOS) {
          AppLog.d('Running on+++++++++++= ON IOS');
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          AppLog.d('Running on ${packageInfo.version}');
          AppLog.d('Running on ${packageInfo.buildNumber}');
          AppString.appVersion.value = packageInfo.version;

          if (isApiVersionGreater(response.message!.iosProductionVersion!,
              AppString.appVersion.value)) {
            actionUpdateVersion(
                context: Get.context,
                url: "https://apps.apple.com/us/app/referaly/id6502189377",
                forceUpdate:
                    response.message!.iosProductionVersionDate.toString());
          } else {
            AppLog.d(
                'App version is up-to-date: ${AppString.appVersion.value}');
            _initializeApp();
          }
        }
      } else {
        // If API call fails or returns null, proceed with app initialization
        debugPrint(
            'Version update API failed or returned null - proceeding with app initialization');
        _initializeApp();
      }
      update();
      return response;
    } catch (e) {
      debugPrint('Error in getAppUpdate: $e');
      // On any error, proceed with app initialization
      _initializeApp();
      return null;
    }
  }

  void actionUpdateVersion(
      {BuildContext? context, String? url, String? forceUpdate}) {
    showDialog(
      context: context!,
      barrierDismissible: false,
      builder: (BuildContext cxt) {
        return WillPopScope(
          onWillPop: () async {
            exit(0); // Close the app when back button is pressed
          },
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: AppColors.whiteColor,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      AppAssets.imgAppLgo,
                      height: 30.h,
                      width: 30.w,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    // You can customize this string or use a translation key
                    tr(LanguageKeys.updateVersion),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.fontBlack),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: tr(LanguageKeys.okay),
                    onPressed: () async {
                      if (url != null && await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      } else {
                        AppLog.d('Could not launch the app store.');
                      }
                      exit(0); // Close app after redirecting
                    },
                    height: 48,
                    borderRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _initBranch() async {
    try {
      // Wait a bit for Branch SDK to be fully initialized
      await Future.delayed(const Duration(milliseconds: 500));

      // For killed state (cold start)
      FlutterBranchSdk.getLatestReferringParams().then((data) {
        debugPrint('Branch SDK cold start - checking for deep link');
        if (data.isNotEmpty) {
          _handleDeepLink(data);
        }
      });

      // For background/foreground state (when app is already running)
      _branchSubscription = FlutterBranchSdk.listSession().listen(
        (data) {
          debugPrint('Branch SDK session - checking for deep link');
          if (data.isNotEmpty) {
            _handleDeepLink(data);
          }
        },
        onError: (error) => debugPrint('Branch SDK error: $error'),
      );
    } catch (e) {
      debugPrint('Branch SDK initialization error: $e');
    }
  }

  void _handleDeepLink(Map<dynamic, dynamic> data) {
    // Only handle if this is actually a clicked Branch link
    if (!(data.containsKey('+clicked_branch_link') &&
        data['+clicked_branch_link'] == true)) {
      debugPrint('Not a clicked Branch link, ignoring');
      return;
    }

    // Check if we have a deal_id (required for deep link handling)
    final dealId = data['deal_id'];
    if (dealId == null) {
      debugPrint('No deal_id found in Branch data, ignoring');
      return;
    }

    // Prevent handling the same deep link twice using branch_view_id
    final branchViewId = data['+branch_view_id']?.toString();
    if (branchViewId != null && branchViewId == _lastHandledBranchViewId) {
      debugPrint('Deep link already handled for view ID: $branchViewId');
      return;
    }

    // Store the view ID to prevent duplicate handling
    _lastHandledBranchViewId = branchViewId;

    final accessToken = AppPreference.readString(AppPreference.accessToken);
    debugPrint('DeepLink Data: ${jsonEncode(data)}');
    _branchController.updateBranchData(data);
    debugPrint('-> Branch Link Clicked');
    debugPrint('-> Referring link: ${data['~referring_link']}');
    debugPrint('-> deeplink_path: ${data['deeplink_path']}');

    final sendLeadOut = int.tryParse(data['send_lead_out']?.toString() ?? '');
    final campaign = data['~campaign'];
    final stage = data['~stage'];

    debugPrint('-> sendLeadOut: $sendLeadOut');
    debugPrint('-> dealId: $dealId');
    debugPrint('-> accessToken: ${accessToken}');

    if ((sendLeadOut == 0 || sendLeadOut == null) &&
        dealId != null &&
        accessToken != null &&
        accessToken.isNotEmpty) {
      debugPrint('------> Navigating with lead out : $sendLeadOut');
      debugPrint('------> Navigating with dealId : $dealId');
      debugPrint('------> Navigating with campaign : $campaign');
      debugPrint('------> Navigating with stage : $stage');
      Get.put(ControllerMainProfessional());

      Future.delayed(Duration(seconds: 1), () {
        Get.find<ControllerMainProfessional>()
            .handleDealId(dealId.toString(), campaign, stage);

        Get.offNamed(ScreenMain.pageId, arguments: {
          'dealId': dealId.toString(),
        });
      });
    } else {
      // Store deep link data for after login
      if (dealId != null) {
        AppPreference.writeString('pending_deal_id', dealId.toString());
        if (campaign != null) {
          AppPreference.writeString('pending_campaign', campaign.toString());
        }
        if (stage != null) {
          AppPreference.writeString('pending_stage', stage.toString());
        }
        debugPrint(
            '------> Stored deep link data for after login: dealId=$dealId');
        AppPreference.writeBool(AppPreference.isDeeplink, true);
      }
      Get.offAllNamed(ScreenLogin.pageId);
    }
  }

  Future<void> _initializeApp() async {
    if (_isInitializing) {
      debugPrint('App initialization already in progress');
      return;
    }

    _isInitializing = true;

    try {
      // Wait for 2 seconds (shorter for iOS)
      final delayDuration = Platform.isIOS
          ? const Duration(seconds: 1)
          : const Duration(seconds: 2);
      await Future.delayed(delayDuration);

      // Get app state
      final isFirstTime = AppPreference.readInt(AppPreference.isFirstTime);
      final isLoggedIn = AppPreference.readInt(AppPreference.isLoggedIn);
      final accessToken = AppPreference.readString(AppPreference.accessToken);

      debugPrint(
          'App State - First Time: $isFirstTime, Logged In: $isLoggedIn, Has Token: ${accessToken != null && accessToken.isNotEmpty}');
      debugPrint(
          'Access Token: ${accessToken?.substring(0, accessToken.length > 20 ? 20 : accessToken.length)}...');

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
        // Get.offAllNamed(ScreenProfileType.pageId);
      } else {
        debugPrint('Navigating to login screen');
        Get.offAllNamed(ScreenLogin.pageId);
      }
    } catch (e) {
      debugPrint('Error in splash initialization: $e');
      // On error, go to language screen as fallback
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

  /// Clear deep link tracking (useful during logout)
  void clearDeepLinkTracking() {
    _lastHandledBranchViewId = null;
    debugPrint('Deep link tracking cleared');
  }
}
