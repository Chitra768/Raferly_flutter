import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/utils/translations.dart';
import '../../controller/onboarding_consultation_success_controller.dart';
import '../../resources/app_colors.dart';
import '../../resources/text_style.dart';

class OnboardingConsultationSuccessScreen
    extends GetView<OnboardingConsultationSuccessController> {
  static const String pageId = '/onboarding_consultation_success';
  const OnboardingConsultationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(tr(LanguageKeys.busniess),
            style: stylePoppins(fontWeight: FontWeight.w500, fontSize: 16)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(
              color: AppColors.textFieldColor,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 62),
                  Image.asset(
                    AppAssets.imgSuccess1,
                    width: 52,
                    height: 52,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    tr(LanguageKeys.weWillGetBackToYou),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: AppColors.blackColor),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      tr(LanguageKeys
                          .weWillCoverThisDuringYourConsultationCall),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.textTitle),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.onBookConsultation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        tr(LanguageKeys.bookMyConsultation),
                        style: stylePoppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
