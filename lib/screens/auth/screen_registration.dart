import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/controller_registration.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_log.dart';
import '../../social_logins/google_sign_in_service.dart';
import '../../widgets/custom_auth_app_bar.dart';
import '../../widgets/custom_toast_msg.dart';

import '../home/screen_main.dart';

class ScreenRegistration extends StatelessWidget {
  static const String pageId = "/ScreenRegistration";
  final controller = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();
  final RxBool showPrivacyError = false.obs;

  ScreenRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAuthAppBar(),
        backgroundColor: Colors.white,
        body: Obx(() {
          return SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            tr(LanguageKeys.createAnAccountSignIn),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.w,
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

                    // Top social icons

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Social Signup
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialLoginButton(
                                  text: tr(LanguageKeys.google),
                                  iconData: AppAssets.imgGoogle1,
                                  fontSize: 16.w,
                                  iconColor: Colors.red, // Google's red
                                  onPressed: () async {
                                    // controller.isLoggingIn.value = true;

                                    final user = await GoogleSignInService
                                        .loginWithGoogle();

                                    if (user != null) {
                                      final tokenId = await FirebaseAuth
                                          .instance.currentUser
                                          ?.getIdToken(true);

                                      if (tokenId != null) {
                                        final success =
                                            await GoogleSignInService
                                                .socialLoginApi(user, tokenId,
                                                    socialType: 'google');
                                        if (success) {
                                          // controller.isLoggingIn.value = false;
                                          Get.offAllNamed(ScreenMain.pageId);
                                        } else {}
                                      } else {}
                                    } else {
                                      // controller.isLoggingIn.value = false;
                                    }
                                  }),

                              Column(
                                children: [
                                  SizedBox(height: 10.w),
                                  SocialLoginButton(
                                      text: tr(LanguageKeys.facebook),
                                      iconData: AppAssets.imgFacebook1,
                                      fontSize: 14.w,
                                      iconColor:
                                          const Color(0xFF1877F2), // Facebook
                                      onPressed: () async {
                                        try {
                                          final credential =
                                              await GoogleSignInService
                                                  .signInWithApple();

                                          if (credential != null) {
                                            final user = credential.user;
                                            final idToken = await user?.getIdToken(
                                                true); // ✅ force refresh token

                                            if (user != null &&
                                                idToken != null) {
                                              final success =
                                                  await GoogleSignInService
                                                      .socialLoginApi(
                                                user,
                                                idToken,
                                                socialType: 'apple',
                                              );

                                              if (success) {
                                                Get.offAllNamed(
                                                    ScreenMain.pageId);
                                              } else {}
                                            } else {}
                                          } else {}
                                        } catch (e) {
                                        } finally {}
                                      }),
                                ],
                              ),

                              /// apple Login
                              SizedBox(height: 10.w),

                              /// Apple Login
                              if (Platform.isIOS)
                                SocialLoginButton(
                                    text: tr(LanguageKeys.apple),
                                    iconData: AppAssets.imgApple1,
                                    fontSize: 14.w,
                                    iconColor: const Color(0xFF000000), //
                                    onPressed: () async {
                                      // controller.isLoggingIn.value = true;

                                      User? user = await GoogleSignInService
                                          .loginWithFacebook();

                                      if (user != null) {
                                        final accessToken = (await FacebookAuth
                                                .instance.accessToken)
                                            ?.tokenString;

                                        if (accessToken != null) {
                                          final success =
                                              await GoogleSignInService
                                                  .socialLoginApi(
                                                      user, accessToken,
                                                      socialType: 'facebook');
                                          if (success) {
                                            // controller.isLoggingIn.value = false;
                                            Get.offAllNamed(ScreenMain.pageId);
                                          } else {}
                                        } else {}
                                      } else {
                                        // controller.isLoggingIn.value = false;
                                      }
                                    }),
                            ],
                          ),
                          SizedBox(height: 30.w),
                          // Title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys.register),
                                style: TextStyle(
                                    fontSize: 24.w,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4.w),
                              Text(tr(LanguageKeys.welcomeTotreferaly),
                                  style: TextStyle(
                                      color: AppColors.greyFontColor,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(height: 32.w),

                          _buildLabel(tr(LanguageKeys.firstName),
                              isRequired: true),
                          _buildUnderlineField(
                            controller: controller.tcFirstNameController,
                            hintText: tr(LanguageKeys.enterFirstName),
                            validator: (value) => value!.trim().isEmpty
                                ? "First Name is required"
                                : null,
                          ),
                          SizedBox(height: 16.w),

                          _buildLabel(tr(LanguageKeys.lastName),
                              isRequired: true),
                          _buildUnderlineField(
                            controller: controller.tcLastNameController,
                            hintText: tr(LanguageKeys.enterLastName),
                            validator: (value) => value!.trim().isEmpty
                                ? "Last Name is required"
                                : null,
                          ),
                          SizedBox(height: 16.w),

                          _buildLabel(tr(LanguageKeys.email), isRequired: true),
                          _buildUnderlineField(
                            controller: controller.tcEmailController,
                            hintText: tr(LanguageKeys.enterEmail),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Email is required";
                              } else if (!GetUtils.isEmail(value.trim())) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.w),

                          _buildLabel(tr(LanguageKeys.password),
                              isRequired: true),
                          Obx(() => _buildUnderlineField(
                                controller: controller.tcPasswordController,
                                hintText: tr(LanguageKeys.enterPassword),
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                suffixIcon: IconButton(
                                  icon: Icon(controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () =>
                                      controller.togglePasswordVisibility(),
                                ),
                                validator: (value) => value!.trim().isEmpty
                                    ? "Password is required"
                                    : null,
                              )),
                          const SizedBox(height: 16),

                          _buildLabel(tr(LanguageKeys.phoneNumber),
                              isRequired: false),
                          _buildPhoneNumberField(
                            controller: controller.tcPhoneNumberController,
                            selectedCountry: controller.selectedCountry,
                            countryList: controller.countries,
                          ),
                          SizedBox(height: 16.w),

                          SizedBox(height: 16.w),

                          _buildLabel(tr(LanguageKeys.job)),
                          _buildUnderlineField(
                            controller: controller.tcJobController,
                            hintText: tr(LanguageKeys.enterJob),
                          ),

                          SizedBox(height: 16.w),
                          _buildLabel(tr(LanguageKeys.city)),
                          _buildUnderlineField(
                            controller: controller.tcCity,
                            hintText: tr(LanguageKeys.enterCity),
                          ),
                          SizedBox(height: 20.w),

                          /// Privacy Policies selection box
                          Obx(() => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 0.75, // Shrinks the checkbox
                                    child: Checkbox(
                                      value: controller.isAccepted.value,
                                      onChanged: (bool? newValue) {
                                        controller.isAccepted.value = newValue!;
                                        showPrivacyError.value = false;
                                      },
                                      checkColor: AppColors.blackColor,
                                      // Black tick
                                      fillColor:
                                          WidgetStateProperty.resolveWith<
                                              Color>((Set<WidgetState> states) {
                                        return Colors
                                            .white; // Always white background regardless of state
                                      }),
                                      side: BorderSide(
                                          color: showPrivacyError.value &&
                                                  !controller.isAccepted.value
                                              ? AppColors.redColor
                                              : Colors.black,
                                          width: 1.5),
                                      // Red border only when validation fails
                                      visualDensity: VisualDensity.compact,
                                      // Reduces internal padding
                                      shape: RoundedRectangleBorder(
                                        // Optional: rounded square checkbox
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            tr(LanguageKeys.acceptThePolicies),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: showPrivacyError.value &&
                                                  !controller.isAccepted.value
                                              ? AppColors.redColor
                                              : AppColors.blackColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                tr(LanguageKeys.privacyPolicy),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                // final url =
                                                //     'https://refearly-back.developmentlabs.co/privacy-policy?lang=${Get.locale?.languageCode ?? 'en'}';
                                                // final uri = Uri.parse(url);

                                                final urlString =
                                                    'https://refearly-back.developmentlabs.co/privacy-policy?lang=${Get.locale?.languageCode ?? 'en'}';
                                                controller.openPdfBottomSheet(
                                                    context, urlString);
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(height: 25.w),

                          /// Register Button
                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: PrimaryButton(
                                text: tr(LanguageKeys.register),
                                onPressed: () {
                                  if (!controller.isAccepted.value) {
                                    showPrivacyError.value = true;

                                    return;
                                  }
                                  controller.registerApi();
                                },
                                elevation: 2,
                                isLoading: controller.isLoadingRegister.value,
                              ),
                            );
                          }),

                          SizedBox(height: 25.w),

                          /// Sign-in
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                tr(LanguageKeys.alredyHaveAcc),
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 15.w),
                              ),
                              SizedBox(width: 4.w),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(ScreenLogin.pageId);
                                },
                                child: Text(
                                  tr(LanguageKeys.login),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                    fontSize: 15.w,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.w),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// ----------------- Custom Widgets ------------------

Widget _buildLabel(String text, {bool isRequired = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Text(text,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600)),
        if (isRequired)
          Text(' *', style: TextStyle(color: AppColors.redColor, fontSize: 16)),
      ],
    ),
  );
}

Widget _buildUnderlineField({
  required TextEditingController controller,
  required String hintText,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: AppColors.blackColor.withOpacity(0.045),
        hintStyle: TextStyle(color: AppColors.greyFontColor),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    ),
  );
}

Widget _socialIcon(
    IconData assetPath, String tooltip, VoidCallback onTapCallback) {
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
          child: Icon(
            assetPath,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      ),
    ),
  );
}

Widget _buildPhoneNumberField({
  required TextEditingController controller,
  required Rx<Country> selectedCountry,
  required List<Country> countryList,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.blackColor.withOpacity(0.045),
      borderRadius: BorderRadius.circular(12),
    ),
    // padding: const EdgeInsets.symmetric(horizontal: 1),
    child: Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Get.bottomSheet(
              _buildCountryPickerBottomSheet(
                countryList: countryList,
                selectedCountry: selectedCountry,
              ),
              isScrollControlled: true,
              backgroundColor: Colors.white,
            );
          },
          child: Obx(() => Container(
                width: 80,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  selectedCountry.value.code,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: tr(LanguageKeys.enterNum),
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: AppColors.greyFontColor),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCountryPickerBottomSheet({
  required List<Country> countryList,
  required Rx<Country> selectedCountry,
}) {
  return SafeArea(
    child: Container(
      height: Get.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ListView.separated(
              itemCount: countryList.length,
              separatorBuilder: (_, __) => Divider(color: AppColors.grey200),
              itemBuilder: (context, index) {
                final country = countryList[index];
                return ListTile(
                  minVerticalPadding: 0,
                  minTileHeight: 40,
                  onTap: () {
                    selectedCountry.value = country;
                    Get.back();
                  },
                  leading:
                      Text(country.emoji, style: const TextStyle(fontSize: 20)),
                  title: Text(country.name),
                  // trailing: Text(country.code),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
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
