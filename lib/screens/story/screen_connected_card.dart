import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

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
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            color: AppColors.dividerColor,
            height: 1,
          ),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.connectedCardImagesList.length,
              onPageChanged: (index) {
                AppHelper.showLog("index: $index");
                controller.currentCardIndex.value = index;
              },
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        tr(LanguageKeys.selectYourStyle),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 340,
                              height: 190,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  controller.connectedCardImagesList[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  controller.connectedCardImagesList.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: _getIndicatorBorder(index,
                                            controller.currentCardIndex.value),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(1.5),
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _getIndicatorColor(
                                              index,
                                              controller
                                                  .currentCardIndex.value),
                                          border: _getIndicatorBorder(
                                              index,
                                              controller
                                                  .currentCardIndex.value),
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
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(
                  () => PrimaryButton(
                    text: controller.currentCardIndex.value == 0
                        ? tr(LanguageKeys.getItForPrice)
                        : controller.currentCardIndex.value == 1
                            ? tr(LanguageKeys.getItForPriceTwo)
                            : tr(LanguageKeys.getItForPriceThree),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    onPressed: () {
                      if (controller.currentCardIndex.value == 0) {
                        UrlLauncher.launchUrl(Uri.parse(
                            "https://buy.stripe.com/00g03S9LaeREfUk5kD"));
                      } else if (controller.currentCardIndex.value == 1) {
                        UrlLauncher.launchUrl(Uri.parse(
                            "https://buy.stripe.com/eVq00l5zKh2C8ra7Zi2Nq0D"));
                      } else if (controller.currentCardIndex.value == 2) {
                        UrlLauncher.launchUrl(Uri.parse(
                            "https://buy.stripe.com/14AcN7e6g27I6j2bbu2Nq0C"));
                      }
                    },
                    borderRadius: 10,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 15),
                SecondaryButton(
                  text: tr(LanguageKeys.upgradePlanFree),
                  backgroundColor: AppColors.whiteColor,
                  textColor: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  onPressed: () {
                    Get.toNamed(MembershipScreen.pageId)?.then((value) {
                      controller.mainController.getProfile();
                    });
                  },
                  borderRadius: 10,
                ),
                const SizedBox(height: 25),
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
