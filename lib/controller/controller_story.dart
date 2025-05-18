import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/screens/story/screen_connected_card.dart';

import '../resources/app_assets.dart';

class StoryController extends GetxController {
  late PageController pageController;

  final RxInt currentPage = 0.obs;
  final RxInt totalStories = 0.obs; // Set dynamically
  final RxDouble progress = 0.0.obs;

  final RxList<String> storyTitles = <String>[
    'A connected card that you tap on the phone, easy and fast',
    'A digital visit card for your leads, clients and partners',
    'Your best networking tool !!',
    'Stand out, be different and order your card now',
  ].obs;

  final RxList<String> storyImages = <String>[
    AppAssets.imgStoryOne,
    AppAssets.imgStoryTwo,
    AppAssets.imgStoryThree,
    AppAssets.imgStoryFour,
  ].obs;

  @override
  void onInit() {
    super.onInit();
    totalStories.value = storyImages.length;
    pageController = PageController(initialPage: 0);

    // Manually set current page to 0 and print it
    currentPage.value = 0;
    print('Current Page Index: 0');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    print('Current Page Index: $page');
  }

  void nextPage() {
    if (currentPage.value < totalStories.value - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      currentPage.value = totalStories.value - 1; // Make sure index is valid
      // Navigate after a short delay to allow UI update
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.toNamed('/networking');
      });
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void handleTapDown(TapDownDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth / 3) {
      previousPage();
    } else if (tapPosition > (screenWidth * 2 / 3)) {
      nextPage();
    }
  }
  
  void onTapOrderCard(){
    Get.toNamed(ScreenConnectedCard.pageId);
  }
}
