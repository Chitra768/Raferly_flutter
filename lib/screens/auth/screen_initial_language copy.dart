import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_choose_language_initial.dart';
import 'package:referaly/resources/app_preference.dart';

import '../../resources/app_colors.dart';
import 'screen_welcome.dart';

class ScreenInitialLanguageCopy extends GetView<ControllerChooseLanguageInitial> {
  static const String pageId = "/ScreenInitialLanguage";

  final ControllerChooseLanguageInitial controller =
      Get.put(ControllerChooseLanguageInitial());

  ScreenInitialLanguageCopy({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF2A3240), // Dark gray background
        body: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Globe Icon with gradient background
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.language,
                      color: AppColors.whiteColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Choose Your Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF374151),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Select your preferred language to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Language Options
                  Obx(
                    () => Column(
                      children: controller.languages.map((language) {
                        final languageCode = language.locale.languageCode;
                        final languageName = language.name;
                        final isSelected =
                            controller.selectedLanguage.value == languageCode;
                        final languageFlag = language.flag;

                        // Secondary text for each language
                        String secondaryText = '';
                        if (languageCode == 'en') {
                          secondaryText = 'Default language';
                        } else if (languageCode == 'es') {
                          secondaryText = 'Spanish';
                        } else if (languageCode == 'fr') {
                          secondaryText = 'French';
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () =>
                                controller.changeLanguage(languageCode),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFFE5E7EB),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Flag Icon
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        languageFlag,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Language Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          languageName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF374151),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          secondaryText,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Radio Button
                                  Radio<String>(
                                    value: languageCode,
                                    groupValue:
                                        controller.selectedLanguage.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.changeLanguage(value);
                                      }
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Continue Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Mark first launch as complete
                        await AppPreference.writeInt(
                            AppPreference.isFirstTime, 1);
                        if (AppPreference.readInt(AppPreference.isFirstTime) ==
                            0) {
                          AppPreference.writeInt(AppPreference.isFirstTime, 1);
                        }
                        // Navigate to welcome screen
                        Get.offAll(() => ScreenWelcome());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom text
                  const Text(
                    'You can change this later in settings',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
