import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/onboarding/select_jobs_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';

import '../../bindings/binding_select_jobs.dart';
import '../../controller/controller_registration.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../social_logins/google_sign_in_service.dart';
import '../webview/webview_screen.dart';

class ScreenRegistration extends StatelessWidget {
  static const String pageId = "/ScreenRegistration";
  final controller = Get.put(RegistrationController());
  final RxBool showPrivacyError = false.obs;
  final _formKey1 = GlobalKey<FormState>();

  ScreenRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey1,
          child: Obx(() {
            return Column(
              children: [
                // Purple Header Section
                Container(
                  width: double.infinity,
                  color: AppColors.primary,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Back button
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Get.offAllNamed(ScreenInitialLanguage.pageId),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: SvgPicture.asset(
                              AppAssets.imgHandshake,
                              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
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
                                    onTap: () => Get.offNamed(ScreenRegistration.pageId),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
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
                                    onTap: () => Get.toNamed(ScreenLogin.pageId),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
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
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Create Account Title
                        Text(
                          tr(LanguageKeys.createAccount),
                          style: TextStyle(
                            fontSize: 20.w,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 8.w),
                        Text(
                          tr(LanguageKeys.joinOurProfessionalNetwork),
                          style: TextStyle(
                            fontSize: 12.w,
                            color: AppColors.greyFontColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 22.w),

                        // Google Button (Full Width)
                        SocialLoginButton(
                            text: tr(LanguageKeys.google),
                            iconData: AppAssets.imgGoogle,
                            fontSize: 12.w,
                            borderColor: Colors.grey.withOpacity(0.3),
                            onPressed: () async {
                              final user = await GoogleSignInService.loginWithGoogle();

                              if (user != null) {
                                final tokenId = await FirebaseAuth.instance.currentUser?.getIdToken(true);

                                if (tokenId != null) {
                                  final success = await GoogleSignInService.socialLoginApi(user, tokenId,
                                      socialType: 'google');
                                }
                              }
                            }),

                        SizedBox(height: 12.w),

                        // Facebook and Apple Buttons (Side by Side)
                        // Facebook and Apple buttons (full width on Android, half width on iOS)
                        Platform.isIOS
                            ? Row(
                                children: [
                                  Expanded(
                                    child: SocialLoginButton(
                                      text: 'Facebook',
                                      iconData: AppAssets.imgFacebook1,
                                      fontSize: 12,
                                      iconColor: const Color(0xFF1877F2), // Facebook blue
                                      onPressed: () async {
                                        try {
                                          User? user = await GoogleSignInService.loginWithFacebook();
                                          if (user != null) {
                                            final accessToken =
                                                (await FacebookAuth.instance.accessToken)?.tokenString;
                                            if (accessToken != null) {
                                              final success = await GoogleSignInService.socialLoginApi(
                                                  user, accessToken,
                                                  socialType: 'facebook');
                                            } else {
                                              CustomToast.show(Get.overlayContext!,
                                                  tr(LanguageKeys.facebookTokenNotFound));
                                            }
                                          } else {
                                            CustomToast.show(
                                                Get.overlayContext!, tr(LanguageKeys.socialLoginCancelled));
                                          }
                                        } catch (e) {
                                          CustomToast.show(
                                              Get.overlayContext!, tr(LanguageKeys.socialLoginError));
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
                                          debugPrint("🍎 Starting Apple Sign-In...");

                                          final credential = await GoogleSignInService.signInWithApple();

                                          if (credential != null) {
                                            final user = credential.user;
                                            debugPrint("🍎 Apple Sign-In successful: ${user?.email}");

                                            final idToken =
                                                await user?.getIdToken(true); // ✅ force refresh token

                                            if (user != null && idToken != null) {
                                              debugPrint(
                                                  "🍎 Got Firebase ID token, calling social login API...");
                                              final success = await GoogleSignInService.socialLoginApi(
                                                user,
                                                idToken,
                                                socialType: 'apple',
                                              );
                                            } else {
                                              debugPrint("❌ Apple Sign-In: User or ID token is null");
                                              Get.snackbar(
                                                'Error',
                                                'Apple Sign-In failed. Please try again.',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                          } else {
                                            debugPrint("❌ Apple Sign-In: Credential is null");
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
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : SocialLoginButton(
                                text: 'Facebook',
                                iconData: AppAssets.imgFacebook1,
                                fontSize: 12,
                                iconColor: const Color(0xFF1877F2), // Facebook blue
                                onPressed: () async {
                                  try {
                                    User? user = await GoogleSignInService.loginWithFacebook();
                                    if (user != null) {
                                      final accessToken =
                                          (await FacebookAuth.instance.accessToken)?.tokenString;
                                      if (accessToken != null) {
                                        final success = await GoogleSignInService.socialLoginApi(
                                            user, accessToken,
                                            socialType: 'facebook');
                                      } else {
                                        CustomToast.show(
                                            Get.overlayContext!, tr(LanguageKeys.facebookTokenNotFound));
                                      }
                                    } else {
                                      CustomToast.show(
                                          Get.overlayContext!, tr(LanguageKeys.socialLoginCancelled));
                                    }
                                  } catch (e) {
                                    CustomToast.show(Get.overlayContext!, tr(LanguageKeys.socialLoginError));
                                  }
                                },
                              ),
                        SizedBox(height: 24.w),

                        // Separator
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                tr(LanguageKeys.orComplete),
                                style: TextStyle(
                                  color: AppColors.greyFontColor,
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.w),

                        // Form Fields
                        // First Name and Last Name Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(tr(LanguageKeys.firstName), isRequired: true),
                                  _buildFormField(
                                    controller: controller.tcFirstNameController,
                                    hintText: tr(LanguageKeys.enterFirstName),
                                    validator: (value) =>
                                        value!.trim().isEmpty ? "First Name is required" : null,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(tr(LanguageKeys.lastName), isRequired: true),
                                  _buildFormField(
                                    controller: controller.tcLastNameController,
                                    hintText: tr(LanguageKeys.enterLastName),
                                    validator: (value) =>
                                        value!.trim().isEmpty ? "Last Name is required" : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.w),

                        // Email Field
                        _buildLabel(tr(LanguageKeys.email), isRequired: true),
                        _buildFormField(
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

                        // Phone Number Field (Full Width)
                        _buildLabel(tr(LanguageKeys.phoneNumber), isRequired: true),
                        _buildPhoneNumberField(
                          controller: controller.tcPhoneNumberController,
                          selectedCountry: controller.selectedCountry,
                          countryList: controller.countries,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? "Phone Number is required" : null,
                        ),

                        SizedBox(height: 16.w),

                        // City Field (Full Width)
                        _buildLabel(tr(LanguageKeys.city), isRequired: true),
                        _buildFormField(
                          controller: controller.tcCity,
                          hintText: tr(LanguageKeys.enterCity),
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? "City is required" : null,
                        ),

                        SizedBox(height: 16.w),

                        // You are (Professional / Individual)
                        _buildLabel(tr(LanguageKeys.youAre), isRequired: true),
                        SizedBox(height: 8.w),
                        Obx(() {
                          final isPro = controller.isProfessional.value;
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => controller.isProfessional.value = true,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: isPro ? AppColors.roleCardSelectedBg : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isPro ? AppColors.primary : Colors.grey.withOpacity(0.3),
                                        width: isPro ? 2 : 1,
                                      ),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        if (isPro)
                                          Positioned(
                                            top: -16.w,
                                            right: -29.w,
                                            child: Container(
                                              width: 24.w,
                                              height: 24.w,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 14.w,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.imgJobActivity,
                                              height: 20.w,
                                              width: 20.w,
                                              colorFilter: ColorFilter.mode(
                                                isPro ? AppColors.primary : AppColors.greyFontColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(height: 10.w),
                                            Text(
                                              tr(LanguageKeys.professional),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14.w,
                                                fontWeight: FontWeight.w500,
                                                color: isPro ? AppColors.primary : AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.isProfessional.value = false,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: !isPro ? AppColors.roleCardSelectedBg : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: !isPro ? AppColors.primary : Colors.grey.withOpacity(0.3),
                                        width: !isPro ? 2 : 1,
                                      ),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        if (!isPro)
                                          Positioned(
                                            top: -16.w,
                                            right: -29.w,
                                            child: Container(
                                              width: 24.w,
                                              height: 24.w,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 14.w,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              // AppAssets.imgProfileIcon,
                                              AppAssets.imgPersonactivity,
                                              height: 20.w,
                                              width: 20.w,
                                              colorFilter: ColorFilter.mode(
                                                !isPro ? AppColors.primary : AppColors.greyFontColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(height: 10.w),
                                            Text(
                                              tr(LanguageKeys.individual),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14.w,
                                                fontWeight: FontWeight.w500,
                                                color: !isPro ? AppColors.primary : AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                        SizedBox(height: 16.w),

                        // Job/Profession Field
                        _buildLabel(tr(LanguageKeys.job), isRequired: true),
                        GestureDetector(
                          onTap: () async {
                            final result = await Get.to(
                              () => const SelectJobsScreen(isSingleSelection: true),
                              binding: BindingSelectJobs(isSingleSelection: true),
                            );
                            if (result != null && result is Map) {
                              if (result.containsKey('id') && result.containsKey('title')) {
                                final jobId = result['id'];
                                final jobTitle = result['title'] ?? '';
                                controller.tcJobController.text = jobTitle;
                                controller.selectedJob.value = jobTitle;
                                controller.selectedJobId.value = jobId.toString();
                              }
                            }
                          },
                          child: AbsorbPointer(
                            child: _buildFormField(
                              controller: controller.tcJobController,
                              hintText: tr(LanguageKeys.enterJob),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty ? "Job is required" : null,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.w),

                        // Password Field
                        _buildLabel(tr(LanguageKeys.password), isRequired: true),
                        Obx(() => _buildFormField(
                              controller: controller.tcPasswordController,
                              hintText: tr(LanguageKeys.enterPassword),
                              obscureText: !controller.isPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => controller.togglePasswordVisibility(),
                              ),
                              validator: (value) => value!.trim().isEmpty ? "Password is required" : null,
                              onChanged: (_) {
                                // Trigger re-validation of confirm password field
                                if (controller.tcConfirmPasswordController.text.isNotEmpty) {
                                  _formKey1.currentState?.validate();
                                }
                              },
                            )),

                        SizedBox(height: 16.w),

                        // Confirm Password Field
                        _buildLabel(tr(LanguageKeys.confirmPassword), isRequired: true),
                        Obx(() => _buildFormField(
                              controller: controller.tcConfirmPasswordController,
                              hintText: tr(LanguageKeys.confirmPassword),
                              obscureText: !controller.isPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () => controller.togglePasswordVisibility(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Confirm Password is required";
                                }
                                if (value.trim() != controller.tcPasswordController.text.trim()) {
                                  return tr(LanguageKeys.passwordDoNotMatch);
                                }
                                return null;
                              },
                            )),

                        SizedBox(height: 20.w),

                        /// Privacy Policies selection box
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Checkbox(
                                    value: controller.isAccepted.value,
                                    side: BorderSide(
                                      color: AppColors.grey300,
                                      width: 1,
                                    ),
                                    onChanged: (value) {
                                      controller.isAccepted.value = value ?? false;
                                    },
                                    activeColor: AppColors.primary,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  )),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () async {
                                    // final Uri url = Uri.parse(
                                    //     "https://refearly-back.developmentlabs.co/privacy-policy?lang=${Get.locale?.languageCode ?? 'en'}");
                                    // if (await canLaunchUrl(url)) {
                                    //   await launchUrl(url,
                                    //       mode: LaunchMode.externalApplication);
                                    // } else {
                                    //   throw 'Could not launch $url';
                                    // }

                                    Get.toNamed(WebViewScreen.pageId, arguments: {
                                      'url':
                                          "https://refearly-back.developmentlabs.co/privacy-policy?lang=${Get.locale?.languageCode ?? 'en'}",
                                      'title': tr(LanguageKeys.privacyPolicy),
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(() => Text(
                                            tr(LanguageKeys.acceptThePolicies),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: showPrivacyError.value && !controller.isAccepted.value
                                                  ? AppColors.redColor
                                                  : AppColors.blackColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                      GestureDetector(
                                        onTap: () async {
                                          Get.toNamed(WebViewScreen.pageId, arguments: {
                                            'url':
                                                "https://refearly-back.developmentlabs.co/privacy-policy?lang=${Get.locale?.languageCode ?? 'en'}",
                                            'title': tr(LanguageKeys.privacyPolicy),
                                          });
                                        },
                                        child: Obx(() => Text(
                                              tr(LanguageKeys.privacyPolicy),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 25.w),

                        /// Create Account Button
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate form first
                                if (!_formKey1.currentState!.validate()) {
                                  return;
                                }

                                // Check privacy policy acceptance
                                if (!controller.isAccepted.value) {
                                  showPrivacyError.value = true;
                                  return;
                                }

                                // Check if passwords match
                                if (controller.tcPasswordController.text !=
                                    controller.tcConfirmPasswordController.text) {
                                  Get.snackbar(
                                    tr(LanguageKeys.error),
                                    'Passwords do not match',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                controller.registerApi();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: controller.isLoadingRegister.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      tr(LanguageKeys.createAccount),
                                      style: TextStyle(
                                        fontSize: 16.w,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        }),

                        SizedBox(height: 25.w),

                        // /// Sign-in Link
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       tr(LanguageKeys.alredyHaveAcc),
                        //       style: TextStyle(
                        //         color: AppColors.blackColor,
                        //         fontSize: 15.w,
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         Get.toNamed(ScreenLogin.pageId);
                        //       },
                        //       child: Text(
                        //         tr(LanguageKeys.signinNew),
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w600,
                        //           color: AppColors.primary,
                        //           fontSize: 15.w,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // SizedBox(height: 20.w),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
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
        Flexible(
          child: Text(text,
              style: TextStyle(fontSize: 14, color: AppColors.blackColor, fontWeight: FontWeight.w600)),
        ),
        if (isRequired) Text(' *', style: TextStyle(color: AppColors.redColor, fontSize: 16)),
      ],
    ),
  );
}

Widget _buildFormField({
  required TextEditingController controller,
  required String hintText,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(color: AppColors.greyFontColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.redColor, width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    ),
  );
}

Widget _buildPhoneNumberField({
  required TextEditingController controller,
  required Rx<Country> selectedCountry,
  required List<Country> countryList,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    selectedCountry.value.code,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                )),
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              validator: validator,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              decoration: InputDecoration(
                hintText: tr(LanguageKeys.enterNum),
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(color: AppColors.greyFontColor),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                errorStyle: const TextStyle(height: 0.8),
              ),
            ),
          ),
        ],
      ),
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
                  leading: Text(country.emoji, style: const TextStyle(fontSize: 20)),
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
  final Color? iconColor;
  final Color borderColor;
  final Color textColor;
  final bool applyIconOffset;
  final double fontSize;
  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconData,
    required this.onPressed,
    this.iconColor,
    required this.fontSize,
    this.borderColor = const Color(0xFFE5E7EB),
    this.textColor = const Color(0xFF374151),
    this.applyIconOffset = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon area
            SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: SvgPicture.asset(
                  iconData,
                  colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
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
