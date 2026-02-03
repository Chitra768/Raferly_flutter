import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String referrerName;
  final String commissionAmount;
  final String processingFee;
  final String totalAmount;
  final String currencySymbol;
  final String? transactionId;
  final DateTime? transactionDate;
  final String? paymentMethod;
  final VoidCallback? onDownloadReceipt;
  final VoidCallback? onBackToDashboard;
  final VoidCallback? onResendEmail;

  const PaymentConfirmationScreen({
    super.key,
    required this.referrerName,
    required this.commissionAmount,
    required this.processingFee,
    required this.totalAmount,
    required this.currencySymbol,
    this.transactionId,
    this.transactionDate,
    this.paymentMethod,
    this.onDownloadReceipt,
    this.onBackToDashboard,
    this.onResendEmail,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
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

    return '$month $day, $year at $hour:$minuteStr $period';
  }

  void _copyTransactionId(BuildContext context) {
    if (widget.transactionId != null) {
      Clipboard.setData(ClipboardData(text: widget.transactionId!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction ID copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(widget.transactionDate);
    final displayTransactionId =
        widget.transactionId ?? '#TXN-${DateTime.now().millisecondsSinceEpoch}';
    final displayPaymentMethod = widget.paymentMethod ?? 'VISA •••• 4532';

    return Scaffold(
      backgroundColor: const Color(0xFFDCFCE7),
      // Light green background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.paymentConfirmation),
          style: stylePoppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Green Header Section
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Checkmark Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF66BB6A).withOpacity(0.25),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF66BB6A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Payment Successful Text
                    Text(
                      tr(LanguageKeys.paymentSuccessful),
                      style: stylePoppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      tr(LanguageKeys.paymentSuccessfulDescription),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.95),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment Summary Section
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                tr(LanguageKeys.paymentSummary),
                                style: stylePoppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            label: tr(LanguageKeys.paidTo),
                            value: widget.referrerName,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            label: '${tr(LanguageKeys.commissionAmount)}:',
                            value:
                                '${widget.currencySymbol}${widget.commissionAmount}',
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            label: tr(LanguageKeys.processingFeeWithPercent),
                            value:
                                '${widget.currencySymbol}${widget.processingFee}',
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 24),
                          _buildSummaryRow(
                            label: tr(LanguageKeys.totalPaid),
                            value:
                                '${widget.currencySymbol}${widget.totalAmount}',
                            isBold: true,
                            valueColor: const Color(0xFF4CAF50),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Transaction Details Section
                          Text(
                            tr(LanguageKeys.transactionDetails),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Transaction ID with copy
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow(
                                  label: tr(LanguageKeys.transactionId),
                                  value: displayTransactionId,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _copyTransactionId(context),
                                child: const Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            label: tr(LanguageKeys.dateAndTime),
                            value: formattedDate,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow(
                                  label: tr(LanguageKeys.paymentMethod),
                                  value: displayPaymentMethod,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1434CB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    'VISA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${tr(LanguageKeys.status)}: ${tr(LanguageKeys.completed)}',
                                style: stylePoppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Confirmation Sent Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLightPink,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.notifications_active,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LanguageKeys.paymentConfirmationSent),
                                  style: stylePoppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tr(LanguageKeys
                                      .paymentConfirmationSentDescription),
                                  style: stylePoppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: widget.onResendEmail,
                                  child: Text(
                                    '${tr(LanguageKeys.resendEmail)} →',
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
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
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // What's Next? Section
                          Text(
                            tr(LanguageKeys.whatsNext),
                            style: stylePoppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildNextStepItem(
                            icon: Icons.access_time_filled_outlined,
                            title: tr(LanguageKeys.processingTime),
                            description:
                                tr(LanguageKeys.processingTimeDescription),
                          ),
                          const SizedBox(height: 10),
                          _buildNextStepItem(
                            icon: Icons.email_rounded,
                            title: tr(LanguageKeys.notification),
                            description:
                                tr(LanguageKeys.notificationDescription)
                                    .replaceAll(
                                        '{referrer}', widget.referrerName),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Buttons Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Download Receipt Button
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
                              onPressed: widget.onDownloadReceipt,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.imgDownload,
                                    color: Colors.white,
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    tr(LanguageKeys.downloadReceipt),
                                    style: stylePoppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Back to Dashboard Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightColor,
                                foregroundColor: const Color(0xFF374151),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: widget.onBackToDashboard,
                              child: Text(
                                tr(LanguageKeys.backToDashboard),
                                style: stylePoppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: stylePoppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: stylePoppins(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.detailsTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: stylePoppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: stylePoppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.detailsTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.detailsTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
    );
  }
}
