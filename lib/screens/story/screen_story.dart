import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller_story.dart';
import '../../resources/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button_outline.dart';

class StoryScreen extends GetView<StoryController> {
  static const String pageId = '/storyScreen';
  final controllerr = Get.put(StoryController());

  StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (details) => controllerr.handleTapDown(details, context),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // Story indicators at top
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.03,
                    left: screenWidth * 0.025,
                    right: screenWidth * 0.025,
                  ),
                  child: Row(
                    children: List.generate(
                      controllerr.totalStories.value,
                      (index) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.005),
                          child: Obx(() {
                            final isCurrentPage =
                                index == controllerr.currentPage.value;
                            final progress = isCurrentPage
                                ? controllerr.progress.value
                                : index < controllerr.currentPage.value
                                    ? 1.0
                                    : 0.0;

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: const Color(0xFFE9E9E9),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                                minHeight: screenHeight * 0.007,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),

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
                              final imageWidget = LayoutBuilder(
                                builder: (context, constraints) {
                                  return Image.asset(
                                    controllerr.storyImages[index],
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    fit: BoxFit.cover,
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
                                              text: 'I already have a card',
                                              backgroundColor:
                                                  AppColors.whiteColor,
                                              textColor: AppColors.primary,
                                              fontSize: 12,
                                              onPressed: () {},
                                              borderRadius: 10,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.025),
                                          Expanded(
                                            child: PrimaryButton(
                                              text: 'Order a card',
                                              fontSize: 12,
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
                                );
                              }

                              return imageWidget;
                            },
                          ),
                        ),

                        // Buttons below ONLY if NOT last page
                        if (!isLastPage)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.04,
                              left: screenWidth * 0.05,
                              right: screenWidth * 0.05,
                              top: screenHeight * 0.02,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    text: 'I already have a card',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    onPressed: () {},
                                    borderRadius: 10,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.025),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Order a card',
                                    fontSize: 12,
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
