import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/screens/auth/screen_registration.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/social_logins/google_sign_in_service.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../../controller/controller_welcome.dart';
import '../../resources/app_colors.dart';
import '../../resources/validation_helper.dart';
import '../../widgets/secondary_button_outline.dart';

class ScreenWelcome extends GetView<WelcomeController> {
  static String pageId = "/ScreenWelcome";

  final welcomeController = Get.put(WelcomeController());

  ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Placeholder for the house image
                Stack(
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgBackgroundWelcome,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SvgPicture.asset(
                        AppAssets.imgWelcomePage,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),

                // Welcome text
                Obx(
                  () => Text(
                    tr(LanguageKeys.Welcome),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary, // Set the color to black
                    ),
                  ),
                ),

                SizedBox(height: 50.h),
                Obx(
                  () => PrimaryButton(
                      text: tr(LanguageKeys.createAccont),
                      onPressed: () {
                        Get.toNamed(ScreenRegistration.pageId);
                      }),
                ),
                SizedBox(height: 15.h),
                Obx(
                  () => SecondaryButton(
                    text: tr(LanguageKeys.login),
                    onPressed: () {
                      Get.toNamed(ScreenLogin.pageId);
                    },
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      thickness: 1,
                      color: Colors.grey.withAlpha(100),
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Flexible(
                        child: Text(
                          tr(LanguageKeys.welcometitle),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.withAlpha(100),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final user =
                            await GoogleSignInService.loginWithGoogle();

                        if (user != null) {
                          final tokenId = await user.getIdToken();

                          if (tokenId != null) {
                            final success =
                                await GoogleSignInService.socialLoginApi(
                                    user, tokenId,
                                    socialType: 'google');
                            if (success) {
                              final loginResponse =
                                  GoogleSignInService.lastLoginResponse;
                              final hasCompanyType =
                                  ValidationHelper.isValidString(
                                      loginResponse?.data?.user?.companyType);
                              if (!hasCompanyType) {
                                Get.offAllNamed(ScreenProfileType.pageId);
                              } else {
                                // controller.isLoggingIn.value = false;
                                Get.offAllNamed(ScreenMain.pageId);
                              }
                            } else {}
                          } else {}
                        } else {
                          // controller.isLoggingIn.value = false;
                        }
                      },
                      child: SocialLoginButton(
                        text: tr(LanguageKeys.google),
                        iconData: AppAssets.imgGoogle1,
                        fontSize: 16.w,
                        iconColor: Colors.red, // Google's red
                        onPressed: () async {
                          try {
                            final user =
                                await GoogleSignInService.loginWithGoogle();
                            if (user != null) {
                              // For Google sign-in, we pass an empty string as accessToken
                              // since the socialLoginApi method will handle getting the Google token
                              final success =
                                  await GoogleSignInService.socialLoginApi(
                                      user, '',
                                      socialType: 'google');
                              if (success) {
                                final loginResponse =
                                    GoogleSignInService.lastLoginResponse;
                                final hasCompanyType =
                                    ValidationHelper.isValidString(
                                        loginResponse?.data?.user?.companyType);
                                if (!hasCompanyType) {
                                  Get.offAllNamed(ScreenProfileType.pageId);
                                } else {
                                  Get.offAllNamed(ScreenMain.pageId);
                                }
                              } else {}
                            } else {}
                          } catch (e) {}
                        },
                      ),
                    ),
                    SizedBox(height: 10.w),
                    GestureDetector(
                      onTap: () async {
                        User? user =
                            await GoogleSignInService.loginWithFacebook();

                        if (user != null) {
                          final accessToken =
                              (await FacebookAuth.instance.accessToken)
                                  ?.tokenString;
                          print('FB ACCESS TOKEN $accessToken');
                          if (accessToken != null) {
                            final success =
                                await GoogleSignInService.socialLoginApi(
                                    user, accessToken,
                                    socialType: 'facebook');
                            if (success) {
                              final loginResponse =
                                  GoogleSignInService.lastLoginResponse;
                              final hasCompanyType =
                                  ValidationHelper.isValidString(
                                      loginResponse?.data?.user?.companyType);
                              if (!hasCompanyType) {
                                Get.offAllNamed(ScreenProfileType.pageId);
                              } else {
                                // controller.isLoggingIn.value = false;
                                Get.offAllNamed(ScreenMain.pageId);
                              }
                            } else {
                              // controller.isLoggingIn.value = false;
                              // CustomToast.show(Get.overlayContext!,
                              //     "Facebook login failed");
                            }
                          } else {
                            // controller.isLoggingIn.value = false;
                            // CustomToast.show(Get.overlayContext!,
                            //     "Access token not found");
                          }
                        } else {
                          // controller.isLoggingIn.value = false;
                        }
                      },
                      child: SocialLoginButton(
                        text: tr(LanguageKeys.facebook),
                        iconData: AppAssets.imgFacebook1,
                        fontSize: 14.w,
                        iconColor: const Color(0xFF1877F2), // Face
                        onPressed: () async {
                          try {
                            User? user =
                                await GoogleSignInService.loginWithFacebook();
                            if (user != null) {
                              final accessToken =
                                  (await FacebookAuth.instance.accessToken)
                                      ?.tokenString;
                              if (accessToken != null) {
                                final success =
                                    await GoogleSignInService.socialLoginApi(
                                        user, accessToken,
                                        socialType: 'facebook');
                                if (success) {
                                  final loginResponse =
                                      GoogleSignInService.lastLoginResponse;
                                  final hasCompanyType =
                                      ValidationHelper.isValidString(
                                          loginResponse
                                              ?.data?.user?.companyType);
                                  if (!hasCompanyType) {
                                    Get.offAllNamed(ScreenProfileType.pageId);
                                  } else {
                                    Get.offAllNamed(ScreenMain.pageId);
                                  }
                                } else {}
                              } else {}
                            } else {}
                          } catch (e) {}
                        },
                      ),
                    ),

                    /// Apple Login
                    if (Platform.isIOS) SizedBox(height: 16.w),
                    if (Platform.isIOS)
                      SocialLoginButton(
                          text: tr(LanguageKeys.apple),
                          iconData: AppAssets.imgApple1,
                          fontSize: 14.w,
                          iconColor: const Color(0xFF000000), //
                          onPressed: () async {
                            try {
                              debugPrint("🍎 Starting Apple Sign-In...");

                              final credential =
                                  await GoogleSignInService.signInWithApple();

                              if (credential != null) {
                                final user = credential.user;
                                debugPrint(
                                    "🍎 Apple Sign-In successful: ${user?.email}");

                                final idToken = await user
                                    ?.getIdToken(true); // ✅ force refresh token

                                if (user != null && idToken != null) {
                                  debugPrint(
                                      "🍎 Got Firebase ID token, calling social login API...");
                                  final success =
                                      await GoogleSignInService.socialLoginApi(
                                    user,
                                    idToken,
                                    socialType: 'apple',
                                  );

                                  if (success) {
                                    final loginResponse =
                                        GoogleSignInService.lastLoginResponse;
                                    final hasCompanyType =
                                        ValidationHelper.isValidString(
                                            loginResponse
                                                ?.data?.user?.companyType);
                                    if (!hasCompanyType) {
                                      Get.offAllNamed(ScreenProfileType.pageId);
                                    } else {
                                      debugPrint(
                                          "🍎 Apple Sign-In API call successful");
                                      // Check for pending deep link data
                                      final pendingDealId =
                                          AppPreference.readString(
                                              'pending_deal_id');
                                      if (pendingDealId != null &&
                                          pendingDealId.isNotEmpty) {
                                        debugPrint(
                                            '------> Found pending deep link data: dealId=$pendingDealId');

                                        // Get pending campaign and stage data
                                        final pendingCampaign =
                                            AppPreference.readString(
                                                'pending_campaign');
                                        final pendingStage =
                                            AppPreference.readString(
                                                'pending_stage');

                                        // Clear pending data
                                        AppPreference.writeString(
                                            'pending_deal_id', '');
                                        AppPreference.writeString(
                                            'pending_campaign', '');
                                        AppPreference.writeString(
                                            'pending_stage', '');

                                        // Handle the deep link
                                        try {
                                          Get.find<ControllerMainProfessional>()
                                              .handleDealId(
                                                  pendingDealId,
                                                  pendingCampaign,
                                                  pendingStage);
                                        } catch (e) {
                                          debugPrint(
                                              'Error handling pending deal: $e');
                                        }

                                        Get.offAllNamed(ScreenMain.pageId,
                                            arguments: {
                                              'dealId': pendingDealId,
                                            });
                                      } else {
                                        Get.offAllNamed(ScreenMain.pageId);
                                      }
                                    }
                                  } else {
                                    debugPrint(
                                        "❌ Apple Sign-In API call failed");
                                    // Show error message to user
                                    Get.snackbar(
                                      'Error',
                                      'Apple Sign-In failed. Please try again.',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                } else {
                                  debugPrint(
                                      "❌ Apple Sign-In: User or ID token is null");
                                  Get.snackbar(
                                    'Error',
                                    'Apple Sign-In failed. Please try again.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } else {
                                debugPrint(
                                    "❌ Apple Sign-In: Credential is null");
                                Get.snackbar(
                                  'Error',
                                  'Apple Sign-In was cancelled or failed.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                              }
                            } catch (e) {
                              debugPrint("❌ Apple Sign-In exception: $e");
                              Get.snackbar(
                                'Error',
                                'Apple Sign-In error: ${e.toString()}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } finally {
                              debugPrint("🍎 Apple Sign-In process completed");
                            }
                          }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconData;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color borderColor;
  final Color textColor;
  final bool applyIconOffset;
  final double fontSize;
  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.iconData,
    required this.onPressed,
    required this.iconColor,
    required this.fontSize,
    this.borderColor = const Color(0xFF263238),
    this.textColor = const Color(0xFF263238),
    this.applyIconOffset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon area (fixed width)
            SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: SvgPicture.asset(
                  iconData,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Text (flexible width)
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: fontSize,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
