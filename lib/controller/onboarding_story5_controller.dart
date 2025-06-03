import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:referaly/screens/onboarding/onboarding_business_network.dart';

class OnboardingStory5Controller extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void goToNext() {
     Get.offAndToNamed(OnboardingBusinessNetworkScreen.pageId);
    // if (currentPage.value < 2) {
    //   pageController.nextPage(
    //       duration: Duration(milliseconds: 300), curve: Curves.ease);
    // } else {
    //   // TODO: Navigate to main app or next flow
    //   // Example: Get.offAllNamed('/home');
    //   Get.offAndToNamed(OnboardingBusinessNetworkScreen.pageId);
    // }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
