import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/screens/auth/screen_welcome.dart';
import 'package:referaly/utils/translations.dart';

import '../../controller/controller_login.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_log.dart';
import '../../social_logins/google_sign_in_service.dart';
import '../../widgets/custom_auth_app_bar.dart';
import '../../widgets/custom_toast_msg.dart';
import '../../widgets/primary_button.dart';
import '../home/screen_main.dart';
import 'forgot_password.dart';
import 'screen_registration.dart';
import '../../controller/controller_main_professional.dart';
import '../../resources/app_preference.dart';

class ScreenLogin extends StatelessWidget {
  static const String pageId = "/ScreenLogin";
  final ControllerLogin controller = Get.put(ControllerLogin());

  ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAuthAppBar(
          onBackTap: () {
            Get.offAllNamed(ScreenWelcome.pageId);
          },
        ),
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              children: [
                SizedBox(height: 10.w),

                /// Create account
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.45))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys.createAnAccount),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.w,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                            thickness: 1,
                            color: Colors.grey.withOpacity(0.45))),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SocialLoginButton(
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
                                            .handleDealId(pendingDealId,
                                                pendingCampaign, pendingStage);
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
                          SocialLoginButton(
                            text: tr(LanguageKeys.facebook),
                            iconData: AppAssets.imgFacebook1,
                            fontSize: 14.w,
                            iconColor: const Color(0xFF1877F2), // Facebook blue
                            onPressed: () async {
                              try {
                                User? user = await GoogleSignInService
                                    .loginWithFacebook();
                                if (user != null) {
                                  final accessToken =
                                      (await FacebookAuth.instance.accessToken)
                                          ?.tokenString;
                                  if (accessToken != null) {
                                    final success = await GoogleSignInService
                                        .socialLoginApi(user, accessToken,
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
                                        Get.offAllNamed(ScreenMain.pageId);
                                      }
                                    } else {
                                      CustomToast.show(Get.overlayContext!,
                                          tr(LanguageKeys.facebookLoginFailed));
                                    }
                                  } else {
                                    CustomToast.show(Get.overlayContext!,
                                        tr(LanguageKeys.facebookTokenNotFound));
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
                        ],
                      ),
                      SizedBox(height: 30.w),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                tr(LanguageKeys.loginToContinue),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26.w,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Text(
                                tr(LanguageKeys.welcomeBacktreferaly),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

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
                            // Regular expression for validating email format
                            String pattern =
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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
                            validator: (value) => value == null || value.isEmpty
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

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              Get.toNamed(ScreenForgotPassword.pageId),
                          child: Obx(
                            () => Text(
                              tr(LanguageKeys.forgotPassword),
                              style: TextStyle(
                                fontSize: 16.w,
                                color: AppColors.blackColor.withOpacity(0.65),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.w),

                      Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: PrimaryButton(
                            text: tr(LanguageKeys.login),
                            onPressed: () {
                              if (controller.loginFormKey.currentState!
                                  .validate()) {
                                controller.loginApi();
                              }
                            },
                            elevation: 2,
                            isLoading: controller.isLoadingLogin.value,
                          ),
                        );
                      }),

                      const SizedBox(height: 30),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4,
                        children: [
                          Obx(
                            () => Text(
                              tr(LanguageKeys.donthaveanAccount),
                              style: TextStyle(
                                  color: AppColors.blackColor.withOpacity(0.75),
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(ScreenRegistration.pageId),
                            child: Obx(
                              () => Text(
                                tr(LanguageKeys.signup),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                  fontSize: 16.w,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
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
          label, // No "*" here
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.7),
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
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          mainAxisSize: MainAxisSize.min,
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
            // Text (will not shift icon due to above fixed width)
            SizedBox(
              width: 80,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
