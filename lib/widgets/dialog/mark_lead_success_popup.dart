import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/deals/lead_won_payment_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/commission_payment_popup.dart';

import '../../models/model_add_commission.dart';

class MarkLeadSuccessPopup extends StatefulWidget {
  final String currencySymbol;
  final void Function(String turnover, String commission, double netIncome, String messages) onSubmit;
  final VoidCallback? onClose;
  final int stepId;
  final int leadId;
  final String? initialRevenue;
  final String? initialCommission;
  final String? businessReferrerName;
  final String? referrerAvatarUrl;

  const MarkLeadSuccessPopup({
    super.key,
    required this.currencySymbol,
    required this.onSubmit,
    required this.stepId,
    required this.leadId,
    this.onClose,
    this.initialRevenue,
    this.initialCommission,
    this.businessReferrerName,
    this.referrerAvatarUrl,
  });

  @override
  State<MarkLeadSuccessPopup> createState() => _MarkLeadSuccessPopupState();
}

class _MarkLeadSuccessPopupState extends State<MarkLeadSuccessPopup> {
  final TextEditingController _turnoverController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  double _netIncome = 0.0;
  String? _errorText;
  bool _isLoading = false;

  late final NumberFormat _formatter;

  @override
  void initState() {
    super.initState();
    _formatter = NumberFormat.currency(
      symbol: widget.currencySymbol,
      decimalDigits: 2,
    );

    // Pre-fill controllers if initial values are provided
    if (widget.initialRevenue != null && widget.initialRevenue!.isNotEmpty) {
      _turnoverController.text = widget.initialRevenue!;
    }
    if (widget.initialCommission != null && widget.initialCommission!.isNotEmpty) {
      _commissionController.text = widget.initialCommission!;
    }

    _turnoverController.addListener(_recalculateNetIncome);
    _commissionController.addListener(_recalculateNetIncome);

    // Recalculate net income if initial values were set
    if (widget.initialRevenue != null || widget.initialCommission != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recalculateNetIncome();
      });
    }
  }

  @override
  void dispose() {
    _turnoverController
      ..removeListener(_recalculateNetIncome)
      ..dispose();
    _commissionController
      ..removeListener(_recalculateNetIncome)
      ..dispose();
    super.dispose();
  }

  void _recalculateNetIncome() {
    final turnover = _parseAmount(_turnoverController.text);
    final commission = _parseAmount(_commissionController.text);

    setState(() {
      _netIncome = turnover - commission;
      _errorText = null;
    });
  }

  double _parseAmount(String value) {
    if (value.isEmpty) return 0;
    final sanitized = value.replaceAll(',', '.');
    return double.tryParse(sanitized) ?? 0;
  }

  Future<void> _handleSubmit() async {
    // Validate that fields are not empty
    if (_turnoverController.text.trim().isEmpty || _commissionController.text.trim().isEmpty) {
      setState(() {
        _errorText = tr(LanguageKeys.pleaseEnterAmount);
      });
      return;
    }

    // Parse values
    final turnover = _parseAmount(_turnoverController.text.trim());
    final commission = _parseAmount(_commissionController.text.trim());
    final netIncome = turnover - commission;

    // Validate that revenue, commission, and turnover (netIncome) are not 0
    if (turnover == 0) {
      setState(() {
        _errorText = 'Revenue (Turnover) cannot be 0';
      });
      return;
    }

    if (commission == 0) {
      setState(() {
        _errorText = 'Commission cannot be 0';
      });
      return;
    }

    if (netIncome == 0) {
      setState(() {
        _errorText = 'Net Income (Turnover) cannot be 0';
      });
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      // Call API: revenue goes to revenue, commission goes to commission
      final response = await RESTAuth.addCommisionAmount(
        id: widget.stepId,
        amount: _commissionController.text.trim().replaceAll(',', ''),
        leadId: widget.leadId,
        revenue: turnover.toString().replaceAll(',', ''),
        name: "Payment received",
      );

      setState(() {
        _isLoading = false;
      });

      if (response is ApiSuccess<ModelAddCommission>) {
        if (response.data.status == true) {
          final commissionResponse = response.data.data;
          final deal = commissionResponse?.deal;
          final showLeadWonScreen = deal?.multiLevelReferral == '1' &&
              deal?.level2CommissionPercentage != null &&
              deal!.level2CommissionPercentage != 'null' &&
              deal.level2CommissionPercentage!.trim().isNotEmpty;
          final level2Details = commissionResponse?.level2details;

          AppLog.d(
              "Lead success popup closed Multilevel referral: ${response.data.data?.deal?.multiLevelReferral}");
          // Close the current popup
          Navigator.of(context).pop();
          if (showLeadWonScreen) {
            Future.microtask(() {
              Get.to(
                () => const LeadWonPaymentScreen(),
                arguments: {
                  'leadName': level2Details?.leadName ?? '',
                      // '${commissionResponse?.firstName ?? ''} ${commissionResponse?.lastName ?? ''}'
                      //     .trim(),
                  // 'leadService': commissionResponse?.description,
                  'dealValue': level2Details?.dealValue?.toString(),
                  'originalReferrerName': level2Details?.originalReferrer ?? '',
                  'chainMiddleName': level2Details?.firstLevelReferrer ?? '',
                  'chainBottomName':
                      (level2Details?.leadName ?? '')
                          .trim(),
                  'commissionDealValue': '${widget.currencySymbol}${level2Details?.dealValue ?? 0}',
                  'commissionMiddleAmount':
                      '${widget.currencySymbol}${level2Details?.firstLevelReferrerCommission ?? 0}',
                  'level2CommissionPercentage':
                      (level2Details?.level2CommissionPercentage ?? '').toString(),
                  'originalReferrerCommission':
                      '${widget.currencySymbol}${level2Details?.originalReferrerCommission ?? 0}',
                  'currencySymbol': widget.currencySymbol,
                  'referrerRole': tr(LanguageKeys.businessReferrer),
                  'referrerAvatarUrl': widget.referrerAvatarUrl,
                  'leadId': widget.leadId,
                  // Backward-compat: some UI pieces still read this key for the amount.
                  'commissionOriginalAmount':
                      '${widget.currencySymbol}${level2Details?.originalReferrerCommission ?? 0}',
                  'paymentRecipient': level2Details?.originalReferrer ?? '',
                  'paymentAmount':
                      '${widget.currencySymbol}${level2Details?.originalReferrerCommission ?? 0}',
                  'paymentReason': tr(LanguageKeys.commissions),
                  'onPayViaReferaly': () {
                    widget.onSubmit(
                      _turnoverController.text.trim(),
                      _commissionController.text.trim(),
                      netIncome,
                      response.data.message ?? '',
                    );
                  },
                  'onPayOutsideApp': () {
                    widget.onSubmit(
                      _turnoverController.text.trim(),
                      _commissionController.text.trim(),
                      netIncome,
                      response.data.message ?? '',
                    );
                  },
                },
              );
            });
          } else {
            // Open commission payment popup
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CommissionPaymentPopup(
                commissionAmount: _commissionController.text.trim(),
                currencySymbol: widget.currencySymbol,
                referrerName: widget.businessReferrerName ?? 'Business Referrer',
                referrerRole: tr(LanguageKeys.businessReferrer),
                referrerAvatarUrl: widget.referrerAvatarUrl,
                leadId: widget.leadId,
                onConfirm: () {
                  // Call the onSubmit callback after commission payment is confirmed
                  widget.onSubmit(
                    _turnoverController.text.trim(),
                    _commissionController.text.trim(),
                    netIncome,
                    response.data.message ?? '',
                  );
                },
                onClose: () {
                  // Still call onSubmit even if closed, as information was already submitted
                },
              ),
            );
          }
        } else {
          AppLog.d("Lead success popup closed Status false: ${response.data.message}");
          setState(() {
            _errorText = response.data.message ?? 'Something went wrong';
          });
        }
      } else if (response is ApiFailure) {
        AppLog.d("Lead success popup closed ApiFailure: ${response.error.message}");
        setState(() {
          _errorText = response.error.message ?? 'Failed to submit information';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = 'An error occurred: ${e.toString()}';
      });
      AppLog.d("Lead success popup closed Error: ${e.toString()}");
    }
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssets.imgInfoActivity,
              width: 18,
              height: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tr(LanguageKeys.privacyNoticeTurnover),
              style: stylePoppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ).copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
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
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tr(LanguageKeys.congratulationsLeadWon),
                            style: stylePoppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(LanguageKeys.successfulDealDescription),
                        style: stylePoppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.detailsTextColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 20),
                      _buildPrivacyNotice(),
                      const SizedBox(height: 16),
                      _AmountField(
                        label: tr(LanguageKeys.turnoverGenerated),
                        controller: _turnoverController,
                        currencySymbol: widget.currencySymbol,
                      ),
                      const SizedBox(height: 16),
                      _AmountField(
                        label: tr(LanguageKeys.commissionPaid),
                        controller: _commissionController,
                        currencySymbol: widget.currencySymbol,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                tr(LanguageKeys.netIncome),
                                style: stylePoppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.detailsTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _formatter.format(_netIncome),
                                style: stylePoppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorText!,
                          style: stylePoppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
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
                          onPressed: _isLoading ? null : _handleSubmit,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  tr(LanguageKeys.submitInformation),
                                  style: stylePoppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
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
                            widget.onClose?.call();
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
                      const SizedBox(height: 24),
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

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String currencySymbol;

  const _AmountField({
    required this.label,
    required this.controller,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: stylePoppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.detailsTextColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                currencySymbol,
                style: stylePoppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.detailsTextColor,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: '0.00',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.textFieldBorderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
