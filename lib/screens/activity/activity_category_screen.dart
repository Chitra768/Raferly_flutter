import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/activity_category_controller.dart';

class ActivityCategoryScreen extends GetView<ActivityCategoryController> {
  static const String pageId = '/ActivityCategoryScreen';

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
          tr(LanguageKeys.howItWorks),
          style: stylePoppins(
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Divider(
            color: AppColors.dividerColor,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.doYouHaveQuestionsRegarding),
                  style: stylePoppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCategoryCard(
                  context,
                  AppAssets.imgActivityIcon, // Placeholder asset
                  tr(LanguageKeys.yourActivity),
                  onTap: controller.onActivityTap,
                ),
                const SizedBox(height: 16),
                _buildCategoryCard(
                  context,
                  AppAssets.imgBusniessIcon, // Placeholder asset
                  tr(LanguageKeys.businessReferrerFeatures),
                  onTap: controller.onBusinessReferrerTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String icon, String text,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Image.asset(icon, width: 40, height: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: stylePoppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
