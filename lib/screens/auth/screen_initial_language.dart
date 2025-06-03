import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_choose_language_initial.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../../resources/app_colors.dart';
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
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  tr(LanguageKeys.chooseLanguage),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Use Obx to rebuild the list when the selectedLanguage changes.
                Obx(
                  () => Column(
                    children: controller.languages.map((language) {
                      final languageCode = language.locale.languageCode;
                      final languageName = language.name;
                      final isSelected =
                          controller.selectedLanguage.value == languageCode;
                      final languageFlag = language.flag;
                      final languageMode = language.mode;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () => controller.changeLanguage(languageCode),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.whiteColor
                                  : AppColors.greyFontColor.withOpacity(0.080),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 1 : 0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(languageFlag,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(width: 8),
                                      Text(
                                        languageName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: isSelected
                                              ? AppColors.blackColor
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                  Transform.scale(
                                    scale: 1.25,
                                    child: Radio<String>(
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: tr(LanguageKeys.letGo),
                  onPressed: () async {
                    // Mark first launch as complete
                    await AppPreference.writeInt(AppPreference.isFirstTime, 1);
                    if (AppPreference.readInt(AppPreference.isFirstTime) == 0) {
      AppPreference.writeInt(AppPreference.isFirstTime, 1);
      // Future.delayed(const Duration(seconds: 2), () {
      //   Get.dialog(DiscoverReferalyFinderDialog(onLetsGo: Get.back));
      // });
    }
                    // Navigate to welcome screen
                    Get.offAll(() => ScreenWelcome());
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
