import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadWonPaymentController extends GetxController {
  final RxString appBarTitle = 'ReferralHub'.obs;
  final RxString leadName = ''.obs;
  final RxString leadService = ''.obs;
  final RxString dealValue = ''.obs;
  final RxString leadDetails = ''.obs;
  final RxString originalReferrerName = ''.obs;
  final RxString chainMiddleName = ''.obs;
  final RxString chainBottomName = ''.obs;
  final RxString commissionDealValue = ''.obs;
  final RxString commissionMiddleAmount = ''.obs;
  final RxString commissionOriginalAmount = ''.obs;
  final RxString level2CommissionPercentage = ''.obs;
  final RxString originalReferrerCommission = ''.obs;
  final RxString currencySymbol = ''.obs;
  final RxString referrerRole = ''.obs;
  final RxString referrerAvatarUrl = ''.obs;
  final RxInt leadId = 0.obs;
  final RxString paymentRecipient = ''.obs;
  final RxString paymentAmount = ''.obs;
  final RxString paymentReason = ''.obs;

  VoidCallback? onPayViaReferaly;
  VoidCallback? onPayOutsideApp;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) return;

    appBarTitle.value = (args['appBarTitle'] as String?) ?? appBarTitle.value;
    leadName.value = (args['leadName'] as String?) ?? leadName.value;
    leadService.value = (args['leadService'] as String?) ?? leadService.value;
    dealValue.value = (args['dealValue'] as String?) ?? dealValue.value;
    leadDetails.value = (args['leadDetails'] as String?) ?? leadDetails.value;
    originalReferrerName.value =
        (args['originalReferrerName'] as String?) ?? originalReferrerName.value;
    chainMiddleName.value = (args['chainMiddleName'] as String?) ?? chainMiddleName.value;
    chainBottomName.value = (args['chainBottomName'] as String?) ?? chainBottomName.value;
    commissionDealValue.value =
        (args['commissionDealValue'] as String?) ?? commissionDealValue.value;
    commissionMiddleAmount.value =
        (args['commissionMiddleAmount'] as String?) ?? commissionMiddleAmount.value;
    commissionOriginalAmount.value =
        (args['commissionOriginalAmount'] as String?) ?? commissionOriginalAmount.value;
    level2CommissionPercentage.value =
        (args['level2CommissionPercentage'] as String?) ?? level2CommissionPercentage.value;
    originalReferrerCommission.value =
        (args['originalReferrerCommission'] as String?) ?? originalReferrerCommission.value;
    currencySymbol.value = (args['currencySymbol'] as String?) ?? currencySymbol.value;
    referrerRole.value = (args['referrerRole'] as String?) ?? referrerRole.value;
    referrerAvatarUrl.value = (args['referrerAvatarUrl'] as String?) ?? referrerAvatarUrl.value;
    leadId.value = (args['leadId'] as int?) ?? leadId.value;
    paymentRecipient.value = (args['paymentRecipient'] as String?) ?? paymentRecipient.value;
    paymentAmount.value = (args['paymentAmount'] as String?) ?? paymentAmount.value;
    paymentReason.value = (args['paymentReason'] as String?) ?? paymentReason.value;
    onPayViaReferaly = args['onPayViaReferaly'] as VoidCallback?;
    onPayOutsideApp = args['onPayOutsideApp'] as VoidCallback?;
  }
}
