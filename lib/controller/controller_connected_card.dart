import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';

class ControllerConnectedCard extends GetxController {
  final RxInt currentCardIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  final RxString currentLocale = ''.obs;

  List<String> cardImagesByLocale(String locale) {
    AppHelper.showLog("locale: $locale");
    switch (locale) {
      case 'es':
        return [
          AppAssets.imgConnectedCardSpanishOne,
          AppAssets.imgConnectedCardSpanishTwo,
          AppAssets.imgConnectedCardSpanishThree,
        ];
      case 'fr':
        return [
          AppAssets.imgConnectedCardFrenchOne,
          AppAssets.imgConnectedCardFrenchTwo,
          AppAssets.imgConnectedCardFrenchThree,
        ];
      case 'en':
      default:
        return [
          AppAssets.imgConnectedCardOne,
          AppAssets.imgConnectedCardTwo,
          AppAssets.imgConnectedCardThree,
        ];
    }
  }

  /// List of connected card images
  List<String> get connectedCardImagesList {
    return cardImagesByLocale(currentLocale.value);
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with current language
    currentLocale.value = AppPreference.getLanguage();

    // Listen for language changes
    ever(currentLocale, (_) {
      update(); // Trigger UI update when language changes
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
