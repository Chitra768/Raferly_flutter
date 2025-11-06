import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_welcome.dart';
import 'package:referaly/utils/translations.dart';

import '../../controller/controller_login.dart';
import '../../social_logins/google_sign_in_service.dart';
import '../../widgets/custom_toast_msg.dart';
import '../home/screen_main.dart';
import 'forgot_password.dart';
import 'screen_registration.dart';
import '../../controller/controller_main_professional.dart';
import '../../resources/app_preference.dart';
import '../../resources/app_colors.dart';

class ScreenLogin extends StatelessWidget {
  static const String pageId = "/ScreenLogin";
  final ControllerLogin controller = Get.put(ControllerLogin());

  ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary, // Project primary color
        body: SingleChildScrollView(
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              children: [
                // Purple Header Section
                Container(
                  width: double.infinity,
                  color: AppColors.primary,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Back button
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Get.offAllNamed(
                                    ScreenInitialLanguage.pageId),
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          // Logo
                          Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: AppColors.primary, width: 2),
                            ),
                            child: SvgPicture.asset(
                              AppAssets.imgHandshake,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.primary, BlendMode.srcIn),
                            ),
                          ),
                          const SizedBox(height: 5),
                          // App Name
                          const Text(
                            'Referaly',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Tagline
                          Text(
                            tr(LanguageKeys.professionalreeferr),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Navigation Tabs
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        Get.toNamed(ScreenRegistration.pageId),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        tr(LanguageKeys.signupNew),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        Get.toNamed(ScreenLogin.pageId),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        tr(LanguageKeys.signinNew),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                // White Card Section
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Welcome Back heading
                        Text(
                          tr(LanguageKeys.welcomeBack),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tr(LanguageKeys.signInToYourProfessionalAccount),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyFontColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Social Login Buttons
                        Column(
                          children: [
                            // Google Button (Full width)
                            SocialLoginButton(
                              text: tr(LanguageKeys.continueWithGoogle),
                              iconData: AppAssets.imgGoogle1,
                              fontSize: 12,
                              iconColor: Colors.red,
                              onPressed: () async {
                                try {
                                  final user = await GoogleSignInService
                                      .loginWithGoogle();
                                  if (user != null) {
                                    // For Google sign-in, we pass an empty string as accessToken
                                    // since the socialLoginApi method will handle getting the Google token
                                    final success = await GoogleSignInService
                                        .socialLoginApi(user, '',
                                            socialType: 'google');
                                    if (success) {
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
                                        // Force fresh data fetch after login by clearing any existing controller
                                        if (Get.isRegistered<
                                            ControllerMainProfessional>()) {
                                          Get.delete<
                                              ControllerMainProfessional>();
                                        }
                                        // Small delay to ensure controller is properly deleted before navigation
                                        await Future.delayed(
                                            const Duration(milliseconds: 100));
                                        Get.offAllNamed(ScreenMain.pageId);
                                      }
                                    } else {
                                      CustomToast.show(Get.overlayContext!,
                                          tr(LanguageKeys.googleLoginFailed));
                                    }
                                  } else {
                                    CustomToast.show(Get.overlayContext!,
                                        tr(LanguageKeys.socialLoginCancelled));
                                  }
                                } catch (e) {
                                  CustomToast.show(Get.overlayContext!,
                                      tr(LanguageKeys.socialLoginError));
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            // Facebook and Apple buttons (full width on Android, half width on iOS)
                            Platform.isIOS
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: SocialLoginButton(
                                          text: 'Facebook',
                                          iconData: AppAssets.imgFacebook1,
                                          fontSize: 12,
                                          iconColor: const Color(
                                              0xFF1877F2), // Facebook blue
                                          onPressed: () async {
                                            try {
                                              User? user =
                                                  await GoogleSignInService
                                                      .loginWithFacebook();
                                              if (user != null) {
                                                final accessToken =
                                                    (await FacebookAuth.instance
                                                            .accessToken)
                                                        ?.tokenString;
                                                if (accessToken != null) {
                                                  final success =
                                                      await GoogleSignInService
                                                          .socialLoginApi(
                                                              user, accessToken,
                                                              socialType:
                                                                  'facebook');
                                                  if (success) {
                                                    // Check for pending deep link data
                                                    final pendingDealId =
                                                        AppPreference.readString(
                                                            'pending_deal_id');
                                                    if (pendingDealId != null &&
                                                        pendingDealId
                                                            .isNotEmpty) {
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
                                                          'pending_deal_id',
                                                          '');
                                                      AppPreference.writeString(
                                                          'pending_campaign',
                                                          '');
                                                      AppPreference.writeString(
                                                          'pending_stage', '');

                                                      // Handle the deep link

                                                      try {
                                                        Get.find<
                                                                ControllerMainProfessional>()
                                                            .handleDealId(
                                                                pendingDealId,
                                                                pendingCampaign,
                                                                pendingStage);
                                                      } catch (e) {
                                                        debugPrint(
                                                            'Error handling pending deal: $e');
                                                      }

                                                      Get.offAllNamed(
                                                          ScreenMain.pageId,
                                                          arguments: {
                                                            'dealId':
                                                                pendingDealId,
                                                          });
                                                    } else {
                                                      // Force fresh data fetch after login by clearing any existing controller
                                                      if (Get.isRegistered<
                                                          ControllerMainProfessional>()) {
                                                        Get.delete<
                                                            ControllerMainProfessional>();
                                                      }
                                                      // Small delay to ensure controller is properly deleted before navigation
                                                      await Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100));
                                                      Get.offAllNamed(
                                                          ScreenMain.pageId);
                                                    }
                                                  } else {
                                                    CustomToast.show(
                                                        Get.overlayContext!,
                                                        tr(LanguageKeys
                                                            .facebookLoginFailed));
                                                  }
                                                } else {
                                                  CustomToast.show(
                                                      Get.overlayContext!,
                                                      tr(LanguageKeys
                                                          .facebookTokenNotFound));
                                                }
                                              } else {
                                                CustomToast.show(
                                                    Get.overlayContext!,
                                                    tr(LanguageKeys
                                                        .socialLoginCancelled));
                                              }
                                            } catch (e) {
                                              CustomToast.show(
                                                  Get.overlayContext!,
                                                  tr(LanguageKeys
                                                      .socialLoginError));
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Apple Button
                                      Expanded(
                                        child: SocialLoginButton(
                                          text: 'Apple',
                                          iconData: AppAssets.imgApple1,
                                          fontSize: 12,
                                          iconColor: const Color(0xFF000000),
                                          onPressed: () async {
                                            try {
                                              debugPrint(
                                                  "🍎 Starting Apple Sign-In...");

                                              final credential =
                                                  await GoogleSignInService
                                                      .signInWithApple();

                                              if (credential != null) {
                                                final user = credential.user;
                                                debugPrint(
                                                    "🍎 Apple Sign-In successful: ${user?.email}");

                                                final idToken =
                                                    await user?.getIdToken(
                                                        true); // ✅ force refresh token

                                                if (user != null &&
                                                    idToken != null) {
                                                  debugPrint(
                                                      "🍎 Got Firebase ID token, calling social login API...");
                                                  final success =
                                                      await GoogleSignInService
                                                          .socialLoginApi(
                                                    user,
                                                    idToken,
                                                    socialType: 'apple',
                                                  );

                                                  if (success) {
                                                    debugPrint(
                                                        "🍎 Apple Sign-In API call successful");
                                                    // Check for pending deep link data
                                                    final pendingDealId =
                                                        AppPreference.readString(
                                                            'pending_deal_id');
                                                    if (pendingDealId != null &&
                                                        pendingDealId
                                                            .isNotEmpty) {
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
                                                          'pending_deal_id',
                                                          '');
                                                      AppPreference.writeString(
                                                          'pending_campaign',
                                                          '');
                                                      AppPreference.writeString(
                                                          'pending_stage', '');

                                                      // Handle the deep link
                                                      try {
                                                        Get.find<
                                                                ControllerMainProfessional>()
                                                            .handleDealId(
                                                                pendingDealId,
                                                                pendingCampaign,
                                                                pendingStage);
                                                      } catch (e) {
                                                        debugPrint(
                                                            'Error handling pending deal: $e');
                                                      }

                                                      Get.offAllNamed(
                                                          ScreenMain.pageId,
                                                          arguments: {
                                                            'dealId':
                                                                pendingDealId,
                                                          });
                                                    } else {
                                                      // Force fresh data fetch after login by clearing any existing controller
                                                      if (Get.isRegistered<
                                                          ControllerMainProfessional>()) {
                                                        Get.delete<
                                                            ControllerMainProfessional>();
                                                      }
                                                      // Small delay to ensure controller is properly deleted before navigation
                                                      await Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  100));
                                                      Get.offAllNamed(
                                                          ScreenMain.pageId);
                                                    }
                                                  } else {
                                                    debugPrint(
                                                        "❌ Apple Sign-In API call failed");
                                                    // Show error message to user
                                                    Get.snackbar(
                                                      'Error',
                                                      'Apple Sign-In failed. Please try again.',
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText: Colors.white,
                                                    );
                                                  }
                                                } else {
                                                  debugPrint(
                                                      "❌ Apple Sign-In: User or ID token is null");
                                                  Get.snackbar(
                                                    'Error',
                                                    'Apple Sign-In failed. Please try again.',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
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
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor:
                                                      Colors.orange,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            } catch (e) {
                                              debugPrint(
                                                  "❌ Apple Sign-In exception: $e");
                                              Get.snackbar(
                                                'Error',
                                                'Apple Sign-In error: ${e.toString()}',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            } finally {
                                              debugPrint(
                                                  "🍎 Apple Sign-In process completed");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : SocialLoginButton(
                                    text: 'Facebook',
                                    iconData: AppAssets.imgFacebook1,
                                    fontSize: 12,
                                    iconColor: const Color(
                                        0xFF1877F2), // Facebook blue
                                    onPressed: () async {
                                      try {
                                        User? user = await GoogleSignInService
                                            .loginWithFacebook();
                                        if (user != null) {
                                          final accessToken =
                                              (await FacebookAuth
                                                      .instance.accessToken)
                                                  ?.tokenString;
                                          if (accessToken != null) {
                                            final success =
                                                await GoogleSignInService
                                                    .socialLoginApi(
                                                        user, accessToken,
                                                        socialType: 'facebook');
                                            if (success) {
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
                                                  Get.find<
                                                          ControllerMainProfessional>()
                                                      .handleDealId(
                                                          pendingDealId,
                                                          pendingCampaign,
                                                          pendingStage);
                                                } catch (e) {
                                                  debugPrint(
                                                      'Error handling pending deal: $e');
                                                }

                                                Get.offAllNamed(
                                                    ScreenMain.pageId,
                                                    arguments: {
                                                      'dealId': pendingDealId,
                                                    });
                                              } else {
                                                // Force fresh data fetch after login by clearing any existing controller
                                                if (Get.isRegistered<
                                                    ControllerMainProfessional>()) {
                                                  Get.delete<
                                                      ControllerMainProfessional>();
                                                }
                                                Get.offAllNamed(
                                                    ScreenMain.pageId);
                                              }
                                            } else {
                                              CustomToast.show(
                                                  Get.overlayContext!,
                                                  tr(LanguageKeys
                                                      .facebookLoginFailed));
                                            }
                                          } else {
                                            CustomToast.show(
                                                Get.overlayContext!,
                                                tr(LanguageKeys
                                                    .facebookTokenNotFound));
                                          }
                                        } else {
                                          CustomToast.show(
                                              Get.overlayContext!,
                                              tr(LanguageKeys
                                                  .socialLoginCancelled));
                                        }
                                      } catch (e) {
                                        CustomToast.show(Get.overlayContext!,
                                            tr(LanguageKeys.socialLoginError));
                                      }
                                    },
                                  ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Divider with text
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: AppColors.grey300,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                tr(LanguageKeys.orSignInWithEmail),
                                style: TextStyle(
                                  color: AppColors.greyFontColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: AppColors.grey300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Email
                        Obx(
                          () => _buildTextField(
                            controller: controller.tcEmail,
                            hintText: tr(LanguageKeys.enterEmail),
                            label: tr(LanguageKeys.email),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return tr(LanguageKeys.pleaseEnterEmail);
                              }
                              // Regular expression for validating email format - allows special characters
                              String pattern = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value.trim())) {
                                return tr(LanguageKeys.pleaseEnterValidEmail);
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password
                        Obx(() => _buildTextField(
                              controller: controller.tcPassword,
                              hintText: tr(LanguageKeys.enterPassword),
                              label: tr(LanguageKeys.password),
                              obscureText: !controller.isPasswordVisible.value,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? tr(LanguageKeys.pleaseEnterPassword)
                                      : null,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[500],
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            )),

                        const SizedBox(height: 16),

                        // Remember me and Forgot password row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(() => Checkbox(
                                      value: controller.rememberMe.value,
                                      side: BorderSide(
                                        color: AppColors.grey300,
                                        width: 1,
                                      ),
                                      onChanged: (value) {
                                        controller.rememberMe.value =
                                            value ?? false;
                                      },
                                      activeColor: AppColors.primary,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    )),
                                const SizedBox(width: 0),
                                Text(
                                  tr(LanguageKeys.rememberMe),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed(ScreenForgotPassword.pageId),
                              child: Text(
                                tr(LanguageKeys.forgotPassword),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Sign In Button
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: controller.isLoadingLogin.value
                                  ? null
                                  : () {
                                      if (controller.loginFormKey.currentState!
                                          .validate()) {
                                        controller.loginApi();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoadingLogin.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      tr(LanguageKeys.signIn),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        }),

                        const SizedBox(height: 24),

                        // Terms and Privacy Policy
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      tr(LanguageKeys.bySigningInYouAgreeToOur),
                                  style: TextStyle(
                                    color: AppColors.greyFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle Terms of Service tap
                                    },
                                    child: Text(
                                      tr(LanguageKeys.termsOfService),
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: tr(LanguageKeys.and),
                                  style: TextStyle(
                                    color: AppColors.greyFontColor,
                                    fontSize: 10,
                                  ),
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle Privacy Policy tap
                                    },
                                    child: Text(
                                      tr(LanguageKeys.privacyPolicy),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Center(
                        //   child: RichText(
                        //     textAlign: TextAlign.center,
                        //     text: TextSpan(

                        //       children: [
                        //         TextSpan(
                        //           text:
                        //               tr(LanguageKeys.bySigningInYouAgreeToOur),
                        //           style: TextStyle(
                        //             color: AppColors.greyFontColor,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //         WidgetSpan(
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               // Handle Terms of Service tap
                        //             },
                        //             child: Text(
                        //               tr(LanguageKeys.termsOfService),
                        //               style: const TextStyle(
                        //                 color: AppColors.primary,
                        //                 fontSize: 12,
                        //                 decoration: TextDecoration.underline,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         TextSpan(
                        //           text: tr(LanguageKeys.and),
                        //           style: TextStyle(
                        //             color: AppColors.greyFontColor,
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //         WidgetSpan(
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               // Handle Privacy Policy tap
                        //             },
                        //             child: Text(
                        //               tr(LanguageKeys.privacyPolicy),
                        //               style: const TextStyle(
                        //                 color: AppColors.primary,
                        //                 fontSize: 12,
                        //                 decoration: TextDecoration.underline,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.greyFontColor),
            filled: true,
            fillColor: AppColors.whiteColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textFieldColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textFieldColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.textFieldColor, width: 1),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
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
    this.borderColor = const Color(0xFFC6CED9),
    this.textColor = const Color(0xFF000000),
    this.applyIconOffset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.whiteColor,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            SizedBox(
              width: 16,
              height: 16,
              child: SvgPicture.asset(
                iconData,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
