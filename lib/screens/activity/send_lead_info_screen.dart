import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/send_lead_info_controller.dart';
import 'package:video_player/video_player.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(LanguageKeys.sendLead),
              style: stylePoppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share Opportunities Effortlessly',
              style: stylePoppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.detailsTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Connect businesses with valuable leads and earn rewards for successful referrals. Our streamlined process makes lead sharing simple, efficient, and profitable for everyone involved.',
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.detailsTextColor,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => Stack(
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
                        child: controller.isInitialized.value &&
                                controller.isPlaying.value
                            ? AspectRatio(
                                aspectRatio: controller
                                    .videoController.value.aspectRatio,
                                child: VideoPlayer(controller.videoController),
                              )
                            : Image.asset(
                                AppAssets.imgLeadIcon,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (!controller.isPlaying.value)
                      GestureDetector(
                        onTap: controller.playVideo,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.play_arrow,
                                color: Colors.white, size: 36),
                          ),
                        ),
                      ),
                  ],
                )),
            const SizedBox(height: 32),
            Text(
              'How to Share Leads',
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
                children: List.generate(4, (index) => _buildStep(index + 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
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
              'Select Your Contact',
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
