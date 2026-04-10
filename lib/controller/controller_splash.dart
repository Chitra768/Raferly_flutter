import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/models/model_login.dart';
import 'package:referaly/models/model_version_update.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/app_strings.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/auth/login.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/branch_deep_link/branch_deep_link_controller.dart';
import '../helpers/profile_gate.dart';
import '../languages/languagekeys.dart';
import '../utils/translations.dart';
import 'controller_main_professional.dart';

class ControllerSplash extends GetxController {
  late final BranchDeepLinkController _branchController;
  StreamSubscription<Map<dynamic, dynamic>>? _branchSubscription;
  bool _isInitializing = false;
  bool _isHandlingEmailVerification = false; // Track if we're handling email verification
  String? _lastHandledBranchViewId; // Track last handled deep link to prevent duplicates
  final Set<String> _processedEmailTokens =
      {}; // Track processed email verification tokens to prevent duplicates

  @override
  void onInit() {
    super.onInit();
    getAppUpdate();
    _branchController = Get.put(BranchDeepLinkController());

    _initBranch();

    // // iOS-specific fallback timer (shorter timeout for iOS)
    // final timeoutDuration = Platform.isIOS
    //     ? const Duration(seconds: 8)
    //     : const Duration(seconds: 15);
    // Timer(timeoutDuration, () {
    //   debugPrint(
    //       'Fallback timer triggered - proceeding with app initialization');
    //   _initializeApp();
    // });
  }

  @override
  void onClose() {
    _branchSubscription?.cancel();
    super.onClose();
  }

  bool isApiVersionGreater(String apiVersion, String appVersion) {
    List<int> apiParts = apiVersion.split('.').map(int.parse).toList();
    List<int> appParts = appVersion.split('.').map(int.parse).toList();

    int maxLength = [apiParts.length, appParts.length].reduce((a, b) => a > b ? a : b);

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
      // Ensure UI language is correctly set before showing any dialogs
      final savedLanguage = AppPreference.getLanguage();
      if (savedLanguage.isNotEmpty) {
        final normalizedLang = savedLanguage.contains('_') ? savedLanguage.split('_').first : savedLanguage;
        if (['en', 'es', 'fr'].contains(normalizedLang)) {
          await LanguageController.to.changeLanguage(normalizedLang);
        }
      }

      // Add timeout to prevent hanging - shorter timeout for iOS
      final timeoutDuration = Platform.isIOS ? const Duration(seconds: 5) : const Duration(seconds: 10);
      final response = await RESTAuth.versionUpdate().timeout(
        timeoutDuration,
        onTimeout: () {
          debugPrint('Version update API timeout - proceeding with app initialization');
          return null;
        },
      );

      if (response != null && response.status == true) {
        if (Platform.isAndroid) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          AppHelper.showLog('Running on ${packageInfo.version}');
          AppHelper.showLog('Running on ${packageInfo.buildNumber}');
          final language = AppPreference.getLanguage();
          AppHelper.showLog('Language: $language');

          AppString.appVersion.value = packageInfo.version;

          if (isApiVersionGreater(response.message!.androidProductionVersion!, AppString.appVersion.value)) {
            actionUpdateVersion(
                url: "https://play.google.com/store/apps/details?id=com.referaly&pli=1",
                forceUpdate: response.message!.androidProductionVersionDate.toString(),
                newVersion: response.message!.androidProductionVersion);
          } else {
            AppLog.d('App version is up-to-date: ${AppString.appVersion.value}');
            _initializeApp();
          }
        } else if (Platform.isIOS) {
          AppLog.d('Running on+++++++++++= ON IOS');
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          AppLog.d('Running on ${packageInfo.version}');
          AppLog.d('Running on ${packageInfo.buildNumber}');
          AppString.appVersion.value = packageInfo.version;

          if (isApiVersionGreater(response.message!.iosProductionVersion!, AppString.appVersion.value)) {
            actionUpdateVersion(
                url: "https://apps.apple.com/us/app/referaly/id6502189377",
                forceUpdate: response.message!.iosProductionVersionDate.toString(),
                newVersion: response.message!.iosProductionVersion);
          } else {
            AppLog.d('App version is up-to-date: ${AppString.appVersion.value}');
            _initializeApp();
          }
        }
      } else {
        // If API call fails or returns null, proceed with app initialization
        debugPrint('Version update API failed or returned null - proceeding with app initialization');
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

  void actionUpdateVersion({String? url, String? forceUpdate, String? newVersion}) {
    // Use Get.dialog instead of showDialog to work without needing Get.context
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          exit(0); // Close the app when back button is pressed
        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.whiteColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with gradient and icon
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.imgDownload,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr(LanguageKeys.updateRequired),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    if ((newVersion ?? '').isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Version ${newVersion!}',
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.whiteColor.withOpacity(0.9),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tr(LanguageKeys.updateRequiredText),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.fontBlack,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: tr(LanguageKeys.updateNow),
                      leading: SvgPicture.asset(AppAssets.imgDownload),
                      onPressed: () async {
                        if (url != null && await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        } else {
                          AppLog.d('Could not launch the app store.');
                        }
                        exit(0); // Close app after redirecting
                      },
                      height: 58,
                      borderRadius: 12,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tr(LanguageKeys.youWillBeRedirectedToTheAppStoreText),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _handleEmailVerification(Map<dynamic, dynamic> data) async {
    _isHandlingEmailVerification = true; // Set flag to prevent _initializeApp from interfering
    try {
      final token = data['token']?.toString();

      if (token == null || token.isEmpty) {
        debugPrint('No token found in email verification link');
        // Navigate to login screen if token is missing
        Get.offAllNamed(ScreenLogin.pageId);
        return;
      }

      // Mark token as being processed to prevent duplicate calls
      _processedEmailTokens.add(token);

      debugPrint('Verifying email token: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');

      // Call verify email token API
      final response = await RESTAuth.verifyEmailToken(
        verificationToken: token,
      );

      if (response is ApiSuccess<ModelLogin>) {
        if (response.data.status == true) {
          debugPrint('Email verification successful');

          // Store the access token and user data (similar to login)
          if (response.data.data?.accessToken != null) {
            await AppPreference.writeString(
              AppPreference.accessToken,
              response.data.data!.accessToken!,
            );
          }

          if (response.data.data?.user?.email != null) {
            await AppPreference.writeString(
              AppPreference.email,
              response.data.data!.user!.email!,
            );
          }

          await AppPreference.writeInt(AppPreference.isLoggedIn, 1);

          if (response.data.data?.user?.isPaid != null) {
            await AppPreference.writeString(
              AppPreference.isPaid,
              response.data.data!.user!.isPaid.toString(),
            );
          }

          if (response.data.data?.user?.productId != null) {
            await AppPreference.writeString(
              AppPreference.productId,
              response.data.data!.user!.productId.toString(),
            );
          }

          final companyType = response.data.data?.user?.companyType?.toString().trim().toLowerCase();

          // If backend already knows the user's company_type, do NOT show UI selection again.
          // Individual users must stay on the simplified UI, so skip ScreenProfileType.
           if (companyType == 'individual') {
            debugPrint(
                'Email verification successful, company_type=$companyType -> navigating to Main Home');
            Get.offAllNamed(ScreenMain.pageId);
          } else {
            debugPrint(
                'Email verification successful, company_type missing -> navigating to profile type selection');
            Get.offAllNamed(ScreenProfileType.pageId);
          }
        } else {
          debugPrint('Email verification failed: ${response.data.message}');
          // Show error and navigate to login
          Get.offAllNamed(ScreenLogin.pageId);
        }
      } else if (response is ApiFailure) {
        debugPrint('Email verification API error: ${response.error.message}');
        // Navigate to login screen even on error
        Get.offAllNamed(ScreenLogin.pageId);
      }
    } catch (e) {
      debugPrint('Error handling email verification: $e');
      // Navigate to login screen on exception
      Get.offAllNamed(ScreenLogin.pageId);
    } finally {
      _isHandlingEmailVerification = false; // Reset flag
    }
  }

  void _initBranch() async {
    try {
      // Wait a bit for Branch SDK to be fully initialized
      await Future.delayed(const Duration(milliseconds: 500));

      // For killed state (cold start)
      FlutterBranchSdk.getLatestReferringParams().then((data) {
        debugPrint('Branch SDK cold start - checking for deep link ${jsonEncode(data)}');
        if (data.isNotEmpty) {
          _handleDeepLink(data);
        }
      });

      // For background/foreground state (when app is already running)
      _branchSubscription = FlutterBranchSdk.listSession().listen(
        (data) {
          debugPrint('Branch SDK session - checking for deep link ${jsonEncode(data)}');
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
    if (!(data.containsKey('+clicked_branch_link') && data['+clicked_branch_link'] == true)) {
      debugPrint('Not a clicked Branch link, ignoring');
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

    // Check for email verification link
    final ogTitle = data['\$og_title']?.toString();
    if (ogTitle == 'Sign In | Admin') {
      // Check if user is already logged in - skip email verification if already verified
      final isLoggedIn = AppPreference.readInt(AppPreference.isLoggedIn);
      final accessToken = AppPreference.readString(AppPreference.accessToken);

      if (isLoggedIn == 1 && accessToken != null && accessToken.isNotEmpty) {
        debugPrint('User already logged in, skipping email verification');
        return;
      }

      // Check if we've already processed this token
      final token = data['token']?.toString();
      if (token != null && _processedEmailTokens.contains(token)) {
        debugPrint('Email verification token already processed, skipping');
        return;
      }

      debugPrint('Email verification link detected');
      _handleEmailVerification(data);
      return;
    }

    // Check if we have a deal_id (required for deep link handling)
    final dealId = data['deal_id'];
    if (dealId == null) {
      debugPrint('No deal_id found in Branch data, ignoring');
      return;
    }

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
    debugPrint('-> accessToken: $accessToken');

    if ((sendLeadOut == 0 || sendLeadOut == null) &&
        dealId != null &&
        accessToken != null &&
        accessToken.isNotEmpty) {
      debugPrint('------> Navigating with lead out : $sendLeadOut');
      debugPrint('------> Navigating with dealId : $dealId');
      debugPrint('------> Navigating with campaign : $campaign');
      debugPrint('------> Navigating with stage : $stage');
      Get.put(ControllerMainProfessional());

      Future.delayed(const Duration(seconds: 1), () {
        Get.find<ControllerMainProfessional>().handleDealId(dealId.toString(), campaign, stage);

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
        debugPrint('------> Stored deep link data for after login: dealId=$dealId');
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

    // Don't initialize if we're handling email verification
    if (_isHandlingEmailVerification) {
      debugPrint('Email verification in progress, skipping app initialization');
      return;
    }

    _isInitializing = true;

    try {
      // Wait for 2 seconds (shorter for iOS)
      final delayDuration = Platform.isIOS ? const Duration(seconds: 1) : const Duration(seconds: 2);
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
        debugPrint('Resolving post-login route (premium profile gate)');
        final destination = await ProfileGate.resolvePostLoginDestination();
        Get.offAllNamed(destination);
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
    if (_branchController.hasValidDeepLink && AppPreference.accessToken.isNotEmpty) {
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
    _processedEmailTokens.clear();
    debugPrint('Deep link tracking cleared');
  }
}
