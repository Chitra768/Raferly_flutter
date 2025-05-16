import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/widget_loading.dart';

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
        appBar: const CustomAuthAppBar(),
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
                      child: Text(
                        tr(LanguageKeys.createAnAccount),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.blackColor,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialIcon(AppAssets.imgGoogle, 'Google', () async {
                            // controller.isLoggingIn.value = true;

                            final user =
                            await GoogleSignInService.loginWithGoogle();

                            if (user != null) {
                              final tokenId = await FirebaseAuth
                                  .instance.currentUser
                                  ?.getIdToken(true);

                              if (tokenId != null) {
                                final success =
                                await GoogleSignInService.socialLoginApi(
                                    user, tokenId,
                                    socialType: 'google');
                                if (success) {
                                  // controller.isLoggingIn.value = false;
                                  Get.offAllNamed(ScreenMain.pageId);
                                } else {
                                  // controller.isLoggingIn.value = false;
                                  // CustomToast.show(Get.overlayContext!,
                                  //     "Google login failed");
                                }
                              } else {
                                // controller.isLoggingIn.value = false;
                                // CustomToast.show(Get.overlayContext!,
                                //     "Google token not found");
                              }
                            } else {
                              // controller.isLoggingIn.value = false;
                            }
                          }),

                          /// Only Google login

                          // _socialIcon(Icons.g_mobiledata, 'Google',
                          //     () async {
                          //   controller.isLoggingIn.value = true;
                          //
                          //   try {
                          //     // Attempt Google login
                          //     final user = await GoogleSignInService
                          //         .loginWithGoogle();
                          //
                          //     if (user != null) {
                          //       // Firebase user object already contains necessary data
                          //       final String? accessToken =
                          //           await user.getIdToken(
                          //               true); // Get Firebase ID token
                          //       final String? idToken =
                          //           accessToken; // Using the same token as ID token
                          //
                          //       print("Google SignIn Success:");
                          //       print("User Email: ${user.email}");
                          //       print(
                          //           "User Display Name: ${user.displayName}");
                          //       print("Access Token: $accessToken");
                          //       print("ID Token: $idToken");
                          //
                          //       // Checking if tokens are available
                          //       if (accessToken != null &&
                          //           idToken != null) {
                          //         // Proceed with further actions, e.g., API call for social login
                          //         controller.isLoggingIn.value = false;
                          //         CustomToast.show(Get.overlayContext!,
                          //             "Google login successful!");
                          //       } else {
                          //         controller.isLoggingIn.value = false;
                          //         CustomToast.show(Get.overlayContext!,
                          //             "Google token not found");
                          //       }
                          //     } else {
                          //       controller.isLoggingIn.value = false;
                          //       CustomToast.show(Get.overlayContext!,
                          //           "Google login cancelled.");
                          //     }
                          //   } catch (e) {
                          //     controller.isLoggingIn.value = false;
                          //     CustomToast.show(Get.overlayContext!,
                          //         "Login failed: ${e.toString()}");
                          //   }
                          // }),

                          /// Apple Login
                          if (Platform.isIOS)
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                _socialIcon(AppAssets.imgApple, 'Apple',
                                        () async {
                                      try {
                                        final credential = await GoogleSignInService
                                            .signInWithApple();

                                        if (credential != null) {
                                          final user = credential.user;
                                          final idToken = await user?.getIdToken(
                                              true); // ✅ force refresh token

                                          if (user != null && idToken != null) {
                                            final success =
                                            await GoogleSignInService
                                                .socialLoginApi(
                                              user,
                                              idToken,
                                              socialType: 'apple',
                                            );

                                            if (success) {
                                              Get.offAllNamed(ScreenMain.pageId);
                                            } else {
                                              CustomToast.show(Get.overlayContext!,
                                                  "Apple login failed");
                                            }
                                          } else {
                                            CustomToast.show(Get.overlayContext!,
                                                "Apple token or user not found");
                                          }
                                        } else {
                                          CustomToast.show(Get.overlayContext!,
                                              "Apple login cancelled");
                                        }
                                      } catch (e) {
                                        CustomToast.show(Get.overlayContext!,
                                            "Apple login error: ${e.toString()}");
                                      } finally {}
                                    }),
                              ],
                            ),

                          /// Facebook Login
                          const SizedBox(width: 20),
                          _socialIcon(AppAssets.imgFaceBook, 'Facebook',
                                  () async {
                                // controller.isLoggingIn.value = true;

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
                                      // controller.isLoggingIn.value = false;
                                      Get.offAllNamed(ScreenMain.pageId);
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
                              }),
                        ],
                      ),

                      const SizedBox(height: 30),
                       Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr(LanguageKeys.loginToContinue),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              tr(LanguageKeys.welcomeBacktreferaly),
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email
                      _buildTextField(
                        controller: controller.tcEmail,
                        hintText: tr(LanguageKeys.enterEmail),
                        label: tr(LanguageKeys.email),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          // Regular expression for validating email format
                          String pattern =
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password
                      Obx(() => _buildTextField(
                        controller: controller.tcPassword,
                        hintText: tr(LanguageKeys.enterPassword),
                        label: tr(LanguageKeys.password),
                        obscureText: !controller.isPasswordVisible.value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter password'
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
                          child: Text(
                            tr(LanguageKeys.forgotPassword),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.blackColor.withOpacity(0.65),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Obx(() {
                        return SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: controller.isLoadingLogin.value
                              ? const WidgetLoading()
                              : PrimaryButton(
                            text: tr(LanguageKeys.login),
                            onPressed: () => controller.loginApi(),
                            elevation: 2,
                          ),
                        );
                      }),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              tr(LanguageKeys.donthaveanAccount),
                            style: TextStyle(
                                color: AppColors.blackColor.withOpacity(0.75),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(ScreenRegistration.pageId),
                            child: Text(
                              tr(LanguageKeys.signup),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                                fontSize: 16,
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

  Widget _socialIcon(
      String assetPath, String tooltip, VoidCallback onTapCallback) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(500),
        onTap: onTapCallback,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Padding for SVG fitting
            child: SvgPicture.asset(
              assetPath,
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}