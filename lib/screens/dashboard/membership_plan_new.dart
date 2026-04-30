import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/membership_plan_new_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/logo_loader.dart';

class MembershipPlanNewScreen extends StatefulWidget {
  static const String pageId = '/membership_plan_new';

  const MembershipPlanNewScreen({super.key});

  @override
  State<MembershipPlanNewScreen> createState() => _MembershipPlanNewScreenState();
}

class _MembershipPlanNewScreenState extends State<MembershipPlanNewScreen> {
  late final MembershipPlanNewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MembershipPlanNewController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                'R',
                style: stylePoppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'referaly',
              style: stylePoppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 45),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // _Header(
            //   onBack: () => Get.back(),
            //   onMenu: () {},
            // ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LogoLoader(),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        tr(LanguageKeys.membershipPlansTitle),
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tr(LanguageKeys.membershipPlansSubtitle),
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ).copyWith(height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      _NoticeBanner(onTapLink: _openReferaly),
                      const SizedBox(height: 16),
                      _TypeToggle(
                        value: controller.selectedType.value,
                        onChanged: controller.setTypeAndReload,
                      ),
                      const SizedBox(height: 20),
                      _PlanCard(
                        tone: _CardTone.popular,
                        icon: Icons.person_outline,
                        title: tr(LanguageKeys.membershipPlanIndependentTitle),
                        description: tr(LanguageKeys.membershipPlanIndependentDesc),
                        price: _formatPlanPrice(card: 'independent'),
                        priceSuffix: tr(LanguageKeys.membershipPlanPerMonth),
                        vatText: tr(LanguageKeys.membershipPlanVatText),
                        billedYearlyText: _formatBilledYearlyText(card: 'independent'),
                        guaranteeText: tr(LanguageKeys.membershipPlanGuarantee),
                        features: [
                          tr(LanguageKeys.membershipPlanIndependentFeature1),
                          tr(LanguageKeys.membershipPlanIndependentFeature2),
                          tr(LanguageKeys.membershipPlanIndependentFeature3),
                          tr(LanguageKeys.membershipPlanIndependentFeature4),
                        ],
                        badgeText: tr(LanguageKeys.membershipPlanPopular),
                        buttonStyle: _ButtonStyle.primary,
                        buttonText: tr(LanguageKeys.membershipPlanGoToSite),
                        onPressed: _openReferaly,
                      ),
                      const SizedBox(height: 16),
                      _PlanCard(
                        tone: _CardTone.normal,
                        icon: Icons.apartment_outlined,
                        title: tr(LanguageKeys.membershipPlanAgencyTitle),
                        description: tr(LanguageKeys.membershipPlanAgencyDesc),
                        price: _formatPlanPrice(card: 'agency'),
                        priceSuffix: tr(LanguageKeys.membershipPlanPerMonth),
                        vatText: tr(LanguageKeys.membershipPlanVatText),
                        billedYearlyText: _formatBilledYearlyText(card: 'agency'),
                        guaranteeText: tr(LanguageKeys.membershipPlanGuarantee),
                        features: [
                          tr(LanguageKeys.membershipPlanAgencyFeature1),
                          tr(LanguageKeys.membershipPlanAgencyFeature2),
                          tr(LanguageKeys.membershipPlanAgencyFeature3),
                          tr(LanguageKeys.membershipPlanAgencyFeature4),
                          tr(LanguageKeys.membershipPlanAgencyFeature5),
                        ],
                        buttonStyle: _ButtonStyle.secondary,
                        buttonText: tr(LanguageKeys.membershipPlanGoToSite),
                        onPressed: _openReferaly,
                      ),
                      const SizedBox(height: 16),
                      _PlanCard(
                        tone: _CardTone.dark,
                        icon: Icons.code,
                        title: tr(LanguageKeys.membershipPlanWhiteLabelTitle),
                        description: tr(LanguageKeys.membershipPlanWhiteLabelDesc),
                        price: tr(LanguageKeys.membershipPlanCustomPricing),
                        priceSuffix: '',
                        vatText: tr(LanguageKeys.membershipPlanOnDemandOnly),
                        billedYearlyText: '',
                        guaranteeText: '',
                        features: [
                          tr(LanguageKeys.membershipPlanWhiteLabelFeature1),
                          tr(LanguageKeys.membershipPlanWhiteLabelFeature2),
                          tr(LanguageKeys.membershipPlanWhiteLabelFeature3),
                          tr(LanguageKeys.membershipPlanWhiteLabelFeature4),
                          tr(LanguageKeys.membershipPlanWhiteLabelFeature5),
                        ],
                        buttonStyle: _ButtonStyle.inverse,
                        buttonText: tr(LanguageKeys.membershipPlanGoToSite),
                        onPressed: _openReferaly,
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: Text(
                          tr(LanguageKeys.membershipPlanCopyright),
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      if (controller.errorMessage.value.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.redColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPlanPrice({required String card}) {
    final plan = controller.findPlanForCard(card);
    if (plan == null) return '€—';

    num? value;
    if (controller.selectedType.value.toLowerCase() == 'yearly') {
      // Yearly view shows the monthly equivalent (API: monthly_amount)
      value = plan.monthlyAmount ?? plan.amount;
    } else {
      // Monthly view shows the monthly amount (API: amount)
      value = plan.amount ?? plan.monthlyAmount;
    }
    if (value == null) return '€—';

    final str = value.toStringAsFixed(2);
    return '€$str';
  }

  String _formatBilledYearlyText({required String card}) {
    if (controller.selectedType.value.toLowerCase() != 'yearly') return '';
    final plan = controller.findPlanForCard(card);
    final amount = plan?.amount;
    if (amount == null) return '';
    final str = amount.toStringAsFixed(0);
    return tr(LanguageKeys.membershipPlanBilledYearly).replaceAll('{amount}', str);
  }

  Future<void> _openReferaly() async {
    final uri = Uri.parse('https://www.referaly.fr/en/pricing.html');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMenu;

  const _Header({required this.onBack, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back, color: Color(0xFF111827)),
            ),
          ),
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'R',
                  style: stylePoppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'referaly',
                style: stylePoppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: onMenu,
            borderRadius: BorderRadius.circular(8),
            child: const SizedBox(
              width: 32,
              height: 32,
              // child: Icon(Icons.menu, color: Color(0xFF111827)),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  final VoidCallback onTapLink;

  const _NoticeBanner({required this.onTapLink});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info_outline, color: Color(0xFF1E40AF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: stylePoppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E40AF),
                ).copyWith(height: 1.45),
                children: [
                  TextSpan(text: tr(LanguageKeys.membershipPlanImportantPrefix)),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: onTapLink,
                      child: Text(
                        'referaly.fr',
                        style: stylePoppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E40AF),
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  TextSpan(text: tr(LanguageKeys.membershipPlanImportantSuffix)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _TypeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isYearly = value.toLowerCase() == 'yearly';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: _TogglePill(
              selected: !isYearly,
              text: tr(LanguageKeys.Monthly),
              onTap: () => onChanged('Monthly'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TogglePill(
              selected: isYearly,
              text: tr(LanguageKeys.Yearly),
              onTap: () => onChanged('Yearly'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onTap;

  const _TogglePill({
    required this.selected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF8B5CF6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: stylePoppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }
}

enum _CardTone { normal, popular, dark }

enum _ButtonStyle { secondary, primary, inverse }

class _PlanCard extends StatelessWidget {
  final _CardTone tone;
  final IconData icon;
  final String title;
  final String description;
  final String price;
  final String priceSuffix;
  final String vatText;
  final String billedYearlyText;
  final String guaranteeText;
  final List<String> features;
  final _ButtonStyle buttonStyle;
  final String buttonText;
  final VoidCallback onPressed;
  final String? badgeText;

  const _PlanCard({
    required this.tone,
    required this.icon,
    required this.title,
    required this.description,
    required this.price,
    required this.priceSuffix,
    required this.vatText,
    required this.billedYearlyText,
    required this.guaranteeText,
    required this.features,
    required this.buttonStyle,
    required this.buttonText,
    required this.onPressed,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = tone == _CardTone.dark;
    final borderColor = (tone == _CardTone.popular) ? const Color(0xFF8B5CF6) : const Color(0xFFF3F4F6);
    final borderWidth = (tone == _CardTone.popular) ? 2.0 : 1.0;
    final bgColor = isDark ? const Color(0xFF4C1D95) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final bodyColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280);
    final featureColor = isDark ? const Color(0xFFE5E7EB) : const Color(0xFF374151);
    final dividerColor = isDark ? const Color(0x1AFFFFFF) : const Color(0xFFF3F4F6);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              if (tone == _CardTone.popular)
                const BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 25,
                  offset: Offset(0, 20),
                  spreadRadius: -5,
                )
              else
                const BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0x1AFFFFFF) : const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: isDark ? Colors.white : const Color(0xFF8B5CF6), size: 22),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: stylePoppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: stylePoppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: bodyColor,
                ).copyWith(height: 1.45),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: stylePoppins(
                      fontSize: isDark ? 26 : 30,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  if (priceSuffix.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        priceSuffix,
                        style: stylePoppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: bodyColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                vatText,
                style: stylePoppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                ),
              ),
              if (!isDark && billedYearlyText.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  billedYearlyText,
                  style: stylePoppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
              if (guaranteeText.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        guaranteeText,
                        style: stylePoppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Container(height: 1, color: dividerColor),
              const SizedBox(height: 16),
              ...features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 16, color: isDark ? Colors.white : const Color(0xFF8B5CF6)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: stylePoppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: featureColor,
                          ).copyWith(height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _ActionButton(
                style: buttonStyle,
                text: buttonText,
                onPressed: onPressed,
                darkCard: isDark,
              ),
            ],
          ),
        ),
        if (badgeText != null && badgeText!.isNotEmpty)
          Positioned(
            top: -10,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badgeText!,
                style: stylePoppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final _ButtonStyle style;
  final String text;
  final VoidCallback onPressed;
  final bool darkCard;

  const _ActionButton({
    required this.style,
    required this.text,
    required this.onPressed,
    required this.darkCard,
  });

  @override
  Widget build(BuildContext context) {
    final bg = switch (style) {
      _ButtonStyle.secondary => const Color(0xFFF9FAFB),
      _ButtonStyle.primary => const Color(0xFF8B5CF6),
      _ButtonStyle.inverse => Colors.white,
    };
    final border = (style == _ButtonStyle.secondary) ? const Color(0xFFE5E7EB) : Colors.transparent;
    final fg = switch (style) {
      _ButtonStyle.secondary => const Color(0xFF374151),
      _ButtonStyle.primary => Colors.white,
      _ButtonStyle.inverse => const Color(0xFF4C1D95),
    };

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
          boxShadow: (style == _ButtonStyle.primary)
              ? const [
                  BoxShadow(color: Color(0x338B5CF6), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -1)
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: stylePoppins(fontSize: 15, fontWeight: FontWeight.w600, color: fg),
            ),
            const SizedBox(width: 8),

            // SvgPicture.asset(AppAssets.imgProfileSend, width: 24, height: 24, color: fg),
            Icon(Icons.open_in_new, color: fg, size: 20),
          ],
        ),
      ),
    );
  }
}
