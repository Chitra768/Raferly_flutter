import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller_connected_card.dart';
import '../../resources/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button_outline.dart';

class ScreenConnectedCard extends GetView<ControllerConnectedCard> {
  static const String pageId = '/screenConnectedCard';
  const ScreenConnectedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: const BackButton(),
        title: const Text(
          'Connected Card',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select your style',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.cardImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          controller.cardImages[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.cardImages.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: _getIndicatorBorder(index,
                            controller.currentCardIndex.value), // Outer border
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(
                            1.5), // Margin to see outer border
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getIndicatorColor(
                              index, controller.currentCardIndex.value),
                          border: _getIndicatorBorder(
                              index, controller.currentCardIndex.value),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            SecondaryButton(
              text: 'Upgrade your plan and get ot for free',
              backgroundColor: AppColors.whiteColor,
              textColor: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              onPressed: () {},
              borderRadius: 10,
            ),
            const SizedBox(height: 15),
            PrimaryButton(
              text: r'Get it for 60$',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              onPressed: () {},
              borderRadius: 10,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ],
        ),
      ),
    );
  }

  Color _getIndicatorColor(int index, int currentIndex) {
    if (index == 0) {
      return currentIndex == index ? AppColors.primary : Colors.grey.shade300;
    } else if (index == 1) {
      return currentIndex == index ? Colors.black : Colors.grey.shade300;
    } else if (index == 2) {
      return currentIndex == index ? Colors.white : Colors.grey.shade300;
    }
    return Colors.grey.shade300; // Default color
  }

  Border? _getIndicatorBorder(int index, int currentIndex) {
    if (index == 0 && currentIndex == index) {
      return Border.all(color: AppColors.primary, width: 2);
    } else if (index == 1 && currentIndex == index) {
      return Border.all(color: Colors.black, width: 2);
    } else if (index == 2 && currentIndex == index) {
      return Border.all(color: Colors.black, width: 2);
    }
    return null; // No border for inactive
  }
}
