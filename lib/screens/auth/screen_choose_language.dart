import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/widgets/primary_button.dart';

import '../../controller/controller_choose_language.dart';
import '../../resources/app_colors.dart';
import 'screen_welcome.dart';

class ScreenChooseLanguage extends GetView<ControllerChooseLanguage> {
  static const String pageId = "/ScreenChooseLanguage";

  final ControllerChooseLanguage controlerr =
      Get.put(ControllerChooseLanguage());

  ScreenChooseLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              const Text(
                'Choose Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              // Use Obx to rebuild the list when the selectedLanguage changes.
              Obx(
                () => Column(
                  children: controlerr.languages.map((language) {
                    final languageCode = language.locale.languageCode;
                    final languageName = language.name;
                    final isSelected =
                        controlerr.selectedLanguage.value == languageCode;
                    final languageFlag = language.flag; // Get the flag
                    final languageMode = language.mode; // Get the mode

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        // Use GestureDetector for the whole row
                        onTap: () => controlerr.changeLanguage(languageCode),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.greyFontColor.withOpacity(0.080),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300, // border color
                              width: isSelected ? 1 : 0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // space between
                              children: [
                                Row(
                                  // Wrap the flag, name, and mode in a Row
                                  children: [
                                    Text(languageFlag,
                                        style: const TextStyle(
                                            fontSize: 18)), // Display the flag
                                    const SizedBox(width: 8), // Add some spacing
                                    Text(
                                      languageName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: isSelected
                                            ? AppColors.blackColor
                                            : Colors.black, // text color
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.w500
                                      ),
                                    ),
                                    const SizedBox(width: 8), // Add some spacing
                                  ],
                                ),
                                // Use a Radio widget, but hide the label.
                                Transform.scale(
                                  // Wrap the Radio widget with Transform.scale
                                  scale:
                                      1.25, // Increase the size of the Radio button
                                  child: Radio<String>(
                                    value: languageCode,
                                    groupValue: controlerr.selectedLanguage.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        // null check
                                        controlerr.changeLanguage(value);
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
              const SizedBox(height: 40),
              PrimaryButton(text: "Let's Go!!!", onPressed: (){
                Get.toNamed(ScreenWelcome.pageId);
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
