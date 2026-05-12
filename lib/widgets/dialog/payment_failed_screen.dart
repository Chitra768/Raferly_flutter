import 'package:flutter/material.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class PaymentFailedScreen extends StatelessWidget {
  final String totalAmount;
  final String currencySymbol;
  final String? paymentMethod;
  final String? cardBrand;
  final DateTime? transactionDate;
  final String? errorMessage;
  final VoidCallback? onTryDifferentPayment;
  final VoidCallback? onBackToDashboard;

  const PaymentFailedScreen({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    this.paymentMethod,
    this.cardBrand,
    this.transactionDate,
    this.errorMessage,
    this.onTryDifferentPayment,
    this.onBackToDashboard,
  });

  String _formatDate(DateTime? date) {
    final dateToFormat = date ?? DateTime.now();

    // Manual formatting to avoid locale initialization issues
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final month = months[dateToFormat.month - 1];
    final day = dateToFormat.day;
    final year = dateToFormat.year;

    // Format time
    int hour = dateToFormat.hour;
    final minute = dateToFormat.minute;
    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) {
      hour = hour - 12;
    } else if (hour == 0) {
      hour = 12;
    }

    final minuteStr = minute.toString().padLeft(2, '0');

    return '$month $day, $year $hour:$minuteStr $period';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(transactionDate);
    final displayPaymentMethod = paymentMethod ?? tr(LanguageKeys.card);
    final hasReason = (errorMessage ?? '').trim().isNotEmpty;
    final reasonTitle = hasReason
        ? tr(LanguageKeys.paymentDeclined)
        : tr(LanguageKeys.insufficientFunds);
    final reasonBody = hasReason
        ? errorMessage!.trim()
        : tr(LanguageKeys.insufficientFundsDescription);

    return Scaffold(
      backgroundColor: AppColors.whiteColor, // Light pink background
      body: SafeArea(
        child: Container(
          color: AppColors.primaryLightPink,
          child: Column(
            children: [
              // White Header Section
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  tr(LanguageKeys.paymentFailed),
                  style: stylePoppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.detailsTextColor,
                  ),
                ),
              ),

              // Main Content Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Error Icon Section - Large red circle with white X
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE53935), // Red
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Transaction Denied Text
                      Text(
                        tr(LanguageKeys.transactionDenied),
                        style: stylePoppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.detailsTextColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        tr(LanguageKeys.paymentFailedDescription),
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.detailsTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Transaction Details Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: const Border(
                            left: BorderSide(
                              color: Color(0xFFE53935), // Red left border
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Transaction Details Title
                            Text(
                              tr(LanguageKeys.transactionDetails),
                              style: stylePoppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.detailsTextColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Amount Attempted
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr(LanguageKeys.amountAttempted),
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.detailsTextColor,
                                  ),
                                ),
                                Text(
                                  '$currencySymbol$totalAmount',
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.detailsTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Payment Method
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    tr(LanguageKeys.paymentMethod),
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.detailsTextColor,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          displayPaymentMethod,
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.detailsTextColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _CardBrandPill(brand: cardBrand),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Date & Time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tr(LanguageKeys.dateAndTime),
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.detailsTextColor,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.detailsTextColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Status - Pill-shaped badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${tr(LanguageKeys.status)}:',
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.detailsTextColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE53935)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFE53935),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    tr(LanguageKeys.declined),
                                    style: stylePoppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFE53935), // Red
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Reason for Decline Section
                            Text(
                              tr(LanguageKeys.reasonForDecline),
                              style: stylePoppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.detailsTextColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.error_sharp,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          reasonTitle,
                                          style: stylePoppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.Darkorange,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          reasonBody,
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(
                                                0xFFC62828), // Dark red
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // What you can do next Section
                            Text(
                              tr(LanguageKeys.whatYouCanDoNext),
                              style: stylePoppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.detailsTextColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Use Different Payment Method
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.grey300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withOpacity(0.1),
                                    ),
                                    child: const Icon(
                                      Icons.credit_card,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr(LanguageKeys
                                              .useDifferentPaymentMethod),
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.detailsTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tr(LanguageKeys
                                              .useDifferentPaymentMethodDescription),
                                          style: stylePoppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Add Funds to Account
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.grey300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withOpacity(0.1),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr(LanguageKeys.addFundsToAccount),
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.detailsTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tr(LanguageKeys
                                              .addFundsToAccountDescription),
                                          style: stylePoppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Contact Support
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.grey300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary.withOpacity(0.1),
                                    ),
                                    child: const Icon(
                                      Icons.headset_mic,
                                      color: AppColors.primary,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr(LanguageKeys.contactSupport),
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.detailsTextColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tr(LanguageKeys
                                              .contactSupportDescription),
                                          style: stylePoppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Try Different Payment Method Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: onTryDifferentPayment,
                                child: Text(
                                  tr(LanguageKeys.tryDifferentPaymentMethod),
                                  style: stylePoppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Back to Dashboard Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFF3F4F6), // Light gray
                                  foregroundColor: AppColors.detailsTextColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: onBackToDashboard,
                                child: Text(
                                  tr(LanguageKeys.backToDashboard),
                                  style: stylePoppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.detailsTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small pill that mirrors the card brand returned by Stripe (e.g. visa,
/// mastercard, amex, discover, jcb). Renders nothing for unknown brands so we
/// never claim the user paid with a card type they did not use.
class _CardBrandPill extends StatelessWidget {
  final String? brand;

  const _CardBrandPill({this.brand});

  @override
  Widget build(BuildContext context) {
    final spec = _brandSpec(brand);
    if (spec == null) return const SizedBox.shrink();

    return Container(
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: spec.color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          spec.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static _BrandSpec? _brandSpec(String? raw) {
    final normalized = (raw ?? '').toLowerCase().trim();
    switch (normalized) {
      case 'visa':
        return const _BrandSpec('VISA', Color(0xFF1434CB));
      case 'mastercard':
      case 'master_card':
      case 'master-card':
        return const _BrandSpec('MC', Color(0xFFEB001B));
      case 'amex':
      case 'american_express':
      case 'american express':
        return const _BrandSpec('AMEX', Color(0xFF2E77BB));
      case 'discover':
        return const _BrandSpec('DISC', Color(0xFFFF6000));
      case 'jcb':
        return const _BrandSpec('JCB', Color(0xFF003B82));
      case 'diners':
      case 'diners_club':
        return const _BrandSpec('DC', Color(0xFF0079BE));
      case 'unionpay':
      case 'union_pay':
        return const _BrandSpec('UP', Color(0xFFE21836));
      default:
        return null;
    }
  }
}

class _BrandSpec {
  final String label;
  final Color color;
  const _BrandSpec(this.label, this.color);
}
