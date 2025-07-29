import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/onboarding_story5_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class OnboardingPager extends GetView<OnboardingStory5Controller> {
  static const String pageId = '/onboarding_pager';
  OnboardingPager({super.key});
  final controller = Get.put(OnboardingStory5Controller());

  String getBoardImageByLocal(BuildContext context) {
    final String langCode =
        AppPreference.readString(AppPreference.appLanguage) ?? 'en';
    debugPrint('Selected language from AppPreference: $langCode');
    switch (langCode) {
      case 'fr':
        return AppAssets.imgBoard2French;
      case 'es':
        return AppAssets.imgBoard2Spanish;
      case 'en':
      default:
        return AppAssets.imgBoard2English;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

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
          const Image(
              width: double.infinity,
              fit: BoxFit.cover,
              image: AssetImage(AppAssets.imgBoard1)),
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
            /* key: ValueKey(imagePath),*/
            width: double.infinity,
            fit: BoxFit.cover,
            image: AssetImage(getBoardImageByLocal(context)),
          ),
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
          const Expanded(
            child: Image(
                width: double.infinity,
                fit: BoxFit.cover,
                image: AssetImage(AppAssets.imgBoard3)),
          ),
        ],
      )), // Replace with your custom widget
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.01,
                ),
                child: Icon(Icons.arrow_back, color: AppColors.blackColor),
              ),
            ),

            Obx(() => _SegmentedIndicator(
                  currentIndex: controller.currentPage.value,
                  count: pages.length,
                )),

            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    // Swipe left - go to next page
                    if (controller.currentPage.value < pages.length - 1) {
                      controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  } else if (details.primaryVelocity! > 0) {
                    // Swipe right - go to previous page
                    if (controller.currentPage.value > 0) {
                      controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
                onTapDown: (details) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  if (details.localPosition.dx < screenWidth / 2) {
                    // Tap on left side - go to previous page
                    if (controller.currentPage.value > 0) {
                      controller.pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  } else {
                    // Tap on right side - go to next page or next screen
                    if (controller.currentPage.value < pages.length - 1) {
                      controller.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // On last page, tap right side to go to next screen
                      controller.goToNext();
                    }
                  }
                },
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: pages,
                ),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.all(24.0),
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
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        );
      }),
    ),
  );
}
