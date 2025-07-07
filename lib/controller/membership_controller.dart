import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/in_app_purchase_service.dart';

class MembershipController extends GetxController {
  final InAppPurchaseService purchaseService = InAppPurchaseService();
  final RxBool isYearly = true.obs;
  final RxBool isIndependent = true.obs;
  final RxString productId = ''.obs;
  final RxString amount = ''.obs;
  final RxString currency = ''.obs;
  final RxBool isProductsLoaded = false.obs;

  void togglePlan(bool data) => isYearly.value = data;

  void togglePlanType(bool data) => isIndependent.value = data;
  void resetProductsLoaded() => isProductsLoaded.value = false;

  // Method to refresh current plan status
  void refreshCurrentPlanStatus() {
    productId.value = AppPreference.readString(AppPreference.productId) ?? '';
    update(); // Trigger UI update
  }

  @override
  void onInit() {
    super.onInit();
    productId.value = AppPreference.readString(AppPreference.productId) ?? '';
    _initializePurchaseService();
  }

  Future<void> _initializePurchaseService() async {
    try {
      await purchaseService.initialize();
    } catch (e) {
      debugPrint('Error initializing purchase service: $e');
    } finally {}
  }

  void toggleSubscriptionType() {
    isYearly.value = !isYearly.value;
  }

  Future<void> purchaseSubscription() async {
    AppHelper.showLog("Independent : ${isIndependent.value}");
    try {
      final productId = isYearly.value
          ? (isIndependent.value == true
              ? purchaseService.getYearlySubscriptionId()
              : purchaseService.getYearlyAgencySubscriptionId())
          : (isIndependent.value == true
              ? purchaseService.getMonthlySubscriptionId()
              : purchaseService.getMonthlyAgencySubscriptionId());

      print('productId: $productId');
      amount.value = purchaseService.getAmountForProductId(productId);
      currency.value = purchaseService.getCurrencyForProductId(productId);
      await purchaseService.buySubscription(productId);
    } catch (e) {
      debugPrint('Error purchasing subscription: $e');
    } finally {}
  }

  void openManageSubscription() async {
    const url = 'https://play.google.com/store/account/subscriptions';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error if the URL can't be launched
      print('Could not launch $url');
    }
  }

  @override
  void onClose() {
    purchaseService.dispose();
    super.onClose();
  }
}
