import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/helpers/premium_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/utils/translations.dart';

import '../apis/rest_auth.dart';
import '../models/model_login.dart';
import '../models/model_profile.dart';
import 'package:referaly/screens/onboarding/referral_onboarding_welcome_screen.dart';
import '../resources/app_helper.dart';
import '../resources/validation_helper.dart';
import '../controller/controller_main_professional.dart';
import '../fcm/pending_notification_store.dart';

class ControllerLogin extends GetxController {
  final tcEmail = TextEditingController();
  final tcPassword = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoadingLogin = false.obs;
  final fcmTokenAPI = ''.obs;
  final rememberMe = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _restoreRememberMe();
    regenerateFCMToken();
    AppHelper.showLog("Language: ${AppPreference.readString('language')}");
  }

  void _restoreRememberMe() {
    final savedRememberMe = AppPreference.readBool(AppPreference.rememberMe);
    rememberMe.value = savedRememberMe;

    if (!savedRememberMe) return;

    final savedEmail = AppPreference.readString(AppPreference.usrEmail) ?? '';
    final savedPassword = AppPreference.readString(AppPreference.usrPassword) ?? '';

    if (savedEmail.trim().isNotEmpty) tcEmail.text = savedEmail;
    if (savedPassword.trim().isNotEmpty) tcPassword.text = savedPassword;
  }

  Future<void> _persistRememberMe({
    required String email,
    required String password,
  }) async {
    if (rememberMe.value) {
      await AppPreference.writeBool(AppPreference.rememberMe, true);
      await AppPreference.writeString(AppPreference.usrEmail, email);
      await AppPreference.writeString(AppPreference.usrPassword, password);
      return;
    }

    await AppPreference.writeBool(AppPreference.rememberMe, false);
    await AppPreference.remove(AppPreference.usrEmail);
    await AppPreference.remove(AppPreference.usrPassword);
  }

  regenerateFCMToken() async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      String? fcmToken = await AppPreference.readString(AppPreference.fcmToken);

      if (!ValidationHelper.isValidString(fcmToken)) {
        // Request permission first
        NotificationSettings settings =
            await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          // Get the token
          fcmToken = await _firebaseMessaging.getToken();

          if (fcmToken != null) {
            // Store the token
            await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
            print("FCM token retrieved: $fcmToken");
          } else {
            // Handle simulator case
            print("Running on simulator - using mock token for testing");
            fcmToken =
                "SIMULATOR_MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
            await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
          }
        } else {
          print("Notification permission not granted");
          // Use a mock token if permission is not granted
          fcmToken = "MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
          await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
        }
      }

      // // Initialize push notification service
      // final pushNotificationService =
      //     PushNotificationService(_firebaseMessaging);
      // await pushNotificationService.initialise(Get.context!);context

      return fcmToken;
    } catch (e) {
      print("Error getting FCM token: $e");
      // Provide a fallback token for testing
      String mockToken = "MOCK_TOKEN_${DateTime.now().millisecondsSinceEpoch}";
      await AppPreference.writeString(AppPreference.fcmToken, mockToken);
      return mockToken;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginApi() async {
    AppHelper.hideKeyboard(Get.overlayContext!);
    await FirebaseMessaging.instance.requestPermission();
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null) {
    //   await AppPreference.writeString(AppPreference.fcmToken, fcmToken);
    // }
    String? fcmToken = await AppPreference.readString(AppPreference.fcmToken);
    // if (!loginFormKey.currentState!.validate()) return;

    final email = tcEmail.text.trim();
    final password = tcPassword.text.trim();

    isLoadingLogin.value = true;

    // Fetch FCM token
    // final fcmToken= await FirebaseMessaging.instance.getToken() ?? '';

    try {
      final response = await RESTAuth.login(
        email: email.toLowerCase(),
        password: password,
        fcmToken: fcmToken!,
      );

      if (response is ApiSuccess<ModelLogin>) {
        if (response.data.status == true) {
          await _persistRememberMe(email: email.toLowerCase(), password: password);
          // Store the access token
          if (response.data.data?.accessToken != null) {
            await AppPreference.writeString(
              AppPreference.accessToken,
              response.data.data!.accessToken!,
            );
          }

          await AppPreference.writeString(
              AppPreference.accessToken, response.data.data!.accessToken!);
          await AppPreference.writeString(
              AppPreference.email, response.data.data!.user!.email!);

          await AppPreference.writeInt(AppPreference.isLoggedIn, 1);
          await AppPreference.writeString(AppPreference.isPaid,
              response.data.data!.user!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.user!.productId.toString());
          await PremiumHelper.persistRoleNames(
              response.data.data!.user!.roleNames);
          await AgencyColleagueAccessHelper.persistFromLoginUser(
              response.data.data!.user,
          );

          // Check for pending deep link data (user came from referral link)
          final pendingDealId = AppPreference.readString('pending_deal_id');
          if (pendingDealId != null && pendingDealId.isNotEmpty) {
            debugPrint(
                '------> Found pending deep link data: dealId=$pendingDealId');

            // Fetch profile to check if mandatory info (Personal + Business) is complete
            final profileResponse = await RESTAuth.getProfile();
            final bool profileComplete =
                profileResponse is ApiSuccess<ModelProfile> &&
                    profileResponse.data.status == true &&
                    (profileResponse.data.data?.isProfileCompleted ?? false) &&
                    (profileResponse.data.data?.isCompanyCompleted ?? false);

            if (profileComplete) {
              // Mandatory info already filled → open deal and go to main
              final pendingCampaign =
                  AppPreference.readString('pending_campaign');
              final pendingStage = AppPreference.readString('pending_stage');
              AppPreference.writeString('pending_deal_id', '');
              AppPreference.writeString('pending_campaign', '');
              AppPreference.writeString('pending_stage', '');

              try {
                Get.put(ControllerMainProfessional());
                Get.find<ControllerMainProfessional>()
                    .handleDealId(pendingDealId, pendingCampaign, pendingStage);
              } catch (e) {
                debugPrint('Error handling pending deal: $e');
              }
              Get.offAllNamed(ScreenMain.pageId, arguments: {
                'dealId': pendingDealId,
              });
              await PendingNotificationStore.consumeAfterLogin();
            } else {
              // Mandatory info incomplete → show onboarding (Personal + Business); do NOT clear pending_deal_id
              Get.offAllNamed(ReferralOnboardingWelcomeScreen.pageId);
            }
          } else {
            // Force fresh data fetch after login by clearing any existing controller
            if (Get.isRegistered<ControllerMainProfessional>()) {
              Get.delete<ControllerMainProfessional>();
            }
            // Small delay to ensure controller is properly deleted before navigation
            await Future.delayed(const Duration(milliseconds: 100));
            Get.offAllNamed(ScreenMain.pageId);
            await PendingNotificationStore.consumeAfterLogin();
          }
          // Get.offAllNamed(ScreenMain.pageId);
        } else {
          Get.defaultDialog(
            backgroundColor: AppColors.whiteColor,
            title: tr(LanguageKeys.whoops),
            titleStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            radius: 12,
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    response.data.message ?? '',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8E2DE2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          tcEmail.clear();
                          tcPassword.clear();
                          Get.back();
                        },
                        child: Obx(
                          () => Text(tr(LanguageKeys.okay),
                              style: stylePoppins(
                                  color: AppColors.whiteColor, fontSize: 12)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else if (response is ApiFailure) {
        final errorMsg = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
        Get.snackbar(
          tr(LanguageKeys.whoops),
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor,
          colorText: AppColors.whiteColor,
        );
      }
    } catch (e) {
      debugPrint('Login Error: $e');
    } finally {
      isLoadingLogin.value = false;
    }
  }

  @override
  void dispose() {
    tcEmail.dispose();
    tcPassword.dispose();
    super.dispose();
  }
}
