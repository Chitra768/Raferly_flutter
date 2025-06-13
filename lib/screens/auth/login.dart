import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
                const SizedBox(height: 10),

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
                            fontSize: 18,
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
                      /// Social Signup

                      const SizedBox(height: 30),
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
                                  fontSize: 26,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Obx(
                              () => Text(
                                tr(LanguageKeys.welcomeBacktreferaly),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
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
                            if (!regex.hasMatch(value)) {
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
                                fontSize: 16,
                                color: AppColors.blackColor.withOpacity(0.65),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

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
                                  fontSize: 16,
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
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          SocialLoginButton(
                            text: tr(LanguageKeys.google),
                            iconData: FontAwesomeIcons.google,
                            iconBgColor: Colors.white,
                            iconColor: AppColors
                                .primary, // Or Google blue if you prefer
                            onPressed: () async {
                              try {
                                final user =
                                    await GoogleSignInService.loginWithGoogle();
                                if (user != null) {
                                  final tokenId = await FirebaseAuth
                                      .instance.currentUser
                                      ?.getIdToken(true);
                                  if (tokenId != null) {
                                    final success = await GoogleSignInService
                                        .socialLoginApi(user, tokenId,
                                            socialType: 'google');
                                    if (success) {
                                      Get.offAllNamed(ScreenMain.pageId);
                                    } else {
                                      CustomToast.show(Get.overlayContext!,
                                          tr(LanguageKeys.googleLoginFailed));
                                    }
                                  } else {
                                    CustomToast.show(Get.overlayContext!,
                                        tr(LanguageKeys.googleTokenNotFound));
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
                            iconData: FontAwesomeIcons.facebookF,
                            iconBgColor: AppColors.primary, // Facebook blue
                            iconColor: Colors.white,
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
                                      Get.offAllNamed(ScreenMain.pageId);
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
  final Color borderColor;
  final Color textColor;
  final Color iconBgColor;
  final Color iconColor;
  final IconData iconData;
  final VoidCallback onPressed;

  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.iconData,
    required this.iconBgColor,
    required this.iconColor,
    required this.onPressed,
    this.borderColor = const Color(0xFF263238),
    this.textColor = const Color(0xFF263238),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
