import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/helpers/premium_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/models/model_profile.dart' as profile_model;
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/add_business_referrer_screen.dart';
import 'package:referaly/screens/dashboard/team_management_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/screens/statistics/overall_statistics_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/access_denied_view.dart';
import 'package:referaly/widgets/dialog/network_filter_dialog.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/logo_loader.dart';

import '../get/screens.dart';

typedef MyNetworkReferrerRowBuilder = Widget Function(
  int index,
  BusinessReferrers ref,
  bool isExpanded,
  VoidCallback onHeaderTap,
  bool embedInDottedParent,
);

void openMyNetworkFilterDialog(
  BuildContext context,
  MyActivityController controller, {
  VoidCallback? onSelectionChanged,
}) {
  openNetworkFilterDialog(
    context,
    activeCount: controller.myNetworkActiveCount(),
    pendingCount: controller.myNetworkPendingCount(),
    currentFilterBy: controller.myNetworkEffectiveFilterBy(),
    onSelect: (filterBy) {
      onSelectionChanged?.call();
      return controller.setMyNetworkFilterBy(filterBy);
    },
    onClear: () {
      onSelectionChanged?.call();
      return controller.setMyNetworkFilterBy('');
    },
  );
}

Future<void> openMyNetworkDealFilterSheet(
  BuildContext context,
  MyActivityController controller, {
  VoidCallback? onSelectionChanged,
}) async {
  final deals = controller.contactList.value?.data ?? <ContractData>[];

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                tr(LanguageKeys.chooseDeal),
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  tr(LanguageKeys.myNetworkAllDeals),
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
                trailing: controller.myNetworkDealIdFilter.value == null
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  controller.setMyNetworkDealFilter(dealId: null, dealName: '');
                  onSelectionChanged?.call();
                  Navigator.of(ctx).pop();
                },
              ),
              const Divider(height: 1, color: AppColors.slate200),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    final d = deals[index];
                    final name = (d.dealName ?? '').trim();
                    if (name.isEmpty) return const SizedBox.shrink();
                    final isSelected = controller.myNetworkDealIdFilter.value == d.id;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate900,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        controller.setMyNetworkDealFilter(dealId: d.id, dealName: name);
                        onSelectionChanged?.call();
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class MyNetworkTabContent extends StatefulWidget {
  const MyNetworkTabContent({
    super.key,
    required this.controller,
    required this.buildReferrerRow,
    required this.expandedReferrerIndex,
    required this.onReferrerExpandChanged,
    this.onFilterOrSortChanged,
  });

  final MyActivityController controller;
  final MyNetworkReferrerRowBuilder buildReferrerRow;
  final int? expandedReferrerIndex;
  final void Function(int?) onReferrerExpandChanged;
  final VoidCallback? onFilterOrSortChanged;

  @override
  State<MyNetworkTabContent> createState() => _MyNetworkTabContentState();
}

class _MyNetworkTabContentState extends State<MyNetworkTabContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.controller.myNetworkSearchQuery.value,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  profile_model.Data? get _profileData => widget.controller.mainController.profile.value?.data;

  /// Premium: `role_names` contains `agency-user` or `independent-user`.
  bool _isNetworkPremium() {
    return PremiumHelper.isPremiumUser(_profileData);
  }

  void _showAccessSnack(String message) =>
      AgencyColleagueAccessHelper.showAccessDeniedSnackbar(message: message);

  void _openAgency() {
    if (AgencyColleagueAccessHelper.canManageTeam(_profileData)) {
      Get.toNamed(TeamManagementScreen.pageId);
      return;
    }
    if (AgencyColleagueAccessHelper.isAgencyColleague(_profileData)) {
      _showAccessSnack(tr(LanguageKeys.agencyColleagueCannotManageTeam));
      return;
    }
    if (!_isNetworkPremium()) {
      Get.dialog(
        PremiumUpgradeDialog(
          onSeeOffers: () {
            Get.back();
            Get.toNamed(MembershipPlanNewScreen.pageId)?.then((_) {
              widget.controller.mainController.getProfile();
            });
          },
        ),
      );
      return;
    }
    _showAccessSnack(tr(LanguageKeys.agencyColleagueCannotManageTeam));
  }

  void _openNotify() {
    // Get.toNamed(SendNotificationScreen.pageId);
    if (!_isNetworkPremium()) {
      Get.dialog(
        PremiumUpgradeDialog(
          onSeeOffers: () {
            Get.back();
            Get.toNamed(MembershipPlanNewScreen.pageId)?.then((_) {
              widget.controller.mainController.getProfile();
            });
            // Get.toNamed(MembershipScreen.pageId)?.then((_) {
            //   widget.controller.mainController.getProfile();
            // });
          },
        ),
      );
    } else {
      Get.toNamed(SendNotificationScreen.pageId);
    }
  }

  void _openStats() {
    if (_isNetworkPremium()) {
      Get.toNamed(OverallStatisticsScreen.pageId);
    } else {
      Get.dialog(
        PremiumUpgradeDialog(
          onSeeOffers: () {
            Get.back();
            Get.toNamed(MembershipPlanNewScreen.pageId)?.then((_) {
              widget.controller.mainController.getProfile();
            });
            // Get.toNamed(MembershipScreen.pageId)?.then((_) {
            //   widget.controller.mainController.getProfile();
            // });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    if (!AgencyColleagueAccessHelper.canView(
      _profileData,
      AgencyPermission.businessReferrers,
    )) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Center(
          child: Text(
            tr(LanguageKeys.agencyColleagueContentRestricted),
            textAlign: TextAlign.center,
            style: stylePoppins(fontSize: 16.sp, color: AppColors.slate700),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatsCard(c),
          const SizedBox(height: 20),
          _buildQuickActionsRow(),
          const SizedBox(height: 12),
          _buildPrimaryButtons(),
          const SizedBox(height: 20),
          // Filter and Sort
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr(LanguageKeys.myNetworkBusinessReferrerSectionTitle),
                style: stylePoppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Obx(() {
                  final hasFilter = c.myNetworkStatusFilter.value != MyNetworkStatusFilter.all ||
                      c.myNetworkSortType.value != MyNetworkSortType.none;
                  final appliedLabel = c.myNetworkAppliedFilterLabel();
                  final dealLabel = c.myNetworkDealNameFilter.value.trim();
                  final hasDeal = c.myNetworkDealIdFilter.value != null;

                  Widget buildChip({
                    required VoidCallback onTap,
                    required IconData icon,
                    required bool showDot,
                    required String text,
                  }) {
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.slate200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Icon(icon, size: 12, color: AppColors.slate700),
                                  if (showDot)
                                    Positioned(
                                      right: -4,
                                      top: -4,
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: AppColors.yellowColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: showDot ? AppColors.purple500 : AppColors.slate700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.end,
                      children: [
                        buildChip(
                          onTap: () => openMyNetworkDealFilterSheet(
                            context,
                            c,
                            onSelectionChanged: widget.onFilterOrSortChanged,
                          ),
                          icon: Icons.work_outline,
                          showDot: hasDeal,
                          text: dealLabel.isNotEmpty ? dealLabel : tr(LanguageKeys.myNetworkDealFilter),
                        ),
                        buildChip(
                          onTap: () => openMyNetworkFilterDialog(
                            context,
                            c,
                            onSelectionChanged: widget.onFilterOrSortChanged,
                          ),
                          icon: Icons.filter_list,
                          showDot: hasFilter,
                          text: appliedLabel.isNotEmpty ? appliedLabel : tr(LanguageKeys.myNetworkFilter),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (v) => c.myNetworkSearchQuery.value = v,
            style: stylePoppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.slate900,
            ),
            decoration: InputDecoration(
              hintText: tr(LanguageKeys.myNetworkSearchHint),
              hintStyle: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.gray400,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(Icons.search, size: 14, color: AppColors.gray400),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.slate200, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.slate200, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary.withOpacity(0.45), width: 2),
              ),
              contentPadding: const EdgeInsets.fromLTRB(0, 15, 18, 15),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (c.isNetworkLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: LogoLoader()),
              );
            }
            if (c.isNetworkAccessDenied.value) {
              return AccessDeniedView(message: c.error.value);
            }
            final raw = c.networkList.value?.data?.businessReferrers ?? [];
            if (raw.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tr(LanguageKeys.addBusinessReferrence),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            }
            final q = c.myNetworkSearchQuery.value.trim().toLowerCase();
            final list = q.isEmpty
                ? raw
                : raw.where((b) {
                    final name = '${b.firstName ?? ''} ${b.lastName ?? ''}'.toLowerCase();
                    final company = (b.companyName ?? '').toLowerCase();
                    final email = (b.email ?? '').toLowerCase();
                    return name.contains(q) || company.contains(q) || email.contains(q);
                  }).toList();

            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    tr(LanguageKeys.myNetworkNoFilterResults),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate500,
                    ),
                  ),
                ),
              );
            }
            final visible = list;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final ref = visible[index];
                final expanded = widget.expandedReferrerIndex == index;
                if (ref.isPendingInvitation == true) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildPendingReferrerEntry(
                      ref: ref,
                      index: index,
                      expanded: expanded,
                    ),
                  );
                }
                return widget.buildReferrerRow(
                  index,
                  ref,
                  expanded,
                  () {
                    widget.onReferrerExpandChanged(
                      expanded ? null : index,
                    );
                  },
                  false,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  /// Figma 4935:936 — compact stats card (icon + count + subtitle + trailing chart).
  Widget _buildStatsCard(MyActivityController c) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 10),
              spreadRadius: -3,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      // AppAssets.imgReferrelsPeopleSvg,
                      AppAssets.imgActivityPerson,
                      height: 22,
                      // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (c.networkList.value?.data?.activeBusinessReferrers ??
                                      c.networkList.value?.data?.totalBusinessReferrers)
                                  ?.toString() ??
                              '0',
                          style: stylePoppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ).copyWith(height: 1.25),
                        ),
                        Text(
                          tr(LanguageKeys.myNetworkActiveReferrersSubtitle),
                          style: stylePoppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate500,
                          ).copyWith(height: 1.33),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.trending_up_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Figma 4935:952 — single bordered panel, two quick actions.
  Widget _buildQuickActionsRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.slate50, Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // if (AgencyColleagueAccessHelper.canManageTeam(_profileData)) ...[
          Expanded(
            child: Obx(
              () {
                final premium =
                    _isNetworkPremium() && AgencyColleagueAccessHelper.canManageTeam(_profileData);
                return _buildQuickActionTile(
                  onTap: _openAgency,
                  icon: SvgPicture.asset(
                    AppAssets.imgAgency,
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                  ),
                  label: tr(LanguageKeys.myNetworkAgency),
                  showCrown: !premium,
                  badgeCount:
                      widget.controller.referrers.isNotEmpty ? widget.controller.referrers.length : null,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // ],
          Expanded(
            child: Obx(
              () {
                final premium =
                    PremiumHelper.isPremiumUser(widget.controller.mainController.profile.value?.data);
                return _buildQuickActionTile(
                  onTap: _openNotify,
                  icon: SvgPicture.asset(
                    AppAssets.imgSendActivity,
                    // height: 20,
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                  ),
                  label: tr(LanguageKeys.myNetworkNotifyReferrers),
                  showCrown: !premium,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile({
    required VoidCallback onTap,
    required Widget icon,
    required String label,
    required bool showCrown,
    int? badgeCount,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.purple500.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
              if (badgeCount != null && badgeCount > 0)
                Positioned(
                  right: 2,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.pdfBg,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: stylePoppins(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (showCrown)
                Positioned(
                  top: -4,
                  right: -4,
                  child: SvgPicture.asset(
                    AppAssets.imgHDashboardCrown,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blueColor2,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: stylePoppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.slate700,
            ).copyWith(height: 1.25),
          ),
        ],
      ),
    );
  }

  /// Figma 4935:966–974 — bordered rows, label left + icon capsule right.
  Widget _buildPrimaryButtons() {
    return Column(
      children: [
        _buildFigmaPillActionRow(
          label: tr(LanguageKeys.myNetworkAddBusinessReferrerManually),
          onTap: () {
            if (!AgencyColleagueAccessHelper.guardEdit(
              _profileData,
              AgencyPermission.businessReferrers,
            )) {
              return;
            }
            if (!_isNetworkPremium()) {
              Get.dialog(
                PremiumUpgradeDialog(
                  onSeeOffers: () {
                    Get.back();
                    Get.toNamed(MembershipPlanNewScreen.pageId)?.then((_) {
                      widget.controller.mainController.getProfile();
                    });
                  },
                ),
              );
              return;
            }
            Get.toNamed(
              AddBusinessReferrerScreen.pageId,
              arguments: {'created_by_parent': 'false'},
            );
          },
          trailingIcon: const Icon(Icons.person_add_alt_1_rounded, size: 20, color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        _buildFigmaPillActionRow(
          label: tr(LanguageKeys.myNetworkStatsRanking),
          onTap: _openStats,
          trailingIcon: SvgPicture.asset(AppAssets.imgActivityStatics, height: 16, color: AppColors.primary),
        ),
      ],
    );
  }

  /// Compact pending row (dashed peach border); expanded shows full [ReferrerListItem] inside same border.
  Widget _buildPendingReferrerEntry({
    required BusinessReferrers ref,
    required int index,
    required bool expanded,
  }) {
    const borderPeach = AppColors.orange;
    const accentOrange = AppColors.orange600;

    final inner = expanded
        ? widget.buildReferrerRow(
            index,
            ref,
            true,
            () => widget.onReferrerExpandChanged(null),
            true,
          )
        : Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => widget.onReferrerExpandChanged(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _pendingInitialAvatar(ref),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _referrerDisplayName(ref),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: stylePoppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: accentOrange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  tr(LanguageKeys.myNetworkInvitationPending),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: stylePoppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slate500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      size: 24,
                      color: accentOrange,
                    ),
                  ],
                ),
              ),
            ),
          );

    return DottedBorder(
      color: borderPeach,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [6, 4],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: inner,
      ),
    );
  }

  Widget _pendingInitialAvatar(BusinessReferrers ref) {
    final letter = _referrerInitialLetter(ref);
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.slate200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: stylePoppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.slate500,
        ),
      ),
    );
  }

  String _referrerDisplayName(BusinessReferrers ref) {
    return '${ref.firstName ?? ''} ${ref.lastName ?? ''}'.trim();
  }

  String _referrerInitialLetter(BusinessReferrers ref) {
    final n = _referrerDisplayName(ref);
    if (n.isEmpty) return '?';
    return n[0].toUpperCase();
  }

  Widget _buildFigmaPillActionRow({
    required String label,
    required VoidCallback onTap,
    required Widget trailingIcon,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.whiteColor,
            border: Border.all(
              width: 2,
              color: AppColors.primary.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate800,
                  ).copyWith(height: 1.4),
                ),
              ),
              Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.purple500.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: trailingIcon
                  // child: Icon(trailingIcon, size: 17, color: AppColors.primary),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
