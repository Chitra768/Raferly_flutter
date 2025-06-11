import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';
import '../../controller/controller_profile_type.dart';
import '../../resources/app_colors.dart';
import '../../widgets/custom_auth_app_bar.dart';

class ScreenProfileType extends GetView<ControllerProfileType> {
  static const String pageId = "/ScreenProfileType";

  final ControllerProfileType profileTypeController =
      Get.put(ControllerProfileType());

  ScreenProfileType({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: const CustomAuthAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Obx(
                    () => Text(
                      tr(LanguageKeys.chooseProfileType),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => Column(
                      children: [
                        _buildProfileTypeOption(
                          context,
                          LanguageKeys.individual,
                          LanguageKeys.individualSubtitle,
                          LanguageKeys.individualDescription,
                          profileTypeController.selectedProfileType.value ==
                              LanguageKeys.individual,
                          () => profileTypeController
                              .selectProfileType(LanguageKeys.individual),
                        ),
                        const SizedBox(height: 16),
                        _buildProfileTypeOption(
                          context,
                          LanguageKeys.professional,
                          LanguageKeys.professionalSubtitle,
                          LanguageKeys.professionalDescription,
                          profileTypeController.selectedProfileType.value ==
                              LanguageKeys.professional,
                          () => profileTypeController
                              .selectProfileType(LanguageKeys.professional),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(() => Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFF963ADD),
                                  Color(0xFF4F107F),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: PrimaryButton(
                              text: tr(LanguageKeys.Continue),
                              onPressed: () {
                                profileTypeController.goToNextScreen(context);
                              },
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          if (profileTypeController.isLoading.value)
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                                strokeWidth: 2.5,
                              ),
                            ),
                        ],
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTypeOption(
      BuildContext context,
      String typeKey,
      String subtitle,
      String description,
      bool isSelected,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        tr(typeKey),
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        tr(subtitle),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey500,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 4),
                    // Obx(
                    //   () => Text(
                    //     tr(description),
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: AppColors.blackColor,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //     softWrap: true,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppColors.primary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
