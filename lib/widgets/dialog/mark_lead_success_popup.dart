import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class MarkLeadSuccessPopup extends StatefulWidget {
  final String currencySymbol;
  final void Function(String turnover, String commission, double netIncome)
      onSubmit;
  final VoidCallback? onClose;

  const MarkLeadSuccessPopup({
    super.key,
    required this.currencySymbol,
    required this.onSubmit,
    this.onClose,
  });

  @override
  State<MarkLeadSuccessPopup> createState() => _MarkLeadSuccessPopupState();
}

class _MarkLeadSuccessPopupState extends State<MarkLeadSuccessPopup> {
  final TextEditingController _turnoverController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  double _netIncome = 0.0;
  String? _errorText;

  late final NumberFormat _formatter;

  @override
  void initState() {
    super.initState();
    _formatter = NumberFormat.currency(
      symbol: widget.currencySymbol,
      decimalDigits: 2,
    );
    _turnoverController.addListener(_recalculateNetIncome);
    _commissionController.addListener(_recalculateNetIncome);
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
      _netIncome = (turnover - commission).clamp(0, double.infinity);
      _errorText = null;
    });
  }

  double _parseAmount(String value) {
    if (value.isEmpty) return 0;
    final sanitized = value.replaceAll(',', '.');
    return double.tryParse(sanitized) ?? 0;
  }

  void _handleSubmit() {
    if (_turnoverController.text.trim().isEmpty ||
        _commissionController.text.trim().isEmpty) {
      setState(() {
        _errorText = tr(LanguageKeys.pleaseEnterAmount);
      });
      return;
    }

    Navigator.of(context).pop();
    widget.onSubmit(
      _turnoverController.text.trim(),
      _commissionController.text.trim(),
      _netIncome,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(top: 24),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tr(LanguageKeys.netIncome),
                              style: stylePoppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.detailsTextColor,
                              ),
                            ),
                            Text(
                              _formatter.format(_netIncome),
                              style: stylePoppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
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
                          onPressed: _handleSubmit,
                          child: Text(
                            tr(LanguageKeys.submitInformation),
                            style: stylePoppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: '0.00',
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.textFieldBorderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
