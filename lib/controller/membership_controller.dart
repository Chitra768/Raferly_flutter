import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/in_app_purchase_service.dart';

class MembershipController extends GetxController {
  final InAppPurchaseService _purchaseService = InAppPurchaseService();
  final RxBool isLoading = false.obs;
  final RxBool isYearly = false.obs;
  final RxBool isIndependent = true.obs;

  void togglePlan(bool data) => isYearly.value = data;

  void togglePlanType(bool data) => isIndependent.value = data;
  @override
  void onInit() {
    super.onInit();
    _initializePurchaseService();
  }

  Future<void> _initializePurchaseService() async {
    isLoading.value = true;
    try {
      await _purchaseService.initialize();
    } catch (e) {
      debugPrint('Error initializing purchase service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSubscriptionType() {
    isYearly.value = !isYearly.value;
  }

  Future<void> purchaseSubscription() async {
    isLoading.value = true;
    try {
      final productId = isYearly.value
          ? _purchaseService.getYearlySubscriptionId()
          : _purchaseService.getMonthlySubscriptionId();
      await _purchaseService.buySubscription(productId);
    } catch (e) {
      debugPrint('Error purchasing subscription: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _purchaseService.dispose();
    super.onClose();
  }
}
