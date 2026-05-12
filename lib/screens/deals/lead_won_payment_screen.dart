import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/lead_won_payment_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/payment_flow_helpers.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_app_bar.dart';
import 'package:referaly/widgets/dialog/commission_payment_popup.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/widgets/secondary_button_outline.dart';

import '../../resources/app_assets.dart';

class LeadWonPaymentScreen extends StatelessWidget {
  const LeadWonPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeadWonPaymentController>(
      init: LeadWonPaymentController(),
      builder: (controller) {
        final formattedLeadDetails = controller.leadDetails.value.isNotEmpty
            ? controller.leadDetails.value
            : (() {
                final name = controller.leadName.value.isNotEmpty
                    ? controller.leadName.value
                    : controller.chainBottomName.value;
                final service = controller.leadService.value;
                final leadLine = '${tr(LanguageKeys.leadLabel)} $name';
                if (service.trim().isEmpty) return leadLine;
                return '$leadLine -\n$service';
              })();

        final formattedDealValue = controller.dealValue.value.trim().isNotEmpty
            ? '${tr(LanguageKeys.dealValueLabel)} ${controller.dealValue.value}'
            : '';

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CommonAppBar(title: controller.appBarTitle.value),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const _RoundIcon(
                              icon: Icons.emoji_events_outlined,
                              backgroundColor: Color(0xFFDCFCE7),
                              iconColor: Color(0xFF166534),
                              size: 48,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr(LanguageKeys.leadMarkedAsWonTitle),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    tr(LanguageKeys.leadMarkedAsWonSubtitle),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF4B5563),
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _TintCard(
                          tint: const Color(0xFFF0FDF4),
                          border: const Color(0xFFBBF7D0),
                          radius: 8,
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedLeadDetails,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF166534),
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    if (formattedDealValue.isNotEmpty)
                                      Text(
                                        formattedDealValue,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF15803D),
                                          height: 1.3,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _SectionCard(
                    child: Column(
                      children: [
                        _SectionHeader(
                          // icon: Icons.link,
                          icon: AppAssets.imgLink,

                          title: tr(LanguageKeys.referralChainTitle),
                        ),
                        const SizedBox(height: 16),
                        _ReferralChainTile(
                          color: const Color(0xFFFAF7FF),
                          borderColor: const Color(0xFFEADcff),
                          icon: Icons.person,
                          iconBg: const Color(0xFF8A47FF),
                          titleColor: const Color(0xFF553C9A),
                          subtitleColor: const Color(0xFF7C3AED),
                          title: controller.originalReferrerName.value,
                          subtitle: tr(LanguageKeys.originalReferrerLabel),
                          trailingIcon: AppAssets.imgPurpleCrown,
                          trailingColor: const Color(0xFF7C3AED),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 22,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ReferralChainTile(
                          color: const Color(0xFFEFF6FF),
                          borderColor: const Color(0xFFBFDBFE),
                          icon: Icons.apartment,
                          iconBg: const Color(0xFF2563EB),
                          titleColor: const Color(0xFF1E3A8A),
                          subtitleColor: const Color(0xFF1D4ED8),
                          title: controller.chainMiddleName.value,
                          subtitle:
                              '${tr(LanguageKeys.businessReferredByLabel)} ${controller.originalReferrerName.value}',
                          trailingIcon: AppAssets.imgPurpleCrown,
                          trailingColor: const Color(0xFF2563EB),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Icon(
                            Icons.arrow_downward_rounded,
                            size: 22,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ReferralChainTile(
                          color: const Color(0xFFECFDF5),
                          borderColor: const Color(0xFFBBF7D0),
                          icon: Icons.star_rate_rounded,
                          iconBg: const Color(0xFF16A34A),
                          titleColor: const Color(0xFF14532D),
                          subtitleColor: const Color(0xFF15803D),
                          title: controller.chainBottomName.value,
                          subtitle:
                              '${tr(LanguageKeys.leadReferredByLabel)} ${controller.chainMiddleName.value})',
                          trailingIcon: AppAssets.imgPurpleCrown,
                          trailingColor: const Color(0xFF16A34A),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          // icon: Icons.calculate_outlined,
                          icon: AppAssets.imgCalculator,
                          title: tr(LanguageKeys.commissionCalculationTitle),
                        ),
                        const SizedBox(height: 8),
                        _TintCard(
                          tint: const Color(0xFFFFF7ED),
                          border: const Color(0xFFFED7AA),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _RoundIcon(
                                icon: Icons.warning_amber_rounded,
                                backgroundColor: Color(0xFFFFEDD5),
                                iconColor: Color(0xFFC2410C),
                                size: 34,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr(LanguageKeys.commissionPaymentRequiredTitle),
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF7C2D12),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${tr(LanguageKeys.commissionPaymentRequiredBodyPrefix)} '
                                      '${controller.chainMiddleName.value} '
                                      '${tr(LanguageKeys.commissionPaymentRequiredBodyMiddle)} '
                                      '${controller.originalReferrerName.value}, '
                                      '${tr(LanguageKeys.commissionPaymentRequiredBodySuffix)}',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.grey700,
                                        height: 1.25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _KeyValueRow(
                          label: tr(LanguageKeys.commissionDealValueLabel),
                          value: controller.commissionDealValue.value,
                          valueStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _KeyValueRow(
                          label: '${controller.chainMiddleName.value}\n${tr(LanguageKeys.commission)}',
                          value: controller.commissionMiddleAmount.value,
                          valueStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _KeyValueRow(
                          label:
                              '${tr(LanguageKeys.commissionToOriginalReferrerLabel)} (${controller.level2CommissionPercentage.value}%)',
                          value: controller.originalReferrerCommission.value.isNotEmpty
                              ? controller.originalReferrerCommission.value
                              : controller.commissionOriginalAmount.value,
                          valueStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryLightPink,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys.paymentDueTitle),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF553C9A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tr(LanguageKeys.payToLabel),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, color: Color(0xFF553C9A))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(controller.paymentRecipient.value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400, color: AppColors.primary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tr(LanguageKeys.amountLabel),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, color: Color(0xFF553C9A))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(controller.paymentAmount.value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400, color: AppColors.primary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${controller.level2CommissionPercentage.value}% commission on ${controller.chainMiddleName.value}’s earning',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          // icon: Icons.payments_outlined,
                          icon: AppAssets.imgAtmCard,
                          title: tr(LanguageKeys.processPaymentTitle),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr(LanguageKeys.paymentDetailsTitle),
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.fontBlack,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _KeyValueRow(
                          label: tr(LanguageKeys.recipientLabel),
                          value: controller.paymentRecipient.value,
                          labelStyle: TextStyle(color: AppColors.grey700),
                          valueStyle: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Divider(color: AppColors.grey200),
                        const SizedBox(height: 8),
                        _KeyValueRow(
                          label: tr(LanguageKeys.amountLabel),
                          value: controller.paymentAmount.value,
                          labelStyle: TextStyle(color: AppColors.grey700),
                          valueStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(color: AppColors.grey200),
                        const SizedBox(height: 8),
                        _KeyValueRow(
                          label: tr(LanguageKeys.reasonLabel),
                          value: controller.paymentReason.value,
                          labelStyle: TextStyle(color: AppColors.grey700),
                          valueStyle: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Divider(color: AppColors.grey200),
                        const SizedBox(height: 14),
                        _CommissionSummaryBlock(controller: controller),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          text: tr(LanguageKeys.payViaReferaly),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ViaReferalyPaymentScreen(
                                  commissionAmount: _formatTotal(controller.commissionMiddleAmount.value, controller.commissionOriginalAmount.value, controller.currencySymbol.value.isNotEmpty ? controller.currencySymbol.value : '€'),
                                  currencySymbol: controller.currencySymbol.value.isNotEmpty
                                      ? controller.currencySymbol.value
                                      : '€',
                                  referrerName: controller.paymentRecipient.value,
                                  referrerRole: controller.referrerRole.value.isNotEmpty
                                      ? controller.referrerRole.value
                                      : tr(LanguageKeys.businessReferrer),
                                  referrerAvatarUrl: controller.referrerAvatarUrl.value.isNotEmpty
                                      ? controller.referrerAvatarUrl.value
                                      : null,
                                  leadId: controller.leadId.value == 0 ? null : controller.leadId.value,
                                  onConfirm: controller.onPayViaReferaly,
                                ),
                              ),
                            );
                          },
                          leading: SvgPicture.asset(AppAssets.imgLighting, width: 18, height: 18),
                          spacing: 8,
                          borderRadius: 10,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        const SizedBox(height: 10),
                        SecondaryButton(
                          text: tr(LanguageKeys.payOutsideApp),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => ImportantInformationPopup(
                                onConfirm: () async {
                                  final infoNavigator = Navigator.of(dialogContext);
                                  final success = await PaymentFlowHelpers
                                      .confirmOutsideReferalyPayment(
                                    leadId: controller.leadId.value,
                                  );
                                  if (!success) return;
                                  if (infoNavigator.canPop()) {
                                    infoNavigator.pop();
                                  }
                                  controller.onPayOutsideApp?.call();
                                },
                                onGoBack: () => Navigator.of(dialogContext).pop(),
                              ),
                            );
                          },
                          leading: const Icon(Icons.launch_outlined, size: 18),
                          height: 50,
                          borderRadius: 10,
                          textColor: AppColors.primary,
                          borderColor: AppColors.primary.withValues(alpha: 0.25),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            tr(LanguageKeys.paymentProcessedWithin),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.grey600,
                              height: 1.25,
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
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 4, 8),
      child: Row(
        children: [
          // Icon(icon, size: 18, color: AppColors.primary),
          SvgPicture.asset(icon,
              width: 18, height: 18, colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.fontBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionSummaryBlock extends StatelessWidget {
  final LeadWonPaymentController controller;

  const _CommissionSummaryBlock({required this.controller});

  @override
  Widget build(BuildContext context) {
    final reason = controller.paymentReason.value.trim();
    final middleAmount = controller.commissionMiddleAmount.value.trim();
    final originalAmount = controller.commissionOriginalAmount.value.trim();
    final computedTotal = _formatTotal(middleAmount, originalAmount, controller.currencySymbol.value.isNotEmpty ? controller.currencySymbol.value : '€');

    // If we don't have enough data, avoid rendering an empty card.
    final hasAny =
        reason.isNotEmpty || middleAmount.isNotEmpty || originalAmount.isNotEmpty || computedTotal.isNotEmpty;
    if (!hasAny) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 2),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: Text(
        //           tr(LanguageKeys.reasonLabel),
        //           style: stylePoppins(
        //             fontSize: 13,
        //             fontWeight: FontWeight.w600,
        //             color: AppColors.grey700,
        //           ),
        //         ),
        //       ),
        //       Text(
        //         tr(LanguageKeys.referralCommissionLabel),
        //         style: stylePoppins(
        //           fontSize: 13,
        //           fontWeight: FontWeight.w600,
        //           color: AppColors.grey700,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F3FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9D5FF)),
          ),
          child: Column(
            children: [
              _commissionRow(
                label: '${controller.chainMiddleName.value} ${tr(LanguageKeys.commission)}',
                value: middleAmount.isNotEmpty ? middleAmount : '-',
                boldValue: false,
              ),
              const SizedBox(height: 10),
              _commissionRow(
                label: tr(LanguageKeys.commissionToOriginalReferrerLabel),
                value: originalAmount.isNotEmpty ? originalAmount : '-',
                boldValue: false,
              ),
              const SizedBox(height: 8),
              Divider(color: AppColors.grey200),
              const SizedBox(height: 8),
              _commissionRow(
                label: tr(LanguageKeys.totalPaymentLabel),
                value: computedTotal.isNotEmpty ? computedTotal : '-',
                boldValue: true,
                valueColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _commissionRow({
    required String label,
    required String value,
    required bool boldValue,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: stylePoppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.fontBlack,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          textAlign: TextAlign.right,
          style: stylePoppins(
            fontSize: 14,
            fontWeight: boldValue ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.fontBlack,
          ),
        ),
      ],
    );
  }
}

String _formatTotal(String middle, String original, String currencySymbol) {
  final middleValue = _parseAmount(middle);
  final originalValue = _parseAmount(original);
  final total = middleValue + originalValue;
  if (total == 0 && middle.trim().isEmpty && original.trim().isEmpty) return '';

  final symbol = currencySymbol.trim().isNotEmpty ? currencySymbol.trim() : '€';
  return '$symbol${total.toStringAsFixed(2)}';
}

double _parseAmount(String text) {
  final raw = text.trim();
  if (raw.isEmpty) return 0;

  // Remove everything except digits, separators and minus.
  var cleaned = raw.replaceAll(RegExp(r'[^0-9,.\-]'), '');
  cleaned = cleaned.replaceAll(' ', '');

  // If comma is used as decimal separator (and dot isn't), normalize to dot.
  if (cleaned.contains(',') && !cleaned.contains('.')) {
    cleaned = cleaned.replaceAll(',', '.');
  } else if (cleaned.contains(',') && cleaned.contains('.')) {
    // If both exist, assume commas are thousands separators and remove them.
    cleaned = cleaned.replaceAll(',', '');
  }

  return double.tryParse(cleaned) ?? 0;
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(25),
      child: child,
    );
  }
}

class _TintCard extends StatelessWidget {
  final Widget child;
  final Color tint;
  final Color border;
  final double radius;
  final EdgeInsetsGeometry padding;

  const _TintCard({
    required this.child,
    required this.tint,
    required this.border,
    this.radius = 12,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
      ),
      padding: padding,
      child: child,
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const _RoundIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(icon, color: iconColor, size: size * 0.52),
    );
  }
}

class _ReferralChainTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  // final IconData trailingIcon;
  final String trailingIcon;
  final Color trailingColor;
  final Color? borderColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const _ReferralChainTile({
    required this.color,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.trailingIcon,
    required this.trailingColor,
    this.borderColor,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? AppColors.grey200.withValues(alpha: 0.6), width: 2),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: titleColor ?? AppColors.fontBlack,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor ?? AppColors.grey700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Icon(trailingIcon, color: trailingColor, size: 18),
          SvgPicture.asset(trailingIcon, width: 18, height: 18),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _KeyValueRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: labelStyle ??
              TextStyle(
                fontSize: 12.5,
                color: AppColors.grey700,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ??
                  const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
