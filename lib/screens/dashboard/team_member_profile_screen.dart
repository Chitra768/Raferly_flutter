import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/controller/team_member_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

/// Independent member profile — Figma 3474:1730 (EN), 3474:1988 (FR), 3474:1465 (ES).
class TeamMemberProfileScreen extends GetView<TeamMemberProfileController> {
  static const String pageId = '/teamMemberProfile';

  const TeamMemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const Center(child: LogoLoader());
        }
        final profile = controller.profile.value;
        if (profile == null) {
          return _errorState();
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _headerWithAbout(context, profile)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _performanceSection(profile),
                  const SizedBox(height: 24),
                  _quickActionsSection(profile),
                  if (profile.canSwitchToAgency) ...[
                    const SizedBox(height: 24),
                    _switchAgencySection(),
                  ],
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.error.value.isNotEmpty
                  ? controller.error.value
                  : tr(LanguageKeys.somethingWentWrong),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: controller.loadProfile,
              child: Text(tr(LanguageKeys.retry)),
            ),
          ],
        ),
      ),
    );
  }

  /// Gradient header with About card overlapping by 16px (Figma 3474:1730).
  Widget _headerWithAbout(BuildContext context, TeamMemberProfileModel profile) {
    final top = MediaQuery.paddingOf(context).top;
    const headerHeight = 196.0;
    const cardOverlap = 16.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _gradientHeader(context, profile, headerHeight, top),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: headerHeight + top - cardOverlap),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _aboutCard(profile),
            ),
          ],
        ),
      ],
    );
  }

  Widget _gradientHeader(
    BuildContext context,
    TeamMemberProfileModel profile,
    double headerHeight,
    double topInset,
  ) {
    return Container(
      height: headerHeight + topInset,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.teamProfilePurple, AppColors.teamProfilePurpleDark],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, topInset + 6, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Get.back(),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: ClipOval(
                    child: _avatarImage(profile.avatarUrl, 72),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 32 / 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: AppColors.amber500, size: 14),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                profile.collaborationLabel ??
                                    tr(LanguageKeys.teamMemberProfileIndependentAccount),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }

  Widget _avatarImage(String? url, double size) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _avatarPlaceholder(size),
      );
    }
    return _avatarPlaceholder(size);
  }

  Widget _avatarPlaceholder(double size) {
    return Container(
      color: Colors.white24,
      child: Icon(Icons.person, color: Colors.white70, size: size * 0.5),
    );
  }

  Widget _aboutCard(TeamMemberProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlack10,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.shadowBlack5,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.teamProfileIconTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_outline, color: AppColors.teamProfilePurple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.teamMemberProfileAboutTitle),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    height: 24 / 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.aboutIndependent ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.detailsTextColor,
                    height: 23 / 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _performanceSection(TeamMemberProfileModel profile) {
    final perf = profile.performance;
    final currency = NumberFormat.currency(
      symbol: perf.currency == 'USD' ? '\$' : '€',
      decimalDigits: 0,
      locale: 'fr_FR',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.teamMemberProfilePerformance),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
            height: 28 / 18,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 165.5 / 130,
          children: [
            _metricCard(
              label: tr(LanguageKeys.teamMemberProfileTotalLeads),
              value: '${perf.totalLeads}',
              icon: Icons.people_outline,
              iconBg: AppColors.blue50,
              iconColor: AppColors.blue600,
            ),
            _metricCard(
              label: tr(LanguageKeys.teamMemberProfilePendingLeads),
              value: '${perf.displayPendingLeads}',
              icon: Icons.schedule,
              iconBg: AppColors.amber50Soft,
              iconColor: AppColors.amber500,
            ),
            _metricCard(
              label: tr(LanguageKeys.teamMemberProfileSuccessfulLeads),
              value: '${perf.successfulLeads}',
              icon: Icons.check_circle_outline,
              iconBg: AppColors.emerald50,
              iconColor: AppColors.teamStatusSuccessFg,
            ),
            _metricCard(
              label: tr(LanguageKeys.teamMemberProfileLostLeads),
              value: '${perf.lostLeads}',
              icon: Icons.cancel_outlined,
              iconBg: AppColors.teamWarningBg,
              iconColor: AppColors.red600,
            ),
            _metricCard(
              label: tr(LanguageKeys.teamMemberProfileBusinessReferrers),
              value: '${perf.businessReferrers}',
              icon: Icons.handshake_outlined,
              iconBg: AppColors.violet50,
              iconColor: AppColors.teamProfilePurple,
            ),
            _metricCard(
              label: tr(LanguageKeys.teamMemberProfileReferralContracts),
              value: '${perf.referralContracts}',
              icon: Icons.description_outlined,
              iconBg: AppColors.blue100,
              iconColor: AppColors.blue700,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _conversionRateCard(perf.conversionRate),
        const SizedBox(height: 12),
        _financialCard(
          label: tr(LanguageKeys.teamMemberProfileTurnoverGenerated),
          value: currency.format(perf.totalTurnover),
          icon: Icons.euro_rounded,
          iconBg: AppColors.emerald50,
          iconColor: AppColors.emerald600,
        ),
        const SizedBox(height: 12),
        _financialCard(
          label: tr(LanguageKeys.teamMemberProfileCommission),
          value: currency.format(perf.totalCommissionPaid),
          icon: Icons.payments_outlined,
          iconBg: AppColors.lightorange,
          iconColor: AppColors.orange600,
        ),
        const SizedBox(height: 12),
        _financialCard(
          label: tr(LanguageKeys.teamMemberProfileNetIncome),
          value: currency.format(perf.totalNetIncome),
          icon: Icons.account_balance_wallet_outlined,
          iconBg: AppColors.emerald50,
          iconColor: AppColors.teamStatusSuccessFg,
        ),
      ],
    );
  }

  Widget _metricCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray100),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlack5,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.k6B7280,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _conversionRateCard(double rate) {
    return Container(
      height: 97,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.teamProfilePurple, AppColors.teamProfilePurpleDark],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlack10,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr(LanguageKeys.teamMemberProfileConversionRate),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${rate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 36 / 30,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.show_chart, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _financialCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray100),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowBlack5,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.k6B7280,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                    height: 32 / 24,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _quickActionsSection(TeamMemberProfileModel profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.teamMemberProfileQuickActions),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
            height: 28 / 18,
          ),
        ),
        const SizedBox(height: 16),
        _quickActionTile(
          highlighted: true,
          title: tr(LanguageKeys.teamMemberProfileSeeActivity),
          subtitle: tr(LanguageKeys.teamMemberProfileViewLeadsSubtitle),
          icon: Icons.auto_graph_rounded,
          onTap: () => controller.openContent(TeamMemberContentTab.leads),
        ),
      ],
    );
  }

  Widget _quickActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool highlighted,
    required VoidCallback onTap,
  }) {
    final bg = highlighted ? AppColors.teamProfilePurple : AppColors.whiteColor;
    final borderColor = highlighted ? AppColors.teamProfilePurple : AppColors.teamProfilePurple;
    final titleColor = highlighted ? Colors.white : AppColors.gray900;
    final subtitleColor = highlighted ? Colors.white.withOpacity(0.8) : AppColors.k6B7280;
    final iconBoxColor = highlighted ? Colors.white.withOpacity(0.2) : AppColors.teamProfileIconTint;
    final iconColor = highlighted ? Colors.white : AppColors.teamProfilePurple;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      elevation: highlighted ? 4 : 0,
      shadowColor: highlighted ? AppColors.teamProfilePurple.withOpacity(0.3) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: highlighted
                ? const [
                    BoxShadow(
                      color: AppColors.shadowBlack10,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: AppColors.shadowBlack5,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBoxColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 22),
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
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: subtitleColor),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: highlighted ? Colors.white : AppColors.k6B7280,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchAgencySection() {
    return Obx(() {
      final switching = controller.isSwitching.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.teamWarningBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.red200, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.red200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.red600, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tr(LanguageKeys.teamMemberProfileSwitchAgencyWarning),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teamWarningText,
                      height: 24 / 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 76,
              child: ElevatedButton(
                onPressed: switching ? null : controller.switchToAgency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red600,
                  disabledBackgroundColor: AppColors.red600.withOpacity(0.6),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: switching
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              tr(LanguageKeys.teamMemberProfileSwitchAgency),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
