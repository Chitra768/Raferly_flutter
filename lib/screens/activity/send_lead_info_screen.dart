import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/send_lead_info_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SendLeadInfoScreen extends StatelessWidget {
  static const String pageId = '/SendLeadInfoScreen';
  final SendLeadInfoController controller = Get.put(SendLeadInfoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        foregroundColor: AppColors.whiteColor,
        backgroundColor: Colors.white,
        surfaceTintColor: AppColors.whiteColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.yourActivity),
          style: stylePoppins(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              color: AppColors.dividerColor,
              height: 1,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.activity.value?.title ?? '',
                    style: stylePoppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.activity.value?.subtitle ?? '',
                    style: stylePoppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.detailsTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.activity.value?.text ?? '',
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.detailsTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  controller.activity.value?.videoLink != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black12,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Obx(
                                    () => controller.playVideo1.value
                                        ? YoutubePlayer(
                                            controller:
                                                controller.videocontroller!,
                                            showVideoProgressIndicator: true,
                                          )
                                        : Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  'https://img.youtube.com/vi/${controller.videoId}/0.jpg',
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller.playVideo1
                                                        .value = true;
                                                    controller.videocontroller
                                                        ?.play();
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.black45,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 48,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 0),
                  Text(
                    controller.activity.value?.guidelineTitle ?? '',
                    style: stylePoppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColors.detailsTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(
                          controller.activity.value?.guidelines?.length ?? 0,
                          (index) => _buildStep(
                              index + 1,
                              controller.activity.value?.guidelines?[index] ??
                                  '')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: stylePoppins(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.detailsTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
