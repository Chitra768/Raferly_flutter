import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/dashboard/add_agency_coworker_dialog.dart';
import 'package:referaly/screens/dashboard/add_business_referrer_screen.dart';
import 'package:referaly/screens/dashboard/membership_screen.dart';
import 'package:referaly/screens/send_notification_screen.dart';
import 'package:referaly/screens/statistics/overall_statistics_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/premium_upgrade_dialog.dart';
import 'package:referaly/widgets/dialog/network_filter_dialog.dart';

import '../get/screens.dart';

/// Figma node 4935:934 (English wireframe) — slate / purple tokens.
const Color _fnSlate900 = Color(0xFF0F172A);
const Color _fnSlate700 = Color(0xFF334155);
const Color _fnSlate500 = Color(0xFF64748B);
const Color _fnSlate200 = Color(0xFFE2E8F0);
const Color _fnSlate100 = Color(0xFFF1F5F9);
const Color _fnSlate50 = Color(0xFFF8FAFC);
const Color _fnGray400 = Color(0xFF9CA3AF);
const Color _fnPurple = Color(0xFF9333EA);
const Color _fnPurpleLight = Color(0xFFA855F7);

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
    onSelect: (filterBy) async {
      await controller.setMyNetworkFilterBy(filterBy);
      onSelectionChanged?.call();
    },
    onClear: () async {
      await controller.setMyNetworkFilterBy('');
      onSelectionChanged?.call();
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

  void _openAgency() {
    if ((AppPreference.readString(AppPreference.isPaid) != "3") &&
        AppPreference.readString(AppPreference.isPaid) != "1") {
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
      Get.dialog(AddAgencyCoworkerDialog());
    }
  }

  void _openNotify() {
    if (AppPreference.readString(AppPreference.isPaid) == "0") {
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
    if (AppPreference.readString(AppPreference.isPaid) != "0") {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  tr(LanguageKeys.myNetworkBusinessReferrerSectionTitle),
                  style: stylePoppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: _fnSlate900,
                  ),
                ),
              ),
              Obx(
                () {
                  final hasFilter = c.myNetworkStatusFilter.value != MyNetworkStatusFilter.all ||
                      c.myNetworkSortType.value != MyNetworkSortType.none;
                  final appliedLabel = c.myNetworkAppliedFilterLabel();
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => openMyNetworkFilterDialog(
                        context,
                        c,
                        onSelectionChanged: widget.onFilterOrSortChanged,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _fnSlate200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.filter_list,
                                  size: 12,
                                  color: _fnSlate700,
                                ),
                                if (hasFilter)
                                  Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF59E0B),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              appliedLabel.isNotEmpty ? appliedLabel : tr(LanguageKeys.myNetworkFilter),
                              style: stylePoppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: appliedLabel.isNotEmpty ? _fnPurple : _fnSlate700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
              color: _fnSlate900,
            ),
            decoration: InputDecoration(
              hintText: tr(LanguageKeys.myNetworkSearchHint),
              hintStyle: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: _fnGray400,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(Icons.search, size: 14, color: _fnGray400),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 48),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _fnSlate200, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _fnSlate200, width: 2),
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
            final raw = c.networkList.value?.data?.businessReferrers ?? [];
            final filtered = c.myNetworkDisplayReferrers();
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
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    tr(LanguageKeys.myNetworkNoFilterResults),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: _fnSlate500,
                    ),
                  ),
                ),
              );
            }
            const maxPreviewItems = 6;
            final visible =
                filtered.length > maxPreviewItems ? filtered.sublist(0, maxPreviewItems) : filtered;
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
          border: Border.all(color: _fnSlate100),
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
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_fnPurple, _fnPurpleLight],
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
                            color: _fnSlate900,
                          ).copyWith(height: 1.25),
                        ),
                        Text(
                          tr(LanguageKeys.myNetworkActiveReferrersSubtitle),
                          style: stylePoppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _fnSlate500,
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
              decoration: const BoxDecoration(
                color: Color(0x1A9333EA),
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
        border: Border.all(color: _fnSlate200),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_fnSlate50, Colors.white],
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
            child: Obx(
              () => _buildQuickActionTile(
                onTap: _openAgency,
                icon: SvgPicture.asset(
                  AppAssets.imgRefrealSvg,
                  // height: ,
                  // colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                ),
                label: tr(LanguageKeys.myNetworkAgency),
                showCrown: AppPreference.readString(AppPreference.isPaid) != "3" &&
                    AppPreference.readString(AppPreference.isPaid) != "1",
                badgeCount:
                    widget.controller.referrers.isNotEmpty ? widget.controller.referrers.length : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionTile(
              onTap: _openNotify,
              icon: SvgPicture.asset(
                AppAssets.imgAddNotificationSvg,
                // height: 20,
                // colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              label: tr(LanguageKeys.myNetworkNotifyReferrers),
              showCrown: AppPreference.readString(AppPreference.isPaid) == "0",
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
                  color: const Color(0x1A9333EA),
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
                      Color(0xFF3B82F6),
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
              color: _fnSlate700,
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
    const borderPeach = Color(0xFFFED7AA);
    const accentOrange = Color(0xFFEA580C);

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
                                    color: _fnSlate500,
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
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: stylePoppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF64748B),
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
                    color: const Color(0xFF1E293B),
                  ).copyWith(height: 1.4),
                ),
              ),
              Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0x1A9333EA),
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
