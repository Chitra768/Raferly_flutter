import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/membership_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/services/in_app_purchase_service.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:referaly/widgets/dialog/nfc_card_video_dialog.dart';

class MembershipScreen extends StatefulWidget {
  static String pageId = "/membership";
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  MembershipController controller = Get.put(MembershipController());

  @override
  void initState() {
    super.initState();
    controller = Get.put(MembershipController());
  }

  // @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.Membership),
          style: stylePoppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(() {
            AppHelper.showLog(
                "Loader: ${controller.purchaseService.isLoading.value}");
            return controller.purchaseService.isLoading.value == false
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildHeaderSection(),
                                const SizedBox(height: 24),
                                // _buildPlanToggleSection(),
                                // const SizedBox(height: 32),
                                _buildInfoCards(),
                                // Plans
                                Obx(() => Column(
                                      children: [
                                        _buildPlanCard(
                                          title: tr(LanguageKeys.Independent),
                                          price: _getProductPrice(
                                            controller.isYearly.value
                                                ? controller.purchaseService
                                                    .getYearlySubscriptionId()
                                                : controller.purchaseService
                                                    .getMonthlySubscriptionId(),
                                          ),
                                          isPrimary:
                                              controller.isIndependent.value,
                                          onTap: () =>
                                              controller.togglePlanType(true),
                                          features:
                                              tr(LanguageKeys.UniqueAccess),
                                          features2: tr(LanguageKeys.VatTxt),
                                          isCurrentPlan: (controller
                                                  .isYearly.value
                                              ? (controller.productId.value ==
                                                      InAppPurchaseService
                                                          .androidYearlySubscription ||
                                                  controller.productId.value ==
                                                      InAppPurchaseService
                                                          .iosYearlySubscription)
                                              : (controller.productId.value ==
                                                      InAppPurchaseService
                                                          .androidMonthlySubscription ||
                                                  controller.productId.value ==
                                                      InAppPurchaseService
                                                          .iosMonthlySubscription)),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildPlanCard(
                                          title: tr(LanguageKeys.AgencyPremium),
                                          price: _getProductPrice(
                                            controller.isYearly.value
                                                ? controller.purchaseService
                                                    .getYearlyAgencySubscriptionId()
                                                : controller.purchaseService
                                                    .getMonthlyAgencySubscriptionId(),
                                          ),
                                          isPrimary:
                                              !controller.isIndependent.value,
                                          onTap: () =>
                                              controller.togglePlanType(false),
                                          features2: tr(LanguageKeys.VatTxt),
                                          features: tr(
                                              LanguageKeys.upTo10TeamAccesses),
                                          isCurrentPlan: (controller
                                                  .isYearly.value
                                              ? (controller.productId.value ==
                                                      InAppPurchaseService
                                                          .androidYearlyAgencySubscription ||
                                                  controller.productId.value ==
                                                      InAppPurchaseService
                                                          .iosYearlyAgenySubscription)
                                              : (controller.productId.value ==
                                                      InAppPurchaseService
                                                          .androidMonthlyAgencySubscription ||
                                                  controller.productId.value ==
                                                      InAppPurchaseService
                                                          .iosMonthlyAgenySubscription)),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 24),
                                _buildSubscriptionButton(),
                                const SizedBox(height: 14),
                                if (AppPreference.readString(
                                        AppPreference.isPaid) !=
                                    "0")
                                  _buildCancelSubscriptionButton(),
                                const SizedBox(height: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: SizedBox(width: 24, height: 24, child: LogoLoader()),
                  );
          }),
          // Loader overlay for updateSubscription
          Obx(() => controller.purchaseService.isBuyLoading.value
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 40,
                            height: 40,
                            child: LogoLoader(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tr(LanguageKeys.UpdatingSubscription),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Obx(() {
      return controller.isYearly.value
          ? Column(
              children: [
                _buildInfoCard(
                  btnTitle: tr(LanguageKeys.NFCCardBUtton),
                  content: tr(LanguageKeys.RefferalyCard),
                  title: tr(LanguageKeys.ReferalyConnectedCard),
                  icon: AppAssets.imgCard,
                  ontap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const NfcCardVideoDialog(videoId: 'Ap8meXlseY8'),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildInfoCard(
                  btnTitle: tr(LanguageKeys.NFCCardBUtton),
                  content: tr(LanguageKeys.UnlimitedCoachingdesc),
                  title: tr(LanguageKeys.UnlimitedCoaching),
                  icon: AppAssets.imgGroup,
                  ontap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const NfcCardVideoDialog(videoId: 'fEK7ykU9u8Y'),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            )
          : const SizedBox();
    });
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Center(
          child: Text(
            tr(LanguageKeys.GetPremium),
            style: stylePoppins(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            tr(LanguageKeys.chooseBestPlan),
            style:
                stylePoppins(fontSize: 16, color: Colors.black.withAlpha(500)),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanToggleSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.circleBackgrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(() => Row(
            children: [
              _buildToggleButton(
                label: tr(LanguageKeys.TabYearly),
                offer: '-20%',
                isSelected: controller.isYearly.value,
                onTap: () => controller.togglePlan(true),
              ),
              _buildToggleButton(
                label: tr(LanguageKeys.Monthly),
                isSelected: !controller.isYearly.value,
                onTap: () => controller.togglePlan(false),
              ),
            ],
          )),
    );
  }

  Widget _buildToggleButton({
    required String label,
    String offer = '',
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: stylePoppins(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (offer.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadiusDirectional.circular(50)),
                  alignment: Alignment.center,
                  child: Text(
                    offer,
                    style: stylePoppins(fontSize: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String features,
    required bool isPrimary,
    required VoidCallback onTap,
    bool isCurrentPlan = false,
    required String features2,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: isPrimary
                  ? (isCurrentPlan == true
                      ? AppColors.primary.withAlpha(10)
                      : AppColors.primary)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isPrimary
                    ? (isCurrentPlan == true
                        ? AppColors.primary
                        : AppColors.primary.withAlpha(10))
                    : AppColors.grey200,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isPrimary
                        ? (isCurrentPlan == true
                            ? AppColors.blackColor
                            : AppColors.whiteColor)
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: stylePoppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isPrimary
                            ? (isCurrentPlan == true
                                ? AppColors.blackColor
                                : AppColors.whiteColor)
                            : AppColors.primary,
                      ),
                    ),
                    Text(
                      controller.isYearly.value
                          ? ' / ${tr(LanguageKeys.TabYearly)}'
                          : ' / ${tr(LanguageKeys.Monthly)}',
                      style: stylePoppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isPrimary
                            ? (isCurrentPlan == true
                                ? AppColors.blackColor
                                : AppColors.whiteColor)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        features2,
                        style: stylePoppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isPrimary
                              ? (isCurrentPlan == true
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor)
                              : AppColors.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.imgCheckGreen,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        features,
                        style: stylePoppins(
                          fontSize: 14,
                          color: isPrimary
                              ? (isCurrentPlan == true
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor)
                              : AppColors.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrentPlan)
            Positioned(
              top: -18,
              left: 24,
              right: 24,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    tr(LanguageKeys.YourCurrentPlan),
                    style: stylePoppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionButton() {
    return InkWell(
      onTap: () {
        controller.purchaseSubscription();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppPreference.readString(AppPreference.isPaid) == "0"
                    ? SvgPicture.asset(AppAssets.imgPrimum,
                        height: 24, color: Colors.white)
                    : Image.asset(
                        AppAssets.imgUpdateSubscription,
                        height: 24,
                        color: Colors.white,
                      ),
                const SizedBox(width: 8),
                Text(
                  AppPreference.readString(AppPreference.isPaid) == "0"
                      ? tr(LanguageKeys.BuySubscription)
                      : tr(LanguageKeys.UpgradePlan),
                  style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelSubscriptionButton() {
    return InkWell(
      onTap: () {
        controller.openManageSubscription();
      },
      child: Center(
        child: Text(tr(LanguageKeys.CancelPlan),
            style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
      ),
    );
  }

  Widget _buildInfoCard({
    required String icon,
    required String title,
    required String content,
    required String btnTitle,
    required VoidCallback ontap,
  }) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, height: 22, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style:
                      stylePoppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              /// Gift icon
              Center(
                child: SvgPicture.asset(
                  AppAssets.imgCc,
                  height: 35,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style:
                stylePoppins(fontSize: 16, color: Colors.black.withAlpha(200)),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: ontap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.imgPlay,
                      height: 16, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    btnTitle,
                    style: stylePoppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static String _getCurrencyCodeFromLocale(Locale locale) {
    switch (locale.countryCode) {
      case 'IN':
        return 'INR';
      case 'US':
        return 'USD';
      case 'GB':
        return 'GBP';
      case 'DE':
        return 'EUR';
      case 'FR':
        return 'EUR';
      case 'JP':
        return 'JPY';
      case 'AE':
        return 'AED';
      case 'CA':
        return 'CAD';
      case 'AU':
        return 'AUD';
      default:
        return 'USD'; // Fallback
    }
  }

  String _getProductPrice(String productId) {
    // if (!_isProductsLoaded.value) {
    //   return '...';
    // }
    // 👇 Get device locale and map to currency code
    final locale = PlatformDispatcher.instance.locale; // or use your context
    final currencyCode = _getCurrencyCodeFromLocale(locale);
    debugPrint('currencyCode: $currencyCode');
    debugPrint('currencyCode: $locale');
    // 👇 Set the current currency code
    // Get the product details from the in-app purchase service
    final products = controller.purchaseService.getProducts();
    debugPrint('Looking for product ID: $productId');
    debugPrint('Available products:');
    for (var product in products) {
      debugPrint('Product ID: ${product.id}, Price: ${product.price}');
    }

    try {
      final product = products.firstWhere(
        (element) => element.id == productId,
      );
      debugPrint('Found product: ${product.id} with price: ${product.price}');

      // Clean the price string by removing currency symbol and commas
      final cleanPrice = product.price
          .replaceAll(RegExp(r'[^\d.]'),
              '') // Remove everything except digits and decimal point
          .trim();
      // Get the current device locale
      debugPrint('Cleaned price: $cleanPrice');
      return product.price;
    } catch (e) {
      debugPrint('Product not found: $productId');
      debugPrint('Error: $e');
      return '...';
    }
  }
}
