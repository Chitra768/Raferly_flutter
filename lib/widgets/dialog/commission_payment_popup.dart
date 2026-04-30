import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:referaly/widgets/dialog/payment_confirmation_screen.dart';
import 'package:referaly/widgets/dialog/payment_failed_screen.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/apis/api_path.dart';
import 'package:referaly/apis/base_api.dart';

class CommissionPaymentPopup extends StatefulWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onClose;
  final String? commissionAmount;
  final String? currencySymbol;
  final String? referrerName;
  final String? referrerRole;
  final String? referrerAvatarUrl;
  final int? leadId;

  const CommissionPaymentPopup({
    super.key,
    this.onConfirm,
    this.onClose,
    this.commissionAmount,
    this.currencySymbol,
    this.referrerName,
    this.referrerRole,
    this.referrerAvatarUrl,
    this.leadId,
  });

  @override
  State<CommissionPaymentPopup> createState() => _CommissionPaymentPopupState();
}

class _CommissionPaymentPopupState extends State<CommissionPaymentPopup> {
  String? _selectedPaymentMethod; // 'via_referaly' or 'outside_referaly'

  @override
  void initState() {
    super.initState();
    // Default to "Outside Referaly" as shown in the image
    _selectedPaymentMethod = 'outside_referaly';
  }

  void _handleConfirm() {
    if (_selectedPaymentMethod != null) {
      if (_selectedPaymentMethod == 'outside_referaly') {
        // Show Important Information popup on top of current dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => ImportantInformationPopup(
            onConfirm: () {
              // Close both dialogs
              Navigator.of(dialogContext)
                  .pop(); // Close Important Information popup
              Navigator.of(context).pop(); // Close Commission Payment popup
              widget.onConfirm?.call();
            },
            onGoBack: () {
              // Just close the Important Information popup, keep Commission Payment popup open
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      } else if (_selectedPaymentMethod == 'via_referaly') {
        // Navigate to Via Referaly Payment Screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViaReferalyPaymentScreen(
              commissionAmount: widget.commissionAmount ?? '0',
              currencySymbol: widget.currencySymbol ?? '€',
              referrerName: widget.referrerName ?? 'Mike Spencer',
              referrerRole:
                  widget.referrerRole ?? tr(LanguageKeys.businessReferrer),
              referrerAvatarUrl: widget.referrerAvatarUrl,
              leadId: widget.leadId,
              onConfirm: () {
                // Close Payment Screen and Commission Payment popup
                Navigator.of(context).pop(); // Close Payment Screen
                Navigator.of(context).pop(); // Close Commission Payment popup
                widget.onConfirm?.call();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 720),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Purple Header Section
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF963ADD), Color(0xFF7A2BD7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Handshake Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: SvgPicture.asset(
                              AppAssets.imgHandshake,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title
                          Text(
                            tr(LanguageKeys.commissionPayment),
                            style: stylePoppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Subtitle
                          Text(
                            tr(LanguageKeys.requiredToCompleteDeal),
                            style: stylePoppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Close Button
                    Positioned(
                      right: 6,
                      top: 6,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onClose?.call();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(top: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Instruction
                      Text(
                        tr(LanguageKeys.chooseHowToPayCommission),
                        style: stylePoppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.detailsTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Payment Option 1: Via Referaly
                      _PaymentOptionCard(
                        title: tr(LanguageKeys.viaReferaly),
                        description: tr(LanguageKeys.weHandleInvoicing),
                        fee: tr(LanguageKeys.fivePercentFee),
                        status: null,
                        isAvailable: true,
                        isSelected: _selectedPaymentMethod == 'via_referaly',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'via_referaly';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Payment Option 2: Outside Referaly
                      _PaymentOptionCard(
                        title: tr(LanguageKeys.outsideReferaly),
                        description: tr(LanguageKeys.payDirectlyToReferrer),
                        fee: tr(LanguageKeys.free),
                        isAvailable: true,
                        isSelected:
                            _selectedPaymentMethod == 'outside_referaly',
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = 'outside_referaly';
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Important Note
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF90CAF9),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF2196F3),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tr(LanguageKeys.commissionPaymentRequiredNote),
                                style: stylePoppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _handleConfirm,
                          child: Text(
                            tr(LanguageKeys.confirmPaymentMethod),
                            style: stylePoppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Go Back Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5F5F5),
                            foregroundColor: const Color(0xFF666666),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tr(LanguageKeys.goBack),
                                style: stylePoppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String fee;
  final String? status;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.description,
    required this.fee,
    this.status,
    required this.isAvailable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isAvailable ? 1.0 : 0.6,
      child: GestureDetector(
        onTap: isAvailable ? onTap : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: stylePoppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.detailsTextColor,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                description,
                style: stylePoppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 12),
              // Fee and Status - Column layout for Via Referaly
              if (status != null) ...[
                // Fee badge (pill-shaped)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.percent,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        fee,
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Status badge (pill-shaped)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFFFF9800),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time_filled_sharp,
                        size: 14,
                        color: Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status!,
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Outside Referaly: Show only free with checkmark
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        fee,
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ImportantInformationPopup extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onGoBack;

  const ImportantInformationPopup({
    this.onConfirm,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 720),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Purple Header Section
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF963ADD), Color(0xFF7A2BD7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Info Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Main Title - Payment Outside Referaly
                          Text(
                            tr(LanguageKeys.paymentOutsideReferaly),
                            style: stylePoppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Subtitle - Important Information
                          Text(
                            tr(LanguageKeys.importantInformation),
                            style: stylePoppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // Close Button
                    Positioned(
                      right: 6,
                      top: 6,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(top: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Referrer Notification
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          border: Border.all(
                            color: const Color(0xFFBFDBFE),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.notifications_active,
                              color: Color(0xFF2563EB),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LanguageKeys.referrerWillBeNotified),
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E40AF),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tr(LanguageKeys
                                        .referrerWillBeNotifiedDescription),
                                    style: stylePoppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF1D4ED8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Section 2: Prompt Payment
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppAssets.imgHandshake,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF963ADD),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LanguageKeys.payPromptlyToMaintainTrust),
                                    style: stylePoppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tr(LanguageKeys
                                        .payPromptlyToMaintainTrustDescription),
                                    style: stylePoppins(
                                      fontSize: 12,
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
                      // Section 3: Recommended Payment Time
                      Builder(
                        builder: (context) {
                          // Split the label text
                          final labelText =
                              tr(LanguageKeys.recommendedPaymentTime);
                          final labelParts = labelText.split(' ');
                          final labelLine1 =
                              labelParts.isNotEmpty ? labelParts[0] : '';
                          final labelLine2 = labelParts.length > 1
                              ? labelParts.sublist(1).join(' ')
                              : '';

                          // Split the value text
                          final valueText = tr(LanguageKeys.within24To48Hours);
                          final valueParts = valueText.split(' ');
                          final valueLine1 = valueParts.length > 1
                              ? valueParts
                                  .sublist(0, valueParts.length - 1)
                                  .join(' ')
                              : valueText;
                          final valueLine2 =
                              valueParts.length > 1 ? valueParts.last : '';

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column - Label
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        labelLine1,
                                        style: stylePoppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF666666),
                                        ),
                                      ),
                                      Text(
                                        labelLine2,
                                        style: stylePoppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Right column - Value
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      valueLine1,
                                      style: stylePoppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                    if (valueLine2.isNotEmpty)
                                      Text(
                                        valueLine2,
                                        style: stylePoppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E293B),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // I Understand, Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: onConfirm,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tr(LanguageKeys.iUnderstandContinue),
                                style: stylePoppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Go Back Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF666666),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: onGoBack,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tr(LanguageKeys.goBack),
                                style: stylePoppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class ViaReferalyPaymentScreen extends StatefulWidget {
  final String commissionAmount;
  final String currencySymbol;
  final String referrerName;
  final String referrerRole;
  final String? referrerAvatarUrl;
  final int? leadId;
  final VoidCallback? onConfirm;

  const ViaReferalyPaymentScreen({
    required this.commissionAmount,
    required this.currencySymbol,
    required this.referrerName,
    required this.referrerRole,
    this.referrerAvatarUrl,
    this.leadId,
    this.onConfirm,
  });

  @override
  State<ViaReferalyPaymentScreen> createState() =>
      _ViaReferalyPaymentScreenState();
}

class _ViaReferalyPaymentScreenState extends State<ViaReferalyPaymentScreen> {
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    // Stripe is already initialized in main.dart, no need to initialize again
  }

  double _parseAmount(String value) {
    if (value.isEmpty) return 0;
    final sanitized =
        value.replaceAll(',', '.').replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(sanitized) ?? 0;
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      symbol: widget.currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  Future<void> _handlePayment() async {
    if (_isProcessingPayment) return;

    AppLog.d(
      '[ViaReferalyPayment] start'
      ' leadId=${widget.leadId}'
      ' commissionAmount="${widget.commissionAmount}"'
      ' currencySymbol="${widget.currencySymbol}"'
      ' referrerName="${widget.referrerName}"',
      tag: 'Stripe',
    );

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final commission = _parseAmount(widget.commissionAmount);
      final processingFee = commission * 0.05; // 5% processing fee
      final totalAmount = commission + processingFee;

      AppLog.d(
        '[ViaReferalyPayment] parsed amounts'
        ' commission=$commission'
        ' processingFee=$processingFee'
        ' total=$totalAmount',
        tag: 'Stripe',
      );

      // Create payment intent on backend
      final paymentIntentResponse = await _createPaymentIntent(
        leadId: widget.leadId,
      );

      AppLog.d(
        '[ViaReferalyPayment] createIntent response=${paymentIntentResponse == null ? "null" : jsonEncode(paymentIntentResponse)}',
        tag: 'Stripe',
      );

      if (paymentIntentResponse == null) {
        throw Exception('Failed to create payment intent');
      }

      // Extract client_secret and payment_intent_id from backend response
      final clientSecret =
          paymentIntentResponse['data']['client_secret'] as String;
      final paymentIntentId =
          paymentIntentResponse['data']['payment_intent_id'] as String;

      AppLog.d(
        '[ViaReferalyPayment] got intent'
        ' paymentIntentId=$paymentIntentId'
        ' clientSecretPrefix=${clientSecret.length >= 12 ? clientSecret.substring(0, 12) : clientSecret}',
        tag: 'Stripe',
      );

      // Initialize payment sheet
      AppLog.d('[ViaReferalyPayment] initPaymentSheet()', tag: 'Stripe');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Referaly',
          style: ThemeMode.system,
        ),
      );

      // Present payment sheet
      AppLog.d('[ViaReferalyPayment] presentPaymentSheet()', tag: 'Stripe');
      await Stripe.instance.presentPaymentSheet();
      AppLog.d('[ViaReferalyPayment] presentPaymentSheet() success', tag: 'Stripe');

      // Payment successful - Verify payment with backend
      debugPrint('');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('✅ ✅ ✅ PAYMENT SUCCESSFUL IN STRIPE ✅ ✅ ✅');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('📋 Verifying payment with backend...');

      // Verify payment with backend
      final verifyResponse =
          await _verifyPayment(paymentIntentId: paymentIntentId);

      AppLog.d(
        '[ViaReferalyPayment] verify response=${verifyResponse == null ? "null" : jsonEncode(verifyResponse)}',
        tag: 'Stripe',
      );

      if (verifyResponse == null || verifyResponse['status'] != true) {
        throw Exception(
            'Failed to verify payment: ${verifyResponse?['message'] ?? 'Unknown error'}');
      }

      debugPrint('✅ Payment verified successfully');
      debugPrint('   Payment Intent ID: $paymentIntentId');
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('');

      // Extract payment details from verify response if available
      String? paymentMethodDisplay = 'Card';
      DateTime? transactionDate = DateTime.now();

      // Try to get payment method details from verify response
      if (verifyResponse['data'] != null) {
        final data = verifyResponse['data'] as Map<String, dynamic>?;
        if (data != null) {
          // Extract payment method if available in response
          if (data['payment_method'] != null) {
            final pm = data['payment_method'] as Map<String, dynamic>?;
            if (pm != null && pm['card'] != null) {
              final card = pm['card'] as Map<String, dynamic>;
              final brand = (card['brand'] as String?)?.toUpperCase() ?? 'CARD';
              final last4 = card['last4'] as String? ?? '****';
              paymentMethodDisplay = '$brand •••• $last4';
            }
          }

          // Extract transaction date if available
          if (data['created'] != null) {
            transactionDate = DateTime.fromMillisecondsSinceEpoch(
              (data['created'] as int) * 1000,
            );
          }
        }
      }

      // Payment successful - Show confirmation screen
      if (mounted) {
        // Close payment screen and commission popup
        Navigator.of(context).pop(); // Close payment screen
        Navigator.of(context).pop(); // Close commission payment popup

        // Show payment confirmation screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentConfirmationScreen(
              referrerName: widget.referrerName,
              commissionAmount: _formatAmount(commission)
                  .replaceAll(widget.currencySymbol, '')
                  .trim(),
              processingFee: _formatAmount(processingFee)
                  .replaceAll(widget.currencySymbol, '')
                  .trim(),
              totalAmount: _formatAmount(totalAmount)
                  .replaceAll(widget.currencySymbol, '')
                  .trim(),
              currencySymbol: widget.currencySymbol,
              transactionId: paymentIntentId,
              transactionDate: transactionDate,
              paymentMethod: paymentMethodDisplay,
              onDownloadReceipt: () {
                // TODO: Implement download receipt functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Receipt download functionality coming soon'),
                  ),
                );
              },
              onBackToDashboard: () {
                Navigator.of(context).pop();
                widget.onConfirm?.call();
              },
              onResendEmail: () {
                // TODO: Implement resend email functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email resend functionality coming soon'),
                  ),
                );
              },
            ),
          ),
        );
      }
    } on StripeException catch (e) {
      AppLog.e(
        '[ViaReferalyPayment] StripeException'
        ' code=${e.error.code}'
        ' message=${e.error.message}'
        ' stack=${e.toString()}',
        tag: 'Stripe',
      );
      if (mounted) {
        final commission = _parseAmount(widget.commissionAmount);
        final processingFee = commission * 0.05;
        final totalAmount = commission + processingFee;

        // Close payment screen
        Navigator.of(context).pop();

        // Show payment failed screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentFailedScreen(
              totalAmount: _formatAmount(totalAmount)
                  .replaceAll(widget.currencySymbol, '')
                  .trim(),
              currencySymbol: widget.currencySymbol,
              // Keep old static fallback for reference (do not remove).
              // paymentMethod: 'VISA •••• 4532',
              paymentMethod: 'Card',
              transactionDate: DateTime.now(),
              errorMessage:
                  '${e.error.message ?? ''}${e.error.stripeErrorCode != null ? ' (stripeCode: ${e.error.stripeErrorCode})' : ''}',
              onTryDifferentPayment: () {
                // Go back to payment screen to retry
                Navigator.of(context).pop();
              },
              onBackToDashboard: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close commission payment popup
              },
            ),
          ),
        );
      }
    } catch (e) {
      AppLog.e('[ViaReferalyPayment] Exception: ${e.toString()}', tag: 'Stripe');
      if (mounted) {
        debugPrint('Payment error: ${e.toString()}');
        final commission = _parseAmount(widget.commissionAmount);
        final processingFee = commission * 0.05;
        final totalAmount = commission + processingFee;

        // Close payment screen
        Navigator.of(context).pop();

        // Show payment failed screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentFailedScreen(
              totalAmount: _formatAmount(totalAmount)
                  .replaceAll(widget.currencySymbol, '')
                  .trim(),
              currencySymbol: widget.currencySymbol,
              // Keep old static fallback for reference (do not remove).
              // paymentMethod: 'VISA •••• 4532',
              paymentMethod: 'Card',
              transactionDate: DateTime.now(),
              errorMessage: e.toString(),
              onTryDifferentPayment: () {
                // Go back to payment screen to retry
                Navigator.of(context).pop();
              },
              onBackToDashboard: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close commission payment popup
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent({
    required int? leadId,
  }) async {
    AppLog.d('[createIntent] request leadId=$leadId', tag: 'Stripe');
    try {
      if (leadId == null) {
        throw Exception('Lead ID is required to create payment intent');
      }

      // Call backend API to create payment intent
      // Using a helper class that extends BaseAPI functionality
      final helper = _ApiHelper();
      if (!(await helper.hasInternet() ?? false)) {
        throw Exception(tr(LanguageKeys.noInternetConnection));
      }

      final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.createPaymentIntent}');
      final headers = await helper.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';

      final requestBody = jsonEncode({
        'lead_id': leadId,
      });

      helper.apiLog('createPaymentIntent URL: $url');
      helper.apiLog('createPaymentIntent Body: $requestBody');

      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

      helper.apiLog('createPaymentIntent Response: ${response.statusCode}');
      helper.apiLog('createPaymentIntent Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResult = jsonDecode(response.body);
        AppLog.d('[createIntent] decoded=${jsonEncode(decodedResult)}', tag: 'Stripe');
        return decodedResult;
      } else {
        final decodedResult = jsonDecode(response.body);
        AppLog.e(
          '[createIntent] httpStatus=${response.statusCode} decoded=${jsonEncode(decodedResult)}',
          tag: 'Stripe',
        );
        throw Exception(
            decodedResult['message'] ?? 'Failed to create payment intent');
      }
    } catch (e) {
      AppLog.e('[createIntent] Exception: $e', tag: 'Stripe');
      debugPrint('Error creating payment intent: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _verifyPayment({
    required String paymentIntentId,
  }) async {
    AppLog.d('[verifyPayment] request intentId=$paymentIntentId', tag: 'Stripe');
    try {
      // Call backend API to verify payment
      final helper = _ApiHelper();
      if (!(await helper.hasInternet() ?? false)) {
        throw Exception(tr(LanguageKeys.noInternetConnection));
      }

      final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.verifyPayment}');
      final headers = await helper.getHeaderWithToken();
      headers['Content-Type'] = 'application/json';

      final requestBody = jsonEncode({
        'payment_intent_id': paymentIntentId,
      });

      helper.apiLog('verifyPayment URL: $url');
      helper.apiLog('verifyPayment Body: $requestBody');

      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

      helper.apiLog('verifyPayment Response: ${response.statusCode}');
      helper.apiLog('verifyPayment Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResult = jsonDecode(response.body);
        AppLog.d('[verifyPayment] decoded=${jsonEncode(decodedResult)}', tag: 'Stripe');
        return decodedResult;
      } else {
        final decodedResult = jsonDecode(response.body);
        AppLog.e(
          '[verifyPayment] httpStatus=${response.statusCode} decoded=${jsonEncode(decodedResult)}',
          tag: 'Stripe',
        );
        throw Exception(decodedResult['message'] ?? 'Failed to verify payment');
      }
    } catch (e) {
      AppLog.e('[verifyPayment] Exception: $e', tag: 'Stripe');
      debugPrint('Error verifying payment: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commission = _parseAmount(widget.commissionAmount);
    final processingFee = commission * 0.05; // 5% processing fee
    final totalAmount = commission + processingFee;

    return Scaffold(
      backgroundColor: AppColors.primaryLightPink, // Dark grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed:
              _isProcessingPayment ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.detailsTextColor),
        ),
        title: Text(
          tr(LanguageKeys.commissionPayment),
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.detailsTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  // Profile Picture
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: widget.referrerAvatarUrl != null &&
                            widget.referrerAvatarUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              widget.referrerAvatarUrl!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 32,
                          ),
                  ),
                  const SizedBox(width: 12),
                  // Name and Role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.referrerName,
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.detailsTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.referrerRole,
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
            const SizedBox(height: 20),
            // Commission Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LanguageKeys.commissionDetails),
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.detailsTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Commission Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr(LanguageKeys.commissionAmount),
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      Text(
                        _formatAmount(commission),
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.detailsTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Processing Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr(LanguageKeys.processingFeePercent),
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      Text(
                        _formatAmount(processingFee),
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.detailsTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Divider
                  const Divider(height: 24),
                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr(LanguageKeys.totalAmount),
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.detailsTextColor,
                        ),
                      ),
                      Text(
                        _formatAmount(totalAmount),
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Payment Method Card
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: AppColors.whiteColor,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Payment Method Title
            //       Text(
            //         tr(LanguageKeys.paymentMethod),
            //         style: stylePoppins(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //           color: AppColors.detailsTextColor,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       // Selected Payment Card Container (Light Purple Background)
            //       Container(
            //         width: double.infinity,
            //         padding: const EdgeInsets.all(16),
            //         decoration: BoxDecoration(
            //           color: AppColors.primary
            //               .withOpacity(0.01), // Light purple background
            //           borderRadius: BorderRadius.circular(12),
            //           border: Border.all(
            //             color: AppColors.primary.withOpacity(0.2),
            //             width: 1,
            //           ),
            //           boxShadow: [
            //             BoxShadow(
            //               color: AppColors.primary.withOpacity(0.1),
            //               blurRadius: 8,
            //               offset: const Offset(0, 2),
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           children: [
            //             // VISA Logo
            //             Container(
            //               width: 40,
            //               height: 24,
            //               decoration: BoxDecoration(
            //                 color: const Color(0xFF1434CB),
            //                 borderRadius: BorderRadius.circular(4),
            //               ),
            //               child: const Center(
            //                 child: Text(
            //                   'VISA',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 10,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(width: 12),
            //             // Card Details
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     '•••• •••• •••• 4532',
            //                     style: stylePoppins(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w500,
            //                       color: AppColors.detailsTextColor,
            //                     ),
            //                   ),
            //                   const SizedBox(height: 4),
            //                   Text(
            //                     '${tr(LanguageKeys.expires)} 12/26',
            //                     style: stylePoppins(
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.w400,
            //                       color: const Color(0xFF666666),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             // // Change Button
            //             // TextButton(
            //             //   onPressed: () {
            //             //     // Calculate total amount
            //             //     final commission =
            //             //         _parseAmount(widget.commissionAmount);
            //             //     final processingFee = commission * 0.05;
            //             //     final calculatedTotalAmount =
            //             //         commission + processingFee;

            //             //     Navigator.of(context).push(
            //             //       MaterialPageRoute(
            //             //         builder: (context) => PaymentDetailsForm(
            //             //           totalAmount:
            //             //               _formatAmount(calculatedTotalAmount),
            //             //           currencySymbol: widget.currencySymbol,
            //             //           onPaymentComplete: () {
            //             //             // Navigate back after payment completion
            //             //             Navigator.of(context).pop();
            //             //             // You can add additional logic here, like showing success message
            //             //           },
            //             //           onCancel: () {
            //             //             Navigator.of(context).pop();
            //             //           },
            //             //         ),
            //             //       ),
            //             //     );
            //             //   },
            //             //   style: TextButton.styleFrom(
            //             //     padding: EdgeInsets.zero,
            //             //     minimumSize: Size.zero,
            //             //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //             //   ),
            //             //   child: Text(
            //             //     tr(LanguageKeys.change),
            //             //     style: stylePoppins(
            //             //       fontSize: 14,
            //             //       fontWeight: FontWeight.w500,
            //             //       color: AppColors.primary,
            //             //     ),
            //             //   ),
            //             // ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
            // Secure Payment Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.security,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LanguageKeys.securePayment),
                          style: stylePoppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.detailsTextColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tr(LanguageKeys.securePaymentDescription),
                          style: stylePoppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProcessingPayment
                      ? AppColors.primary.withOpacity(0.6)
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isProcessingPayment ? null : _handlePayment,
                child: _isProcessingPayment
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        '${tr(LanguageKeys.pay)} ${_formatAmount(totalAmount)}',
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class to use BaseAPI functionality
class _ApiHelper with BaseAPI {
  // This class provides access to BaseAPI methods
}
