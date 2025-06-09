import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_preference.dart';

class ControllerConnectedCard extends GetxController {
  final RxInt currentCardIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);

  List<String> cardImagesByLocale(String locale) {
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
    final locale = AppPreference.getLanguage();
    return cardImagesByLocale(locale);
  }

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentCardIndex.value = pageController.page?.round() ?? 0;
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
