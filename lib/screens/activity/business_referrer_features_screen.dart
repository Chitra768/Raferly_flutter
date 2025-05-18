import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/controller/business_referrer_features_controller.dart';

class BusinessReferrerFeaturesScreen
    extends GetView<BusinessReferrerFeaturesController> {
  static const String pageId = '/BusinessReferrerFeaturesScreen';

  final BusinessReferrerFeaturesController controller =
      Get.put(BusinessReferrerFeaturesController());

  final List<_FeatureItem> items = const [
    _FeatureItem(AppAssets.imgLeadIcon, LanguageKeys.sendLead),
   _FeatureItem( AppAssets.imgpremiumIcon, LanguageKeys.editProfileCompanyInfo),
    _FeatureItem(AppAssets.imgpremiumIcon, LanguageKeys.setupConnectedCard),
    _FeatureItem(AppAssets.imgSearch, LanguageKeys.bookCall),
    _FeatureItem(AppAssets.imgAddLead, LanguageKeys.addLeadManually),
    _FeatureItem(AppAssets.imgSearch, LanguageKeys.referalyFinder),
  ];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(LanguageKeys.businessReferrerFeatures),
              style: stylePoppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => controller.onFeatureTap(index),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(item.icon, width: 40, height: 40),
                          const SizedBox(height: 16),
                          Text(
                            tr(item.label),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String icon;
  final String label;
  const _FeatureItem(this.icon, this.label);
}
