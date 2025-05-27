import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/onboarding_story5_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class OnboardingPager extends GetView<OnboardingStory5Controller> {
  static const String pageId = '/onboarding_pager';
  OnboardingPager({super.key});
  final controller = Get.put(OnboardingStory5Controller());

  @override
  Widget build(BuildContext context) {
    final pages = [
      Center(
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr(LanguageKeys.networkWithProfessionals),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Image(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: AssetImage(
                      AppAssets.imgBoard1)),
            ],
          )), // Replace with your custom widget
      Center(
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr(LanguageKeys.findBusinessReferrers),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Image(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: AssetImage(AppAssets.imgBoard2)),
            ],
          )),
      Center(
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr(LanguageKeys.alsoReferThem),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Image(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: AssetImage(
                        AppAssets.imgBoard3)),
              ),
            ],
          )), // Replace with your custom widget
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => _SegmentedIndicator(
                  currentIndex: controller.currentPage.value,
                  count: pages.length,
                )),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: pages,
              ),
            ),

            // Button
            Padding(
              padding: EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: controller.goToNext,
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      tr(LanguageKeys.startNetworkingNow),
                      style: stylePoppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _SegmentedIndicator({required int currentIndex, required int count}) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Row(
      children: List.generate(count, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: index == 0 ? 0 : 4),
            height: 6,
            decoration: BoxDecoration(
              color:
                  index == currentIndex ? AppColors.primary : Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }),
    ),
  );
}
