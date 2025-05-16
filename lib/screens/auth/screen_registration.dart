import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';
import '../../controller/controller_registration.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_log.dart';
import '../../social_logins/google_sign_in_service.dart';
import '../../widgets/custom_auth_app_bar.dart';
import '../../widgets/custom_toast_msg.dart';
import '../../widgets/widget_loading.dart';
import '../home/screen_main.dart';

class ScreenRegistration extends StatelessWidget {
  static const String pageId = "/ScreenRegistration";
  final controller = Get.put(RegistrationController());
  final _formKey = GlobalKey<FormState>();

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
            child: controller.isLoadingRegister.value
                ? const Center(child: WidgetLoading())
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top social icons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Divider(
                                            thickness: 1, color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        tr(LanguageKeys.createAnAccount),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                        child: Divider(
                                            thickness: 1, color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                /// Social Signup

                                /// Social Signup
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _socialIcon(Icons.g_mobiledata, 'Google',
                                        () async {
                                      controller.isLoadingRegister.value = true;

                                      final user = await GoogleSignInService
                                          .loginWithGoogle();

                                      if (user != null) {
                                        // Get a fresh token
                                        final tokenId =
                                            await GoogleSignInService
                                                .refreshGoogleToken(user);

                                        if (tokenId != null) {
                                          final success =
                                              await GoogleSignInService
                                                  .socialLoginApi(
                                                      user, tokenId);
                                          if (success) {
                                            controller.isLoadingRegister.value =
                                                false;
                                            Get.offAllNamed(ScreenMain.pageId);
                                          } else {
                                            controller.isLoadingRegister.value =
                                                false;
                                            CustomToast.show(
                                                Get.overlayContext!,
                                                "Google login failed");
                                          }
                                        } else {
                                          controller.isLoadingRegister.value =
                                              false;
                                          CustomToast.show(Get.overlayContext!,
                                              "Failed to get Google token");
                                        }
                                      } else {
                                        controller.isLoadingRegister.value =
                                            false;
                                      }
                                    }),
                                    const SizedBox(width: 20),
                                    _socialIcon(Icons.apple, 'Apple', () async {
                                      controller.isLoadingRegister.value = true;

                                      // TODO: Add Apple sign-in logic here.
                                      controller.isLoadingRegister.value =
                                          false;
                                    }),
                                    const SizedBox(width: 20),
                                    _socialIcon(Icons.facebook, 'Facebook',
                                        () async {
                                      controller.isLoadingRegister.value = true;

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
                                                      user, accessToken);
                                          if (success) {
                                            controller.isLoadingRegister.value =
                                                false;
                                            Get.offAllNamed(ScreenMain.pageId);
                                          } else {
                                            controller.isLoadingRegister.value =
                                                false;
                                            // CustomToast.show(Get.overlayContext!,
                                            //     "Facebook login failed");
                                          }
                                        } else {
                                          controller.isLoadingRegister.value =
                                              false;
                                          // CustomToast.show(Get.overlayContext!,
                                          //     "Access token not found");
                                        }
                                      } else {
                                        controller.isLoadingRegister.value =
                                            false;
                                      }
                                    }),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                // Title
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr(LanguageKeys.register),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(tr(LanguageKeys.welcomeBacktreferaly),
                                        style: TextStyle(
                                            color: AppColors.greyFontColor,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 32),

                                _buildLabel(tr(LanguageKeys.firstName),
                                    isRequired: true),
                                _buildUnderlineField(
                                  controller: controller.tcFirstNameController,
                                  hintText: tr(LanguageKeys.enterFirstName),
                                  validator: (value) => value!.trim().isEmpty
                                      ? tr(LanguageKeys.emptyFirstName)
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                _buildLabel(tr(LanguageKeys.lastName),
                                    isRequired: true),
                                _buildUnderlineField(
                                  controller: controller.tcLastNameController,
                                  hintText: tr(LanguageKeys.enterLastName),
                                  validator: (value) => value!.trim().isEmpty
                                      ? tr(LanguageKeys.emptyLastName)
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                _buildLabel(tr(LanguageKeys.email),
                                    isRequired: true),
                                _buildUnderlineField(
                                  controller: controller.tcEmailController,
                                  hintText: tr(LanguageKeys.enterEmail),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return tr(LanguageKeys.emptyEmail);
                                    } else if (!GetUtils.isEmail(
                                        value.trim())) {
                                      return tr(LanguageKeys.invalidEmail);
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                _buildLabel(tr(LanguageKeys.password),
                                    isRequired: true),
                                Obx(() => _buildUnderlineField(
                                      controller:
                                          controller.tcPasswordController,
                                      hintText: tr(LanguageKeys.enterPassword),
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            controller.isPasswordVisible.value
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                        onPressed: () => controller
                                            .togglePasswordVisibility(),
                                      ),
                                      validator: (value) =>
                                          value!.trim().isEmpty
                                              ? tr(LanguageKeys.emptyPassword)
                                              : null,
                                    )),
                                const SizedBox(height: 16),

                                _buildLabel(tr(LanguageKeys.phoneNumber),
                                    isRequired: false),
                                _buildPhoneNumberField(
                                  controller:
                                      controller.tcPhoneNumberController,
                                  selectedCountry: controller.selectedCountry,
                                  countryList: controller.countries,
                                ),
                                const SizedBox(height: 16),

                                /// Select Professional/Individual
                                Row(
                                  children: [
                                    Obx(() => InkWell(
                                          onTap: () {
                                            controller.isProfessional.value =
                                                true;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            // Ensures no extra space around the Row
                                            children: [
                                              Radio<bool>(
                                                value: true,
                                                groupValue: controller
                                                    .isProfessional.value,
                                                onChanged: (val) => controller
                                                    .isProfessional
                                                    .value = val!,
                                                activeColor: AppColors.primary,
                                              ),
                                              Text(
                                                tr(LanguageKeys.professional),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(width: 20),
                                    Obx(() => InkWell(
                                          onTap: () {
                                            controller.isProfessional.value =
                                                false;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            // Ensures no extra space around the Row
                                            children: [
                                              Radio<bool>(
                                                value: false,
                                                groupValue: controller
                                                    .isProfessional.value,
                                                onChanged: (val) => controller
                                                    .isProfessional
                                                    .value = val!,
                                                activeColor: AppColors.primary,
                                              ),
                                              Text(
                                                tr(LanguageKeys.individual),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.blackColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                _buildLabel(tr(LanguageKeys.job)),
                                _buildUnderlineField(
                                  controller: controller.tcJobController,
                                  hintText: tr(LanguageKeys.enterJob),
                                ),

                                const SizedBox(height: 16),
                                _buildLabel(tr(LanguageKeys.city)),
                                _buildUnderlineField(
                                  controller: controller.tcCity,
                                  hintText: tr(LanguageKeys.enterCity),
                                ),
                                const SizedBox(height: 20),

                                /// Privacy Policies selection box
                                Obx(() => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: 0.75, // Shrinks the checkbox
                                          child: Checkbox(
                                            value: controller.isAccepted.value,
                                            onChanged: (bool? newValue) {
                                              controller.isAccepted.value =
                                                  newValue!;
                                            },
                                            checkColor: AppColors.blackColor,
                                            // Black tick
                                            fillColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                                    (Set<WidgetState> states) {
                                              return Colors
                                                  .white; // Always white background regardless of state
                                            }),
                                            side: const BorderSide(
                                                color: Colors.black,
                                                width: 1.5),
                                            // Persistent black border
                                            visualDensity:
                                                VisualDensity.compact,
                                            // Reduces internal padding
                                            shape: RoundedRectangleBorder(
                                              // Optional: rounded square checkbox
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text: tr(LanguageKeys.acceptThePolicies),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: tr(
                                                      LanguageKeys.privacyPolicy),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // Replace this with your logic to show dialog or navigate
                                                          Get.defaultDialog(
                                                            title:
                                                                tr(LanguageKeys.privacyPolicy),
                                                            content: const Text(
                                                                "Here are your privacy policies..."),
                                                          );
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 25),

                                /// Register Button
                                Obx(() {
                                  return controller.isLoadingRegister.value
                                      ? WidgetLoading(
                                          size: 40,
                                          color: AppColors.primary,
                                        )
                                      : PrimaryButton(
                                          text: tr(LanguageKeys.register),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              controller.registerApi();
                                            }
                                          },
                                        );
                                }),

                                const SizedBox(height: 25),

                                /// Sign-in
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tr(LanguageKeys.alredyHaveAcc),
                                      style:  TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 15),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.toNamed(ScreenLogin.pageId);
                                      },
                                      child: Text(
                                        tr(LanguageKeys.login),
                                        style:  TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
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
    IconData iconData, String tooltip, VoidCallback onTapCallback) {
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
        child: Icon(
          iconData,
          color: AppColors.primary,
          size: 28,
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
          const SizedBox(height: 8),
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
