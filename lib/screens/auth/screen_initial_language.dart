import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_choose_language_initial.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_assets.dart';
import 'screen_welcome.dart';

class ScreenInitialLanguage extends GetView<ControllerChooseLanguageInitial> {
  static const String pageId = "/ScreenInitialLanguage";

  final ControllerChooseLanguageInitial controller =
      Get.put(ControllerChooseLanguageInitial());

  ScreenInitialLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background SVG
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                AppAssets.imgBackgroundInitialLanguage,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),

                    // App Logo and Name Section
                    Center(
                      child: SvgPicture.asset(
                        AppAssets.imgAppLgo,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // App Name
                    const Text(
                      'Referaly',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // Tagline
                    Text(
                      tr(LanguageKeys.yourAppForBusinessReferrals),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Central Visual Section - Using Direct SVG Image
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        child: SvgPicture.asset(
                          AppAssets.imgCircleBackground,
                          width: 240,
                          height: 240,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Feature Descriptions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeatureItem(
                            AppAssets.imgAttached, tr(LanguageKeys.connect)),
                        _buildFeatureItem(
                            AppAssets.imgTrophy, tr(LanguageKeys.reward)),
                        _buildFeatureItem(
                            AppAssets.imgWelcomeRocket, tr(LanguageKeys.grow)),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Language Selection Title
                    Text(
                      tr(LanguageKeys.chooseYourLanguage),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Language Options
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: controller.languages.map((language) {
                          final languageCode = language.locale.languageCode;
                          final languageName = language.name;
                          final isSelected =
                              controller.selectedLanguage.value == languageCode;
                          final languageFlag = language.flag;

                          return GestureDetector(
                            onTap: () =>
                                controller.changeLanguage(languageCode),
                            child: Container(
                              width: 70,
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withOpacity(0.1)
                                          : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : const Color(0xFFE5E7EB),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageFlag,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    languageName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primary
                                          : const Color(0xFF374151),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Get Started Button
                    Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Mark first launch as complete
                          await AppPreference.writeInt(
                              AppPreference.isFirstTime, 1);
                          if (AppPreference.readInt(
                                  AppPreference.isFirstTime) ==
                              0) {
                            AppPreference.writeInt(
                                AppPreference.isFirstTime, 1);
                          }
                          // Navigate to welcome screen
                          Get.offAll(() => ScreenWelcome());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr(LanguageKeys.profileTypeGetStarted),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.whiteColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Final Tagline
                    Text(
                      tr(LanguageKeys.growLikeThousandsOfOthers),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String text) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.whiteColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.whiteColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }
}
