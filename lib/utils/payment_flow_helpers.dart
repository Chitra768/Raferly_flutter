import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_log.dart';

/// Helpers for the lead-won payment confirmation flow.
///
/// Wraps the `lead/confirmpaymentmethod` API call with the loader / error UX
/// so both the [CommissionPaymentPopup] (single-level lead won) and the
/// [LeadWonPaymentScreen] (multi-level lead won) share identical behaviour
/// without duplicating orchestration code.
class PaymentFlowHelpers {
  PaymentFlowHelpers._();

  /// Confirm the user paid the commission outside Referaly.
  ///
  /// Shows a non-dismissible loader while the API runs, returns `true` when
  /// the backend reports success, otherwise surfaces the failure message via
  /// a snackbar and returns `false` so the caller can keep the current
  /// payment dialog open for retry.
  static Future<bool> confirmOutsideReferalyPayment({
    required int? leadId,
  }) async {
    if (leadId == null || leadId <= 0) {
      _showError('Missing lead id. Please reopen and try again.');
      return false;
    }

    _showLoader();

    try {
      final response = await RESTAuth.confirmPaymentMethod(
        leadId: leadId,
        paymentType: 0,
        paymentCompleted: 0,
      );

      _dismissLoader();

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          return true;
        }
        _showError(response.data.message ?? 'Failed to confirm payment method');
        return false;
      }

      if (response is ApiFailure) {
        _showError(response.error.message ?? 'Failed to confirm payment method');
        return false;
      }

      _showError('Failed to confirm payment method');
      return false;
    } catch (e) {
      _dismissLoader();
      AppLog.e('confirmOutsideReferalyPayment error: $e');
      _showError('An error occurred: ${e.toString()}');
      return false;
    }
  }

  static void _showLoader() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black45,
    );
  }

  static void _dismissLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }
}
