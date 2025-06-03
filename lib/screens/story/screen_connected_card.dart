import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/utils/translations.dart';

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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: const BackButton(),
        title: Text(
          tr(LanguageKeys.ConnectedCard),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(
            color: AppColors.dividerColor,
            height: 1,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            tr(LanguageKeys.selectYourStyle),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18), // Minimal space between title and card
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 340, // Adjust width as needed
                  height: 190, // Adjust height as needed
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.cardImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          controller.cardImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                    height: 18), // Minimal space between card and indicators
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
                            border: _getIndicatorBorder(
                                index, controller.currentCardIndex.value),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(1.5),
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
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PrimaryButton(
                  text: tr(LanguageKeys.getItForPrice) + " 60\$",
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  onPressed: () {},
                  borderRadius: 10,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                const SizedBox(height: 15),
                SecondaryButton(
                  text: tr(LanguageKeys.upgradePlanFree),
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  onPressed: () {},
                  borderRadius: 10,
                ),
                const SizedBox(height: 15),
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _getIndicatorColor(int index, int currentIndex) {
    if (index == 0) {
      return currentIndex == index ? AppColors.primary : AppColors.primary;
    } else if (index == 1) {
      return currentIndex == index ? Colors.black : Colors.black;
    } else if (index == 2) {
      return currentIndex == index ? Colors.white : Colors.white;
    }
    return Colors.grey.shade300; // Default color
  }

  Border? _getIndicatorBorder(int index, int currentIndex) {
    if (index == 0 && currentIndex == index) {
      return Border.all(color: AppColors.primary, width: 1);
    } else if (index == 1 && currentIndex == index) {
      return Border.all(color: Colors.black, width: 1);
    } else if (index == 2 && currentIndex == index) {
      return Border.all(color: Colors.black, width: 1);
    }
    return null; // No border for inactive
  }
}
