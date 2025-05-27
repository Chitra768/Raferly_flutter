import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';

class ControllerConnectedCard extends GetxController {
  final RxInt currentCardIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  final List<String> cardImages = [

      AppAssets.imgConnectedCardThree,
       AppAssets.imgConnectedCardTwo,
    AppAssets.imgConnectedCardOne,
   
  
  ];

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