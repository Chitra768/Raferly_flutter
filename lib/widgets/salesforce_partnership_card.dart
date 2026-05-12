import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

/// [single]: full card when only one contract. [listCollapsed] / [listExpanded]: multi-contract list (Figma).
enum SalesforcePartnershipLayout { single, listCollapsed, listExpanded }

class SalesforcePartnershipCard extends StatelessWidget {
  final SalesforcePartnershipLayout layout;
  final String contractName;
  final String referrersCount;
  final String leadsCount;
  final String commissionRate;
  final String commissionType;
  final bool isRecurring;
  final int accentIndex;

  /// Kept for call sites; header always shows the chart tile (reference design), not this image.
  // ignore: unused_field
  final String? companyLogoUrl;
  final VoidCallback? onViewContract;
  final VoidCallback? onEdit;
  final VoidCallback? onAttachFiles;
  final VoidCallback? onInvitePartner;
  final VoidCallback? onShareForm;
  final VoidCallback? onInviteManually;
  final VoidCallback? onHowItWorks;
  final VoidCallback? onMoreOptions;

  /// List rows: toggles expanded section (whole row is tappable).
  final VoidCallback? onToggleExpand;

  const SalesforcePartnershipCard({
    super.key,
    this.layout = SalesforcePartnershipLayout.single,
    required this.contractName,
    this.referrersCount = '0',
    this.leadsCount = '0',
    required this.commissionRate,
    required this.commissionType,
    this.isRecurring = false,
    this.accentIndex = 0,
    this.companyLogoUrl,
    this.onViewContract,
    this.onEdit,
    this.onAttachFiles,
    this.onInvitePartner,
    this.onShareForm,
    this.onInviteManually,
    this.onHowItWorks,
    this.onMoreOptions,
    this.onToggleExpand,
  });

  static const Color _slateTitle = Color(0xFF1E293B);
  static const Color _slateMuted = Color(0xFF64748B);
  static const Color _iconBg = Color(0xFFF5F3FF);
  static const Color _toggleBg = Color(0xFFF1F5F9);
  static const List<Color> _accentPalette = <Color>[
    Color(0xFF7C3AED), // purple
    Color(0xFF3B82F6), // blue
    Color(0xFF10B981), // green
    Color(0xFFF59E0B), // orange
    Color(0xFFEC4899), // pink/red
  ];

  Color get _accentColor => _accentPalette[accentIndex % _accentPalette.length];

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case SalesforcePartnershipLayout.single:
        return _buildSingleCard(context);
      case SalesforcePartnershipLayout.listCollapsed:
        return _buildListCard(context, expanded: false);
      case SalesforcePartnershipLayout.listExpanded:
        return _buildListCard(context, expanded: true);
    }
  }

  Widget _buildSingleCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSingleHeader(context),
          _buildTwoColumnStatsRow(),
          const SizedBox(height: 12),
          _buildCommissionSection(),
          const SizedBox(height: 12),
          _buildCompactActionGrid(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 20, color: Colors.grey[200]),
          ),
          _buildCtaColumn(),
        ],
      ),
    );
  }

  /// Figma 4935:192 list row + expanded = same content as [single] with collapse chevron (top-right).
  Widget _buildListCard(BuildContext context, {required bool expanded}) {
    const borderColor = Color(0xFFF1F5F9);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!expanded) _buildListCollapsedTapArea(context),
            if (expanded) ...[
              GestureDetector(
                onTap: onToggleExpand,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _buildListExpandedHeader(context),
                    ),
                    const SizedBox(height: 12),
                    _buildExpandedContractBody(context),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Collapsed: Figma — icon + title + chevron (center-aligned), 12px gap, 3-column stats (all purple).
  Widget _buildListCollapsedTapArea(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onToggleExpand,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderIcon(size: 48, companyLogoUrl: companyLogoUrl),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      contractName,
                      style: stylePoppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _slateTitle,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: _toggleBg,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.keyboard_arrow_down, color: _slateMuted, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildListStatsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Expanded: same header affordances as single (title + How it works) + collapse chevron top-right.
  Widget _buildListExpandedHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // _listChevronButton(icon: Icons.keyboard_arrow_up),
        // const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: _buildHeaderIcon(size: 48, companyLogoUrl: companyLogoUrl)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                contractName,
                style: stylePoppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _slateTitle,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 110),
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onHowItWorks,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: Text(
                        tr(LanguageKeys.howItWorks),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: stylePoppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _listChevronButton(icon: Icons.keyboard_arrow_up),
          ],
        ),
      ],
    );
  }

  Widget _listChevronButton({required IconData icon}) {
    return Material(
      color: _toggleBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onToggleExpand,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: _slateMuted, size: 22),
        ),
      ),
    );
  }

  Widget _buildTwoColumnStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _statBlock(tr(LanguageKeys.numberOfPartners), referrersCount, alignEnd: false),
          ),
          Expanded(
            child: _statBlock(tr(LanguageKeys.leadsReceived), leadsCount, alignEnd: true),
          ),
        ],
      ),
    );
  }

  /// Identical to single-card body below the title row (not used for collapsed list).
  Widget _buildExpandedContractBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTwoColumnStatsRow(),
        const SizedBox(height: 12),
        _buildCommissionSection(),
        const SizedBox(height: 12),
        _buildCompactActionGrid(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 20, color: Colors.grey[200]),
        ),
        _buildCtaColumn(),
      ],
    );
  }

  Widget _statBlock(String label, String value, {required bool alignEnd}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: stylePoppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _slateMuted,
          ),
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: stylePoppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildListStatsRow(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _listStatCell(
              tr(LanguageKeys.referrers),
              referrersCount,
              isCommission: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _listStatCell(
              tr(LanguageKeys.leadsReceived),
              leadsCount,
              isCommission: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _listStatCommissionCell(tr(LanguageKeys.commission)),
          ),
        ],
      ),
    );
  }

  Widget _listStatCell(String label, String value, {required bool isCommission}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: stylePoppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: _slateMuted,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Center(
            child: Text(
              value,
              style: stylePoppins(
                fontSize: isCommission ? 14.sp : 18.sp,
                fontWeight: FontWeight.w700,
                color: _accentColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _listStatCommissionCell(String label) {
    final isNoCommission = commissionType == 'no_commission';
    final valueText = isNoCommission
        ? tr(LanguageKeys.no_commission)
        : commissionType == 'fix_commission'
            ? '$commissionRate€'
            : '$commissionRate%';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: stylePoppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: _slateMuted,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Center(
            child: Text(
              valueText,
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isNoCommission ? _slateMuted : _accentColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderIcon(size: 48, companyLogoUrl: companyLogoUrl),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              contractName,
              style: stylePoppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _slateTitle,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Match reference (left) design: generous pill — not the compact one on the right.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onHowItWorks,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Text(
                      tr(LanguageKeys.howItWorks),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: stylePoppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({required double size, String? companyLogoUrl}) {
    final r = BorderRadius.circular(size > 44 ? 12 : 8);
    final accent = _accentColor;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withOpacity(0.10),
        borderRadius: r,
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      // Reference UI: light purple tile + bar chart — not company avatar/logo (avoids "letter" thumbnails).
      child: ClipRRect(borderRadius: r, child: _defaultHeaderIcon(size, companyLogoUrl)),
    );
  }

  Widget _defaultHeaderIcon(double size, String? companyLogoUrl) {
    final accent = _accentColor;
    if (companyLogoUrl != null && companyLogoUrl.isNotEmpty) {
      return Image.network(
        companyLogoUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.bar_chart_rounded,
          color: accent,
          size: size * 0.60,
        ),
      );
    }
    return Icon(
      Icons.bar_chart_rounded,
      color: accent,
      size: size * 0.60,
    );
    // return Icon(
    //   Icons.bar_chart_rounded,
    //   color: AppColors.primary,
    //   size: size * 0.60,
    // );
  }

  Widget _buildCommissionSection() {
    final isNoCommission = commissionType == 'no_commission';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _iconBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.12), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.commission),
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isNoCommission
                      ? tr(LanguageKeys.no_commission)
                      : commissionType == 'fix_commission'
                          ? '${tr(LanguageKeys.fix_commission)} : $commissionRate€'
                          : '${tr(LanguageKeys.percentage_commission)} : $commissionRate%',
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (!isNoCommission)
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                commissionType == 'fix_commission' ? Icons.euro : Icons.percent,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactActionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _compactTile(
              icon: SvgPicture.asset(AppAssets.imgActivityContract),
              label: tr(LanguageKeys.contractActionShortContract),
              onTap: onViewContract,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _compactTile(
              icon: SvgPicture.asset(AppAssets.imgActivityEdit),
              label: tr(LanguageKeys.edit),
              onTap: onEdit,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _compactTile(
              icon: SvgPicture.asset(AppAssets.imgAttach),
              label: tr(LanguageKeys.contractActionShortFiles),
              onTap: onAttachFiles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactTile({
    required Widget icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: icon,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: stylePoppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCtaColumn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          _purpleCta(
            bgColor: AppColors.primary,
            icon: SvgPicture.asset(
              AppAssets.imgPartner,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            title: tr(LanguageKeys.inviteBusinessReferrer),
            subtitle: tr(LanguageKeys.inviteBusinessReferrerSubtext),
            onTap: onInvitePartner,
          ),
          const SizedBox(height: 12),
          _purpleCta(
            bgColor: AppColors.blueColor2,
            icon: SvgPicture.asset(
              AppAssets.imgActivityShare,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            title: tr(LanguageKeys.shareExternalForm),
            subtitle: tr(LanguageKeys.shareExternalFormSubtext),
            onTap: onShareForm,
          ),
          const SizedBox(height: 12),
          _purpleCta(
            bgColor: AppColors.yellowColor,
            icon: Image.asset(AppAssets.imgManuallyIconWhite, color: Colors.white, width: 20, height: 20),
            title: tr(LanguageKeys.inviteManually),
            subtitle: tr(LanguageKeys.inviteManuallyDescription),
            onTap: onInviteManually,
          ),
        ],
      ),
    );
  }

  Widget _purpleCta({
    required Widget icon,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(width: 20, height: 20, child: icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Reference-only: full previous `salesforce_partnership_card.dart` (Git HEAD
// before layout variants). Not compiled — kept for rollback / comparison.
// -----------------------------------------------------------------------------
/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class SalesforcePartnershipCard extends StatelessWidget {
  final String companyName;
  final String dealType;
  final String leadsReceived;
  final String commissionRate;
  final String
      commissionType; // no_commission, fix_commission, percentage_commission
  final bool isRecurring;
  final String? companyLogoUrl;
  final VoidCallback? onViewContract;
  final VoidCallback? onEdit;
  final VoidCallback? onAttachFiles;
  final VoidCallback? onInvitePartner;
  final VoidCallback? onShareForm;
  final VoidCallback? onInviteManually;
  final VoidCallback? onHowItWorks;
  final VoidCallback? onMoreOptions;

  const SalesforcePartnershipCard({
    super.key,
    required this.companyName,
    required this.dealType,
    required this.leadsReceived,
    required this.commissionRate,
    required this.commissionType,
    this.isRecurring = false,
    this.companyLogoUrl,
    this.onViewContract,
    this.onEdit,
    this.onAttachFiles,
    this.onInvitePartner,
    this.onShareForm,
    this.onInviteManually,
    this.onHowItWorks,
    this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          _buildHeader(),

          // Commission Rate Section
          _buildCommissionSection(),

          // Contract management: View Contract, Edit, Attach Files (vertical)
          _buildContractActionButtons(),

          // Referral / Invitation buttons (Purple, Blue, Orange)
          _buildActionButtonsRow2(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: companyLogoUrl != null && companyLogoUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      companyLogoUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultLogo();
                      },
                    ),
                  )
                : _buildDefaultLogo(),
          ),
          const SizedBox(width: 16),

          // Company Info and Header Actions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with company name and actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        companyName,
                        style: stylePoppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Header Actions
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: onHowItWorks,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 100),
                                  child: Text(
                                    tr(LanguageKeys.howItWorks),
                                    textAlign: TextAlign.end,
                                    style: stylePoppins(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),

                              // GestureDetector(
                              //   onTap: onMoreOptions,
                              //   child: Container(
                              //     width: 24,
                              //     height: 24,
                              //     padding: const EdgeInsets.all(6),
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey[100],
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Icon(
                              //       Icons.delete,
                              //       color: Colors.grey,
                              //       size: 11,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dealType,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  leadsReceived,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.business,
          color: Color(0xFF1E40AF),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCommissionSection() {
    final isNoCommission = commissionType == 'no_commission';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.commission),
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.fontBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isNoCommission
                      ? tr(LanguageKeys.noCommissionDefined)
                      : commissionType == 'fix_commission'
                          ? '${tr(LanguageKeys.fix_commission)} : $commissionRate€'
                          : '${tr(LanguageKeys.percentage_commission)} : $commissionRate%',
                  style: stylePoppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        isNoCommission ? AppColors.primary : AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (!isNoCommission)
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                commissionType == 'fix_commission' ? Icons.euro : Icons.percent,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContractActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          _buildContractActionTile(
            icon: SvgPicture.asset(AppAssets.imgActivityContract),
            label: tr(LanguageKeys.viewContract),
            onTap: onViewContract,
          ),
          const SizedBox(height: 8),
          _buildContractActionTile(
            icon: SvgPicture.asset(AppAssets.imgActivityEdit),
            label: tr(LanguageKeys.edit),
            onTap: onEdit,
          ),
          const SizedBox(height: 8),
          _buildContractActionTile(
            icon: SvgPicture.asset(AppAssets.imgAttach),
            label: tr(LanguageKeys.attachFiles),
            onTap: onAttachFiles,
          ),
        ],
      ),
    );
  }

  Widget _buildContractActionTile({
    required Widget icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    const lightGrey = Color(0xFFFFFFFF);
    return Container(
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: icon,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonsRow2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          // Invite a Business Referrer (Purple)
          _buildReferralActionButton(
            backgroundColor: AppColors.primary,
            icon: SvgPicture.asset(
              AppAssets.imgPartner,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            title: tr(LanguageKeys.inviteBusinessReferrer),
            subtitle: tr(LanguageKeys.inviteBusinessReferrerSubtext),
            onTap: onInvitePartner,
          ),
          const SizedBox(height: 12),
          // Share External Form (Blue)
          _buildReferralActionButton(
            backgroundColor: AppColors.blueColor2,
            icon: SvgPicture.asset(
              AppAssets.imgActivityShare,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            title: tr(LanguageKeys.shareExternalForm),
            subtitle: tr(LanguageKeys.shareExternalFormSubtext),
            onTap: onShareForm,
          ),
          const SizedBox(height: 12),
          // Invite Manually (Orange)
          _buildReferralActionButton(
            backgroundColor: AppColors.yellowColor,
            icon:
                Image.asset(AppAssets.imgManuallyIconWhite, color: Colors.white),
            title: tr(LanguageKeys.inviteManually),
            subtitle: tr(LanguageKeys.inviteManuallyDescription),
            onTap: onInviteManually,
          ),
        ],
      ),
    );
  }

  Widget _buildReferralActionButton({
    required Color backgroundColor,
    required Widget icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(width: 20, height: 20, child: icon)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: stylePoppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.95),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
