import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';

import '../../controller/controller_story.dart';
import '../../resources/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button_outline.dart';

class StoryScreen extends GetView<StoryController> {
  static const String pageId = '/storyScreen';
  final controllerr = Get.put(StoryController());

  StoryScreen({super.key});
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
                color: index == currentIndex
                    ? AppColors.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (details) => controllerr.handleTapDown(details, context),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Story indicators at top
                Obx(() => _SegmentedIndicator(
                      currentIndex: controller.currentPage.value,
                      count: controller.storyTitles.length,
                    )),

                Expanded(
                  child: Obx(() {
                    final currentIndex = controllerr.currentPage.value;
                    final isLastPage =
                        currentIndex == controllerr.totalStories.value - 1;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.015,
                          ),
                          child: Text(
                            controllerr.storyTitles[currentIndex],
                            style: TextStyle(
                              fontSize: screenHeight * 0.022,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),

                        // Swipable Images Only
                        Expanded(
                          child: PageView.builder(
                            controller: controllerr.pageController,
                            onPageChanged: controllerr.onPageChanged,
                            itemCount: controllerr.totalStories.value,
                            itemBuilder: (context, index) {
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final screenHeight =
                                  MediaQuery.of(context).size.height;

                              final imageWidget = LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    width: double.infinity,
                                    height: constraints.maxHeight,
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.topCenter,
                                    child: ClipRect(
                                      child: Image.asset(
                                        controllerr.storyImages[index],
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (index == controllerr.totalStories.value - 1) {
                                return Stack(
                                  children: [
                                    Positioned.fill(child: imageWidget),
                                    Positioned(
                                      left: screenWidth * 0.05,
                                      right: screenWidth * 0.05,
                                      bottom: screenHeight * 0.04,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SecondaryButton(
                                              text: tr(
                                                  LanguageKeys.alreadyHaveCard),
                                              backgroundColor:
                                                  AppColors.whiteColor,
                                              textColor: AppColors.primary,
                                              fontSize:
                                                  screenWidth < 600 ? 12 : 16,
                                              height: screenHeight *
                                                  (screenWidth < 600
                                                      ? 0.07
                                                      : 0.07),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              borderRadius: 10,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.025),
                                          Expanded(
                                            child: PrimaryButton(
                                              text: tr(LanguageKeys.orderCard),
                                              fontSize:
                                                  screenWidth < 600 ? 12 : 16,
                                              height: screenHeight *
                                                  (screenWidth < 600
                                                      ? 0.07
                                                      : 0.07),
                                              onPressed: () {
                                                controller.onTapOrderCard();
                                              },
                                              borderRadius: 10,
                                              fontWeight: FontWeight.w600,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return imageWidget;
                            },
                          ),
                        ),

                        // Buttons below ONLY if NOT last page
                        if (!isLastPage)
                          Column(
                            children: [
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.04,
                                  left: screenWidth * 0.05,
                                  right: screenWidth * 0.05,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SecondaryButton(
                                        text: tr(LanguageKeys.alreadyHaveCard),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        height: screenHeight * 0.07,
                                        onPressed: () {
                                          Get.back();
                                        },
                                        borderRadius: 10,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.025),
                                    Expanded(
                                      child: PrimaryButton(
                                        text: tr(LanguageKeys.orderCard),
                                        fontSize: 12,
                                        height: screenHeight * 0.07,
                                        fontWeight: FontWeight.w600,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        onPressed: () {
                                          controller.onTapOrderCard();
                                        },
                                        borderRadius: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
